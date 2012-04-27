<?
// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();

// get a Database connection
$config =& NDB_Config::singleton();
$db = Database::singleton();

$test = $db->pselect("SELECT f.* from flag f join session s ON (s.ID=f.SessionID) LEFT JOIN candidate c ON (c.CandID=s.CandID) WHERE f.CommentID NOT LIKE 'DDE%' AND s.Active='Y' AND c.Active='Y' AND c.CenterID <> 1 AND s.Current_stage <> 'Recycling Bin' AND c.PSCID <> 'scanner'", array());
$couchdbName = 'testt';
//print_r($test);
foreach($test as $row) {
    $query = "SELECT * FROM " . $row['Test_name'] . " WHERE CommentID=:CID";
    $values = $db->pselectRow($query, array("CID" => $row['CommentID']));
    $query = "SELECT ID, CenterID, Visit_label, SubprojectID, CandID FROM session WHERE ID=:SessionID";
    $session = $db->pselectRow($query, array("SessionID" => $row['SessionID']));
    $query = "SELECT CandID, PSCID, psc.alias as Site FROM candidate LEFT JOIN psc USING(CenterID) WHERE CandID=:CandidateID";
    $candidate = $db->pselectRow($query, array("CandidateID" => $session['CandID']));
    $doc = $db->getCouch($row['CommentID'], $couchdbName);
    //print_r($doc);

    $old_data = $doc['data'];
    $new_data = $values;
    if($old_data == $new_data) {
        print "$row[CommentID]: Unchanged\n";
        continue;
    }

    if($doc['_id'] == '') { // new document
        print "$row[CommentID]: New, creating\n";
        $db->putCouch($row['CommentID'], array(
            'Meta' => array(
                'DocType' => $row['Test_name'], 
                'identifier' => array($candidate['Site'], $candidate['PSCID'], $session['Visit_label']),
            ),
            'data' => $values), $couchdbName
        );
    } else {
        // Update old document
        print "$row[CommentID]: Updating\n";
        $doc['data'] = $new_data;
        $db->putCouch($row['CommentID'], $doc, $couchdbName);
    }

}

?>
