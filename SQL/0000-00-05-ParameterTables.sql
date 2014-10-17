--
-- Table structure for table `parameter_candidate`
--

DROP TABLE IF EXISTS `parameter_candidate`;
CREATE TABLE `parameter_candidate` (
  `ParameterCandidateID` int(10) unsigned NOT NULL auto_increment,
  `CandID` int(6) NOT NULL default '0',
  `ParameterTypeID` int(10) unsigned NOT NULL default '0',
  `Value` varchar(255) default NULL,
  `InsertTime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ParameterCandidateID`),
  KEY `candidate_type` (`CandID`,`ParameterTypeID`),
  KEY `parameter_value` (`ParameterTypeID`,`Value`(64)),
  CONSTRAINT `FK_parameter_candidate_2` FOREIGN KEY (`CandID`) REFERENCES `candidate` (`CandID`),
  CONSTRAINT `FK_parameter_candidate_1` FOREIGN KEY (`ParameterTypeID`) REFERENCES `parameter_type` (`ParameterTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='per-candidate equivalent of parameter_session';

--
-- Dumping data for table `parameter_candidate`
--

LOCK TABLES `parameter_candidate` WRITE;
/*!40000 ALTER TABLE `parameter_candidate` DISABLE KEYS */;
/*!40000 ALTER TABLE `parameter_candidate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter_file`
--

DROP TABLE IF EXISTS `parameter_file`;
CREATE TABLE `parameter_file` (
  `ParameterFileID` int(10) unsigned NOT NULL auto_increment,
  `FileID` int(10) unsigned NOT NULL default '0',
  `ParameterTypeID` int(10) unsigned NOT NULL default '0',
  `Value` text,
  `InsertTime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ParameterFileID`),
  UNIQUE KEY `file_type_uniq` (`FileID`,`ParameterTypeID`),
  KEY `parameter_value` (`ParameterTypeID`,`Value`(64)),
  CONSTRAINT `FK_parameter_file_2` FOREIGN KEY (`ParameterTypeID`) REFERENCES `parameter_type` (`ParameterTypeID`),
  CONSTRAINT `FK_parameter_file_1` FOREIGN KEY (`FileID`) REFERENCES `files` (`FileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `parameter_file`
--

LOCK TABLES `parameter_file` WRITE;
/*!40000 ALTER TABLE `parameter_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `parameter_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter_session`
--

DROP TABLE IF EXISTS `parameter_session`;
CREATE TABLE `parameter_session` (
  `ParameterSessionID` int(10) unsigned NOT NULL auto_increment,
  `SessionID` int(10) unsigned NOT NULL default '0',
  `ParameterTypeID` int(10) unsigned NOT NULL default '0',
  `Value` varchar(255) default NULL,
  `InsertTime` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ParameterSessionID`),
  KEY `session_type` (`SessionID`,`ParameterTypeID`),
  KEY `parameter_value` (`ParameterTypeID`,`Value`(64)),
  CONSTRAINT `FK_parameter_session_2` FOREIGN KEY (`ParameterTypeID`) REFERENCES `parameter_type` (`ParameterTypeID`),
  CONSTRAINT `FK_parameter_session_1` FOREIGN KEY (`SessionID`) REFERENCES `session` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `parameter_session`
--

LOCK TABLES `parameter_session` WRITE;
/*!40000 ALTER TABLE `parameter_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `parameter_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter_type`
--

DROP TABLE IF EXISTS `parameter_type`;
CREATE TABLE `parameter_type` (
  `ParameterTypeID` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(255) NOT NULL default '',
  `Type` text,
  `Description` text,
  `RangeMin` double default NULL,
  `RangeMax` double default NULL,
  `SourceField` text,
  `SourceFrom` text,
  `SourceCondition` text,
  `CurrentGUITable` varchar(255) default NULL,
  `Queryable` tinyint(1) default '1',
  `IsFile` tinyint(1) default '0',
  PRIMARY KEY  (`ParameterTypeID`),
  KEY `name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='dictionary of all the variables in the project';

--
-- Dumping data for table `parameter_type`
--

LOCK TABLES `parameter_type` WRITE;
/*!40000 ALTER TABLE `parameter_type` DISABLE KEYS */;
INSERT INTO `parameter_type` VALUES 
	(1,'Selected','varchar(10)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),
	(2,'Geometric_intensity','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(3,'Intensity','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(4,'Movement_artifacts_within_scan','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(5,'Movement_artifacts_between_packets','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(6,'Coverage','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(7,'md5hash','varchar(255)','md5hash magically created by NeuroDB::File',NULL,NULL,'parameter_file.Value','parameter_file',NULL,'quat_table_1',1,0),
	(8,'Color_Artifact','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0),
	(9,'Entropy','text',NULL,NULL,NULL,NULL,'parameter_file',NULL,NULL,0,0);
/*!40000 ALTER TABLE `parameter_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter_type_category`
--

DROP TABLE IF EXISTS `parameter_type_category`;
CREATE TABLE `parameter_type_category` (
  `ParameterTypeCategoryID` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(255) default NULL,
  `Type` enum('Metavars','Instrument') default 'Metavars',
  PRIMARY KEY  (`ParameterTypeCategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `parameter_type_category`
--

LOCK TABLES `parameter_type_category` WRITE;
/*!40000 ALTER TABLE `parameter_type_category` DISABLE KEYS */;
INSERT INTO `parameter_type_category` VALUES (1,'MRI Variables','Metavars');
/*!40000 ALTER TABLE `parameter_type_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parameter_type_category_rel`
--

DROP TABLE IF EXISTS `parameter_type_category_rel`;
CREATE TABLE `parameter_type_category_rel` (
  `ParameterTypeID` int(11) unsigned NOT NULL default '0',
  `ParameterTypeCategoryID` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY  (`ParameterTypeCategoryID`,`ParameterTypeID`),
  KEY `FK_parameter_type_category_rel_1` (`ParameterTypeID`),
  CONSTRAINT `FK_parameter_type_category_rel_2` FOREIGN KEY (`ParameterTypeCategoryID`) REFERENCES `parameter_type_category` (`ParameterTypeCategoryID`),
  CONSTRAINT `FK_parameter_type_category_rel_1` FOREIGN KEY (`ParameterTypeID`) REFERENCES `parameter_type` (`ParameterTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `parameter_type_category_rel`
--

LOCK TABLES `parameter_type_category_rel` WRITE;
/*!40000 ALTER TABLE `parameter_type_category_rel` DISABLE KEYS */;
/*!40000 ALTER TABLE `parameter_type_category_rel` ENABLE KEYS */;
UNLOCK TABLES;


--
-- ADDing Meta-data Visit_label , candidate_label and candidate_dob
--

INSERT INTO parameter_type (Name, Type, Description, RangeMin, RangeMax, SourceField, SourceFrom, CurrentGUITable, Queryable, SourceCondition)
VALUES ('candidate_label','text','Identifier_of_candidate',null,null,'PSCID','candidate',null,1,null);
INSERT INTO parameter_type (Name, Type, Description, RangeMin, RangeMax, SourceField, SourceFrom, CurrentGUITable, Queryable, SourceCondition)
VALUES ('Visit_label','varchar(255)','Visit_label',null,null,'visit_label','session',null,1,null);
INSERT INTO parameter_type (Name, Type, Description, RangeMin, RangeMax, SourceField, SourceFrom, CurrentGUITable, Queryable, SourceCondition)
VALUES  ('candidate_dob','date','Candidate_Dob',null,null,'DoB','candidate',null,1,null);

INSERT INTO parameter_type_category (Name, type) VALUES('Identifiers', 'Metavars');

INSERT INTO parameter_type_category_rel (ParameterTypeID,ParameterTypeCategoryID)
SELECT pt.ParameterTypeID,ptc.ParameterTypeCategoryID
FROM parameter_type pt,parameter_type_category ptc
WHERE ptc.Name='Identifiers' AND pt.Name IN ('candidate_label', 'Visit_label','candidate_dob');


--
-- Table structure for table `parameter_type_override`
--

DROP TABLE IF EXISTS `parameter_type_override`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parameter_type_override` (
  `Name` varchar(255) NOT NULL,
  `Description` text,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parameter_type_override`
--

LOCK TABLES `parameter_type_override` WRITE;
/*!40000 ALTER TABLE `parameter_type_override` DISABLE KEYS */;
/*!40000 ALTER TABLE `parameter_type_override` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-21 16:13:53
