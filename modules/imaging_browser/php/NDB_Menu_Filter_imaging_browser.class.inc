<?php
/**
 * This class features the code for the menu portion of the Loris imaging
 * browser.
 *
 * PHP Version 5
 *
 *  @package    Main
 *  @subpackage RadiologicalReview
 *  @author     Dave MacFarlane <driusan@bic.mni.mcgill.ca>
 *  @license    Loris license
 *  @link       https://www.github.com/aces/Loris-Trunk/
 */

require_once 'NDB_Menu_Filter.class.inc';

/**
 * Provides the PHP code for the menu filter for the imaging browser
 *
 *  @package    Main
 *  @subpackage Imaging
 *  @author     Dave MacFarlane <driusan@bic.mni.mcgill.ca>
 *  @license    Loris license
 *  @link       https://www.github.com/aces/Loris-Trunk/
 */
class NDB_Menu_Filter_imaging_browser extends NDB_Menu_Filter
{
    /**
     * Determine whether the user has permission to view this page
     *
     * @return bool whether the user hass access
     */
    function _hasAccess()
    {
        $user =& User::singleton();
        if (Utility::isErrorX($user)) {
            return PEAR::raiseError("User Error: " .$user->getMessage());
        }
        return $user->hasPermission('view_final_radiological_review');
    }

    /**
     * Set up the variables required by NDB_Menu_Filter class for constructing
     * a query
     *
     * @return null
     */
    function _setupVariables()
    {
        $NewDataSubquery = "CASE 
            COALESCE((SELECT MIN(QCLastChangeTime) from files left join files_qcstatus USING(FileID) WHERE files.SessionID=s.ID AND OutputType='native' AND AcquisitionProtocolID not in (1, 2, 3, 52) group by QCLastChangeTime order by QCLastChangeTime limit 1), 'new')
            WHEN 'new' THEN 'new' 
            WHEN '' THEN 'new'
            ELSE ''
            END";
        $T1PassSubquery = "CASE 
            COALESCE((SELECT MIN(files_qcstatus.QCStatus+0) FROM files JOIN files_qcstatus USING (FileID) WHERE files.SessionID=s.ID AND files.AcquisitionProtocolID=44 GROUP BY files.SessionID), '')
            WHEN '' THEN ''
            WHEN 1 THEN 'Passed'
            WHEN 2 THEN 'Failed'
            END
            ";
    $T2PassSubquery = "CASE 
            COALESCE((SELECT MIN(files_qcstatus.QCStatus+0) FROM files JOIN files_qcstatus USING (FileID) WHERE files.SessionID=s.ID AND files.AcquisitionProtocolID=45 GROUP BY files.SessionID), '')
            WHEN '' THEN ''
            WHEN 1 THEN 'Passed'
            WHEN 2 THEN 'Failed'
            END
            ";



            $this->query = " FROM psc AS p 
                JOIN session s ON (s.CenterID=p.CenterID) 
                JOIN candidate c ON (c.CandID=s.CandID) 
                JOIN files f ON (f.SessionID=s.ID) 
                LEFT JOIN files_qcstatus fqc ON (fqc.FileID=f.FileID) 
                JOIN mri_acquisition_dates md ON (md.SessionID=s.ID) 
            WHERE 
                f.PendingStaging=0 AND 
                f.FileType='mnc' AND 
                f.OutputType='native' AND 
                f.AcquisitionProtocolID not in (1, 2, 3, 52)
            GROUP BY s.ID";

        //        GROUP BY f.SessionID ORDER BY p.Name, firstAcqDate, c.CandID, s.Visit_label;
        $this->columns = array(
            'p.MRI_alias as Site',
            'c.PSCID as PSCID',
            'c.CandID as DCCID',
            's.visit_label as Visit_Label',
            's.MRIQCStatus as QC_Status',
            'MIN(md.AcquisitionDate) as First_Acq_Date',
            'MAX(fqc.QCLastChangeTime) as Last_QC',
            "$NewDataSubquery as New_Data",
            "$T1PassSubquery as T1_Passed",
            "$T2PassSubquery as T2_Passed",
            "'links' as Links"
        );
        $this->order_by = 'c.PSCID, s.Visit_label';
        $this->group_by = 's.ID';
        $this->headers = array(
            'Site',
            'PSCID',
            'DCCID',
            'Visit_Label',
            'QC_Status', 
            'First_Acq_Date',
            'Last_QC',
            'New_Data',
            'T1_Passed',
            'T2_Passed',
            'Links'
        );
        $this->validFilters = array('c.PSCID');
        
        $this->formToFilter = array ('pscid' => 'c.PSCID');
        $this->EqualityFilters = array();
        $this->searchKeyword    = array();
    }

    /**
     * Setup $this->tpl_data for use by Smarty
     *
     * @return null
     */
    function _setFilterForm()
    {
        $DB = Database::singleton();
        $this->addBasicText('pscid','PSCID', array("size"=>10,"maxlength"=>25));

        $outputTypes = $DB->pselect("SELECT DISTINCT OutputType AS outputType FROM files WHERE FileType='mnc' AND OutputType!='native'", array());

        $this->tpl_data['outputTypes'] = array_merge(
            array(
                array('outputType'=>'native'),array('outputType'=>'selected')
            ),
            $outputTypes
        );

        $this->tpl_data['numOutputTypes'] = count($outputTypes);
        $this->addBasicText('keyword','Search keyword in Comments', array("size"=>10,"maxlength"=>25));
    }
}
