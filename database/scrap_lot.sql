DROP PROCEDURE IF EXISTS `scrap_lot`;
CREATE PROCEDURE `scrap_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _comment text,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  
  SET autocommit=0;
   
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
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

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
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
    IF _response IS NULL AND _step_type = "scrap"
    THEN
      -- SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
      IF ( _process_id IS NULL 
         AND _sub_process_id IS NULL 
         AND _position_id IS NULL
         AND _sub_position_id IS NULL
         AND _step_id IS NULL) OR
         (_process_id<=>_process_id_p 
            AND _sub_process_id<=>_sub_process_id_n
            AND _position_id <=>_position_id_n
            AND _sub_position_id <=>_sub_position_id_n
            AND _step_id <=> _step_id_n)
      THEN  -- new step informaiton wasn't supplied
      
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSE
         SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF;
      
       -- check approver information
      IF _response IS NULL
      THEN
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
      END IF;
      
      IF _response IS NULL
      THEN
        SET _step_status = 'scrapped';
        SET _timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;        
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          end_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          end_operator_id,
          status,
          start_quantity,
          end_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _timecode,
          _timecode,
          _process_id,
          _sub_process_id,
          _position_id,
          _sub_position_id,
          _step_id,
          _operator_id,
          _operator_id,
          _step_status,
          _quantity,
          _quantity,
          _uomid ,
          _comment
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'scrapped';
          
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _quantity
                ,update_timecode = _timecode
                ,comment=_comment
           WHERE id=_lot_id;
           
           UPDATE order_detail o, lot_status l
              SET o.quantity_in_process = o.quantity_in_process - convert_quantity(_quantity, _uomid, o.uomid)
            WHERE l.id = _lot_id
              AND o.order_id = l.order_id
              AND o.source_type = 'product'
              AND o.source_id = l.product_id
              ;
             COMMIT;         
        ELSE
          SET _response="Error when recording scrap action in batch history.";
          ROLLBACK;
        END IF;  
        
        
      END IF;
    END IF;
    END IF;
  END IF;
END;
