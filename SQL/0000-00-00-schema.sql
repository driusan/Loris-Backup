
-- MySQL dump 10.11
--
-- Host: localhost    Database: smart_dummy
-- ------------------------------------------------------
-- Server version	5.0.45-Debian_1ubuntu3.3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;
CREATE TABLE `candidate` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `CandID` int(6) NOT NULL default '0',
  `PSCID` varchar(255) NOT NULL default '',
  `ExternalID` varchar(255) default NULL,
  `DoB` date default NULL,
  `EDC` date default NULL,
  `Gender` enum('Male','Female') default NULL,
  `CenterID` tinyint(2) unsigned NOT NULL default '0',
  `ProjectID` int(11) default NULL,
  `Ethnicity` varchar(255) default NULL,
  `Active` enum('Y','N') NOT NULL default 'Y',
  `Date_active` date default NULL,
  `RegisteredBy` varchar(255) default NULL,
  `UserID` varchar(255) NOT NULL default '',
  `Date_registered` date default NULL,
  `flagged_caveatemptor` enum('true','false') default 'false',
  `flagged_reason` int(6),
  `flagged_other` varchar(255) default NULL,
  `flagged_other_status` enum('not_answered') default NULL,
  `Testdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `Entity_type` enum('Human','Scanner') NOT NULL default 'Human',
  `ProbandGender` enum('Male','Female') DEFAULT NULL,
  `ProbandDoB` date DEFAULT NULL,
  PRIMARY KEY  (`CandID`),
  UNIQUE KEY `ID` (`ID`),
  UNIQUE KEY `ExternalID` (`ExternalID`),
  KEY `FK_candidate_1` (`CenterID`),
  CONSTRAINT `FK_candidate_1` FOREIGN KEY (`CenterID`) REFERENCES `psc` (`CenterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `candidate`
--

LOCK TABLES `candidate` WRITE;
/*!40000 ALTER TABLE `candidate` DISABLE KEYS */;
/*!40000 ALTER TABLE `candidate` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `examiners`
--

DROP TABLE IF EXISTS `examiners`;
CREATE TABLE `examiners` (
  `examinerID` int(10) unsigned NOT NULL auto_increment,
  `full_name` varchar(255) default NULL,
  `centerID` tinyint(2) unsigned default NULL,
  `radiologist` tinyint(1) default NULL,
  PRIMARY KEY  (`examinerID`),
  UNIQUE KEY `full_name` (`full_name`,`centerID`),
  KEY `FK_examiners_1` (`centerID`),
  CONSTRAINT `FK_examiners_1` FOREIGN KEY (`centerID`) REFERENCES `psc` (`CenterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `examiners`
--

LOCK TABLES `examiners` WRITE;
/*!40000 ALTER TABLE `examiners` DISABLE KEYS */;
/*!40000 ALTER TABLE `examiners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_bvl_entry`
--

DROP TABLE IF EXISTS `feedback_bvl_entry`;
CREATE TABLE `feedback_bvl_entry` (
  `ID` int(11) unsigned NOT NULL auto_increment,
  `FeedbackID` int(11) unsigned default NULL,
  `Comment` text,
  `UserID` varchar(255) default NULL,
  `Testdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`ID`),
  KEY `FK_feedback_bvl_entry_1` (`FeedbackID`),
  CONSTRAINT `FK_feedback_bvl_entry_1` FOREIGN KEY (`FeedbackID`) REFERENCES `feedback_bvl_thread` (`FeedbackID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_bvl_entry`
--

LOCK TABLES `feedback_bvl_entry` WRITE;
/*!40000 ALTER TABLE `feedback_bvl_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback_bvl_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_bvl_thread`
--

DROP TABLE IF EXISTS `feedback_bvl_thread`;
CREATE TABLE `feedback_bvl_thread` (
  `FeedbackID` int(11) unsigned NOT NULL auto_increment,
  `CandID` int(6) default NULL,
  `SessionID` int(11) unsigned default NULL,
  `CommentID` varchar(255) default NULL,
  `Feedback_level` enum('profile','visit','instrument') NOT NULL default 'profile',
  `Feedback_type` int(11) unsigned default NULL,
  `Public` enum('N','Y') NOT NULL default 'N',
  `Status` enum('opened','answered','closed','comment') NOT NULL default 'opened',
  `Active` enum('N','Y') NOT NULL default 'N',
  `Date_taken` date default NULL,
  `UserID` varchar(255) NOT NULL default '',
  `Testdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `FieldName` text default NULL,
  PRIMARY KEY  (`FeedbackID`),
  KEY `FK_feedback_bvl_thread_1` (`Feedback_type`),
  CONSTRAINT `FK_feedback_bvl_thread_1` FOREIGN KEY (`Feedback_type`) REFERENCES `feedback_bvl_type` (`Feedback_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_bvl_thread`
--

LOCK TABLES `feedback_bvl_thread` WRITE;
/*!40000 ALTER TABLE `feedback_bvl_thread` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback_bvl_thread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_bvl_type`
--

DROP TABLE IF EXISTS `feedback_bvl_type`;
CREATE TABLE `feedback_bvl_type` (
  `Feedback_type` int(11) unsigned NOT NULL auto_increment,
  `Name` varchar(100) NOT NULL default '',
  `Description` text,
  PRIMARY KEY  (`Feedback_type`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_bvl_type`
--

LOCK TABLES `feedback_bvl_type` WRITE;
/*!40000 ALTER TABLE `feedback_bvl_type` DISABLE KEYS */;
INSERT INTO `feedback_bvl_type` VALUES 
    (1,'Input','Input Errors'),
    (2,'Scoring','Scoring Errors');
