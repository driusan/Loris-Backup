INSERT INTO LorisMenu (Label, Link, Parent, OrderNumber) 
SELECT 'Configuration', 'main.php?test_name=configuration', Parent, 4 from LorisMenu WHERE Label = 'Admin';

INSERT INTO LorisMenuPermissions (MenuID, PermID) SELECT m.ID, p.PermID 
FROM permissions p CROSS JOIN LorisMenu m WHERE p.code='superuser' AND m.Label='Configuration';