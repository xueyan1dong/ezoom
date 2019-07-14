/*
*    Copyright 2019 ~ Current  IT Helps LLC
*    Source File            : delete_employee_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 7/13/2019
*    Platform Dependencies  : MySql
*    Description            : delete emplyee group by group id
*    example	            : call delete_employee_group (3)
*    Log                    :
*/
DELIMITER $  -- for escaping purpose

DROP PROCEDURE IF EXISTS `delete_employee_group`$
CREATE PROCEDURE `delete_employee_group`(
  IN _employee_group_id int(10) unsigned
)
BEGIN
	-- delete group from employee_group
	DELETE FROM employee_group WHERE id = _employee_group_id;

	-- remove association from the deleted group
	UPDATE employee
	SET eg_id = NULL
	WHERE eg_id = _employee_group_id;

END$
