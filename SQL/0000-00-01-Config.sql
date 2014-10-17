
-- Stores the Meta data about what config settings are possible
CREATE TABLE `ConfigSettings` (
    `ID` int(11) NOT NULL AUTO_INCREMENT,
    `Name` varchar(255) NOT NULL,
    `Description` varchar(255) DEFAULT NULL,
    `Visible` tinyint(1) DEFAULT '0',
    `AllowMultiple` tinyint(1) DEFAULT '0',
    `DataType` enum('text') DEFAULT NULL,
    `Parent` int(11) DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Stores the values of the ConfigSettings
CREATE TABLE `Config` (
    `ID` int(11) NOT NULL AUTO_INCREMENT,
    `ConfigID` int(11) DEFAULT NULL,
    `Value` text DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Filling ConfigSettings table

--
-- study
--

-- study
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('study', 'Study variables', 1, 0);

-- additional_user_info
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'additional_user_info', 'Display additional user fields in User Accounts page', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- title
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'title', 'Descriptive study title', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- studylogo
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'studylogo', 'Logo of the study', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- columnThreshold
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'columnThreshold', 'Number of columns the quat table will contain', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useEDC
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useEDC', 'Use EDC (Expected Date of Confinement) - false unless the study focuses on neonatals for birthdate estimations.', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- ageMin
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'ageMin', 'Minimum candidate age in years (0+)', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- ageMax
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'ageMax', 'Maximum candidate age in years', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- multipleSites
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'multipleSites', 'More than one site in the project', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useFamilyID
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useFamilyID', 'Use family ID', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- startYear
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'startYear', "Project's start year", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- endYear
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'endYear', "Project's end year", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useExternalID
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useExternalID', "Use external ID field - false unless data is used for blind data distribution, or from external data sources", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useProband
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useProband', "Show proband section on the candidate parameter page", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useProjects
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useProjects', "Whether or not study involves more than one project where each project has multiple cohorts/subprojects", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- useScreening
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'useScreening', "Whether or not there is a screening stage with its own intruments done before the visit stage", 1, 0, 'text', ID FROM ConfigSettings WHERE Name="study";

-- excluded_instruments
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, Parent) SELECT 'excluded_instruments', "Instruments to be excluded from the data dictionary and the data query tool", 1, 0, ID FROM ConfigSettings WHERE Name="study";

-- instrument
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'instrument', "Instrument to be excluded from the data dictionary and the data query tool", 1, 1, 'text', ID FROM ConfigSettings WHERE Name="excluded_instruments";

-- DoubleDataEntryInstruments
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'DoubleDataEntryInstruments', "Instruments for which double data entry should be enabled", 1, 1, 'text', ID FROM ConfigSettings WHERE Name="study";

--
-- paths
--

-- paths
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('paths', 'Path settings', 1, 0);

-- imagePath
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'imagePath', 'Path to images', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- base
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'base', 'Base path', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- data
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'data', 'Path to data', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- extLibs
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'extLibs', 'Path to external libraries', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- mincPath
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'mincPath', 'Path to MINC files', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- DownloadPath
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'DownloadPath', 'Where files are downloaded', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- log
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'log', 'Path to logs', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- IncomingPath
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'IncomingPath', 'Path for data transferred to the project server', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

-- MRICodePath
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'MRICodePath', 'Path to MRI code', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="paths";

--
-- gui
--

-- gui
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('gui', 'GUI settings', 1, 0);

-- css
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'css', 'CSS file used for rendering', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="gui";

-- rowsPerPage
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'rowsPerPage', 'Number of table rows to appear, per page', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="gui";

-- showTiming
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'showTiming', 'Show breakdown of timing information for page loading', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="gui";

-- showPearErrors
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'showPearErrors', 'Print PEAR errors', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="gui";

--
-- www
--

-- www
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('www', 'WWW settings', 1, 0);

-- host
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'host', 'Host', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="www";

-- url
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'url', 'Main project URL', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="www";

-- mantis_url
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'mantis_url', 'Bug tracker URL', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="www";

--
-- dashboard
--

-- dashboard
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('dashboard', 'Dashboard settings', 1, 0);

-- projectDescription
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'projectDescription', 'Description of the project that will be displayed in the top panel of the dashboard', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dashboard";

-- recruitmentTarget
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'recruitmentTarget', 'Target number of participants for the study', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dashboard";

--
-- dicom_archive
--

-- dicom_archive
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('dicom_archive', 'DICOM archive settings', 1, 0);

-- patientIDRegex
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'patientIDRegex', 'Regex for the patient ID', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dicom_archive";

-- patientNameRegex
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'patientNameRegex', 'Regex for the patient name', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dicom_archive";

-- LegoPhantomRegex
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'LegoPhantomRegex', 'Regex to be used on a Lego Phantom scan', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dicom_archive";

-- LivingPhantomRegex
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'LivingPhantomRegex', 'Regex to be used on Living Phantom scan', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dicom_archive";

-- showTransferStatus
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'showTransferStatus', 'Show transfer status in the DICOM archive table', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="dicom_archive";

--
-- statistics
--

-- statistics
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('statistics', 'Statistics settings', 1, 0);

-- excludedMeasures
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'excludedMeasures', 'Excluded measures', 1, 1, 'text', ID FROM ConfigSettings WHERE Name="statistics";

--
-- mail
--

-- mail
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple) VALUES ('mail', 'Mail settings', 1, 0);

