-- This file contains tables which are specific to one specific LORIS module.
-- The tables should eventually be moved into the module that they're relevent
-- to.

--
-- Table structure for table `document_repository`
--

DROP TABLE IF EXISTS `document_repository`;
CREATE TABLE `document_repository` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `PSCID` varchar(255) DEFAULT NULL,
  `Instrument` varchar(255) DEFAULT NULL,
  `visitLabel` varchar(255) DEFAULT NULL,
  `Date_taken` date DEFAULT NULL,
  `Date_uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Data_dir` varchar(255) DEFAULT NULL,
  `File_name` varchar(255) DEFAULT NULL,
  `File_type` varchar(20) DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `File_size` bigint(20) unsigned DEFAULT NULL,
  `uploaded_by` varchar(255) DEFAULT NULL,
  `For_site` int(2) DEFAULT NULL,
  `comments` text,
  `multipart` enum('Yes','No') DEFAULT NULL,
  `EARLI` tinyint(1) DEFAULT '0',
  `hide_video` tinyint(1) DEFAULT '0',
  `File_category` int(3) DEFAULT NULL,
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `document_repository`
--

LOCK TABLES `document_repository` WRITE;
/*!40000 ALTER TABLE `document_repository` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_repository` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_repository_categories`
--

DROP TABLE IF EXISTS `document_repository_categories`;
CREATE TABLE `document_repository_categories` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) DEFAULT NULL,
  `parent_id` int(3) DEFAULT '0',
  `comments` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

LOCK TABLES `document_repository_categories` WRITE;
/*!40000 ALTER TABLE `document_repository_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_repository_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_integrity_flag`
--

DROP TABLE IF EXISTS `data_integrity_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_integrity_flag` (
  `dataflag_id` int(11) NOT NULL AUTO_INCREMENT,
  `dataflag_visitlabel` varchar(255) NOT NULL,
  `dataflag_instrument` varchar(255) NOT NULL,
  `dataflag_date` date NOT NULL,
  `dataflag_status` int(11) NOT NULL,
  `dataflag_comment` text,
  `latest_entry` tinyint(1) NOT NULL DEFAULT '1',
  `dataflag_fbcreated` int(11) NOT NULL DEFAULT '0',
  `dataflag_fbclosed` int(11) NOT NULL DEFAULT '0',
  `dataflag_fbcomment` int(11) NOT NULL DEFAULT '0',
  `dataflag_fbdeleted` int(11) NOT NULL DEFAULT '0',
  `dataflag_userid` varchar(255) NOT NULL,
  PRIMARY KEY (`dataflag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_integrity_flag`
--

LOCK TABLES `data_integrity_flag` WRITE;
/*!40000 ALTER TABLE `data_integrity_flag` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_integrity_flag` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

CREATE TABLE `final_radiological_review` (
      `CommentID` varchar(255) NOT NULL,
      `Review_Done` enum('yes','no','not_answered') DEFAULT NULL,
      `Final_Review_Results` enum('normal','abnormal','atypical','not_answered') DEFAULT NULL,
      `Final_Exclusionary` enum('exclusionary','non_exclusionary','not_answered') DEFAULT NULL,
      `SAS` int(11) DEFAULT NULL,
      `PVS` int(11) DEFAULT NULL,
      `Final_Incidental_Findings` text,
      `Final_Examiner` int(11) DEFAULT NULL,
      `Final_Review_Results2` enum('normal','abnormal','atypical','not_answered') DEFAULT NULL,
      `Final_Examiner2` int(11) DEFAULT NULL,
      `Final_Exclusionary2` enum('exclusionary','non_exclusionary','not_answered') DEFAULT NULL,
      `Review_Done2` tinyint(1) DEFAULT NULL,
      `SAS2` int(11) DEFAULT NULL,
      `PVS2` int(11) DEFAULT NULL,
      `Final_Incidental_Findings2` text,
      `Finalized` enum('yes','no','not_answered') DEFAULT NULL,
      PRIMARY KEY (`CommentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- Dump completed on 2012-10-05 10:49:10

CREATE TABLE participant_status_options (
        ID int(10) unsigned NOT NULL auto_increment,
        Description varchar(255) default NULL,
        Required boolean default NULL,
        parentID int(10) default NULL,
        PRIMARY KEY  (ID),
        UNIQUE KEY ID (ID)
);
INSERT INTO `participant_status_options` VALUES
	(1,'Active',0,NULL),
	(2,'Refused/Not Enrolled',0,NULL),
	(3,'Ineligible',0,NULL),
	(4,'Excluded',0,NULL),
	(5,'Inactive',1,NULL),
	(6,'Incomplete',1,NULL),
	(7,'Complete',0,NULL),
	(8,'Unsure',NULL,5),
	(9,'Requiring Further Investigation',NULL,5),
	(10,'Not Responding',NULL,5),
	(11,'Death',NULL,6),
	(12,'Lost to Followup',NULL,6);

CREATE TABLE participant_status (
        ID int(10) unsigned NOT NULL auto_increment,
        CandID int(6) UNIQUE NOT NULL default '0',
        UserID varchar(255) default NULL,
        Examiner varchar(255) default NULL,
        entry_staff varchar(255) default NULL,
        data_entry_date timestamp NOT NULL,
        participant_status integer DEFAULT NULL REFERENCES participant_status_options(ID),
        participant_suboptions integer DEFAULT NULL REFERENCES participant_status_options(ID),
        reason_specify text default NULL,
        reason_specify_status enum('dnk','not_applicable','refusal','not_answered') default NULL,
        study_consent enum('yes','no','not_answered') default NULL,
        study_consent_date date default NULL,
        study_consent_withdrawal date default NULL,
        PRIMARY KEY  (ID),
        UNIQUE KEY ID (ID)
);


--
-- Table structure for table `certification`
--

DROP TABLE IF EXISTS `certification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certification` (
  `certID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `examinerID` int(10) unsigned NOT NULL DEFAULT '0',
  `date_cert` date DEFAULT NULL,
  `visit_label` varchar(255) DEFAULT NULL,
  `testID` varchar(255) NOT NULL DEFAULT '',
  `pass` enum('not_certified','in_training','certified') DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`certID`,`testID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certification`
--

LOCK TABLES `certification` WRITE;
/*!40000 ALTER TABLE `certification` DISABLE KEYS */;
/*!40000 ALTER TABLE `certification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `certification_history`
--

DROP TABLE IF EXISTS `certification_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certification_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `col` varchar(255) NOT NULL DEFAULT '',
  `old` text,
  `old_date` date DEFAULT NULL,
  `new` text,
  `new_date` date DEFAULT NULL,
  `primaryCols` varchar(255) DEFAULT 'certID',
  `primaryVals` text,
  `testID` int(3) DEFAULT NULL,
  `visit_label` varchar(255) DEFAULT NULL,
  `changeDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` varchar(255) NOT NULL DEFAULT '',
  `type` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


CREATE TABLE `participant_accounts` (
    `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `SessionID` int(6) DEFAULT NULL,
    `Test_name` varchar(255) DEFAULT NULL,
    `Email` varchar(255) DEFAULT NULL,
    `Status` enum('Created','Sent','In Progress','Complete') DEFAULT NULL,
    `OneTimePassword` varchar(8) DEFAULT NULL,
    `CommentID` varchar(255) DEFAULT NULL,
    `UserEaseRating` varchar(1) DEFAULT NULL,
    `UserComments` text,
    PRIMARY KEY (`ID`)
);

CREATE TABLE participant_emails(
    Test_name varchar(255) NOT NULL PRIMARY KEY REFERENCES test_names(Test_name),
    DefaultEmail TEXT NULL
);
CREATE TABLE `family` (
        `ID` int(10) NOT NULL AUTO_INCREMENT,
        `FamilyID` int(6) NOT NULL,
        `CandID` int(6) NOT NULL,
        `Relationship_type` enum('half_sibling','full_sibling','1st_cousin') DEFAULT NULL,
        PRIMARY KEY (`ID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `participant_status_history` (
        `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `CandID` int(6) NOT NULL DEFAULT 0,
        `entry_staff` varchar(255) DEFAULT NULL,
        `data_entry_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        `participant_status` int(11) DEFAULT NULL,
        `reason_specify` varchar(255),
        `reason_specify_status` enum('not_answered') DEFAULT NULL,
        `participant_subOptions` int(11) DEFAULT NULL,
        PRIMARY KEY (`ID`),
        UNIQUE KEY `ID` (`ID`)
        );
CREATE TABLE `consent_info_history` (
        `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `CandID` int(6) NOT NULL DEFAULT 0,
        `entry_staff` varchar(255) DEFAULT NULL,
        `data_entry_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        `study_consent` enum('yes','no','not_answered') DEFAULT NULL,
        `study_consent_date` date DEFAULT NULL,
        `study_consent_withdrawal` date DEFAULT NULL,
        PRIMARY KEY (`ID`),
        UNIQUE KEY `ID` (`ID`)
        ) ;


CREATE TABLE `reliability` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CommentID` varchar(255) DEFAULT NULL,
  `reliability_center_id` int(11) NOT NULL DEFAULT '1',
  `Instrument` varchar(255) DEFAULT NULL,
  `Reliability_score` decimal(4,2) DEFAULT NULL,
  `invalid` enum('no','yes') DEFAULT 'no',
  `Manual_Swap` enum('no','yes') DEFAULT 'no',
  `EARLI_Candidate` enum('no','yes') DEFAULT 'no',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
