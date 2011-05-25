<?
set_time_limit(0);
/**
 * QUAT uses the parameter_type table to determine the list of
 * parameters available for querying, nukes and reconstructs the query
 * gui tables (the wide ones containing all parameter types)
 *
 * IMPORTANT NOTE:
 *
 * You will need entry in your config.xml:
 *
 *       <quatUser>username</quatUser>
 *       <quatPassword>password</quatPassword>
 * 
 * @package main
 * @subpackage query_gui
 */

/*
mysql> describe parameter_type;
+-----------------+-----------------------------------------------+------+-----+---------+----------------+
| Field           | Type                                          | Null | Key | Default | Extra          |
+-----------------+-----------------------------------------------+------+-----+---------+----------------+
| ParameterTypeID | int(10) unsigned                              |      | PRI | NULL    | auto_increment |
| Name            | varchar(255)                                  |      | MUL |         |                |
| Type            | enum('ordinal','nominal','scalar','filePath') |      |     | ordinal |                |
| Description     | text                                          | YES  |     | NULL    |                |
| RangeMin        | double                                        | YES  |     | NULL    |                |
| RangeMax        | double                                        | YES  |     | NULL    |                |
| SourceField     | text                                          | YES  |     | NULL    |                |
| SourceFrom      | text                                          | YES  |     | NULL    |                |
| CurrentGUITable | varchar(255)                                  | YES  |     | NULL    |                |
| Queryable       | tinyint(1)                                    | YES  |     | 1       |                |
+-----------------+-----------------------------------------------+------+-----+---------+----------------+
*/

require_once "Utility.class.inc";
require_once "Log.class.inc";
// settings
$columnThreshhold = Utility::getColumnThresholdCount();
$quatTableBasename = 'quat_table_';
$quatTableCounter = 1;

// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();
$log = new Log("quat_populate");

// get a Database connection
$config =& NDB_Config::singleton();
$dbConfig = $config->getSetting('database');
$db = new Database;
$result = $db->connect($dbConfig['database'], $dbConfig['quatUser'], $dbConfig['quatPassword'], $dbConfig['host'], false);
if(PEAR::isError($result)) {
    die("Could not connect to database: ".$result->getMessage());
}

// get a list of all parameter types that we're populating
$query = "SELECT p.ParameterTypeID, p.Name, p.Type, p.SourceField, p.SourceFrom, p.SourceCondition, p.CurrentGUITable FROM parameter_type_running p JOIN parameter_type_category_rel USING (ParameterTypeID) JOIN parameter_type_category USING (ParameterTypeCategoryID) WHERE Queryable=1";
$parameterTypes = array();
$db->select($query, $parameterTypes);

// loop over the parameter types to build the data query tables
$createSQL = "";
$columnCount = 0;
$nextTableName = $quatTableBasename . $quatTableCounter;
$countParameterTypes = count($parameterTypes);


