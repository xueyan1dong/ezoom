INSERT INTO `organization` (name, status, parent_organization, root_company, description, root_org_type)
VALUES ('Waterworks', 'active', 1, 1, 'This is the top most level organization for Waterworks', 'host'),
	   ('Waterworks MTO', 'active', 1, 1, 'This is the top most level organization for Waterworks', 'host'),
	   ('Waterworks QM', 'active', 1, 1, 'This is the top most level organization for Waterworks', 'host'),
       ('Dayton Grey Contacts', 'active', 39, 39, 'This is the WW contact organization for Dayton Grey', 'client');