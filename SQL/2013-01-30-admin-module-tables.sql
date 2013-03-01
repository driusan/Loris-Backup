 CREATE TABLE `Config` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ConfigID` int(11) DEFAULT NULL,
  `Value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `ConfigSettings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Visible` tinyint(1) DEFAULT '0',
  `AllowMultiple` tinyint(1) DEFAULT '0',
  `Parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


INSERT INTO `ConfigSettings` VALUES (1,'CBrain','Settings specific to CBrain<->Loris Integration',1,0,NULL),(2,'CBrainHost','Host of CBrain server',1,0,1),(3,'CBrainUsername','Username to login on CBrain server',1,0,1),(4,'CBrainPassword','Password to login on CBrain server (Note: this is stored in plaintext due to way CBrainAPI.pm works)',1,0,1),(5,'CBrainRegisterProviderID','CBrain data provider to register files when they\'re registered into Loris',1,0,1),(6,'CBrainDefaultProjectID','Default Project to register CBrain files into',1,0,1);