for($idx=0; $idx<$countParameterTypes; $idx++) {
    $parameterType =& $parameterTypes[$idx];

    // add column to the create table statement
    $createSQL .= !empty($createSQL) ? ', ' : '';
    $createSQL .= "`$parameterType[Name]` $parameterType[Type]";
    $parameterTypes[$idx]['CurrentGUITable'] = $nextTableName;
    $db->update('parameter_type', array('CurrentGUITable'=>$nextTableName), array('ParameterTypeID'=>$parameterType['ParameterTypeID']));
    $columnCount++;

    // if the number of columns is now greater than the threshhold
    if($columnCount >= $columnThreshhold or $idx+1 == $countParameterTypes) {

        // run the create table statement
        $createSQL = "CREATE TABLE $nextTableName (SessionID int not null primary key, $createSQL)";
        $insertSQL = "INSERT INTO $nextTableName (SessionID) SELECT DISTINCT SessionID FROM flag f JOIN parameter_type pt ON (f.Test_name=pt.SourceFrom) WHERE pt.CurrentGUITable='$nextTableName'";
        $quatTableCounter++;
        $nextTableName = $quatTableBasename . $quatTableCounter;
        $result = $db->run($createSQL);
        if($db->isError($result)) {
            die( "Failed to create table $nextTableName: ".$result->getMessage()."\n" );
        }
        $result = $db->run($insertSQL);
        if($db->isError($result)) {
            die( "Failed to populate table $nextTableName: ".$result->getMessage()."\n" );
        }

// Parse command line options
$options = getopt("m", array("metavars","sourcefrom:", "fields:", "help"));
if(isset($options['help'])) {
    print "Usage: $argv[0] [options]\n\n";
    //print "\tValid options are:\n";
    print "   -m, --metavars\t\tOnly populate metavar categories\n";
    print "   --sourcefrom=table\t\tOnly populate fields from table\n";
    print "   --fields=field1,field2,...\tOnly populate (comma separated) list of fields \n";
    print "   --help\t\t\tShow this page\n";
    exit(1);
}
if(isset($options['m']) || isset($options['metavars'])) {
    $query .= " AND parameter_type_category.type='Metavars'";
}
$sessions = array();
$db->select($query, $sessions);

unset($config);
print "At make the data table: " . memory_get_usage() . "\n";

function GetSelectStatement($parameterType, $field=NULL) {
    // construct query string dependant on parameter source
    switch($parameterType['SourceFrom']) {
    case 'files':
        if($field == null) {
            $field = "FileID";
        }
        $query = "SELECT $field AS Value FROM files JOIN session as S ON (s.ID=files.SessionID) WHERE OutputType='$parameterType[SourceField]'";
        break;

    case 'parameter_file':
        if($field == null) {
            $field = "p.Value";
        }
        $query = "SELECT $field FROM session AS s, files AS f, parameter_file AS p WHERE s.ID=f.SessionID AND f.FileID=p.FileID AND (f.QCStatus<>'Fail' OR f.QCStatus IS NULL) AND ParameterTypeID=$parameterType[ParameterTypeID]";
        break;

    case 'files_where_parameter':
        if($field == null) {
            $field = "$parameterType[SourceField]";
        }
        // SourceCondition can refer to acquisition protocol as
        // Scan_type and limiter_type.Name=X and limiter_value.Value=Y
        $query = "SELECT $field AS Value FROM session AS s INNER JOIN files ON (s.ID=files.SessionID) INNER JOIN mri_scan_type ON (files.AcquisitionProtocolID=mri_scan_type.ID) NATURAL JOIN parameter_file AS limiter_value INNER JOIN parameter_type AS limiter_type ON (limiter_value.ParameterTypeID=limiter_type.ParameterTypeID) WHERE $parameterType[SourceCondition]";
        break;

    case 'parameter_file_where_parameter':
        if($field == null) {
            $field = "$parameterType[SourceField]";
        }
        // SourceCondition can refer to acquisition protocol as
        // Scan_type and limiter_type.Name=X and limiter_value.Value=Y
        $query = "SELECT $field FROM session AS s INNER JOIN files ON (s.ID=files.SessionID) INNER JOIN mri_scan_type ON (files.AcquisitionProtocolID=mri_scan_type.ID) INNER JOIN parameter_file AS limiter_value ON (limiter_value.FileID=files.FileID) INNER JOIN parameter_type AS limiter_type ON (limiter_value.ParameterTypeID=limiter_type.ParameterTypeID) INNER JOIN parameter_file ON (files.FileID=parameter_file.FileID) INNER JOIN parameter_type ON (parameter_file.ParameterTypeID=parameter_type.ParameterTypeID) WHERE $parameterType[SourceCondition]";
        break;

    case 'parameter_session':
        if($field == null) {
            $field = "Value";
        }
        $query = "SELECT $field FROM parameter_session JOIN session s ON (s.ID=parameter_session.SessionID) WHERE ParameterTypeID=$parameterType[ParameterTypeID]";
        break;

    case 'parameter_candidate':
        if($field == null) {
            $field = "Value";
        }
        $query = "SELECT $field FROM session s LEFT JOIN parameter_candidate USING (CandID) WHERE ParameterTypeID=$parameterType[ParameterTypeID]";
        break;

    case 'session':
    case 'candidate':
        if($field == null && $parameterType['SourceFrom']=='session') {
            $field = "s.$parameterType[SourceField] ";
        } else if($field == null && $parameterType['SourceFrom']=='candidate') {
            $field = "c.$parameterType[SourceField] ";
        }

        $query = "SELECT $field AS Value FROM session s LEFT JOIN candidate c USING (CandID) WHERE 1=1 ";
        break;

    case 'psc':
        if($field == null) {
            $field = "psc.$parameterType[SourceField]";
        }
        $query = "SELECT $field AS Value FROM session s LEFT JOIN psc USING (CenterID)";
        break;

    case 'mri_acquisition_dates':
        if($field == null) {
            $field = "$parameterType[SourceField] Value";
        }
        $query = "SELECT $field AS Value FROM session s LEFT JOIN candidate USING (CandID) LEFT JOIN mri_acquisition_dates ON (session.ID=mri_acquisition_dates.SessionID)";
	 break;

    //for behavioural instrument data
    default:
        if($parameterType['SourceField'] == 'Administration' || $parameterType['SourceField'] == 'Data_entry' ||
            $parameterType['SourceField'] == 'Validity') {
            $field = "`flag`.`$parameterType[SourceField]`";

        } else if($field == null) {
            $field = "`$parameterType[SourceFrom]`.`$parameterType[SourceField]`";
        }
        $query = "SELECT $field AS Value FROM session s JOIN flag ON (s.ID=flag.SessionID) LEFT JOIN feedback_bvl_thread USING (CommentID) CROSS JOIN $parameterType[SourceFrom] LEFT JOIN candidate ON (s.CandID = candidate.CandID) WHERE flag.Administration<>'None' AND flag.CommentID=$parameterType[SourceFrom].CommentID AND (feedback_bvl_thread.Status IS NULL OR feedback_bvl_thread.Status='closed' OR feedback_bvl_thread.Status='comment')";
        break;
    }
    return $query;
}

$today= getdate();
$date = sprintf("%04d-%02d-%02d", $today['year'], $today['mon'], $today['mday']);

// Update data
foreach($parameterTypes AS $parameterType) {
    if($parameterType['CurrentGUITable'] != null) {
    print "Updating $parameterType[Name], memory: " . memory_get_usage() . " bytes\n";
    switch($parameterType['SourceFrom']) {
        case 'session':
        case 'candidate':
            print "UPDATE $parameterType[CurrentGUITable] SET $parameterType[Name]=(" . GetSelectStatement($parameterType) . " AND $parameterType[CurrentGUITable].SessionID=s.ID)  WHERE $parameterType[CurrentGUITable].SessionID=(" . GetSelectStatement($parameterType, "DISTINCT s.ID"). " AND s.ID=$parameterType[CurrentGUITable].SessionID)";
            $db->run("UPDATE $parameterType[CurrentGUITable] SET $parameterType[Name]=(" . GetSelectStatement($parameterType) . " AND $parameterType[CurrentGUITable].SessionID=s.ID)  WHERE $parameterType[CurrentGUITable].SessionID=(" . GetSelectStatement($parameterType, "DISTINCT s.ID"). " AND s.ID=$parameterType[CurrentGUITable].SessionID)");
            //exit(-1);
            break;
        default:
            print "UPDATE $parameterType[CurrentGUITable] SET $parameterType[Name]=(" . GetSelectStatement($parameterType) . " AND $parameterType[CurrentGUITable].SessionID=s.ID AND flag.CommentID NOT LIKE 'DDE%') WHERE $parameterType[CurrentGUITable].SessionID=(" . GetSelectStatement($parameterType, "DISTINCT s.ID"). " AND flag.CommentID NOT LIKE 'DDE%' AND s.ID=$parameterType[CurrentGUITable].SessionID)";
            $db->run("UPDATE $parameterType[CurrentGUITable] SET $parameterType[Name]=(" . GetSelectStatement($parameterType) . " AND $parameterType[CurrentGUITable].SessionID=s.ID AND flag.CommentID NOT LIKE 'DDE%') WHERE $parameterType[CurrentGUITable].SessionID=(" . GetSelectStatement($parameterType, "DISTINCT s.ID"). " AND flag.CommentID NOT LIKE 'DDE%' AND s.ID=$parameterType[CurrentGUITable].SessionID)");
            break;
    }
    //$db->run("UPDATE $parameterType[CurrentGUITable] SET $parameterType[Name]=(" . GetSelectStatement($parameterType) . " WHERE $parameterType[CurrentGUITable].SessionID=s.ID)");
    }
}
// Once more, for good measure. (and because the if statement above wouldn't be executed
// after the last parameterTypeId)
$updateStmt = "UPDATE $lastGUITable" . "_running SET " . join(", ", $setVals);
$log->addLog($updateStmt);

$db->run($updateStmt);
// Get _running tables from information_schema
// $origTbl = cut off _running
// drop $origTbl if exists;
// rename _running to $origTbl
// Update parameter_type SET CurrentGUITable = null
// Update parameter_type SET CurrentGUITable = SELECT CurrentGUITable from parameter_type_running
// Drop parameter_type_running

?>
