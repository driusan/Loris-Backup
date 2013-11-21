CREATE TABLE `mri_upload` (
  `UploadID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FileType` enum('mnc','obj','xfm','xfmmnc','imp','vertstat','xml','txt') DEFAULT NULL,
  `UploadedBy` varchar(255) NOT NULL DEFAULT '',
  `UploadDate` DateTime DEFAULT NULL,
  `SourceLocation` varchar(255) NOT NULL DEFAULT '',
  `MincInserted` tinyint(1) NOT NULL DEFAULT '0',
  `DicomInserted` tinyint(1) NOT NULL DEFAULT '0',
  `UploadSuccess` tinyint(1) NOT NULL DEFAULT '0',
  `TarchiveID` int(11) DEFAULT NULL,
  `SessionID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`UploadID`)
) ;
