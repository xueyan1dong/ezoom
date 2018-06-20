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
DROP PROCEDURE IF EXISTS `modify_process`$
CREATE procedure modify_process (
  IN _process_id int(10) unsigned,
  IN _prg_id int(10) unsigned,
  IN _name varchar(255),
  IN _version  int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),
  IN _owner_id int(10) unsigned,
  IN _if_default_version tinyint(1),
  IN _employee_id int(10) unsigned,
  IN _usage enum('sub process only','main process only','both'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _process_id IS NULL
  THEN
    SET _response='Process id is required. Please suppy process id.';
    
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Process name is required. Please give the process a name.';
    
  ELSEIF _owner_id IS NULL or _owner_id<0
  THEN
    SET _response = 'Process owner is required. Please give the process an owner.';    
   
  ELSEIF _usage IS NULL or length(_usage)<1
  THEN
    SET _response = 'Process usage is required.  Please select process usage.';
    
  ELSE

      SELECT NAME INTO ifexist 
      FROM process 
      WHERE name=_name
        AND id!= _process_id;
      
      IF ifexist IS NULL
      THEN
       SELECT state
         INTO _oldstate
        FROM process
      WHERE id=_process_id;  
      
        UPDATE process
           SET prg_id = _prg_id,
               name = _name,
               `version` = _version,
               state = _state,
               owner_id = _owner_id,
               if_default_version = _if_default_version,
               `usage` = _usage,
               description = _description,
               comment = _comment,
               state_change_time = now(),
               state_changed_by = _employee_id
        WHERE  id = _process_id;

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
        SELECT state_change_time,
              'process',
              id,
              _oldstate,
              state,
              state_changed_by,
              concat('process' , name , ' general information is updated'),
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
        WHERE id=_process_id;
        SET _response = '';
      ELSE
        SET _response= concat('The process name ' , _name ,' is already used by another process. Please change the process name and try again.');
      END IF;
 
 END IF;
END$
