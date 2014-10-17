--
-- Table structure for table `feedback_mri_comment_types`
--

DROP TABLE IF EXISTS `feedback_mri_comment_types`;
CREATE TABLE `feedback_mri_comment_types` (
  `CommentTypeID` int(11) unsigned NOT NULL auto_increment,
  `CommentName` varchar(255) NOT NULL default '',
  `CommentType` enum('volume','visit') NOT NULL default 'volume',
  `CommentStatusField` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`CommentTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_mri_comment_types`
--

LOCK TABLES `feedback_mri_comment_types` WRITE;
/*!40000 ALTER TABLE `feedback_mri_comment_types` DISABLE KEYS */;
INSERT INTO `feedback_mri_comment_types` VALUES
    (1,'Geometric intensity','volume','a:2:{s:5:\"field\";s:19:\"Geometric_intensity\";s:6:\"values\";a:5:{i:0;s:0:\"\";i:1;s:4:\"Good\";i:2;s:4:\"Fair\";i:3;s:4:\"Poor\";i:4;s:12:\"Unacceptable\";}}'),
    (2,'Intensity','volume','a:2:{s:5:\"field\";s:9:\"Intensity\";s:6:\"values\";a:5:{i:0;s:0:\"\";i:1;s:4:\"Good\";i:2;s:4:\"Fair\";i:3;s:4:\"Poor\";i:4;s:12:\"Unacceptable\";}}'),
    (3,'Movement artifact','volume','a:2:{s:5:\"field\";s:30:\"Movement_artifacts_within_scan\";s:6:\"values\";a:5:{i:0;s:0:\"\";i:1;s:4:\"None\";i:2;s:6:\"Slight\";i:3;s:4:\"Poor\";i:4;s:12:\"Unacceptable\";}}'),
    (4,'Packet movement artifact','volume','a:2:{s:5:\"field\";s:34:\"Movement_artifacts_between_packets\";s:6:\"values\";a:5:{i:0;s:0:\"\";i:1;s:4:\"None\";i:2;s:6:\"Slight\";i:3;s:4:\"Poor\";i:4;s:12:\"Unacceptable\";}}'),
    (5,'Coverage','volume','a:2:{s:5:\"field\";s:8:\"Coverage\";s:6:\"values\";a:5:{i:0;s:0:\"\";i:1;s:4:\"Good\";i:2;s:4:\"Fair\";i:3;s:5:\"Limit\";i:4;s:12:\"Unacceptable\";}}'),	    (6,'Overall','volume',''),
    (7,'Subject','visit',''),
    (8,'Dominant Direction Artifact (DWI ONLY)','volume','a:2:{s:5:"field";s:14:"Color_Artifact";s:6:"values";a:5:{i:0;s:0:"";i:1;s:4:"Good";i:2;s:4:"Fair";i:3;s:4:"Poor";i:4;s:12:"Unacceptable";}}'),
    (9,'Entropy Rating (DWI ONLY)','volume','a:2:{s:5:"field";s:7:"Entropy";s:6:"values";a:5:{i:0;s:0:"";i:1;s:10:"Acceptable";i:2;s:10:"Suspicious";i:3;s:12:"Unacceptable";i:4;s:13:"Not Available";}}');
/*!40000 ALTER TABLE `feedback_mri_comment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_mri_predefined_comments`
--

DROP TABLE IF EXISTS `feedback_mri_predefined_comments`;
CREATE TABLE `feedback_mri_predefined_comments` (
  `PredefinedCommentID` int(11) unsigned NOT NULL auto_increment,
  `CommentTypeID` int(11) unsigned NOT NULL default '0',
  `Comment` text NOT NULL,
  PRIMARY KEY  (`PredefinedCommentID`),
  KEY `CommentType` (`CommentTypeID`),
  CONSTRAINT `FK_feedback_mri_predefined_comments_1` FOREIGN KEY (`CommentTypeID`) REFERENCES `feedback_mri_comment_types` (`CommentTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_mri_predefined_comments`
--

LOCK TABLES `feedback_mri_predefined_comments` WRITE;
/*!40000 ALTER TABLE `feedback_mri_predefined_comments` DISABLE KEYS */;
INSERT INTO `feedback_mri_predefined_comments` VALUES
	(1,2,'missing slices'),
	(2,2,'reduced dynamic range due to bright artifact/pixel'),
	(3,2,'slice to slice intensity differences'),
	(4,2,'noisy scan'),
	(5,2,'susceptibilty artifact above the ear canals.'),
	(6,2,'susceptibilty artifact due to dental work'),
	(7,2,'sagittal ghosts'),
	(8,3,'slight ringing artefacts'),
	(9,3,'severe ringing artefacts'),
	(10,3,'movement artefact due to eyes'),
	(11,3,'movement artefact due to carotid flow'),
	(12,4,'slight movement between packets'),
	(13,4,'large movement between packets'),
	(14,5,'Large AP wrap around, affecting brain'),
	(15,5,'Medium AP wrap around, no affect on brain'),
	(16,5,'Small AP wrap around, no affect on brain'),
	(17,5,'Too tight LR, cutting into scalp'),
	(18,5,'Too tight LR, affecting brain'),
	(19,5,'Top of scalp cut off'),
	(20,5,'Top of brain cut off'),
	(21,5,'Base of cerebellum cut off'),
	(22,5,'missing top third - minc conversion?'),
	(23,6,'copy of prev data'),
	(24,2,"checkerboard artifact"),
	(25,2,"horizontal intensity striping (Venetian blind effect, DWI ONLY)"),
	(26,2,"diagonal striping (NRRD artifact, DWI ONLY)"),
	(27,2,"high intensity in direction of acquisition"),
	(28,2,"signal loss (dark patches)"),
	(29,8,"red artifact"),
	(30,8,"green artifact"),
	(31,8,"blue artifact"),
	(32,6,"Too few remaining gradients (DWI ONLY)"),
	(33,6,"No b0 remaining after DWIPrep (DWI ONLY)"),
	(34,6,"No gradient information available from scanner (DWI ONLY)"),
	(35,6,"Incorrect diffusion direction (DWI ONLY)"),
	(36,6,"Duplicate series"),
	(37,3,"slice wise artifact (DWI ONLY)"),
	(38,3,"gradient wise artifact (DWI ONLY)");
/*!40000 ALTER TABLE `feedback_mri_predefined_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_mri_comments`
--

DROP TABLE IF EXISTS `feedback_mri_comments`;
CREATE TABLE `feedback_mri_comments` (
  `CommentID` int(11) unsigned NOT NULL auto_increment,
  `MRIID` int(11) unsigned default NULL,
  `FileID` int(10) unsigned default NULL,
  `SeriesUID` varchar(64) default NULL,
  `EchoTime` double default NULL,
  `SessionID` int(10) unsigned default NULL,
  `PatientName` varchar(255) default NULL,
  `CandID` varchar(6) default NULL,
  `VisitNo` int(2) default NULL,
  `CommentTypeID` int(11) unsigned NOT NULL default '0',
  `PredefinedCommentID` int(11) unsigned default NULL,
  `Comment` text,
  `ChangeTime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`CommentID`),
  KEY `MRIID` (`MRIID`),
  KEY `Candidate` (`CandID`,`VisitNo`),
  KEY `NonCandidate` (`PatientName`),
  KEY `FK_feedback_mri_comments_1` (`CommentTypeID`),
  KEY `FK_feedback_mri_comments_2` (`PredefinedCommentID`),
  KEY `FK_feedback_mri_comments_3` (`FileID`),
  KEY `FK_feedback_mri_comments_4` (`SessionID`),
  CONSTRAINT `FK_feedback_mri_comments_4` FOREIGN KEY (`SessionID`) REFERENCES `session` (`ID`),
  CONSTRAINT `FK_feedback_mri_comments_1` FOREIGN KEY (`CommentTypeID`) REFERENCES `feedback_mri_comment_types` (`CommentTypeID`),
  CONSTRAINT `FK_feedback_mri_comments_2` FOREIGN KEY (`PredefinedCommentID`) REFERENCES `feedback_mri_predefined_comments` (`PredefinedCommentID`),
  CONSTRAINT `FK_feedback_mri_comments_3` FOREIGN KEY (`FileID`) REFERENCES `files` (`FileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `feedback_mri_comments`
--

LOCK TABLES `feedback_mri_comments` WRITE;
/*!40000 ALTER TABLE `feedback_mri_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback_mri_comments` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `mri_processing_protocol`
--

DROP TABLE IF EXISTS `mri_processing_protocol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mri_processing_protocol` (
  `ProcessProtocolID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ProtocolFile` varchar(255) NOT NULL DEFAULT '',
  `FileType` enum('xml','txt') DEFAULT NULL,
  `Tool` varchar(255) NOT NULL DEFAULT '',
  `InsertTime` int(10) unsigned NOT NULL DEFAULT '0',
  `md5sum` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ProcessProtocolID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `FileID` int(10) unsigned NOT NULL auto_increment,
  `SessionID` int(10) unsigned NOT NULL default '0',
  `File` varchar(255) NOT NULL default '',
  `SeriesUID` varchar(64) DEFAULT NULL,
  `EchoTime` double DEFAULT NULL,
  `CoordinateSpace` varchar(255) default NULL,
  `ClassifyAlgorithm` varchar(255) default NULL,
  `OutputType` varchar(255) NOT NULL default '',
  `AcquisitionProtocolID` int(10) unsigned default NULL,
  `FileType` enum('mnc','obj','xfm','xfmmnc','imp','vertstat','xml','txt','nii','nii.gz') default NULL,
  `PendingStaging` tinyint(1) NOT NULL default '0',
  `InsertedByUserID` varchar(255) NOT NULL default '',
  `InsertTime` int(10) unsigned NOT NULL default '0',
  `SourcePipeline` varchar(255),
  `PipelineDate` date,
  `SourceFileID` int(10) unsigned DEFAULT '0',
  `ProcessProtocolID` int(11) unsigned, 
  `Caveat` tinyint(1) default NULL,
  `TarchiveSource` int(11) default NULL,
  PRIMARY KEY  (`FileID`),
  KEY `file` (`File`),
  KEY `sessionid` (`SessionID`),
  KEY `outputtype` (`OutputType`),
  KEY `filetype_outputtype` (`FileType`,`OutputType`),
  KEY `staging_filetype_outputtype` (`PendingStaging`,`FileType`,`OutputType`),
  KEY `AcquiIndex` (`AcquisitionProtocolID`,`SessionID`),
  CONSTRAINT `FK_files_2` FOREIGN KEY (`AcquisitionProtocolID`) REFERENCES `mri_scan_type` (`ID`),
  CONSTRAINT `FK_files_1` FOREIGN KEY (`SessionID`) REFERENCES `session` (`ID`),
  CONSTRAINT `FK_files_3` FOREIGN KEY (`SourceFileID`) REFERENCES `files` (`FileID`),
  CONSTRAINT `FK_files_4` FOREIGN KEY (`ProcessProtocolID`) REFERENCES `mri_processing_protocol` (`ProcessProtocolID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `files_qcstatus`;
CREATE TABLE `files_qcstatus` (
    FileQCID int(11) PRIMARY KEY auto_increment,
    FileID int(11) UNIQUE NULL,
    SeriesUID varchar(64) DEFAULT NULL,
    EchoTime double DEFAULT NULL,
    QCStatus enum('Pass', 'Fail'),
    QCFirstChangeTime int(10) unsigned,
    QCLastChangeTime int(10) unsigned
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mri_acquisition_dates`
--

DROP TABLE IF EXISTS `mri_acquisition_dates`;
CREATE TABLE `mri_acquisition_dates` (
  `SessionID` int(10) unsigned NOT NULL default '0',
  `AcquisitionDate` date default NULL,
  PRIMARY KEY  (`SessionID`),
  CONSTRAINT `FK_mri_acquisition_dates_1` FOREIGN KEY (`SessionID`) REFERENCES `session` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mri_acquisition_dates`
--

LOCK TABLES `mri_acquisition_dates` WRITE;
/*!40000 ALTER TABLE `mri_acquisition_dates` DISABLE KEYS */;
/*!40000 ALTER TABLE `mri_acquisition_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mri_protocol`
--

DROP TABLE IF EXISTS `mri_protocol`;
CREATE TABLE `mri_protocol` (
  `ID` int(11) unsigned NOT NULL auto_increment,
  `Center_name` varchar(4) NOT NULL default '',
  `ScannerID` int(10) unsigned NOT NULL default '0',
  `Scan_type` int(10) unsigned NOT NULL default '0',
  `TR_range` varchar(255) default NULL,
  `TE_range` varchar(255) default NULL,
  `TI_range` varchar(255) default NULL,
  `slice_thickness_range` varchar(255) default NULL,
  `FoV_x_range` varchar(255) default NULL,
  `FoV_y_range` varchar(255) default NULL,
  `FoV_z_range` varchar(255) default NULL,
  `xspace_range` varchar(255) default NULL,
  `yspace_range` varchar(255) default NULL,
  `zspace_range` varchar(255) default NULL,
  `xstep_range` varchar(255) default NULL,
  `ystep_range` varchar(255) default NULL,
  `zstep_range` varchar(255) default NULL,
  `time_range` varchar(255) default NULL,
  `series_description_regex` varchar(255) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `FK_mri_protocol_1` (`ScannerID`),
  CONSTRAINT `FK_mri_protocol_1` FOREIGN KEY (`ScannerID`) REFERENCES `mri_scanner` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mri_protocol`
--

LOCK TABLES `mri_protocol` WRITE;
/*!40000 ALTER TABLE `mri_protocol` DISABLE KEYS */;
/*!40000 ALTER TABLE `mri_protocol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mri_scan_type`
--

DROP TABLE IF EXISTS `mri_scan_type`;
CREATE TABLE `mri_scan_type` (
  `ID` int(11) unsigned NOT NULL auto_increment,
  `Scan_type` text NOT NULL,
  PRIMARY KEY  (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mri_scan_type`
--

LOCK TABLES `mri_scan_type` WRITE;
/*!40000 ALTER TABLE `mri_scan_type` DISABLE KEYS */;
INSERT INTO `mri_scan_type` VALUES
    (40,'fMRI'),
    (41,'flair'),
    (44,'t1'),
    (45,'t2'),
    (46,'pd'),
    (47,'mrs'),
    (48,'dti'),
    (49,'t1relx'),
    (50,'dct2e1'),
    (51,'dct2e2'),
    (52,'scout'),
    (53,'tal_msk'),
    (54,'cocosco_cls'),
    (55,'clean_cls'),
    (56,'em_cls'),
    (57,'seg'),
    (58,'white_matter'),
    (59,'gray_matter'),
    (60,'csf_matter'),
    (61,'nlr_masked'),
    (62,'pve'),
    (999,'unknown'),
    (1000,'NA');
/*!40000 ALTER TABLE `mri_scan_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mri_scanner`
--

DROP TABLE IF EXISTS `mri_scanner`;
CREATE TABLE `mri_scanner` (
  `ID` int(11) unsigned NOT NULL auto_increment,
  `Manufacturer` varchar(255) default NULL,
  `Model` varchar(255) default NULL,
  `Serial_number` varchar(255) default NULL,
  `Software` varchar(255) default NULL,
  `CandID` int(11) default NULL,
  PRIMARY KEY  (`ID`),
  KEY `FK_mri_scanner_1` (`CandID`),
  CONSTRAINT `FK_mri_scanner_1` FOREIGN KEY (`CandID`) REFERENCES `candidate` (`CandID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mri_scanner`
--

LOCK TABLES `mri_scanner` WRITE;
/*!40000 ALTER TABLE `mri_scanner` DISABLE KEYS */;
INSERT INTO `mri_scanner` VALUES (0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `mri_scanner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_spool`
--

DROP TABLE IF EXISTS `notification_spool`;
CREATE TABLE `notification_spool` (
  `NotificationID` int(11) NOT NULL auto_increment,
  `NotificationTypeID` int(11) NOT NULL default '0',
  `TimeSpooled` int(11) NOT NULL default '0',
  `Message` text,
  `Sent` enum('N','Y') NOT NULL default 'N',
  `CenterID` tinyint(2) unsigned default NULL,
  PRIMARY KEY  (`NotificationID`),
  KEY `FK_notification_spool_1` (`NotificationTypeID`),
  KEY `FK_notification_spool_2` (`CenterID`),
  CONSTRAINT `FK_notification_spool_2` FOREIGN KEY (`CenterID`) REFERENCES `psc` (`CenterID`),
  CONSTRAINT `FK_notification_spool_1` FOREIGN KEY (`NotificationTypeID`) REFERENCES `notification_types` (`NotificationTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notification_spool`
--

LOCK TABLES `notification_spool` WRITE;
/*!40000 ALTER TABLE `notification_spool` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_spool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_types`
--

DROP TABLE IF EXISTS `notification_types`;
CREATE TABLE `notification_types` (
  `NotificationTypeID` int(11) NOT NULL auto_increment,
  `Type` varchar(255) NOT NULL default '',
  `private` tinyint(1) default '0',
  `Description` text,
  PRIMARY KEY  (`NotificationTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notification_types`
--

LOCK TABLES `notification_types` WRITE;
/*!40000 ALTER TABLE `notification_types` DISABLE KEYS */;
INSERT INTO `notification_types` VALUES 
	(1,'mri new study',0,'New studies processed by the MRI upload handler'),
	(2,'mri new series',0,'New series processed by the MRI upload handler'),
	(3,'mri upload handler emergency',1,'MRI upload handler emergencies'),
	(4,'mri staging required',1,'New studies received by the MRI upload handler that require staging'),
	(5,'mri invalid study',0,'Incorrectly labelled studies received by the MRI upload handler'),
	(7,'hardcopy request',0,'Hardcopy requests'),
	(9,'visual bvl qc',0,'Timepoints selected for visual QC'),
	(10,'mri qc status',0,'MRI QC Status change');
/*!40000 ALTER TABLE `notification_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarchive`
--

DROP TABLE IF EXISTS `tarchive`;
CREATE TABLE `tarchive` (
  `DicomArchiveID` varchar(255) NOT NULL default '',
  `PatientID` varchar(255) NOT NULL default '',
  `PatientName` varchar(255) NOT NULL default '',
  `PatientDoB` date NOT NULL default '0000-00-00',
  `PatientGender` varchar(255) default NULL,
  `neurodbCenterName` varchar(255) default NULL,
  `CenterName` varchar(255) NOT NULL default '',
  `LastUpdate` datetime NOT NULL default '0000-00-00 00:00:00',
  `DateAcquired` date NOT NULL default '0000-00-00',
  `DateFirstArchived` datetime default NULL,
  `DateLastArchived` datetime default NULL,
  `AcquisitionCount` int(11) NOT NULL default '0',
  `NonDicomFileCount` int(11) NOT NULL default '0',
  `DicomFileCount` int(11) NOT NULL default '0',
  `md5sumDicomOnly` varchar(255) default NULL,
  `md5sumArchive` varchar(255) default NULL,
  `CreatingUser` varchar(255) NOT NULL default '',
  `sumTypeVersion` tinyint(4) NOT NULL default '0',
  `tarTypeVersion` tinyint(4) default NULL,
  `SourceLocation` varchar(255) NOT NULL default '',
  `ArchiveLocation` varchar(255) default NULL,
  `ScannerManufacturer` varchar(255) NOT NULL default '',
  `ScannerModel` varchar(255) NOT NULL default '',
  `ScannerSerialNumber` varchar(255) NOT NULL default '',
  `ScannerSoftwareVersion` varchar(255) NOT NULL default '',
  `SessionID` int(10) unsigned default NULL,
  `uploadAttempt` tinyint(4) NOT NULL default '0',
  `CreateInfo` text,
  `AcquisitionMetadata` longtext NOT NULL,
  `TarchiveID` int(11) NOT NULL auto_increment,
  `DateSent` datetime DEFAULT NULL,
  `PendingTransfer` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY  (`TarchiveID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tarchive`
--

LOCK TABLES `tarchive` WRITE;
/*!40000 ALTER TABLE `tarchive` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarchive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarchive_files`
--

DROP TABLE IF EXISTS `tarchive_files`;
CREATE TABLE `tarchive_files` (
  `TarchiveFileID` int(11) NOT NULL auto_increment,
  `TarchiveID` int(11) NOT NULL default '0',
  `SeriesNumber` int(11) default NULL,
  `FileNumber` int(11) default NULL,
  `EchoNumber` int(11) default NULL,
  `SeriesDescription` varchar(255) default NULL,
  `Md5Sum` varchar(255) NOT NULL,
  `FileName` varchar(255) NOT NULL,
  PRIMARY KEY  (`TarchiveFileID`),
  KEY `TarchiveID` (`TarchiveID`),
  CONSTRAINT `tarchive_files_ibfk_1` FOREIGN KEY (`TarchiveID`) REFERENCES `tarchive` (`TarchiveID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tarchive_files`
--

LOCK TABLES `tarchive_files` WRITE;
/*!40000 ALTER TABLE `tarchive_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarchive_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarchive_series`
--

DROP TABLE IF EXISTS `tarchive_series`;
CREATE TABLE `tarchive_series` (
  `TarchiveSeriesID` int(11) NOT NULL auto_increment,
  `TarchiveID` int(11) NOT NULL default '0',
  `SeriesNumber` int(11) NOT NULL default '0',
  `SeriesDescription` varchar(255) default NULL,
  `SequenceName` varchar(255) default NULL,
  `EchoTime` double default NULL,
  `RepetitionTime` double default NULL,
  `InversionTime` double default NULL,
  `SliceThickness` double default NULL,
  `PhaseEncoding` varchar(255) default NULL,
  `NumberOfFiles` int(11) NOT NULL default '0',
  `SeriesUID` varchar(255) default NULL,
  PRIMARY KEY  (`TarchiveSeriesID`),
  KEY `TarchiveID` (`TarchiveID`),
  CONSTRAINT `tarchive_series_ibfk_1` FOREIGN KEY (`TarchiveID`) REFERENCES `tarchive` (`TarchiveID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tarchive_series`
--

LOCK TABLES `tarchive_series` WRITE;
/*!40000 ALTER TABLE `tarchive_series` DISABLE KEYS */;
/*!40000 ALTER TABLE `tarchive_series` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `mri_protocol_violated_scans`;
CREATE TABLE `mri_protocol_violated_scans` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CandID` int(6),
  `PSCID` varchar(255),
  `time_run` datetime,
  `series_description` varchar(255) DEFAULT NULL,
   minc_location varchar(255),
   PatientName varchar(255) DEFAULT NULL,
  `TR_range` varchar(255) DEFAULT NULL,
  `TE_range` varchar(255) DEFAULT NULL,
  `TI_range` varchar(255) DEFAULT NULL,
  `slice_thickness_range` varchar(255) DEFAULT NULL,
  `xspace_range` varchar(255) DEFAULT NULL,
  `yspace_range` varchar(255) DEFAULT NULL,
  `zspace_range` varchar(255) DEFAULT NULL,
  `xstep_range` varchar(255) DEFAULT NULL,
  `ystep_range` varchar(255) DEFAULT NULL,
  `zstep_range` varchar(255) DEFAULT NULL,
  `time_range` varchar(255)  DEFAULT NULL,
  `SeriesUID` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tarchive_find_new_uploads` (
      `CenterName` varchar(255) NOT NULL,
      `LastRan` datetime DEFAULT NULL,
      PRIMARY KEY (`CenterName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `files_intermediary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files_intermediary` (
  `IntermedID` int(11) NOT NULL AUTO_INCREMENT,
  `Output_FileID` int(10) unsigned NOT NULL,
  `Input_FileID` int(10) unsigned NOT NULL,
  `Tool` varchar(255) NOT NULL,
  PRIMARY KEY (`IntermedID`),
  KEY `FK_files_intermediary_1` (`Output_FileID`),
  KEY `FK_files_intermediary_2` (`Input_FileID`),
  CONSTRAINT `FK_files_intermediary_1` FOREIGN KEY (`Output_FileID`) REFERENCES `files` (`FileID`),
  CONSTRAINT `FK_files_intermediary_2` FOREIGN KEY (`Input_FileID`) REFERENCES `files` (`FileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


CREATE TABLE `mri_upload` (
  `UploadID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UploadedBy` varchar(255) NOT NULL DEFAULT '',
  `UploadDate` DateTime DEFAULT NULL,
  `SourceLocation` varchar(255) NOT NULL DEFAULT '',
  `number_of_mincInserted` int(11) DEFAULT NULL,
  `number_of_mincCreated` int(11) DEFAULT NULL,
  `TarchiveID` int(11) DEFAULT NULL,
  `SessionID` int(10) unsigned DEFAULT NULL,
  `IsValidated` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UploadID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mri_protocol_checks` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Scan_type` int(11) unsigned DEFAULT NULL,
  `Severity` enum('warning','exclude') DEFAULT NULL,
  `Header` varchar(255) DEFAULT NULL,
  `ValidRange` varchar(255) DEFAULT NULL,
  `ValidRegex` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `MRICandidateErrors` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TimeRun` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SeriesUID` varchar(64) DEFAULT NULL,
  `TarchiveID` int(11) DEFAULT NULL,
  `MincFile` varchar(255) DEFAULT NULL,
  `PatientName` varchar(255) DEFAULT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mri_violations_log` (
  `LogID` int(11) NOT NULL AUTO_INCREMENT,
  `TimeRun` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SeriesUID` varchar(64) DEFAULT NULL,
  `TarchiveID` int(11) DEFAULT NULL,
  `MincFile` varchar(255) DEFAULT NULL,
  `PatientName` varchar(255) DEFAULT NULL,
  `CandID` int(6) DEFAULT NULL,
  `Visit_label` varchar(255) DEFAULT NULL,
  `CheckID` int(11) DEFAULT NULL,
  `Scan_type` int(11) unsigned DEFAULT NULL,
  `Severity` enum('warning','exclude') DEFAULT NULL,
  `Header` varchar(255) DEFAULT NULL,
  `Value` varchar(255) DEFAULT NULL,
  `ValidRange` varchar(255) DEFAULT NULL,
  `ValidRegex` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
