<?php
require_once "NDB_Form.class.inc";
require_once "Email.class.inc";

/**
 * The forms for the user accounts menu
 * @package main
 */
class NDB_Form_admin_module extends NDB_Form
{
    function _hasAccess()
    {
        // create user object
        $editor =& User::singleton();
        if (PEAR::isError($editor)) {
            return PEAR::raiseError("User Error: ".$editor->getMessage());
        }
        //return $editor->hasPermission('admin_module');
        return true;
    }

    function _getDefaults()
    {
        $defaults = array();
        $DB =& Database::singleton();
        //Get the default values
        /*$DB->select("SELECT ConfigID, Value, Description FROM Config c
          JOIN ConfigSettings cc ON (cc.ID = c.ID)",$value_results);
          foreach($value_results AS $vresult){
          $defaults["PTID_".$vresult['ParameterTypeID']]=$vresult['Value'];
          }
         */
        return $defaults;
    }

    function _process($values)
    {
        if(!is_array($values) || count($values) ==0) {
            return true;
        }
        $DB =& Database::singleton();
        /*
        //delete old values
        $DB->delete("parameter_candidate", array("CandID"=>$this->identifier));

        //insert new values
        while(list($key, $value)=each($values)){
        $set="";
        $set['ParameterTypeID']=str_replace("PTID_","",$key);
        $set['CandID']=$this->identifier;
        $set['Value']=$value;
        $set['InsertTime']=time();
        $DB->insert("parameter_candidate", $set);
        }
         */
        $this->tpl_data['success'] = true;

        // freeze it, just in case
        $this->form->freeze();
    }

    function admin_module()
    {
        $DB =& Database::singleton();
        $new_config;
        $config_list = $DB->pselect("SELECT cc.Parent,c.ID, c.Value, cc.Description, cc.Name FROM Config c
                JOIN ConfigSettings cc ON (cc.ID = c.ID)",array());
        print_r($config_list);
        foreach($config_list as $config){
            $this->tpl_data['config_list'][] = $config['ID'];
            $this->tpl_data['config_elements'][$config['ID']]['Parent']= $config['Parent'];
            $this->tpl_data['config_elements'][$config['ID']]['Value']= $config['Value'];
            $this->tpl_data['config_elements'][$config['ID']]['Description']= $config['Description'];
            $this->tpl_data['config_elements'][$config['ID']]['Name']= $config['Name'];
        }
    }
}
?>
