<?php
/**
 * The main entry point for an end user into the Loris database. This file sets
 * all the variables that are necessary for Loris to render the page and 
 * (via NDB_Caller) dispatches to the appropriate PHP class to handle the
 * specifics request of the current request.
 *
 * It also ensures that the correct HTTP header is returned.
 *
 * PHP Version 5
 *
 * @category Behavioural
 * @package  Loris
 * @author   The Loris Team <info-loris.mni@mcgill.ca>
 * @license  Loris license
 * @link     https://www.github.com/aces/Loris-Trunk/
 *
 */
set_include_path(get_include_path().":../project/libraries:../php/libraries:");
ini_set('default_charset', 'utf-8');
ob_start('ob_gzhandler');
// start benchmarking
require_once 'Benchmark/Timer.php';
$timer = new Benchmark_Timer;
$timer->start();

// load the client
require_once 'NDB_Client.class.inc';
$client = new NDB_Client;
$client->initialize();

// require additional libraries
require_once 'NDB_Breadcrumb.class.inc';

$TestName = isset($_REQUEST['test_name']) ? $_REQUEST['test_name'] : '';
$subtest = isset($_REQUEST['subtest']) ? $_REQUEST['subtest'] : '';
// make local instances of objects
$config =& NDB_Config::singleton();

$timer->setMarker('Loaded client');

//--------------------------------------------------

/**
 * Extract parameter from request param and sets the tpl_data parameter
 * for that value. This function does the necessary error checking to ensure
 * that PHP errors/warnings are not thrown and the value is set to empty if
 * the parameter was not set.
 *
 * @param string $param The name of the variable to be extracted from HTTP
 *                      request.
 *
 * @return none, but as a side effect populates $tpl_data
 */
function tplFromRequest($param)
{
    global $tpl_data;
    if (isset($_REQUEST[$param])) {
        $tpl_data[$param] = $_REQUEST[$param];
    } else {
        $tpl_data[$param] = '';
    }
}

tplFromRequest('test_name');
tplFromRequest('subtest');
tplFromRequest('candID');
tplFromRequest('sessionID');
tplFromRequest('commentID');
tplFromRequest('dynamictabs');

// study title
$tpl_data['study_title'] = $config->getSetting('title');
// whether or not you want to see the bloody bvl feedback popup
$tpl_data['PopUpFeedbackBVL'] = $config->getSetting('PopUpFeedbackBVL');
// draw the user information table
$user =& User::singleton();
if (Utility::isErrorX($user)) {
    $tpl_data['error_message'][] = "User Error: ".$user->getMessage();
} else {
    $tpl_data['user'] = $user->getData();
    $tpl_data['user']['permissions'] = $user->getPermissions();
}

$site =& Site::singleton($user->getData('CenterID'));
if (Utility::isErrorX($site)) {
    $tpl_data['error_message'][] = "Site Error: ".$site->getMessage();
    unset($site);
} else {
    $tpl_data['user']['user_from_study_site'] = $site->isStudySite();
}


// the the list of tabs, their links and perms
$mainMenuTabs = $config->getSetting('main_menu_tabs');

foreach (Utility::toArray($mainMenuTabs['tab']) AS $myTab) {
    $tpl_data['tabs'][]=$myTab;
    foreach (Utility::toArray($myTab['subtab']) AS $mySubtab) {
        // skip if inactive
        if ($mySubtab['visible']==0) {
            continue;
        }

        // replace spec chars
        $mySubtab['link'] = str_replace("%26", "&", $mySubtab['link']);
        
        // check for the restricted site access
        if (isset($site) 
            && ($mySubtab['access']=='all' 
            || $mySubtab['access']=='site' 
            && $site->isStudySite())
        ) {

            // if there are no permissions, allow access to the tab
            if (!is_array($mySubtab['permissions']) 
                || count($mySubtab['permissions'])==0
            ) {

                $tpl_data['subtab'][]=$mySubtab;

            } else {

                // if any one permission returns true, allow access to the tab
                foreach ($mySubtab["permissions"] as $permissions) {
    
                    // turn into an array
                    if (!is_array($permissions)) {
                        $permissions = array($permissions);
                    }

                    // test and grant access to button with 1st permission
                    foreach ($permissions as $permission) {
                        if ($user->hasPermission($permission)) {
                            $tpl_data['subtab'][]=$mySubtab;
                            break 2;
                        }
                        unset($permission);
                    }
                    unset($permissions);
                }
            }
        }
        unset($mySubtab);
    } // end foreach
}
$timer->setMarker('Drew user information');

//--------------------------------------------------

// configure browser args for the mri browser
// !!! array URL args -- need to correct query in mri_browser to accept
// candidate data
$argstring = '';
if (!empty($_REQUEST['candID'])) {
    $argstring .= "filter%5BcandID%5D=".$_REQUEST['candID']."&";
}

