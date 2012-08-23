<?
// create an NDB client 
require_once "../php/libraries/NDB_Client.class.inc";
$client = new NDB_Client;
$client->makeCommandLine();
$client->initialize();

// get a Database connection
$config =& NDB_Config::singleton();
$db = Database::singleton();

$couchdbName = "ibis2";
$subprojects = $config->getSetting("subprojects");
$subprojmap = array();
// CandID, PSCID, Visit_label, Cohort, Site, Candidate_Gender

//GET /ibis2/_design/DQG-2.0/_view/search?startkey=["demographics","Site"]&endkey=["demographics","Site","\u9999"]&reduce=false

$rows = $db->queryCouch("DQG-2.0", "search", array("demographics", "Site"), array("demographics", "Site", "香"), false, $couchdbName);

foreach($rows as $row) {
    if(in_array($row['key'][2], array('DRX', 'HPK', 'KAI', 'MND'))) {
        $session = $row['value'];
        $docs = $db->queryCouch("DQG-2.0", "sessions", $session, $session, false, $couchdbName);
        foreach($docs as $doc) {
            $couchdoc = $db->getCouch($doc['id'], $couchdbName);
            $db->deleteCouch($doc['id'], $couchdbName);
            print_r($couchdoc);
        }
    }
}