-- headers
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, Parent) SELECT 'headers', 'Headers', 1, 0, ID FROM ConfigSettings WHERE Name="mail";

-- From
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'From', 'From', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="headers";

-- Reply-to
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'Reply-to', 'Reply-to', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="headers";

-- X-MimeOLE
INSERT INTO ConfigSettings (Name, Description, Visible, AllowMultiple, DataType, Parent) SELECT 'X-MimeOLE', 'X-MimeOLE', 1, 0, 'text', ID FROM ConfigSettings WHERE Name="headers";

-- Filling Config table with default values


-- default study variables

-- additional_user_info
INSERT INTO Config (ConfigID, Value) SELECT ID, 1 FROM ConfigSettings WHERE Name="additional_user_info";

-- title
INSERT INTO Config (ConfigID, Value) SELECT ID, "Example Study" FROM ConfigSettings WHERE Name="title";

-- studylogo
INSERT INTO Config (ConfigID, Value) SELECT ID, "images/neuro_logo_blue.gif" FROM ConfigSettings WHERE Name="studylogo";

-- columnThreshold
INSERT INTO Config (ConfigID, Value) SELECT ID, 250 FROM ConfigSettings WHERE Name="columnThreshold";

-- useEDC
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useEDC";

-- ageMin
INSERT INTO Config (ConfigID, Value) SELECT ID, 8 FROM ConfigSettings WHERE Name="ageMin";

-- ageMax
INSERT INTO Config (ConfigID, Value) SELECT ID, 11 FROM ConfigSettings WHERE Name="ageMax";

-- multipleSites
INSERT INTO Config (ConfigID, Value) SELECT ID, "true" FROM ConfigSettings WHERE Name="multipleSites";

-- useFamilyID
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useFamilyID";

-- startYear
INSERT INTO Config (ConfigID, Value) SELECT ID, 2004 FROM ConfigSettings WHERE Name="startYear";

-- endYear
INSERT INTO Config (ConfigID, Value) SELECT ID, 2014 FROM ConfigSettings WHERE Name="endYear";

-- useExternalID
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useExternalID";

-- useProband
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useProband";

-- useProjects
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useProjects";

-- useScreening
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="useScreening";

-- default path settings

-- imagePath
INSERT INTO Config (ConfigID, Value) SELECT ID, "/data/%PROJECTNAME%/data/" FROM ConfigSettings WHERE Name="imagePath";

-- base
INSERT INTO Config (ConfigID, Value) SELECT ID, "%LORISROOT%" FROM ConfigSettings WHERE Name="base";

-- data
INSERT INTO Config (ConfigID, Value) SELECT ID, "/data/%PROJECTNAME%/data/" FROM ConfigSettings WHERE Name="data";

-- extLibs
INSERT INTO Config (ConfigID, Value) SELECT ID, "/PATH/TO/EXTERNAL/LIBRARY/" FROM ConfigSettings WHERE Name="extLibs";

