<?php
require_once "../project/libraries/QC_Checks.class.inc";
// define a config file to use
$configFile = "../project/config.xml";

//set_include_path(get_include_path().":../php/libraries:");
set_include_path(get_include_path().":../project/libraries:");
require_once "NDB_Client.class.inc";

$client = new NDB_Client();
$client->makeCommandLine();
$client->initialize($configFile);
// get a Database connection
$config =& NDB_Config::singleton();
$dbConfig = $config->getSetting('database');
$DB = new Database;
$result = $DB->connect($dbConfig['database'], $dbConfig['username'], $dbConfig['password'], $dbConfig['host'], false);
if(PEAR::isError($result)) {
        die("Could not connect to database: ".$result->getMessage());
}
$sites =array('2','3','4','5'); 
foreach($sites as $site) {
$run = new QC_Checks($site);
 $run->run();
}

?>
