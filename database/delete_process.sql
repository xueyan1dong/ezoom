DROP PROCEDURE IF EXISTS `delete_process`;
CREATE procedure delete_process (
  IN _process_id int(10) unsigned,
  IN _employee_id int(10) unsigned
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  DECLARE _eventtime datetime;
  SET _eventtime = now();  


   SELECT NAME INTO ifexist 
   FROM process 
   WHERE id= _process_id;
   
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
      if_sub_process,
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
      if_sub_process,
      need_approval,
      approve_emp_usage,
      approve_emp_id  
    FROM process_step
    WHERE process_id=_process_id;

    
    DELETE FROM process_step
    WHERE process_id = _process_id;
  
    -- delete process_segment record
    DELETE FROM process_segment
    WHERE process_id = _process_id;
    
    SELECT state
     INTO _oldstate
     FROM process
   WHERE id=_process_id;  
   
   DELETE FROM product_process
    WHERE process_id = _process_id;
    
   DELETE FROM process
    WHERE id=_process_id;

     INSERT INTO config_history (
       event_time,
       source_table,
       source_id,
       old_state,
       new_state,
       employee,
       comment 
     )
     VALUES (_eventtime,
             'process',
             _process_id,
             _oldstate,
             'deleted',
             _employee_id,
             concat('process ' , ifexist , ' is deleted')
             );


   END IF;

END;
