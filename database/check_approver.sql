/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `check_approver`$
CREATE PROCEDURE `check_approver`(
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  OUT _response varchar(255)
)
BEGIN
      
  IF _need_approval > 0
  THEN
    IF NOT EXISTS (SELECT * FROM employee WHERE id = _approver_id AND password=_approver_password AND status='active')
    THEN
      SET _response = "Approver username or password is incorrect. Please correct.";
    ELSEIF _approve_emp_usage = 'employee group' 
        AND NOT EXISTS (SELECT * FROM employee WHERE id=_approver_id AND eg_id = _approve_emp_id)
    THEN
      SET _response = "Approver doesn't belong to the employee group required for approving this step.";
    ELSEIF _approve_emp_usage='employee' AND _approver_id != _approve_emp_id
    THEN
      SET _response = "Approver is not the person required for approving this step.";
    -- currently we are not taking care of 'employee category' case. x.d.
    END IF;
  END IF;

END$
