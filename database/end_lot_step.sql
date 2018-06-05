/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : start_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for ending a lot at a step
*    Log                    :
*    6/5/2018: xdong: adding handling to new step type -- disassemble
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `end_lot_step`$
CREATE PROCEDURE `end_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _start_timecode char(15),
  IN _operator_id int(10) unsigned,
  IN _end_quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _result_comment text,  -- for long text result or comment
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _autostart_timecode char(15),  
  OUT _response varchar(255)
)
BEGIN
-- doesn't check employee access to the step. End form will check employee access though.
  DECLARE _process_id_p int(10) unsigned;
  DECLARE _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _result text;
  DECLARE _end_timecode char(15);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The batch you supplied does not exist in database";
    ELSE
      -- check position information
      SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid
        INTO _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p, _step_id_p, _uomid
        FROM lot_history
       WHERE lot_id = _lot_id
         AND start_timecode = _start_timecode
         AND status IN ('started', 'restarted') 
         AND end_timecode IS NULL
         ;
      
      IF _process_id_p IS NULL 
      THEN
        SET _response = "The batch is currently not in a workflow step.";
      ELSE
        IF _process_id IS NOT NULL AND _process_id != _process_id_p
        THEN
          SET _response = "The batch is in a different workflow than you supplied.";
        ELSEIF _position_id IS NOT NULL AND _position_id!= _position_id_p
        THEN
          SET _response = concat("The batch is at a different position " , _position_id_p , " than you supplied.");
        ELSEIF _step_id IS NOT NULL AND _step_id != _step_id_p
        THEN
          SET _response = "The batch is at a different step than you supplied.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id_p IS NULL
        THEN
          SET _response = "The batch is not in a sub workflow as you indicated.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id != _sub_process_id_p 
        THEN
          SET _response = "The batch is in a different sub workflow than you supplied.";
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id IS NULL
        THEN
          SET _response = concat("The batch is not in the position " , _sub_position_id , " in sub workflow as you indicated.");
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id!=_sub_position_id_p
        THEN
          SET _response = "The batch is at a different position in sub workflow than you indicated.";
        ELSE
          SET _process_id = _process_id_p;
          SET _position_id = _position_id_p;
          SET _step_id = _step_id_p;
          
          IF _sub_process_id_p IS NOT NULL
          THEN
            SET _sub_process_id = _sub_process_id_p;
          END IF;
          
          IF _sub_position_id_p IS NOT NULL
          THEN
            SET _sub_position_id = _sub_position_id_p;
          END IF;
          
          -- check approver information
          IF _sub_process_id IS NULL
          THEN
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
           ;
          ELSE
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _sub_process_id
               AND position_id = _sub_position_id
               AND step_id = _step_id
             ;
          END IF;
          
          CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
          
          IF _response IS NULL OR length(_response)=0
          THEN
            -- get step type
            SELECT st.name
              INTO _step_type
              FROM step s, step_type st
            WHERE s.id =_step_id
              AND st.id =s.step_type_id;
  
            SET _end_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            IF _step_type in ('consume material', 'disassemble', 'condition', 'hold lot')
            THEN
              SET _step_status = 'ended';
              UPDATE lot_history
                SET end_timecode = _end_timecode
                  , end_operator_id = _operator_id
                  , status = _step_status
                  , end_quantity = _end_quantity
                  , uomid = _uomid
                  , approver_id = _approver_id
                  , result = _short_result
                  , comment = _result_comment
              WHERE lot_id = _lot_id
                AND start_timecode = _start_timecode
                AND status IN ('started', 'restarted')
                AND end_timecode IS NULL;
            
              IF row_count() > 0 THEN
                SET _lot_status = 'in transit';
                UPDATE lot_status
                  SET status = _lot_status
                      ,actual_quantity = _end_quantity
                      ,update_timecode = _end_timecode
                      ,comment = _result_comment
                WHERE id=_lot_id;
               
                SET _process_id_p = null;
                SET _sub_process_id_n = null;
                SET _position_id_n = null;
                SET _sub_position_id_n = null;
                SET _step_id_n = null;
                
                CALL `start_lot_step`(
                  _lot_id,
                  _lot_alias,
                  _operator_id,
                  1,
                  _end_quantity,
                  null,
                  null,
                  'Step started automatically',
                  _process_id_p,
                  _sub_process_id_n,
                  _position_id_n,
                  _sub_position_id_n,
                  _step_id_n,
                  _lot_status_n,
                  _step_status_n,
                  _autostart_timecode,
                  _response
                );
                IF _autostart_timecode IS NOT NULL
                THEN
                  SET _process_id = _process_id_p;
                  SET _sub_process_id = _sub_process_id_n;
                  SET _position_id = _position_id_n;
                  SET _sub_position_id = _sub_position_id_n;
                  SET _step_id = _step_id_n;
                  SET _lot_status = _lot_status_n;
                  SET _step_status = _step_status_n;
                END IF;

              ELSE
                SET _response = "Error encountered when update batch history information.";
              END IF;             
            END IF;

          END IF;
          
 
        END IF;
      END IF;
    END IF;
  END IF;

END$
