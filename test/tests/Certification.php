<?php
/**
 * Test the functionality of the certification module in Loris.
 * Currently, it only checks that the getCertificationConfig
 * function returns the correct values from the config file.
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
require_once 'LorisTest.php';
require_once("NDB_BVL_Instrument.class.inc");

/**
 * Class to implement test for certification
 *
 *  @category Testing
 *  @package  Test
 *  @author   Dave MacFarlane <david.macfarlane2@mcgill.ca>
 *  @license  Loris license
 *  @link     http://www.loris.ca
 */
class TestOfCandidateList extends LorisTest
{

    /**
     * Test that the config file is parsed properly.
     *
     * @return null
     */
    function testCertificationConfig()
    {
        $config = NDB_Config::singleton();
        $config->load(__DIR__ . "/../fixtures/CertificationSingle.xml");
        $settings = $config->getSetting("Certification");

        $this->assertEqual($settings['EnableCertification'], "1", "Didn't load certification properly");
        // getCertificationConfig isn't static, so we need an instance.
        list($CertificationEnabled, $CertificationProjects, $CertificationInstruments)
            = NDB_BVL_Instrument::_getCertificationConfig();
        $this->assertEqual($CertificationEnabled, "1", "Didn't load enabled properly");
        $this->assertEqual($CertificationProjects, array(2), "Didn't load projects properly");
        $this->assertEqual($CertificationInstruments, array("aosi"), "Didn't load instruments properly");

        $config->load(__DIR__ . "/../fixtures/CertificationMulti.xml");
        list($CertificationEnabled, $CertificationProjects, $CertificationInstruments)
            = NDB_BVL_Instrument::_getCertificationConfig();
        $this->assertEqual($CertificationEnabled, "1", "Didn't load enabled properly");
        $this->assertEqual($CertificationProjects, array(1, 2), "Didn't load projects properly got" . print_r($CertificationProjects, true));
        $this->assertEqual($CertificationInstruments, array("aosi", "csbs", "test"), "Didn't load instruments properly");
    }

}
?>
