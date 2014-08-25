<?php

require_once "PEAR.php";
require_once "HTML/QuickForm2.php";
include_once ('HTML/QuickForm2/Renderer/Array.php');

class NDB_Page extends PEAR
{
    /**
     * The name of the test_name being accessed
     */
    var $name;

    /**
     * The name of the page (subtest) being accessed
     */
    var $page;

    /**
     * Reference to the HTML QuickForm
     */
    var $form;

    /**
     * The identifier for the item to edit
     * (ie. the CommentID)
     */
    var $identifier;
    var $commentID;

    /**
     * Form defaults
     */
    var $defaults = array();

    function _setupPage($name, $page, $identifier, $commentID, $formname) {
        $this->form = new HTML_QuickForm2($formname);
        $this->name = $name;
        $this->page = $page;
        $this->identifier = $identifier;
        $this->commentID = $commentID;
        $this->defaults = array();
    }
    
    
    /**
    * Wrapper to create a file element
    */
    function addFile($name, $label) {
        $this->form->addElement('file', $name, $label);
    }

     /**
    * Wrapper to create a header
    */

    function addHeader($header) {
        $this->form->addElement('header', null, $header);
    }

    /**
    * Wrapper to create a select drop-down list
    */

    function addSelect($name, $label, $options, $optional=array()) {
        $optional = array_merge(array('class' => 'form-control input-sm'), $optional);
        $this->form->addElement('select', $name, $optional, array('label' => $label, 'options' => $options))->setId($name);
    }

    /**
    * Wrapper to create a static label
    */

    function addLabel($label) {
        $this->form->addElement('static', null, $label);
    }

    /**
    * Wrapper to create a static score column
    */

    function addScoreColumn($name, $label) {
        $this->form->addElement('static', $name, $label);
    }


    function addBasicText($field, $label, $options=array()) {
        $options = array_merge(array('class' => 'form-control input-sm'), $options);
        $this->form->addElement('text', $field, $options, array('label' => $label))->setId($field);
    }

    function addBasicTextArea($field, $label, $specifications=array('class' => 'form-control input-sm')) {
        $this->form->addElement('textarea', $field, $label, $specifications);
    }

    function addBasicDate($field, $label, $options=array(), $attr=array('class' => 'form-control input-sm', 'style' => 'max-width:33%; display:inline-block;')) {
        $this->form->addElement(
            'date',
            $field,
            null,
            array_merge($options, array('label' => $label))
        )->setId($field);
    }
 
    function addHidden($name, $value=null, $attributes=null) {
        $this->form->addElement('hidden', $name, $attributes);
        if($value !== null) {
            $this->defaults[$name] = $value;
        }
    }

    function addTextAreaGroup($field, $label,$not_answered_options=array('' =>'', 'not_answered' => 'Not Answered')) {
        $group = array();
        $group[] = $this->createTextArea($field, '');
        $group[] = $this->createSelect($field . '_status', '', $not_answered_options, array('class' => 'form-control input-sm not-answered'));

        $this->addGroup($group, $field . '_group', $label, null, false); 


    }
    function addRule($element, $message, $type, $format=null) {
        $elementEl = $this->form->getElementById($element);
        $elementEl->addRule($type, $message, $format);
    }

    function addGroupRule($group, $arg1, $type='', $format=null) {
        $groupEl = $this->form->getElementById($group);
        $groupEl->addRule($type, $arg1, $format);
    }

    function addGroup($elements, $name, $label, $separator, $appendName=null) {
        $group = $this->form->addGroup($name)->setLabel($label)->setSeparator($separator);
        foreach($elements as $el) {
            $group->addElement($el);
        }
    }
    function addPassword($field, $label=null, $attr=array('class' => 'form-control input-sm')){
        $this->form->addElement('password', $field, $label, $attr);
    }

    function createSelect($field, $label, $options=null, $attr=array('class' => 'form-control input-sm')) {
	   return HTML_QuickForm2_Factory::createElement("select", $field, $attr, array('label' => $label, 'options' => $options));
    }

    function createText($field, $label=null, $attr=array('class' => 'form-control input-sm')) {
       return $this->form->createElement("text", $field, $label, $attr);
    } 

    function createTextArea($field, $label=null) {
       return HTML_QuickForm2_Factory::createElement("textarea", $field, null, array('label' => $label, 'class' => 'form-control input-sm'));
    } 
    function createDate($field, $label, $dateOptions=null, $attr=array('class' => 'form-control input-sm', 'style' => 'max-width:33%; display:inline-block;')) {
        return $this->form->createElement("date", $field, $label, $dateOptions, $attr);
    }
    function createCheckbox($field, $label, $options=null, $closer='</label>'){
        $group = array();
        $group[] = $this->form->createElement('static', null, null, '<label>');
        // $html = '<label><input type=\'checkbox\'> '.$label.'</label>';
        $group[] = $this->form->createElement('advcheckbox', $field, null, null, $options);
        $group[] = $this->form->createElement('static', 'checkLabel', null, $label.$closer);
        return $group;
        // return $this->form->createElement('static', null, null, $html);
    }
    function createPassword($field, $label=null, $attr=array('class' => 'form-control input-sm')){
        return $this->form->createElement('password', $field, $label, $attr);
    }

    /**
     * Displays the form
     *
     * @return void
     * @access public
     */
    function display()
    {

        if(!$this->form->toggleFrozen()) {
            // hidden values
              $this->addHidden('test_name', $this->name);
              $this->addHidden('subtest', $this->page);
              $this->addHidden('identifier', $this->identifier);
         }

        $localDefaults = $this->_getDefaults();
        // get the defaults
        if (Utility::isErrorX($localDefaults)) {
            return PEAR::raiseError("NDB_Form::display(): ".$localDefaults->getMessage());
        }
        if(!is_array($localDefaults)) { $localDefaults = array(); }
        // set the quickform object defaults
        $this->_setDefaults(array_merge($this->defaults, $localDefaults));

            // trim all values
        $this->form->addRecursiveFilter('trim');

        // display the HTML_Quickform object
        $renderer = HTML_QuickForm2_Renderer::factory('Stub');
        $renderer->setOption(array(
            'group_errors' => true,
            'group_hiddens' => true
        ));
        $this->form->render($renderer);

        $smarty = new Smarty_neurodb($this->name);
        $smarty->ModuleName = $this->name;

        $FormData = array();
        foreach($this->form as $element) {
            $ID = $element->getId();
            $FormData[$ID] = array(
                'label' => $element->getLabel(),
                'html' => $element->__toString(),
                'error' => $element->getError()
            );
        }
        $FormData['errors'] = $renderer->getErrors();

        $hiddenStr = '';
        foreach($renderer->getHidden() as $hiddenEl) {
            $hiddenStr .= $hiddenEl;
        }
        $FormData['hidden'] = $hiddenStr;

        //$FormData['errors'] = $renderer->getErrors();
        //print_r($renderer->getErrors());
        $smarty->assign($this->tpl_data);
        $smarty->assign('form', $FormData);
        $html = $smarty->fetch("form_$this->template.tpl");
        return $html;
    }

    /**
     * Returns the form-specific defaults
     *
     * @note   overloaded function
     * @return array
     * @access private
     */
    function _getDefaults()
    {
        return $this->defaults;
    }    

    function _setDefaults($defaults= array()) {
        $this->defaults = $defaults;
        $this->form->addDataSource(
            new HTML_QuickForm2_DataSource_Array($defaults)
        );
    }
}
?>
