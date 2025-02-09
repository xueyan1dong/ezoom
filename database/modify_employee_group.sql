/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_employee_group.sql
*    Created By             : Junlu Luo
*    Date Created           : 07/08/2019
*    Platform Dependencies  : MySql
*    Description            : Create or modify employee group
*    example	            :
    		SET @id = 2;
    		CALL modify_employee_group (
    		@id,
    		'Test Group',
    		3,
    		1,
    		'test@ithelps.com',
    		'123-345-7890',
    		NULL,
    		'This is a test group 4',
    		@response);
    		SELECT @id as ID, @response AS Response;
*    Log:		
*       07/08/2019: Junlu Luo: First Created
*       07/30/2019: Xueyan Dong: updated column name reference from or_id to org_id	
 *      09/30/2019: Xueyan Dong: changed the input parameter _or_id to _org_id  		
*/

DELIMITER $  
DROP PROCEDURE IF EXISTS `modify_employee_group`$
CREATE PROCEDURE `modify_employee_group`(
	INOUT _id int(10) unsigned,
	IN _groupname varchar(255),
	IN _org_id int(10) unsigned,  -- if input is 0, replace it with null, as application sends in 0 if group has no belonging org
	IN _ifprivilege TINYINT(1) unsigned,
	IN _email varchar(45),
	IN _phone varchar(45),
	IN _lead_employee int(10) unsigned,
	IN _description text,
	OUT _response varchar(255)
)
this_proc: BEGIN
	SET _response = '';
	
	IF _id IS NULL AND (_groupname IS NULL OR LENGTH(_groupname) < 1) THEN
		SET _response = 'Group name is required. Please fill in the group name.';
    LEAVE this_proc;
  END IF;
  
   -- when application sends in 0, it means the group does not have a belonging organization
  IF _org_id = 0 THEN  
    SET _org_id = NULL;
  END IF;
  
  -- make sure group name is unique
  SET @group_id = NULL;
  SELECT id INTO @group_id
  FROM `employee_group`
  WHERE name = _groupname;
  
  IF _id IS NULL
	THEN
    IF @group_id IS NOT NULL THEN
      SET _response = 'Group name already in use. Please enter a different group name.';
      LEAVE this_proc;
    END IF;
    -- insert new group
		INSERT INTO `employee_group` (
			name,
      org_id,
			ifprivilege,
			email,
			phone,
			lead_employee,
			description
		) VALUES (
			_groupname,
      _org_id,
			_ifprivilege,
			_email,
			_phone,
			_lead_employee,
			_description
		);
		
		SET _id = last_insert_id();
	ELSE
    IF @group_id != _id THEN
      SET _response = 'Group name already in use. Please enter a different group name.';
      LEAVE this_proc;    
    END IF;
    
    -- update existing record
		UPDATE `employee_group`
		SET name = _groupname,
      org_id = _org_id,
			ifprivilege = _ifprivilege,
			email = _email,
			phone = _phone,
			lead_employee = _lead_employee,
			description = _description
		WHERE id = _id;
	END IF;
END$
