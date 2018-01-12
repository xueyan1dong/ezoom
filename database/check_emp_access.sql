DROP PROCEDURE IF EXISTS `check_emp_access`;
CREATE PROCEDURE `check_emp_access`(
  IN _emp_id int(10) unsigned,
  IN _emp_usage enum('employee group', 'employee'),
  IN _allow_emp_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _if_allow tinyint(1) unsigned;
  SET _if_allow=0;
  IF _emp_id IS NULL
  THEN
    SET _response = "Please supply an employee id to be checked";  
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_emp_id) 
  THEN
    SET _response = "The employee selected doesn't exist in database.";
  ELSEIF _allow_emp_id IS NULL
  THEN
    SET _response = "There is no defined restriction for employee access.";
  ELSEIF _emp_usage="employee group" 
    AND EXISTS (SELECT * FROM employee WHERE id=_emp_id
                                         AND eg_id=_allow_emp_id)
  THEN
    SET _if_allow=1;
  ELSEIF _emp_usage="employee" AND _emp_id=_allow_emp_id
  THEN
    SET _if_allow=1;
          
  END IF;
  
  SELECT _if_allow;
 END;