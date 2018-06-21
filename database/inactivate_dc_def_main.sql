/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : inactivate_dc_def_main.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `inactivate_dc_def_main`$
CREATE PROCEDURE `inactivate_dc_def_main`(
  IN _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _oldstate enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _data_table varchar(60);
  DECLARE _curtime datetime;
  DECLARE _db_name varchar(60);
  DECLARE _log varchar(255);
                    
  IF NOT EXISTS (SELECT * FROM employee WHERE id=_recorder) THEN
    SET _response = "Employee who is configuring this data collection does not exist in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_main WHERE id = _def_id) THEN
    SET _response = "The data collection you are working on is not defined in database.";
  ELSE
  
    SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
                                between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
                                and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
                            substring(addtime(timezone, '01:00'), 1, 6),
                            timezone)  
                      FROM company c, employee e
                      WHERE e.id = _recorder AND c.id = e.company_id);
                    
    SELECT c.db_name INTO _db_name
      FROM company c, employee e
     WHERE e.id = _recorder AND c.id = e.company_id;
    
    SELECT state, data_table_name INTO _oldstate, _data_table
      FROM dc_def_main
     WHERE id = _def_id;
    
    IF NOT EXISTS (
      SELECT *
        FROM information_schema.tables
       WHERE table_schema = _db_name
         AND table_name = _data_table
         AND table_rows > 0
    ) THEN
      SET @stmt = CONCAT("DROP TABLE IF EXISTS ", _data_table, ";");
      PREPARE stmt FROM @stmt;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;     
      SET _log = " There is no data collected by the definition currently and data table was deleted";
      SET _data_table = null;
    END IF;
    
    UPDATE dc_def_main
       SET state='inactive',
           data_table_name = _data_table,
           state_change_time = now(),
           state_changed_by = _recorder
     WHERE id = _def_id;
    
    IF row_count() > 0 THEN
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
              concat('data collection ', name, ' is inactivated.', IFNULL(_log, '')),
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
END$