if (!empty($_REQUEST['sessionID'])) {
    $timePoint =& TimePoint::singleton($_REQUEST['sessionID']);
    if (Utility::isErrorX($timePoint)) {
        $tpl_data['error_message'][] 
            = "TimePoint Error (".$_REQUEST['sessionID']."): "
              . $timePoint->getMessage();
    } else {
        $argstring .= "filter%5Bm.VisitNo%5D=".$timePoint->getVisitNo()."&";
    }
}

$link_args['MRIBrowser'] = $argstring;

$timer->setMarker('Configured browser arguments for the MRI browser');

//--------------------------------------------------

$paths = $config->getSetting('paths');

if (!empty($TestName)) {
    if (file_exists($paths['base'] . "htdocs/js/modules/$TestName.js")) {
        $tpl_data['test_name_js'] = "js/modules/$TestName.js";
    }
    if (file_exists("css/instruments/$TestName.css")) { 
        $tpl_data['test_name_css'] = "$TestName.css";
    }
}

//--------------------------------------------------

// get candidate data
if (!empty($_REQUEST['candID'])) {
    $candidate =& Candidate::singleton($_REQUEST['candID']);
    if (Utility::isErrorX($candidate)) {
        $tpl_data['error_message'][] 
            = "Candidate Error (".$_REQUEST['candID']."): "
              . $candidate->getMessage();
    } else {
        $tpl_data['candidate'] = $candidate->getData();
    }
}

// get time point data
if (!empty($_REQUEST['sessionID'])) {
    $timePoint =& TimePoint::singleton($_REQUEST['sessionID']);
    if ($config->getSetting("SupplementalSessionStatus")) {
        $tpl_data['SupplementalSessionStatuses'] = true;
    }
    
    if (Utility::isErrorX($timePoint)) {
        $tpl_data['error_message'][] 
            = "TimePoint Error (".$_REQUEST['sessionID']."): "
              . $timePoint->getMessage();
    } else {
        $tpl_data['timePoint'] = $timePoint->getData();
    }
}

$timer->setMarker('Drew the top workspace tables');

//--------------------------------------------------

// load the menu or instrument
$caller =& NDB_Caller::singleton();
/**
 * Error handler to handle a PEAR_Error and ensure
 * that the right HTTP response code is returned
 *
 * @param PEAR_Error $error The PEAR error object that was thrown
 *
 * @return none
 */
function handleError ($error)
{
    switch ($error->code) {
    case 404:
        header("HTTP/1.1 404 Not Found");
        break;
    case 403:
        header("HTTP/1.1 403 Forbidden");
        break;
    }
    if (empty($error->code)) {
        //print $error->message;
    }
}
$caller->setErrorHandling(PEAR_ERROR_CALLBACK, 'handleError');
$workspace = $caller->load($TestName, $subtest);
if (isset($caller->controlPanel)) {
    $tpl_data['control_panel'] = $caller->controlPanel;

}
if (Utility::isErrorX($workspace)) {
    $tpl_data['error_message'][] = $workspace->getMessage();
} else {
    $tpl_data['workspace'] = $workspace;
}

$timer->setMarker('Drew main workspace');

//--------------------------------------------------

// make the breadcrumb
$breadcrumb = new NDB_Breadcrumb;
$crumbs = $breadcrumb->getBreadcrumb();
if (Utility::isErrorX($crumbs)) {
    $tpl_data['error_message'][] = $crumbs->getMessage();
} else {
    $tpl_data['crumbs'] = $crumbs;
    parse_str($crumbs[0]['query'], $parsed);
    if (isset($parsed['test_name'])) {
        $tpl_data['top_level'] = $parsed['test_name'];
    } else {
        $tpl_data['top_level'] = '';
    }
}

$timer->setMarker('Drew breadcrumbs');

//--------------------------------------------------


// show the back button
$tpl_data['lastURL'] = $_SESSION['State']->getLastURL();

//Display the links, as specified in the config file
$links=$config->getSetting('links');
foreach (Utility::toArray($links['link']) AS $link) {
    $LinkArgs = '';
    $BaseURL = $link['@']['url'];
    if (isset($link['@']['args'])) {
        $LinkArgs = $link_args[$link['@']['args']];
    }
    $LinkLabel = $link['#'];
    $WindowName = md5($link['@']['url']);
    $tpl_data['links'][]=array(
        'url'        => $BaseURL . $LinkArgs,
        'label'      => $LinkLabel, 
        'windowName' => $WindowName
    ); 
}



//Output template using Smarty
$tpl_data['css'] = $config->getSetting('css');
$smarty = new Smarty_neurodb;
$smarty->assign($tpl_data);
$smarty->display('main.tpl');

$timer->setMarker('Compiled HTML page');

//--------------------------------------------------



ob_end_flush();

// timer
$timer->stop();
if ($config->getSetting('showTiming')) {
    // display timer
    $timer->display();
}

//print '<pre>'; print_r($tpl_data); print '</pre>';
?>
