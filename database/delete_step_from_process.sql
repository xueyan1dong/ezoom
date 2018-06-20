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
DROP PROCEDURE IF EXISTS `delete_step_from_process`$
CREATE procedure delete_step_from_process (
  IN _process_id int(10) unsigned,
  IN _employee_id int(10) unsigned,  
  IN _position_id  int(5) unsigned

) 
BEGIN
  DECLARE ifexist int(5) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();

  SELECT position_id INTO ifexist
    FROM process_step
  WHERE process_id = _process_id
    AND position_id = _position_id;
    
  IF ifexist IS NOT NULL
  THEN
  
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
    approve_emp_id 
  )
  SELECT _eventtime,
    process_id,
    position_id,
    step_id,
    'DELETE',
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
    approve_emp_id  
  FROM process_step
  WHERE process_id=_process_id
    AND position_id = _position_id;
  
  DELETE FROM process_step
   WHERE process_id = _process_id
     AND position_id = _position_id;
     
  UPDATE process
    SET state_change_time = _eventtime,
        state_changed_by = _employee_id
  WHERE id = _process_id;  
  
  END IF;
END$
