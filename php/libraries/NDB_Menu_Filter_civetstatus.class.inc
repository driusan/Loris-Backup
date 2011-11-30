<?
require_once 'NDB_Menu_Filter.class.inc';

class NDB_Menu_Filter_civetstatus extends NDB_Menu_Filter
{
    function _hasAccess()
    {
        $user =& User::singleton();
        if (PEAR::isError($user)) {
            return PEAR::raiseError("User Error: " .$user->getMessage());
        }
        return $user->hasPermission('view_cbrain_status');
    }

    function _setupVariables()
    {
        $user =& User::singleton();

        $this->query = " FROM CBrainTasks ct LEFT JOIN CBrainSubmittedFiles sf ON (ct.ID=sf.CBrainTaskID) LEFT JOIN files f ON (f.FileID=sf.FileID) LEFT JOIN CivetFileStatus cfs ON (cfs.CBrainSubmitID=sf.ID) WHERE ct.UserID=" . $user->getData('ID');
        $this->columns = array(
                'ct.CBrainHost',
                'f.SessionID',
                'ct.TaskID as CBrain_Task',
                'ct.Status as Task_Status',
                'SUBSTRING_INDEX(f.File, \'/\', -1) as Source_File',
                'Classify_output',
                'Thickness_Left',
                'Thickness_Right',
                'Surfaces_Left',
                'Surfaces_Right',
                'Final',
                );
        $this->order_by = 'f.File';
        $this->headers = array('CBrain_Task', 'Task_Status', 'Source_File', 'Classify Output', 'Thickness_Left', 'Thickness_Right', 'Surfaces_Left', 'Surfaces_Right', 'Final');
        $this->validFilters = array('ct.Status', 'ct.TaskID', 'f.File', 'SUBSTRING_INDEX(f.File, \'/\', -1)', 'Thickness_Left', 'Thickness_Right', 'Surfaces_Left', 'Surfaces_Right', 'Final');
        $this->formToFilter = array ('Task_Status' => 'ct.Status',
                    'Thickness_Left' => 'Thickness_Left',
                    'Thickness_Right' => 'Thickness_Right',
                    'cbraintaskstatus' => 'ct.Status',
                    'cbraintask' => 'ct.TaskID',
                    'sourcefile' => 'SUBSTRING_INDEX(f.File, \'/\', -1)'
        );
    }

    function _setFilterForm()
    {
        $list_of_statuses = array(null => 'Any', 'Unknown' => 'Unknown',
                    'New' => 'New',
                    'Setting Up'=> 'Setting Up',
                    'Queued'=> 'Queued',
                    'Data Ready'=> 'Data Ready',
                    'On CPU' => 'On CPU', 
                    'Post Processing' => 'Post Processing',
                    'Complete' => 'Complete');

        $this->form->addElement('text', 'cbraintask', 'CBrain Task:');
        $this->form->addElement('select', 'cbraintaskstatus', 'CBrain Status:', $list_of_statuses);
        $this->form->addElement('text', 'sourcefile', 'File:');


    }

    function _setDataTableRows($count)
    {
        $x = 0;
        foreach ($this->list as $item) {
            $this->tpl_data['items'][$x][0]['value'] = $x + $count;
            //print out data rows
            $i = 1;
            $host = '';
            foreach ($item as $key => $val) {
                if ($key == 'CBrainHost') {
                    $host = $val;
                    continue;
                } else if ($key == 'SessionID') {
                    $this->tpl_data['items'][$x][$i]['SessionID'] = $val;
                    continue;
                }
                if ($key == 'CBrain_Task') {
                    $this->tpl_data['items'][$x][$i]['value'] = "<a href=\"$host" . "tasks/" . $val .'">' . $val . '</a>';
                } else {
                    $this->tpl_data['items'][$x][$i]['value'] = $val;
                }
                $this->tpl_data['items'][$x][$i]['SessionID'] = $item['SessionID'];
                $this->tpl_data['items'][$x][$i]['name'] = $key;
                $i++;
            }
            $x++;
        }
    }
}
