<?php
/**
 * NeuroDB client - takes care of using the configuration, creating the first
 * database connection, and including a lot of commonly used libraries.  
 * By default does web-appropriate setup (session management and user auth).
 *
 * PHP Version 5
 *
 * @category Behavioural
 * @package  Loris
 * @author   The Loris Team <info-loris.mni@mcgill.ca>
 * @license  Loris license
 * @link     https://www.github.com/aces/Loris-Trunk/
 */
require_once 'Utility.class.inc';

/**
 * Class to represent the client who is accessing the database.
 *
 * @category Behavioural
 * @package  Loris
 * @author   The Loris Team <info-loris.mni@mcgill.ca>
 * @license  Loris license
 * @link     https://www.github.com/aces/Loris-Trunk/
 */
class NDB_Client
{
    /**
    * defines whether session management and user authentication is performed
    * @access private
    */
    var $_isWebClient = true;

    /**
    * defines that the client is a command line client, not a web based client
    *
    * @return none
    */
    function makeCommandLine()
    {
        $this->_isWebClient = false;
    }

    /**
     * Initializes the environment for the client to be able to use
     * Loris.
     *
     * @param string $configFile The config file that the client should
     *                           use to define the environment
     *
     * @return boolean true on success
     */
    function initialize($configFile = "../project/config.xml")
    {
        // require all relevant OO class libraries
        include_once "NDB_Config.class.inc";
        include_once "Database.class.inc";
        include_once "SinglePointLogin.class.inc";
        include_once "State.class.inc";
        include_once "User.class.inc";
        include_once "Site.class.inc";
        include_once 'NDB_Caller.class.inc';

        include_once "Candidate.class.inc";
        include_once "NDB_BVL_Battery.class.inc";
        include_once "NDB_BVL_Instrument.class.inc";
        include_once "NDB_BVL_InstrumentStatus.class.inc";
        include_once "NDB_BVL_LogicTest.class.inc";
        include_once "TimePoint.class.inc";
        include_once "Utility.class.inc";

        include_once "NDB_BVL_Feedback.class.inc";

        $config =& NDB_Config::singleton($configFile);

        // add extra include paths
        $extLibs = $config->getSetting('extLibs');
        if (!empty($extLibs)) {
            set_include_path($extLibs.":".get_include_path());
        }

        // after the extra includes, as those include Smarty
        include_once "Smarty_hook.class.inc";

        /*
        * new DB Object
        */
        $dbConfig = $config->getSetting('database');
        $DB =& Database::singleton(
            $dbConfig['database'],
            $dbConfig['username'],
            $dbConfig['password'],
            $dbConfig['host']
        );

        if (Utility::isErrorX($DB)) {
            die("Could not connect to database: ".$DB->getMessage());
        }
        $GLOBALS['DB'] =& $DB;
        
        // tell Pear to print errors if the config says so
        if ($config->getSetting('showPearErrors')) {
            PEAR::setErrorHandling(PEAR_ERROR_PRINT);
        }
        
        // stop here if this is a command line client
        if (!$this->_isWebClient) {
            return true;
        }
        
        // start php session
        session_start();

        // if exiting, destroy the php session
        if (isset($_REQUEST['logout']) && $_REQUEST['logout']) {
            session_destroy();
            setcookie("FeedbackButtonBoolean", "");
            session_start();
        }

        /**
        * Log In procedures
        */
        if (!isset($_SESSION['State'])) {
            $_SESSION['State'] =& State::singleton();
            $login = new SinglePointLogin();
            $_SESSION['State']->setProperty('login', $login);
        } else {
            $login =& $_SESSION['State']->getProperty('login');
        }
        if (!$login->isLoggedIn()) {
            $auth = $login->authenticate();
            if (Utility::isErrorX($auth)) {
            } elseif ($auth === true) {
                $error = $login->setState();
            } elseif ($auth === false) {
                $login->clearState();
            }
        }
        if (!$login->isLoggedIn()) {
            // display login window
            //ob_end_clean();
            $login->showLoginScreen();
            //terminate script
            die();
        }
        
        $user =& User::singleton($_SESSION['State']->getUsername());
        if (Utility::isErrorX($user)) {
             die("Could not validate user: ".$user->getMessage());
        }

        // finished initializing
        return true;
    }
}
?>
