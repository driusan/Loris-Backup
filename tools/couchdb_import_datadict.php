<?
// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();

// get a Database connection
$config =& NDB_Config::singleton();
$db = Database::singleton();

$test = $db->pselect("select pt.SourceFrom, pt.SourceField, pt.Type, pt.Description from parameter_type pt LEFT JOIn parameter_type_category_rel ptcr USING (ParameterTypeID) LEFT JOIN parameter_type_category ptc USING (ParameterTypeCategoryID) WHERE pt.Queryable=1 AND ptc.Type='Instrument' AND SourceFrom IN ('tsi', 'rbs_r') ORDER BY SourceFrom", array());
$couchdbName = 'loris_test_2';
$putValue = array('Meta' => array('DataDict' => true));
$Dictionary = array();
$Instrument = array();
$lastFrom = '';


foreach($test as $row) {
    $SourceFrom = $row['SourceFrom'];
    if($lastFrom != $SourceFrom) {
        $Dictionary[$lastFrom] = $Instrument;
        $Instrument = array();
    }
    $Instrument[$row['SourceField']] = array('Description' => $row['Description'], 'Type' => $row['Type']);
    $lastFrom = $row['SourceFrom'];
    
}
$Dictionary[$lastFrom] = $Instrument;
$putValue['DataDictionary'] = $Dictionary;

$db->putCouch("DataDictionary", $putValue, $couchdbName);

?>
