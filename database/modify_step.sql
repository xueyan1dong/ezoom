DROP PROCEDURE IF EXISTS `modify_step`;
CREATE PROCEDURE `modify_step`(
  INOUT _step_id int(10) unsigned, 
  IN _created_by int(10) unsigned,
  IN _version int(5) unsigned,
  IN _if_default_version tinyint(1) unsigned,
  IN _state enum('inactive','production','frozen','checkout','checkin','engineer'),
  IN _eq_usage enum('equipment group','equipment'),
  IN _emp_usage enum('employee group','employee'),
  IN _emp_id int(10) unsigned,  
  IN _name varchar(255),
  IN _step_type_id int(5) unsigned,   
  IN _eq_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _description text,
  IN _comment text,  
  IN _para1 text,
  IN _para2 text,
  IN _para3 text,
  IN _para4 text,
  IN _para5 text,
  IN _para6 text,
  IN _para7 text,
  IN _para8 text,
  IN _para9 text,
  IN _para10 text,  
  IN _para_count tinyint(3),
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _newstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _step_type_id IS NULL OR length(_step_type_id)<1
  THEN
    SET _response='Step type is required. Please give the step a type.';
  
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Step name is required. Please give the step a name.';
  ELSEIF `_version` IS NULL OR length(`_version`)<1
  THEN
    SET _response='Step version is required. Please give the step a version.';  
 
  ELSEIF _created_by IS NULL OR length(_created_by)<1
  THEN
    SET _response='Created by is required. Please select create person.';  
   
  ELSE
    IF _step_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM step 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO step (
          step_type_id,
          name,
          `version`,
          if_default_version,
          state,
          eq_usage,
          eq_id,
          emp_usage,
          emp_id,
          recipe_id,
          mintime,
          maxtime,
          create_time,
          created_by,
          para_count,
          description,
          comment,
          para1,
          para2,
          para3,
          para4,
          para5,
          para6,
          para7,
          para8,
          para9,
          para10
        )
        VALUES (
          _step_type_id,
          _name,
          _version,
          _if_default_version,
          _state,
          _eq_usage,
          _eq_id,
          _emp_usage,
          _emp_id,
          _recipe_id,
          _mintime,
          _maxtime,
          now(),
          _created_by,
          _para_count,
          _description,
          _comment,  
          _para1,
          _para2,
          _para3,
          _para4,
          _para5,
          _para6,
          _para7,
          _para8,
          _para9,
          _para10
        );
        SET _step_id = last_insert_id();
        
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
              'step',
              id,
              NULL,
              state,
              created_by,
              concat('Step ', name, ' is created'),
              concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')
        FROM step
        WHERE id=_step_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another step. Please change the step name and try again.');
      END IF;
    ELSE
    SELECT name INTO ifexist 
      FROM step 
      WHERE name=_name
        AND id !=_step_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM step
      WHERE id=_step_id;
        
      UPDATE step
        SET step_type_id = _step_type_id,
            name = _name,
            `version` = _version,
            if_default_version = _if_default_version,
            state = _state,
            eq_usage = _eq_usage,
            eq_id = _eq_id,
            emp_usage = _emp_usage,
            emp_id = _emp_id,
            recipe_id = _recipe_id,
            mintime = _mintime,
            maxtime = _maxtime,
            state_change_time = now(),
            state_changed_by = _created_by,
            para_count = _para_count,
            description = _description,
            comment = _comment,  
            para1 = _para1,
            para2 = _para2,
            para3 = _para3,
            para4 = _para4,
            para5 = _para5,
            para6 = _para6,
            para7 = _para7,
            para8 = _para8,
            para9 = _para9,
            para10 = _para10
      WHERE id = _step_id;
      
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
                'step',
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('step ', name, ' updated'),
                concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')                
          FROM step
          WHERE id=_step_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another step. Please change the step name and try again.');
    END IF;
  END IF; 
 END IF;
END;
