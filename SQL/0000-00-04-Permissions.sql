--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `permID` int(10) unsigned NOT NULL auto_increment,
  `code` varchar(255) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `categoryID` int(10) DEFAULT NULL,
  PRIMARY KEY  (`permID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES
	(1,'superuser','There can be only one Highlander','1'),
	(2,'user_accounts','User management','2'),
	(3,'user_accounts_multisite','Across all sites create and edit users','2'),
	(4,'context_help','Edit help documentation','2'),
	(5,'bvl_feedback','Behavioural QC','1'),
	(6,'mri_feedback','Edit MRI feedback threads','2'),
	(7,'mri_efax','Edit MRI Efax files','2'),
	(8,'send_to_dcc','Send to DCC','2'),
	(9,'unsend_to_dcc','Reverse Send from DCC','2'),
	(10,'access_all_profiles','Across all sites access candidate profiles','2'),
	(11,'data_entry','Data entry','1'),
	(12,'certification','Certify examiners','2'),
	(13,'certification_multisite','Across all sites certify examiners','2'),
	(14,'timepoint_flag','Edit exclusion flags','2'),
	(15,'timepoint_flag_evaluate','Evaluate overall exclusionary criteria for the timepoint','2'),
	(16,'mri_safety','Review MRI safety form for accidental findings','2'),
	(17,'conflict_resolver','Resolving conflicts','2'),
	(18,'data_dict','Parameter Type description','2'),
	(19,'violated_scans','Violated Scans','2'),
	(20,'violated_scans_modifications','Editing the MRI protocol table (Violated Scans module)','2'),
	(21,'data_integrity_flag','Data Integrity Flag','2'),
	(22,'config','Edit configuration settings','2'),
	(23,'edit_final_radiological_review','Can edit final radiological reviews','2'),
	(24,'view_final_radiological_review','Can see final radiological reviews','2');

/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_category`
--

DROP TABLE IF EXISTS `permissions_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_category` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_category`
--

LOCK TABLES `permissions_category` WRITE;
/*!40000 ALTER TABLE `permissions_category` DISABLE KEYS */;
INSERT INTO `permissions_category` VALUES (1,'Roles'),(2,'Permission');
/*!40000 ALTER TABLE `permissions_category` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `user_perm_rel`;
CREATE TABLE `user_perm_rel` (
  `userID` int(10) unsigned NOT NULL default '0',
  `permID` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`userID`,`permID`),
  KEY `FK_user_perm_rel_2` (`permID`),
  CONSTRAINT `FK_user_perm_rel_2` FOREIGN KEY (`permID`) REFERENCES `permissions` (`permID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_user_perm_rel_1` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_perm_rel`
--

LOCK TABLES `user_perm_rel` WRITE;
/*!40000 ALTER TABLE `user_perm_rel` DISABLE KEYS */;
INSERT INTO `user_perm_rel` VALUES 
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10),
	(1,11),
	(1,12),
	(1,13),
	(1,14),
	(1,15),
	(1,16);
/*!40000 ALTER TABLE `user_perm_rel` ENABLE KEYS */;
UNLOCK TABLES;
