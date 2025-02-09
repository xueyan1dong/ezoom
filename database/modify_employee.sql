/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_employee.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    12/23/2019: Shelby Simpson: Added user_type variable and check for username uniqueness.
*    01/02/2020: Shelby Simpson: Added _datetime variable for creation_date and update_datetime attributes.			
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_employee`$
CREATE PROCEDURE `modify_employee`(
  INOUT _id int(10) unsigned,
  IN _username varchar(20),
  IN _password varchar(20),
  IN _status enum('active','inactive','removed'),
  IN _user_type enum('host','client'),
  IN _or_id int(10) unsigned,
  IN _eg_id int(10) unsigned,
  IN _firstname varchar(20),
  IN _lastname varchar(20),
  IN _middlename varchar(20),
  IN _email varchar(45),
  IN _phone varchar(45),
  IN _role_id int(10) unsigned,
  IN _report_to int(10) unsigned,
  IN _comment text,
  IN _datetime datetime,
  OUT _response varchar(255)
)
BEGIN
  IF  _id IS NULL AND (_username is NULL OR length(_username) < 1)
  THEN 
    SET _response='User name is required. Please fill the username.';
  ELSEIF _id IS NULL AND ( _password is NULL OR length(_password) < 1)
  THEN 
    SET _response='Password is required. Please fill the password.';
  ELSEIF _username IN (SELECT username FROM employee)
  THEN
	SET _response='This username already exists.  Please enter a different one.';
  ELSEIF  _status is NULL OR length(_status) < 1
  THEN 
    SET _response='Status is required. Please fill the Status.';
  ELSEIF  _or_id is NULL OR length(_or_id) < 1
  THEN 
    SET _response='Organization is required. Please fill the Organization.';
  ELSEIF  _firstname is NULL OR length(_firstname) < 1
  THEN 
    SET _response='First Name is required. Please fill the first name.';
  ELSEIF  _lastname is NULL OR length(_lastname) < 1
  THEN 
    SET _response='Last name is required. Please fill the last name.';
  ELSEIF  _role_id IS NULL OR NOT EXISTS (SELECT * FROM system_roles WHERE id=_role_id)
  THEN 
    SET _response='Role is required. Please select a role.';   
  ELSEIF _id is NULL 
  THEN
    INSERT INTO `employee` (
         id, company_id, username, password,
         status, user_type, or_id, eg_id, firstname,
         lastname, middlename, email,
         phone, report_to, comment, creation_date)
    values (
          _id, 1, _username, _password,
         _status, _user_type, _or_id, _eg_id, _firstname,
         _lastname, _middlename, _email,
         _phone, _report_to, _comment, CAST(_datetime as date)
         );
    SET _id = last_insert_id();
    INSERT INTO users_in_roles (
      userId,
      roleId
    )
    values (_id, _role_id);
    
  ELSE
    UPDATE `employee` 
      SET 
      status = _status, 
      user_type = _user_type,
      or_id = _or_id, 
      eg_id = _eg_id, 
      firstname = _firstname,
      lastname = _lastname, 
      middlename = _middlename, 
      email = _email,
      phone = _phone, 
      report_to = _report_to, 
      comment = _comment,
      update_datetime = _datetime
    WHERE id = _id;
    
    UPDATE users_in_roles 
       SET roleId = _role_id
     WHERE userId = _id;
  END IF;
END$
