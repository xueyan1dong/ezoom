/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_organization.sql
*    Created By             : Shelby Simpson
*    Date Created           : 11/24/2019
*    Platform Dependencies  : MySql
*    Description            : Insert new organization (when _id is NULL) or modify an existing one (When _id is NOT NULL).
*    example	            : 
*    Log                    : 12/6/2019 - Added check to make sure current organization does not already exist under the selected parent organization.
*							  12/9/2019 - Modified _root_company check to verify it exists in the company or client table (depending on _root_org_type) 
*										  instead of the organization table.
*							  12/24/2019 - Added checks for host and client root_org_types.
*/
DELIMITER $

DROP PROCEDURE IF EXISTS modify_organization$
CREATE PROCEDURE modify_organization (
	INOUT _id INT(10) unsigned,
    IN _name varchar(255),
    IN _status enum('active', 'inactive', 'removed'),
    IN _lead_employee INT(10) unsigned,
    IN _phone varchar(45),
    IN _email varchar(45),
    IN _description text,
    IN _root_org_type enum('host','client'),
    IN _parent_organization INT(10) unsigned,
    IN _root_company INT(10) unsigned,
    OUT _response varchar(255)
)
BEGIN
	IF  _id IS NULL AND (_name IS NULL OR length(_name) < 1)
	THEN 
		SET _response='An organization name is required. Please fill one in.';
	ELSEIF _status IS NULL
    THEN
		SET _response='Please select a status for the organization.';
    ELSEIF _root_company IS NULL
    THEN
		SET _response='Please enter a root company id.';
	ELSEIF _root_org_type IS NULL
    THEN
		SET _response='Please select a valid root organization type.';
	ELSEIF _root_org_type = 'host' AND NOT EXISTS (SELECT id FROM company WHERE id = _root_company)
    THEN
		SET _response='Please select an existing root host company.';
	ELSEIF _root_org_type = 'client' AND NOT EXISTS (SELECT id FROM client WHERE id = _root_company)
    THEN
		SET _response='Please select an existing root client company.';
	ELSEIF _parent_organization IS NOT NULL AND NOT EXISTS (SELECT id FROM organization WHERE id = _parent_organization)
    THEN
		SET _response='The parent organization id you entered does not exist.  Please enter a valid one.';
    ELSEIF _lead_employee IS NOT NULL AND NOT EXISTS (SELECT id from employee WHERE id = _lead_employee)
    THEN
		SET _response='The lead employee id you entered is invalid.  Please enter a valid one.';
	ELSEIF _id IS NULL AND _name IN (SELECT name FROM organization WHERE parent_organization = _parent_organization)
    THEN
		SET _response='This parent organization already exists under the root company selected.';
    ELSEIF _id is NULL 
	THEN
		INSERT INTO `organization` (
			id, name, status, lead_employee, root_company, parent_organization,
			phone, email, description, root_org_type)
		values (
			_id, _name, _status, _lead_employee, _root_company, _parent_organization,
			_phone, _email, _description, _root_org_type
			);
		SET _id = last_insert_id();
	ELSE
		UPDATE `organization`
			SET
            name = _name,
            status = _status,
            phone = _phone,
            email = _email,
            description = _description,
            lead_employee = _lead_employee,
            root_company = _root_company,
            parent_organization = _parent_organization,
            root_org_type = _root_org_type
		WHERE id = _id;
    END IF;
END$