/*!40000 ALTER TABLE `feedback_bvl_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_bvl_types_site`
--

DROP TABLE IF EXISTS `feedback_bvl_types_site`;
CREATE TABLE `feedback_bvl_types_site` (
  `Feedback_type` int(11) unsigned NOT NULL default '0',
  `CenterID` tinyint(2) unsigned NOT NULL default '0',
  PRIMARY KEY  (`Feedback_type`,`CenterID`),
  KEY `FK_feedback_bvl_types_site_2` (`CenterID`),
  CONSTRAINT `FK_feedback_bvl_types_site_2` FOREIGN KEY (`CenterID`) REFERENCES `psc` (`CenterID`),
  CONSTRAINT `FK_feedback_bvl_types_site_1` FOREIGN KEY (`Feedback_type`) REFERENCES `feedback_bvl_type` (`Feedback_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_bvl_types_site`
--

LOCK TABLES `feedback_bvl_types_site` WRITE;
/*!40000 ALTER TABLE `feedback_bvl_types_site` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback_bvl_types_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flag`
--

DROP TABLE IF EXISTS `flag`;
CREATE TABLE `flag` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `SessionID` int(10) unsigned NOT NULL default '0',
  `Test_name` varchar(255) NOT NULL default '',
  `CommentID` varchar(255) NOT NULL default '',
  `Data_entry` enum('In Progress','Complete') default NULL,
  `Administration` enum('None','Partial','All') default NULL,
  `Validity` enum('Questionable','Invalid','Valid') default NULL,
  `Exclusion` enum('Fail','Pass') default NULL,
  `Flag_status` enum('P','Y','N','F') default NULL,
  `UserID` varchar(255) default NULL,
  `Testdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`CommentID`),
  KEY `Status` (`Flag_status`),
  KEY `flag_ID` (`ID`),
  KEY `flag_SessionID` (`SessionID`),
  KEY `flag_Test_name` (`Test_name`),
  KEY `flag_Exclusion` (`Exclusion`),
  KEY `flag_Data_entry` (`Data_entry`),
  KEY `flag_Validity` (`Validity`),
  KEY `flag_Administration` (`Administration`),
  KEY `flag_UserID` (`UserID`),
  CONSTRAINT `FK_flag_1` FOREIGN KEY (`SessionID`) REFERENCES `session` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_flag_2` FOREIGN KEY (`Test_name`) REFERENCES `test_names` (`Test_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `flag`
--

LOCK TABLES `flag` WRITE;
/*!40000 ALTER TABLE `flag` DISABLE KEYS */;
/*!40000 ALTER TABLE `flag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `id` int(11) NOT NULL auto_increment,
  `tbl` varchar(255) NOT NULL default '',
  `col` varchar(255) NOT NULL default '',
  `old` text,
  `new` text,
  `primaryCols` text,
  `primaryVals` text,
  `changeDate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `userID` varchar(255) NOT NULL default '',
  `type` char(1),
  PRIMARY KEY  (`id`),
  KEY `FK_history_1` (`userID`),
  CONSTRAINT `FK_history_1` FOREIGN KEY (`userID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table keeps track of ongoing changes in the database. ';

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instrument_subtests`
--

DROP TABLE IF EXISTS `instrument_subtests`;
CREATE TABLE `instrument_subtests` (
  `ID` int(11) NOT NULL auto_increment,
  `Test_name` varchar(255) NOT NULL default '',
  `Subtest_name` varchar(255) NOT NULL default '',
  `Description` varchar(255) NOT NULL default '',
  `Order_number` int(11) NOT NULL default '0',
  PRIMARY KEY  (`ID`),
  KEY `FK_instrument_subtests_1` (`Test_name`),
  CONSTRAINT `FK_instrument_subtests_1` FOREIGN KEY (`Test_name`) REFERENCES `test_names` (`Test_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `instrument_subtests`
--

LOCK TABLES `instrument_subtests` WRITE;
/*!40000 ALTER TABLE `instrument_subtests` DISABLE KEYS */;
/*!40000 ALTER TABLE `instrument_subtests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `psc`
--

DROP TABLE IF EXISTS `psc`;
CREATE TABLE `psc` (
  `CenterID` tinyint(2) unsigned NOT NULL auto_increment,
  `Name` varchar(150) NOT NULL default '',
  `PSCArea` varchar(150),
  `Address` varchar(150),
  `City` varchar(150),
  `StateID` tinyint(2) unsigned,
  `ZIP` varchar(12),
  `Phone1` varchar(12),
  `Phone2` varchar(12),
  `Contact1` varchar(150),
  `Contact2` varchar(150),
  `Alias` char(3) NOT NULL default '',
  `MRI_alias` varchar(4) NOT NULL default '',
  `Account` varchar(8),
  `Study_site` enum('N','Y') default 'Y',
  PRIMARY KEY  (`CenterID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `psc`
--

LOCK TABLES `psc` WRITE;
/*!40000 ALTER TABLE `psc` DISABLE KEYS */;
INSERT INTO `psc` VALUES (1,'Data Coordinating Center','','','',0,'','','','','','DCC','','','Y');
/*!40000 ALTER TABLE `psc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_gui_downloadable_queries`
--

DROP TABLE IF EXISTS `query_gui_downloadable_queries`;
CREATE TABLE `query_gui_downloadable_queries` (
  `queryID` int(10) unsigned NOT NULL auto_increment,
  `query` text,
  `filename` varchar(255) default NULL,
  `userID` int(11) unsigned default NULL,
  `downloadDate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`queryID`),
  KEY `FK_query_gui_downloadable_queries_1` (`userID`),
  CONSTRAINT `FK_query_gui_downloadable_queries_1` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `query_gui_downloadable_queries`
--

LOCK TABLES `query_gui_downloadable_queries` WRITE;
/*!40000 ALTER TABLE `query_gui_downloadable_queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_gui_downloadable_queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_gui_stored_queries`
--

DROP TABLE IF EXISTS `query_gui_stored_queries`;
CREATE TABLE `query_gui_stored_queries` (
  `qid` int(10) unsigned NOT NULL auto_increment,
  `userID` int(11) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `selected_fields` text,
  `conditionals` text,
  `conditionals_groups` text,
  `access` enum('private','public') NOT NULL default 'private',
  PRIMARY KEY  (`qid`),
  KEY `name` (`name`),
  KEY `FK_query_gui_stored_queries_1` (`userID`),
  CONSTRAINT `FK_query_gui_stored_queries_1` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `query_gui_stored_queries`
--

LOCK TABLES `query_gui_stored_queries` WRITE;
/*!40000 ALTER TABLE `query_gui_stored_queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_gui_stored_queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_gui_user_files`
--
DROP TABLE IF EXISTS `query_gui_user_files`;
CREATE TABLE query_gui_user_files (
    UserFileID integer auto_increment primary key,
    UserID integer REFERENCES users(ID),
    filename varchar(255),
    downloadDate timestamp DEFAULT CURRENT_TIMESTAMP,
    md5sum varchar(32),
    status enum('ready', 'packaging', 'expired')
);

--
-- Dumping data for table `query_gui_user_files`
--

LOCK TABLES `query_gui_user_files` WRITE;
/*!40000 ALTER TABLE `query_gui_user_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_gui_user_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `CandID` int(6) NOT NULL default '0',
  `CenterID` tinyint(2) unsigned default NULL,
  `VisitNo` smallint(5) unsigned default NULL,
  `Visit_label` varchar(255) default NULL,
  `SubprojectID` int(11) default NULL,
  `Submitted` enum('Y','N') default NULL,
  `Current_stage` enum('Not Started','Screening','Visit','Approval','Subject','Recycling Bin') default NULL,
  `Date_stage_change` date default NULL,
  `Screening` enum('Pass','Failure','Withdrawal','In Progress') default NULL,
  `Date_screening` date default NULL,
  `Visit` enum('Pass','Failure','Withdrawal','In Progress') default NULL,
  `Date_visit` date default NULL,
  `Approval` enum('In Progress','Pass','Failure') default NULL,
  `Date_approval` date default NULL,
  `Active` enum('Y','N') NOT NULL default 'Y',
  `Date_active` date default NULL,
  `RegisteredBy` varchar(255) default NULL,
  `UserID` varchar(255) NOT NULL default '',
  `Date_registered` date default NULL,
  `Testdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `Hardcopy_request` enum('-','N','Y') NOT NULL default '-',
  `BVLQCStatus` enum('Complete') default NULL,
  `BVLQCType` enum('Visual','Hardcopy') default NULL,
  `BVLQCExclusion` enum('Excluded','Not Excluded') default NULL,
  `QCd` enum('Visual','Hardcopy') default NULL,
  `Scan_done` enum('N','Y') default NULL,
  `MRIQCStatus` enum('','Pass','Fail') NOT NULL default '',
  `MRIQCPending` enum('Y','N') NOT NULL default 'N',
  `MRIQCFirstChangeTime` datetime default NULL,
  `MRIQCLastChangeTime` datetime default NULL,
  PRIMARY KEY  (`ID`),
  KEY `session_candVisit` (`CandID`,`VisitNo`),
  KEY `FK_session_2` (`CenterID`),
  CONSTRAINT `FK_session_2` FOREIGN KEY (`CenterID`) REFERENCES `psc` (`CenterID`),
  CONSTRAINT `FK_session_1` FOREIGN KEY (`CandID`) REFERENCES `candidate` (`CandID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table holding session information';

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_battery`
--

DROP TABLE IF EXISTS `test_battery`;
CREATE TABLE `test_battery` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `Test_name` varchar(255) NOT NULL default '',
  `AgeMinDays` int(10) unsigned default NULL,
  `AgeMaxDays` int(10) unsigned default NULL,
  `Active` enum('Y','N') NOT NULL default 'Y',
  `Stage` varchar(255) default NULL,
  `SubprojectID` int(11) default NULL,
  `Visit_label` varchar(255) default NULL,
  `CenterID` int(11) default NULL,
  `firstVisit` enum('Y','N') default NULL,
  PRIMARY KEY  (`ID`),
  KEY `age_test` (`AgeMinDays`,`AgeMaxDays`,`Test_name`),
  KEY `FK_test_battery_1` (`Test_name`),
  CONSTRAINT `FK_test_battery_1` FOREIGN KEY (`Test_name`) REFERENCES `test_names` (`Test_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `test_battery`
--

LOCK TABLES `test_battery` WRITE;
/*!40000 ALTER TABLE `test_battery` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_battery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_names`
--

DROP TABLE IF EXISTS `test_names`;
CREATE TABLE `test_names` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `Test_name` varchar(255) default NULL,
  `Full_name` varchar(255) default NULL,
  `Sub_group` int(11) unsigned default NULL,
  `IsDirectEntry` boolean default NULL,
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `Test_name` (`Test_name`),
  KEY `FK_test_names_1` (`Sub_group`),
  CONSTRAINT `FK_test_names_1` FOREIGN KEY (`Sub_group`) REFERENCES `test_subgroups` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `test_names`
--

LOCK TABLES `test_names` WRITE;
/*!40000 ALTER TABLE `test_names` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_subgroups`
--

DROP TABLE IF EXISTS `test_subgroups`;
CREATE TABLE `test_subgroups` (
  `ID` int(11) unsigned NOT NULL auto_increment,
  `Subgroup_name` varchar(255) default NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `test_subgroups`
--

LOCK TABLES `test_subgroups` WRITE;
/*!40000 ALTER TABLE `test_subgroups` DISABLE KEYS */;
INSERT INTO test_subgroups VALUES (1, 'Instruments');
/*!40000 ALTER TABLE `test_subgroups` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `Visit_Windows` (
  `Visit_label` varchar(255) DEFAULT NULL,
  `WindowMinDays` int(11) DEFAULT NULL,
  `WindowMaxDays` int(11) DEFAULT NULL,
  `OptimumMinDays` int(11) DEFAULT NULL,
  `OptimumMaxDays` int(11) DEFAULT NULL,
  `WindowMidpointDays` int(11) DEFAULT NULL
);
--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `ID` int(10) unsigned NOT NULL auto_increment,
  `UserID` varchar(255) NOT NULL default '',
  `Password` varchar(255) default NULL,
  `Real_name` varchar(255) default NULL,
  `First_name` varchar(255) default NULL,
  `Last_name` varchar(255) default NULL,
  `Degree` varchar(255) default NULL,
  `Position_title` varchar(255) default NULL,
  `Institution` varchar(255) default NULL,
  `Department` varchar(255) default NULL,
  `Address` varchar(255) default NULL,
  `City` varchar(255) default NULL,
  `State` varchar(255) default NULL,
  `Zip_code` varchar(255) default NULL,
  `Country` varchar(255) default NULL,
  `Fax` varchar(255) default NULL,
  `Email` varchar(255) NOT NULL default '',
  `CenterID` tinyint(2) unsigned default NULL,
  `Privilege` tinyint(1) NOT NULL default '0',
  `PSCPI` enum('Y','N') NOT NULL default 'N',
  `DBAccess` varchar(10) NOT NULL default '',
  `Active` enum('Y','N') NOT NULL default 'Y',
  `Examiner` enum('Y','N') NOT NULL default 'N',
  `Password_md5` varchar(34) default NULL,
  `Password_expiry` date NOT NULL default '0000-00-00',
  `Pending_approval` enum('Y','N') default 'Y',
  `Doc_Repo_Notifications` enum('Y','N') default 'N',
  PRIMARY KEY  (`ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `UserID` (`UserID`),
  KEY `FK_users_1` (`CenterID`),
  CONSTRAINT `FK_users_1` FOREIGN KEY (`CenterID`) REFERENCES `psc` (`CenterID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (ID,UserID,Real_name,First_name,Last_name,Email,CenterID,Privilege,PSCPI,DBAccess,Active,Examiner,Password_md5,Password_expiry) 
VALUES (1,'admin','Admin account','Admin','account','admin@localhost',1,0,'N','','Y','N','4817577f267cc8bb20c3e58b48a311b9f6','2015-03-30');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

CREATE TABLE `conflicts_unresolved` (
      `ConflictID` int(10) NOT NULL AUTO_INCREMENT,
      `TableName` varchar(255) NOT NULL,
      `ExtraKeyColumn` varchar(255) DEFAULT NULL,
      `ExtraKey1` varchar(255) NOT NULL,
      `ExtraKey2` varchar(255) NOT NULL,
      `FieldName` varchar(255) NOT NULL,
      `CommentId1` varchar(255) NOT NULL,
      `Value1` varchar(255) DEFAULT NULL,
      `CommentId2` varchar(255) NOT NULL,
      `Value2` varchar(255) DEFAULT NULL,
      PRIMARY KEY (`ConflictID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `conflicts_resolved` (
      `ResolvedID` int(10) NOT NULL AUTO_INCREMENT,
      `UserID` varchar(255) NOT NULL,
      `ResolutionTimestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `User1` varchar(255) DEFAULT NULL,
      `User2` varchar(255) DEFAULT NULL,
      `TableName` varchar(255) NOT NULL,
      `ExtraKeyColumn` varchar(255) DEFAULT NULL,
      `ExtraKey1` varchar(255) NOT NULL DEFAULT '',
      `ExtraKey2` varchar(255) NOT NULL DEFAULT '',
      `FieldName` varchar(255) NOT NULL,
      `CommentId1` varchar(255) NOT NULL,
      `CommentId2` varchar(255) NOT NULL,
      `OldValue1` varchar(255) DEFAULT NULL,
      `OldValue2` varchar(255) DEFAULT NULL,
      `NewValue` varchar(255) DEFAULT NULL,
      `ConflictID` int(10) DEFAULT NULL,
      PRIMARY KEY (`ResolvedID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `session_status`
--

DROP TABLE IF EXISTS `session_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_status` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `SessionID` int(11) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `session_status_index` (`SessionID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_status`
--

LOCK TABLES `session_status` WRITE;
/*!40000 ALTER TABLE `session_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-04-16 21:15:00




/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-21 16:13:53


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


DROP TABLE IF EXISTS `project_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_rel` (
  `ProjectID` int(2) DEFAULT NULL,
  `SubprojectID` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_account_history` (
ID int(10) unsigned NOT NULL AUTO_INCREMENT,
UserID varchar(255) NOT NULL DEFAULT '',
PermID int(10) unsigned DEFAULT NULL,
PermAction enum('I','D') DEFAULT NULL,
ChangeDate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

CREATE TABLE `user_login_history` (
  `loginhistoryID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userID` varchar(255) NOT NULL DEFAULT '',
  `Success` enum('Y','N') NOT NULL DEFAULT 'Y',
  `Failcode` varchar(2) DEFAULT NULL,
  `Fail_detail` varchar(255) DEFAULT NULL,
  `Login_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IP_address` varchar(255) DEFAULT NULL,
  `Page_requested` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`loginhistoryID`),
  KEY `FK_user_login_history_1` (`userID`),
  CONSTRAINT `FK_user_login_history_1` FOREIGN KEY (`userID`) REFERENCES `users` (`UserID`)
)  ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
