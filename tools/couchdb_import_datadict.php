<?
// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();

// get a Database connection
$config =& NDB_Config::singleton();
$db = Database::singleton();

$test = $db->pselect("select pt.SourceFrom, pt.SourceField, pt.Type, pt.Description from parameter_type pt LEFT JOIN parameter_type_category_rel ptcr USING (ParameterTypeID) LEFT JOIN parameter_type_category ptc USING (ParameterTypeCategoryID) WHERE pt.Queryable=1 AND ptc.Type='Instrument' ORDER BY SourceFrom", array());
$couchdbName = 'ibis';
$putValue = array('Meta' => array('DataDict' => true));
$Dictionary = array();
$Instrument = array();
$lastFrom = '';

function PutVal($Dictionary, $Name, $stub) {
    global $db, $couchdbName;
    $old_value = $db->getCouch("DataDictionary:$Name", $couchdbName);
    if($old_value['_rev']) {
        $stub['_rev'] = $old_value['_rev'];
    }
    $stub['DataDictionary'] = array($Name => $Dictionary);
    $db->putCouch("DataDictionary:$Name", $stub, $couchdbName);
}

foreach($test as $row) {
    $SourceFrom = $row['SourceFrom'];
    if($lastFrom != $SourceFrom) {
        PutVal($Instrument, $lastFrom, $putValue);
        $Instrument = array();
    }
    $Instrument[$row['SourceField']] = array('Description' => $row['Description'], 'Type' => $row['Type']);
    $lastFrom = $row['SourceFrom'];
    
}

PutVal($Instrument, $lastFrom, $putValue);
?>