-- mincPath
INSERT INTO Config (ConfigID, Value) SELECT ID, "/data/%PROJECTNAME%/data/" FROM ConfigSettings WHERE Name="mincPath";

-- DownloadPath
INSERT INTO Config (ConfigID, Value) SELECT ID, "%LORISROOT%" FROM ConfigSettings WHERE Name="DownloadPath";

-- log
INSERT INTO Config (ConfigID, Value) SELECT ID, "tools/logs/" FROM ConfigSettings WHERE Name="log";

-- IncomingPath
INSERT INTO Config (ConfigID, Value) SELECT ID, "/data/incoming/" FROM ConfigSettings WHERE Name="IncomingPath";

-- MRICodePath
INSERT INTO Config (ConfigID, Value) SELECT ID, "/data/%PROJECTNAME%/bin/mri/" FROM ConfigSettings WHERE Name="MRICodePath";

-- default gui settings

-- css
INSERT INTO Config (ConfigID, Value) SELECT ID, "main.css" FROM ConfigSettings WHERE Name="css";

-- rowsPerPage
INSERT INTO Config (ConfigID, Value) SELECT ID, 25 FROM ConfigSettings WHERE Name="rowsPerPage";

-- showTiming
INSERT INTO Config (ConfigID, Value) SELECT ID, 0 FROM ConfigSettings WHERE Name="showTiming";

-- showPearErrors
INSERT INTO Config (ConfigID, Value) SELECT ID, 0 FROM ConfigSettings WHERE Name="showPearErrors";

-- default www settings

-- host
INSERT INTO Config (ConfigID, Value) SELECT ID, "localhost" FROM ConfigSettings WHERE Name="host";

-- url
INSERT INTO Config (ConfigID, Value) SELECT ID, "https://localhost/" FROM ConfigSettings WHERE Name="url";

-- default dashboard settings

-- projectDescription
INSERT INTO Config (ConfigID, Value) SELECT ID, "This database provides an on-line mechanism to store both imaging and behavioral data collected from various locations. Within this framework, there are several tools that will make this process as efficient and simple as possible. For more detailed information regarding any aspect of the database, please click on the Help icon at the top right. Otherwise, feel free to contact us at the DCC. We strive to make data collection almost fun." FROM ConfigSettings WHERE Name="projectDescription";

-- default dicom_archive settings

-- patientIDRegex
INSERT INTO Config (ConfigID, Value) SELECT ID, "/./" FROM ConfigSettings WHERE Name="patientIDRegex";

-- patientNameRegex
INSERT INTO Config (ConfigID, Value) SELECT ID, "/./i" FROM ConfigSettings WHERE Name="patientNameRegex";

-- LegoPhantomRegex
INSERT INTO Config (ConfigID, Value) SELECT ID, "/./i" FROM ConfigSettings WHERE Name="LegoPhantomRegex";

-- LivingPhantomRegex
INSERT INTO Config (ConfigID, Value) SELECT ID, "/./i" FROM ConfigSettings WHERE Name="LivingPhantomRegex";

-- showTransferStatus
INSERT INTO Config (ConfigID, Value) SELECT ID, "false" FROM ConfigSettings WHERE Name="showTransferStatus";

-- default statistics settings

-- excludedMeasures
INSERT INTO Config (ConfigID, Value) SELECT ID, "radiology_review" FROM ConfigSettings WHERE Name="excludedMeasures";

-- excludedMeasures
INSERT INTO Config (ConfigID, Value) SELECT ID, "mri_parameter_form" FROM ConfigSettings WHERE Name="excludedMeasures";

-- default mail settings

-- From
INSERT INTO Config (ConfigID, Value) SELECT ID, "no-reply@example.com" FROM ConfigSettings WHERE Name="From";

-- Reply-to
INSERT INTO Config (ConfigID, Value) SELECT ID, "no-reply@example.com" FROM ConfigSettings WHERE Name="Reply-to";

-- X-MimeOLE
INSERT INTO Config (ConfigID, Value) SELECT ID, "Produced by LorisDB" FROM ConfigSettings WHERE Name="X-MimeOLE";
