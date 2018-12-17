/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : duplicate_process.sql
*    Created By             : JunLu
*    Date Created           : 12/15/2018
*    Platform Dependencies  : MySql
*    Description            : 
*    example	              :
        CALL duplicate_process (7, 2, @resp, @new_id);
        SELECT @resp, @new_id;
*    Log                    :
*    12/152018: Junlu Luo: First Created
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `duplicate_process`$
CREATE procedure duplicate_process (
  IN _old_process_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255),
  OUT _new_process_id int(10) unsigned
) 
BEGIN
  SET _response = "";
  
  -- make sure the name of duplicate process is unique
  SET @name = "";
  SET @prg_id = 0;
  SET @versoin = 0;
  
  SELECT `name`, `version`, `prg_id` INTO @name, @version, @prg_id
  FROM process
  WHERE id = _old_process_id;
  
  SET @count = 1;
  WHILE @count > 0 DO
    SET @name = CONCAT(@name, ' - Copy');
    SELECT COUNT(*) INTO @count
    FROM process
    WHERE `name` = @name AND `prg_id` = @prg_id AND `version` = @version;
  END WHILE;
  
  -- duplicate process
  INSERT INTO process (
    `name`,
    `version`,
    `prg_id`,
    `state`,
    `start_pos_id`,
    `owner_id`,
    `if_default_version`,
    `create_time`,
    `created_by`,
    `state_change_time`,
    `state_changed_by`,
    `usage`,
    `description`,
    `comment`
  )
  SELECT @name,
    `version`,
    `prg_id`,
    `state`,
    `start_pos_id`,
    _employee_id,
    `if_default_version`,
    `create_time`,
    `created_by`,
    `state_change_time`,
    `state_changed_by`,
    `usage`,
    `description`,
    `comment`
  FROM process
  WHERE id = _old_process_id;
  
  -- newly created process id
  SET _new_process_id = last_insert_id();
  
  -- insert an entry to the history
  INSERT INTO config_history (
    event_time,
    source_table,
    source_id,
    old_state,
    new_state,
    employee,
    comment,
    new_record
  )
  SELECT create_time,
    'process',
    id,
    null,
    state,
    created_by,
    concat('process', name , 'is created'),
    concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
    '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
      '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
      '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
      '</CREATE_TIME><CREATED_BY>',created_by,
      '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
      '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
      '</STATE_CHANGED_BY><USAGE>', `usage`, 
      '</USAGE><DESCRIPTION>',IFNULL(description,''),
      '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
      '</COMMENT></PROCESS>')
  FROM process
  WHERE id = _new_process_id;

  -- copy steps
  INSERT INTO process_step (
    `process_id`,
    `position_id`,
    `step_id`,
    `prev_step_pos`,
    `next_step_pos`,
    `false_step_pos`,
    `segment_id`,
    `rework_limit`,
    `if_sub_process`,
    `prompt`,
    `if_autostart`,
    `need_approval`,
    `approve_emp_usage`,
    `approve_emp_id`,
    `product_made`
  )
  SELECT 
    _new_process_id,
    `position_id`,
    `step_id`,
    `prev_step_pos`,
    `next_step_pos`,
    `false_step_pos`,
    `segment_id`,
    `rework_limit`,
    `if_sub_process`,
    `prompt`,
    `if_autostart`,
    `need_approval`,
    `approve_emp_usage`,
    `approve_emp_id`,
    `product_made`
  FROM process_step
  WHERE process_id = _old_process_id;
  
END$
