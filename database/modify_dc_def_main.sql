/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_dc_def_main.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_dc_def_main`$
CREATE PROCEDURE `modify_dc_def_main`(
  INOUT _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _state enum('inactive','production','frozen','checkout','checkin','engineer'), 
  IN _name varchar(255),
  IN _contact_emp int(10) unsigned,
  IN _target enum('product', 'equipment','supply'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _oldstate enum('inactive','production','frozen','checkout','checkin','engineer');
  SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
                                between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
                                and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
                            substring(addtime(timezone, '01:00'), 1, 6),
                            timezone)  
                   FROM company c, employee e
                  WHERE e.id = _recorder AND c.id = e.company_id);
  
  IF NOT EXISTS (SELECT * FROM employee WHERE id=_recorder) THEN
    SET _response = "Employee who is configuring this data collection does not exist in database.";
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_contact_emp) THEN
    SET _response = "The selected contact person does not exist in our record.";
  ELSEIF _def_id IS NULL THEN
    IF EXISTS (SELECT * FROM dc_def_main WHERE name = _name) THEN
      SET _response = concat('The data collection named ', _name, ' already exists in database. Please choose another name.');
    ELSE
      INSERT INTO dc_def_main 
      (name, 
      state, 
      contact_emp, 
      target, 
      create_time, 
      created_by,
      description,
      comment)
      VALUES (
        _name,
        _state,
        _contact_emp,
        _target,
        now(),
        _recorder,
        _description,
        _comment
      );
      SET _def_id = last_insert_id();
      
      INSERT INTO config_history 
      (event_time, 
      source_table, 
      source_id, 
      old_state, 
      new_state, 
      employee, 
      comment, 
      new_record)
      SELECT create_time,
             'dc_def_main',
             id,
             null,
             state,
             created_by,
             concat('data collection ', name, ' is created'),
             concat('<DATACOLLECTION><NAME>', name,'</NAME><STATE>',state,
                            '</STATE><CONTACT_EMP>', contact_emp, '</CONTACT_EMP><TARGET>', target,
                            '</TARGET><DATA_TABLE_NAME></DATA_TABLE_NAME><CREATE_TIME>',create_time,
                            '</CREATE_TIME><CREATED_BY>',created_by,
                            '</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME>',
                            '<STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                            '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                            '</COMMENT></DATACOLLECTION>')
      FROM dc_def_main
      WHERE id=_def_id;
             
      
    END IF;
  ELSE
    IF EXISTS (SELECT * FROM dc_def_main WHERE id!=_def_id AND name = _name) THEN
      SET _response = concat('The name ', _name, ' is already used by another data collection in database. Please choose another name.');
    ELSE
      SELECT state INTO _oldstate
        FROM dc_def_main
       WHERE id=_def_id;
      
      IF _oldstate IS NULL THEN
        SET _response="The data collection you are modifying does not exist in database.";
      ELSE
        UPDATE dc_def_main
          SET name=_name,
              state=_state,
              contact_emp = _contact_emp,
              target=_target,
              state_change_time = now(),
              state_changed_by = _recorder,
              description = _description,
              comment = _comment
        WHERE id=_def_id;
      
        INSERT INTO config_history 
        (event_time, 
        source_table, 
        source_id, 
        old_state, 
        new_state, 
        employee, 
        comment, 
        new_record)
        SELECT state_change_time,
              'dc_def_main',
              id,
              _oldstate,
              state,
              state_changed_by,
              concat('data collection ', name, ' is modified'),
              concat('<DATACOLLECTION><NAME>', name,'</NAME><STATE>',state,
                              '</STATE><CONTACT_EMP>', contact_emp, '</CONTACT_EMP><TARGET>', target,
                              '</TARGET><DATA_TABLE_NAME>', ifnull(data_table_name, ''),
                              '</DATA_TABLE_NAME><CREATE_TIME>',create_time,
                              '</CREATE_TIME><CREATED_BY>',created_by,
                              '</CREATED_BY><STATE_CHANGE_TIME>', state_change_time,
                              '</STATE_CHANGE_TIME><STATE_CHANGED_BY>', state_changed_by,
                              '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                              '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                              '</COMMENT></DATACOLLECTION>')
        FROM dc_def_main
        WHERE id=_def_id;
      END IF;
    END IF;
  END IF;
END$ 