<?
// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();

// get a Database connection
$config =& NDB_Config::singleton();
$db = Database::singleton();

$couchdbName = 'ibis2';

// Generate dynamically generate a query of the form 
/* 

select c.PSCID, s.CandID as DCCID, s.Visit_label,
 (  select f.File from files f
      left join parameter_type t on t.name='selected'
      left join parameter_file p on (p.FileID=f.FileID and
p.ParameterTypeID=t.ParameterTypeID )
      where f.sessionID=s.ID
            and f.QCStatus='Pass'
            and t.Name='selected' and p.Value='T1'
    limit 1
  ) as selected_t1,

 (  select f.File from files f
      left join parameter_type t on t.name='selected'
      left join parameter_file p on (p.FileID=f.FileID and
p.ParameterTypeID=t.ParameterTypeID )
      where f.sessionID=s.ID
            and f.QCStatus='Pass'
            and t.Name='selected' and p.Value='T2'
    limit 1
  ) as selected_t2,

 (  select f.File from files f
      left join parameter_type t on t.name='selected'
      left join parameter_file p on (p.FileID=f.FileID and
p.ParameterTypeID=t.ParameterTypeID )
      where f.sessionID=s.ID
            and f.QCStatus='Pass'
            and t.Name='selected' and p.Value='MTR_ON'
    limit 1
  ) as selected_mtr_on,

 (  select f.File from files f
      left join parameter_type t on t.name='selected'
      left join parameter_file p on (p.FileID=f.FileID and
p.ParameterTypeID=t.ParameterTypeID )
      where f.sessionID=s.ID
            and f.QCStatus='Pass'
            and t.Name='selected' and p.Value='MTR_OFF'
    limit 1
  ) as selected_mtr_off
from session s
join candidate c on c.CandID=s.CandID
    where s.MRIQCFirstChangeTime is not NULL
    and (c.PSCID like '%TOR%' OR c.PSCID like '%MTL%') and c.PSCID
not like '%9999%'
order by c.PSCID
;
 */
/*
 * (Above query courtesy of Christine).
 * A couple optimizations below by Dave. Namely: 
 *  1. Make it project independent by doing select distinct from ParameterType to get the types of 
 *     files and remove the site restrictions
 *  2. Exclude phantoms (PSCID <> scanner)
 *  3. Exclude cancelled sessions/candidates
 *  3. Cache the ParameterTypeID since we're generating the query in PHP, so that we don't need
 *     to make the same join in every subquery.
 */

$SelectedTypes = $db->pselect("SELECT DISTINCT pf.ParameterTypeID, pf.Value as ScanType from parameter_type pt JOIN parameter_file pf USING (ParameterTypeID) WHERE pt.Name='selected' AND COALESCE(pf.Value, '') <> ''", array());

$DataDictionary = array(
    'Meta' => array('DataDict' => true), 
    'DataDictionary' => array('mri_data' => array(
        'QCComment' => array(
            'Type' => 'varchar(255)',
            'Description' => 'QC Comment for Session')
        )
));
$BaseQuery = "SELECT c.PSCID, s.Visit_label, fmric.Comment as QCComment, ";
$Subqueries = array();
foreach($SelectedTypes as $STRow) {
    $Type = $STRow['ScanType'];
    // Getting the selected ParameterTypeID in the select distinct and hardcoding it in the subqueries 
    // saves us one join per file type..
    $SelectedTypeID = $STRow['ParameterTypeID'];
    print "Type: $Type";
    $Subqueries[] = "(SELECT f.File FROM files f LEFT JOIN files_qcstatus fqc USING(FileID) 
                    LEFT JOIN parameter_file p ON (p.FileID=f.FileID AND p.ParameterTypeID=$SelectedTypeID)
                    WHERE f.SessionID=s.ID AND fqc.QCStatus='Pass' AND p.Value='$Type' LIMIT 1) as `Selected_$Type`";
    $Subqueries[] = "(SELECT fqc.QCStatus FROM files f LEFT JOIN files_qcstatus fqc USING(FileID) 
                    LEFT JOIN parameter_file p ON (p.FileID=f.FileID AND p.ParameterTypeID=$SelectedTypeID)
                    WHERE f.SessionID=s.ID AND fqc.QCStatus='Pass' AND p.Value='$Type' LIMIT 1) as `$Type" . "_QCStatus`";
    $DataDictionary['DataDictionary']['mri_data']["Selected_$Type"] = array(
        'Type' => 'varchar(255)',
        'Description' => "Selected $Type file for session"
    );
    $DataDictionary['DataDictionary']['mri_data'][$Type . "_QCStatus"] = array(
        'Type' => "enum('Pass', 'Fail')",
        'Description' => "QC Status for $Type file"
    );

}

$OldDataDictionary = $db->getCouch("DataDictionary:mri_data", $couchdbName);
$DataDictionary['_rev'] = $OldDataDictionary['_rev'];
$db->putCouch("DataDictionary:mri_data", $DataDictionary, $couchdbName);
// Update the data dictionary..

$BaseQuery .= join(",", $Subqueries);
$BaseQuery .= " FROM session s JOIN candidate c USING (CandID) LEFT JOIN feedback_mri_comments fmric ON (fmric.CommentTypeID=7 AND fmric.SessionID=s.ID) WHERE c.PSCID <> 'scanner' AND c.PSCID NOT LIKE '%9999' AND c.Active='Y' AND s.Active='Y' AND c.CenterID <> 1";

print "Generated query: $BaseQuery\n\nRunning:\n";
$results = $db->pselect($BaseQuery, array());

foreach($results as $session) {
    $DocName = "MRI_Files:$session[PSCID]_$session[Visit_label]";
    print $DocName . "\n";
    $doc = $db->getCouch($DocName, $couchdbName);

    //print_r($doc);
    $identifier = array($session['PSCID'], $session['Visit_label']);
    unset($session['PSCID']);
    unset($session['Visit_label']);

    $old_data = $doc['data'];
    $new_data = $session;
    
    if($old_data == $new_data) {
        print "$DocName: Unchanged\n";
        continue;
    }

    if($doc['_id'] == '') { // new document
        print "$DocName: New, creating\n";
        unset($session['PSCID']);
        unset($session['Visit_label']);
        $db->putCouch($DocName, array(
            'Meta' => array(
                'DocType' => 'mri_data', 
                'identifier' => $identifier
            ),
            'data' => $session), $couchdbName
        );
    } else {
        // Update old document
        print "$DocName: Updating\n";
        $doc['data'] = $session;
        $db->putCouch($DocName, $doc, $couchdbName);
    }

}

?>
