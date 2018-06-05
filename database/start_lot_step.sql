/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : start_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for starting a lot at a step
*    Log                    :
*    6/1/2018: xdong: adding handling to new step type -- disassemble
*    6/5/2018: xdong: just modified delimiter of the file to be consistant with load_procedures
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `start_lot_step`$
CREATE PROCEDURE `start_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _check_autostart tinyint(1) unsigned,
  IN _start_quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _comment text,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
  -- doesn't check if operator has access to the step, because for autostart, even the operator
  -- only has access to previous step, this step can still be automaically started when previouse step
  -- is ended by the operator.
  -- start form will check employee access though.
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _result varchar(255);
  DECLARE _step_type varchar(20);
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  
 
  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch identifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);
    
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSEIF _response IS NULL
    THEN
      -- start step under two cases: 1. started by start form (_check_autostart = 0)
      -- 2. auto started after another step ends and called by stored procedure (_check_autostart=1)
      -- 3. hold lot step type always autostart, regardless whether it is configured this way
      IF _check_autostart = 0 OR 
        (_check_autostart > 0 
           AND (_if_autostart > 0 OR _step_type='hold lot')
           AND _lot_status = 'in transit' 
           AND _step_status = 'ended'
        )
      THEN

  
        IF _process_id IS NULL 
          AND _sub_process_id IS NULL 
          AND _position_id IS NULL
          AND _sub_position_id IS NULL
          AND _step_id IS NULL
        THEN  -- new step informaiton wasn't supplied
        
          SET _process_id = _process_id_p;
          SET _sub_process_id = _sub_process_id_n;
          SET _position_id = _position_id_n;
          SET _sub_position_id = _sub_position_id_n;
          SET _step_id = _step_id_n;
        ELSEIF _process_id<=>_process_id_p 
              AND _sub_process_id<=>_sub_process_id_n
              AND _position_id <=>_position_id_n
              AND _sub_position_id <=>_sub_position_id_n
              AND _step_id <=> _step_id_n
        THEN -- new step information was supplied and checked
          SET _response='';
        ELSE
          SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
        END IF;        
         
        IF (_response IS NULL OR length(_response)=0)  
        THEN
          CASE 
          WHEN _step_type in ('consume material', 'disassemble', 'condition')
          THEN
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'in process';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF; 
            
         WHEN _step_type='hold lot'
          THEN            
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            IF (_check_autostart > 0)
            THEN
              SET _comment=CONCAT('Batch ', _lot_alias, ' has been held due to the result from previous step.');
            END IF;
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'hold';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF;             

         -- END IF;
         END CASE;
        END IF;


      END IF;
    END IF;
  END IF;
END$
