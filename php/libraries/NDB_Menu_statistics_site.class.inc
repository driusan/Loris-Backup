<?php
require_once "Utility.class.inc";
require_once 'NDB_Menu.class.inc';

/**
 * The welcome menu
 * @package main
 */
class NDB_Menu_statistics_site extends NDB_Menu
{


    var $instruments = array(); 
    var $issues = array();
    
    function _setInstrumentName() {
        $this->instruments = Utility::getAllInstruments();
    }

    // Helper function to get a friendlier version of the instrument name.
    // This is mostly used for the MRI site statistics, which uses 
    // names like "Tarchive_Missing" for "MRI Parameter Form Completed but Missing Tarchive Entry"

    function _getIssueName($issue) {
        return $issue;
    }
    function _getInstrumentName($instrument) {
        return $this->instruments[$instrument];
        //return $instrument;
    }
    function _CompleteCount($id, $instrument) {
        if ($id == '<>1')
            $center = "AND s.CenterID {$id} ";
        else
            $center = "AND s.CenterID={$id} ";
        $DB =& Database::singleton();
        $count = $DB->pselectOne(
                "SELECT count(s.CandID)  FROM session s, 
                candidate c, flag f, {$instrument} i 
                WHERE s.ID=f.SessionID AND f.CommentID=i.CommentID 
                AND s.CandID=c.CandID  
                AND s.Active='Y' 
                $center AND f.Data_entry='Complete' 
                AND s.Current_stage <> 'Recycling Bin'
                AND f.Administration='All' 
                AND i.CommentID NOT LIKE 'DDE%'");
        if (PEAR::isError($result)) {
            return PEAR::raiseError("DB Error: ".$result->getMessage());
        }
        return $count;

    }
    function _GetResults($id, $instrument) {
        if ($id == '<>1')
            $center = "AND s.CenterID {$id} ";
        else
            $center = "AND s.CenterID={$id} ";
        $DB =& Database::singleton();
        $result = $DB->pselect("SELECT s.CandID, f.SessionID, i.CommentID, c.PSCID, 
                s.Visit_label 
                FROM session s, candidate c, flag  f, 
                {$instrument} i 
                WHERE s.ID=f.SessionID AND f.CommentID=i.CommentID 
                AND s.CandID=c.CandID  
                AND s.Active='Y' 
                AND s.Current_stage <> 'Recycling Bin'
                $center
                AND (f.Data_entry is NULL OR f.Data_entry<>'Complete') 
                AND i.CommentID NOT LIKE 'DDE%' ORDER BY s.Visit_label, c.PSCID"); //, $result);
                //s.Visit_label as Visit_label
        if (PEAR::isError($result)) {
            return PEAR::raiseError("DB Error: ".$result->getMessage());
        }
        return $result;
    }
    function setup()
    {   
        // If following a breadcrumb, redirect to the original statistics page
        // since the test_name/subtest don't work the same for the site specific
        // pages as for non-site specific
        if(isset($_GET['subtest'])) {
            header("Location: ?test_name=statistics#data_entry");
        }
        $DB =& Database::singleton();
        if(PEAR::isError($DB)) {
            return PEAR::raiseError("Could not connect to database: ".$DB->getMessage());
        }
        if ($_REQUEST['CenterID'] == '<>1')
        {
            $id = "<>1";
            $name = 'All';
        }
        else
        {
            $center = $DB->pselectRow("SELECT CenterID as ID, PSCArea as Name FROM psc WHERE CenterID =" . $_REQUEST['CenterID']); //, $center);
            $id = $center['ID'];
            $name = $center['Name'];
        }
        // List of all visits. Add to it any time a new one is seen, so
        // that we can iterate over it to display later, and leave blank
        // cells for ones that are missing for a given instrument in the 
        // template
        $visits = array();

        $this->_setInstrumentName();
        $data = array();
        foreach($this->instruments as $instrument=>$label){           
            $complete_count = $this->_CompleteCount($id, $instrument); 

            $results = $this->_GetResults($id, $instrument);

            $test_url = $instrument;

            foreach($results as $row) {
                if(!in_array($row['Visit_label'], $visits)) {
                    $visits[] = $row['Visit_label'];
                }
                $results[$row['Visit_label']][] = array(
                        'test_url' => $test_url,
                        'CandID' => $row['CandID'],
                        'SessionID' => $row['SessionID'],
                        'CommentID' => $row['CommentID'],
                        'PSCID' => $row['PSCID']
                        );
            }
            $data[] = array('name' => $this->_getInstrumentName($instrument), 'count' => $complete_count, 'incompletes' => $results);
        }

        $this->tpl_data["data"] = $data;
        $this->tpl_data["SiteName"] = $name;
        sort($visits);
        $this->tpl_data['AllVisits'] = $visits;
        $this->tpl_data['NumVisitLabels'] = count($visits);

    } // End function
} // End class
    ?>