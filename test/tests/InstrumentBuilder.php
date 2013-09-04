<?php
/**
 * Test the loading and rules of instrument builder type instruments.
 *
 * PHP Version 5
 *
 *  @category Testing
 *  @package  Test
 *  @author   Dave MacFarlane <david.macfarlane2@mcgill.ca>
 *  @license  Loris license
 *  @link     http://www.loris.ca
 *
 */
//require_once 'LorisTest.php';
require_once __DIR__ . '/../test_includes.php';
require_once __DIR__ . '/../simpletest/mock_objects.php';
require_once 'LorisTest.php';
require_once "HTML/QuickForm.php";
require_once 'NDB_BVL_Instrument.class.inc';

Mock::generate('HTML_Quickform');
Mock::generatePartial(
    'NDB_BVL_Instrument',
    'PartialInstrument',
    array('_getExaminerNames')
);
/**
 * Class to implement tests for instrument builder file loading
 *
 *  @category Testing
 *  @package  Test
 *  @author   Dave MacFarlane <david.macfarlane2@mcgill.ca>
 *  @license  Loris license
 *  @link     http://www.loris.ca
 */
class TestOfInstrumentBuilder extends LorisTest // extends UnitTestCase
{

    /**
     * Tests that a instrument loads and populates the appropriate
     * data fields in the instrument base class
     *
     * @return none
     */
    function testSimpleLoad()
    {
        $i= new PartialInstrument();
        $i->form = new MockHTML_Quickform();
        $i->loadInstrumentFile(__DIR__ . "/../fixtures/TestInstrument.linst", false);
        $this->assertEqual(
            $i->LinstQuestions,
            array(
                'AnotherDate' => array(
                    'type' => 'date'),
                'q1' => array(
                    'type' => 'select'
                ),
                'q2' => array(
                    'type' => 'select'
                ),
                'text_q' => array(
                    'type' => 'text'
                ),
                'textarea_q' => array(
                    'type' => 'textarea'
                ),
                'numeric_q' => array(
                    'type' => 'numeric',
                    'options' => array(
                        'min' => '3',
                        'max' => '6'
                    )
                ),
            )
        );
        // Ensure that dateTimeFields was populated correctly for date fields
        $this->assertEqual(
            $i->dateTimeFields,
            array('Date_taken', 'AnotherDate_date')
        );

    }

    /**
     * Tests that rules are properly enforced when no explicit .rules
     * file exists. It tests every combination of _status being answered
     * and not answered for different data types that have a _status
     * dropdown beside the data entry.
     *
     * @return none
     */
    function testNoExplicitRules()
    {
        $i= new PartialInstrument();
        $i->form = new MockHTML_Quickform();
        $i->loadInstrumentFile(__DIR__ . "/../fixtures/TestInstrument.linst", false);

        $SampleDate = array(
            'Y' => '2009',
            'M' => '11',
            'd' => '25'
        );
        $EmptyDate = array(
            'Y' => '',
            'M' => '',
            'd' => ''
        );

        $DataEntry = array('AnotherDate_date' => $EmptyDate,
            'AnotherDate_date_status' => '',
            'q1' => 'abc',
            'q2' => '',
            'text_q' => '',
            'text_q_status' => '',
            'textarea_q' => '',
            'textarea_q_status' => '',
            'numeric_q' => '',
            'numeric_q_status' => ''
        );

        // Only 1 select box answered
        // Should generate errors for all other data types
        $errors = $i->XINValidate($DataEntry);

        $expectedErrors = array(
                'AnotherDate_date_group' => 'A Date, or Not Answered is required.',
                'text_q_group' => 'This field is required.',
                'textarea_q_group' => 'This field is required.',
                'numeric_q_group' => 'This field is required',
                'q2' => 'Required.'
            );
        $this->assertEqual($errors, $expectedErrors);

        /** TEST DATE ANSWERED/_status ERRORS */
        // Date wasn't answered but _status was, should not generate an error
        // (but q2 should still be an error)
        $DataEntry['AnotherDate_date_status'] = 'not_answered';
        unset($expectedErrors['AnotherDate_date_group']);
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        // Date was entered, _status not. Should not generate an error
        $DataEntry['AnotherDate_date_status'] = '';
        $DataEntry['AnotherDate_date'] = $SampleDate;
        $this->assertEqual($errors, $expectedErrors);

        /** TEST TEXT ANSWERED/_status ERRORS */
        // Data entered, no error
        $DataEntry['text_q'] = 'abc';
        unset($expectedErrors['text_q_group']);
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        // Status entered, still no error
        $DataEntry['text_q'] = '';
        $DataEntry['text_q_status'] = 'not_answered';
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        /** TEST TEXTAREA ANSWERED/_status ERRORS */
        $DataEntry['textarea_q'] = 'abc';
        unset($expectedErrors['textarea_q_group']);
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        // Status entered, still no error
        $DataEntry['textarea_q'] = '';
        $DataEntry['textarea_q_status'] = 'not_answered';
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        /** TEST NUMERIC ANSWERED/_status ERRORS */
        $DataEntry['numeric_q'] = '5';
        unset($expectedErrors['numeric_q_group']);
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);

        // Status entered, still no error
        $DataEntry['numeric_q'] = '';
        $DataEntry['numeric_q_status'] = 'not_answered';
        $errors = $i->XINValidate($DataEntry);
        $this->assertEqual($errors, $expectedErrors);
    }
}
?>
