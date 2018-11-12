/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : add_step_to_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : add a step/position to a process in process_step table
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/12/2018: xdong: add new input parameter _product_made to indicate whether at the end of current step/position, final product is made				
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `add_step_to_process`$
CREATE procedure add_step_to_process (
  IN _process_id int(10) unsigned,
  IN _position_id  int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _prev_step_pos  int(5) unsigned,
  IN _next_step_pos  int(5) unsigned,
  IN _false_step_pos  int(5) unsigned,
  IN _segment_id  int(5) unsigned,
  IN _rework_limit smallint(2) unsigned,
  IN _if_sub_process tinyint(1),
  IN _prompt varchar(255),
  IN _if_autostart tinyint(1) unsigned,
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  IN _product_made tinyint(1) unsigned,
  OUT _response varchar(255)
) 
BEGIN

  DECLARE _eventtime datetime;
  DECLARE _step_type varchar(20);
  
  
  SET _eventtime = now();
 

IF NOT EXISTS (SELECT * FROM step WHERE id=_step_id)
THEN
  SET _response="The step you selected doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
THEN
  SET _response="The workflow you are working on doesn't exist in database.";
ELSEIF EXISTS (SELECT position_id FROM process_step WHERE process_id = _process_id AND position_id = _position_id)
THEN
  SET _response= concat('The position ' , _position_id ,' is already used in the process. Please change the position and try again.');
ELSEIF _segment_id IS NOT NULL AND NOT EXISTS(SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id = _segment_id)
THEN
  SET _response = "The segment you chose does not exist in database";
ELSEIF _product_made = 1 AND -- if setting current step/position as product made
        (EXISTS (SELECT position_id FROM process_step ps WHERE process_id = _process_id AND position_id != _position_id AND product_made = 1)
        -- no other step/position should be set as product made
         OR EXISTS (SELECT ps.position_id FROM process_step ps 
                      JOIN process_step ps2
                        ON ps.process_id = ps.step_id
                           AND ps2.product_made=1
                    WHERE ps.process_id = _process_id AND ps.if_sub_process=1)
         -- no other sub process should have it set up
         OR EXISTS (SELECT position_id
                      FROM process_step ps
                     WHERE ps.process_id = _step_id
                       AND _if_sub_process = 1
                       AND ps.product_made = 1)
        -- if current step is a sub process, inside the sub process should not have it set up
        )
THEN
  SET _response = "There is already a step or sub step has been marked as 'Product Made', please turn of that step before check current step as 'Product Made'";

ELSE
  
  SELECT t.name INTO _step_type
    FROM step s, step_type t
   WHERE s.id = _step_id
     AND t.id = s.step_type_id;
     
  IF _step_type = 'condition' AND _false_step_pos IS NULL 
  THEN
    SET _response="A step position on false result is required for conditional step.";
  ELSEIF _step_type != 'condition' AND _false_step_pos IS NOT NULL 
  THEN
    SET _response = "No step position on false result is needed. Please leave it blank.";
  ELSE
  
    IF _if_sub_process = 1
    THEN
      SET _if_autostart = 1;
    END IF;
    INSERT INTO process_step (
      process_id,
      position_id,
      step_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made)
    VALUES (
      _process_id,
      _position_id,
      _step_id,
      _prev_step_pos,
      _next_step_pos,
      _false_step_pos,
      _segment_id,
      _rework_limit,
      _if_sub_process,
      _prompt,
      _if_autostart,
      _need_approval,
      _approve_emp_usage,
      _approve_emp_id,
      _product_made
    );
  
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'insert',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    FROM process_step
    WHERE process_id=_process_id
      AND position_id = _position_id;
    
    UPDATE process
      SET state_change_time = _eventtime,
          state_changed_by = _employee_id
    WHERE id = _process_id;

   
  END IF;


END IF;

END$
