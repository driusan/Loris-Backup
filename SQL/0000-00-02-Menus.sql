CREATE TABLE LorisMenu (
    ID integer unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Parent integer unsigned REFERENCES LorisMenu(ID),
    Label varchar(255),
    Link varchar(255),
    Visible enum('true', 'false'),
    OrderNumber integer
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO LorisMenu (Label, OrderNumber) VALUES
     ('Candidate', 1),
     ('Clinical', 2),
     ('Imaging', 3),
     ('Reports', 4),
     ('Tools', 5),
     ('Admin', 6);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('New Profile', 'main.php?test_name=new_profile', 1, 1),
    ('Access Profile', 'main.php?test_name=candidate_list', 1, 2);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('Reliability', 'main.php?test_name=reliability', 2, 1),
    ('Conflicts Resolver', 'main.php?test_name=conflict_resolver', 2, 2),
    ('Certification', 'main.php?test_name=certification', 2, 3);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('Radiological Reviews', 'main.php?test_name=final_radiological_review', 3, 1),
    ('DICOM Archive', 'main.php?test_name=dicom_archive', 3, 2),
    ('Imaging Browser', 'main.php?test_name=imaging_browser', 3, 3),
    ('MRI Violated Scans', 'main.php?test_name=mri_violations', 3, 4),
    ('MRI Upload', 'main.php?test_name=mri_upload', 3, 5);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('Statistics', 'main.php?test_name=statistics', 4, 1),
    ('Data Query Tool', '/dqt/', 4, 2);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('Data Dictionary', 'main.php?test_name=datadict', 5, 1),
    ('Document Repository', 'main.php?test_name=document_repository', 5, 2),
    ('Data Team Helper', 'main.php?test_name=data_team_helper', 5, 3),
    ('Instrument Builder', 'main.php?test_name=instrument_builder', 5, 4);

INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) VALUES
    ('User Accounts', 'main.php?test_name=user_accounts', 6, 1),
    ('Survey Module', 'main.php?test_name=survey_accounts', 6,2),
    ('Help Editor', 'main.php?test_name=help_editor', 6,3),
    ('Configuration', 'main.php?test_name=configuration', 6, 4);

CREATE TABLE LorisMenuPermissions (
    MenuID integer unsigned REFERENCES LorisMenu(ID),
    PermID integer unsigned REFERENCES permissions(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT="If a user has ANY of the permissions for a module it will show up in their menu bar";

-- New Profile permission
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 7, PermID FROM permissions WHERE code='data_entry';

-- Access Profile
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 8, PermID FROM permissions WHERE code='data_entry';

-- Reliability
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 9, PermID FROM permissions WHERE code='user_accounts';
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 9, PermID FROM permissions WHERE code='reliability_edit_all';
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 9, PermID FROM permissions WHERE code='access_all_profiles';

-- Conflicts Resolver
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 10, PermID FROM permissions WHERE code='data_entry';

-- Certification
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 11, PermID FROM permissions WHERE code='certification';
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 11, PermID FROM permissions WHERE code='certification_multisite';

-- Radiological Reviews
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 12, PermID FROM permissions WHERE code='edit_final_radiological_review';
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 12, PermID FROM permissions WHERE code='view_final_radiological_review';

-- DICOM Archive -- Config file currently does not require any permission
-- Imaging Browser -- Config file currently does not require any permission
-- Statistics -- Config file currently does not require any permission

-- Document Repository
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 16, PermID FROM permissions WHERE code='file_upload';

-- Data Query Tool
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 18, PermID FROM permissions WHERE code='data_dict';

-- Data Dictionary
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 19, PermID FROM permissions WHERE code='data_dict';

-- MRI Upload
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 20, PermID FROM permissions WHERE code='mri_upload';

-- Data Team Helper -- Config file currently does not require any permission
-- Instrument Builder -- Config file currently does not require any permission

-- User Accounts
INSERT INTO LorisMenuPermissions (MenuID, PermID)
    SELECT 23, PermID FROM permissions WHERE code='user_accounts';
INSERT INTO LorisMenuPermissions (MenuID, PermID) SELECT m.ID, p.PermID FROM permissions p CROSS JOIN LorisMenu m WHERE p.code='user_accounts' AND m.Label='Survey Module';
INSERT INTO LorisMenuPermissions (MenuID, PermID) SELECT m.ID, p.PermID FROM permissions p CROSS JOIN LorisMenu m WHERE p.code='violated_scans' AND m.Label='MRI Violated Scans';
INSERT INTO LorisMenuPermissions (MenuID, PermID) SELECT m.ID, p.PermID FROM permissions p CROSS JOIN LorisMenu m WHERE p.code='context_help' AND m.Label='Help Editor';
INSERT INTO LorisMenuPermissions (MenuID, PermID) SELECT m.ID, p.PermID FROM permissions p CROSS JOIN LorisMenu m WHERE p.code='config' AND m.Label='Configuration';
