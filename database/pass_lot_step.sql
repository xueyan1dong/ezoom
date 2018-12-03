/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : pass_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for starting and ending a step in one shot
*    Log                    :
*    6/6/2018: xdong: adding _location parameter to record batch location for certain ship steps
*	 8/2/2018: peiyu: replaced _location nvarchar  to location_id int
*	 11/29/2018 peiyu: added one more state "done" to lot status and update lot_status accordingly. if flag product_made of current step
*    in process_step is 1, update quantity_made and quantity_in_process in order details
*   11/29/2018:xdong: fixed some logical error regarding product_made and done status. 
*                      added code to update quantity_in_process when actual quantity changed
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `pass_lot_step`$
CREATE PROCEDURE `pass_lot_step`(
IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _comment text,
  -- IN _location nvarchar(255), -- for location
  IN _location_id int(11) unsigned,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _autostart_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
 
 -- xxxx_p are for position step just processed before this step
 -- xxxx_n are for the position step to be passed in this call
 -- xxxx_nn are for the next postion step after the step to be passed in this call
 -- inout parameters _process_id, _sub_Process_id, _position_id, _sub_position_id, _step_id should have the same value
 -- as the xxxx_n obtained from call to get_next_step_for_lot
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n, _sub_process_id_nn int(10) unsigned; 
  DECLARE _position_id_p, _position_id_n, _position_id_nn int(5) unsigned;  
  DECLARE _sub_position_id_p, _sub_position_id_n, _sub_position_id_nn int(5) unsigned; 
  DECLARE _step_id_p, _step_id_n, _step_id_nn int(10) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _start_timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _product_made tinyint(1) unsigned;
  DECLARE _quantity_status ENUM('in process', 'made', 'shipped');
  DECLARE _order_id int(10) unsigned;
  DECLARE _product_id int(10) unsigned;
  DECLARE _line_num smallint(5) unsigned;
  DECLARE _actual_quantity_p decimal(16,4);

  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE  -- pull in lot current info, which do not have the step to be passed yet
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid,
           actual_quantity,
           order_id,
           product_id, 
           order_line_num
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid,
           _actual_quantity_p,
           _order_id,
           _product_id,
           _line_num
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
    -- send in last step info through _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p and 
    -- get the info of the step to be processed in this call and save them into _sub_process_id_n, _position_id_n, _sub_position_id_n, _step_id_n etc.
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
                              
    IF _response IS NULL
    THEN
      IF _process_id IS NULL 
        AND _sub_process_id IS NULL 
        AND _position_id IS NULL
        AND _sub_position_id IS NULL
        AND _step_id IS NULL
      THEN  -- step information wasn't supplied from input, replenish them through the internal variables
        
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
      THEN -- new step information was supplied and checked against the result from call to get_next_step_for_lot
        SET _response='';
      ELSE
        SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF; 
        
      IF _response IS NULL OR length(_response)=0  
      THEN
           -- check approver information and product made infomation of the pass step
        IF _sub_process_id IS NULL
        THEN
          SELECT need_approval, approve_emp_usage, approve_emp_id, product_made 
            INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made 
            FROM process_step
           WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
          ;
        ELSE
          SELECT need_approval, approve_emp_usage, approve_emp_id,product_made
            INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made
            FROM process_step
           WHERE process_id = _sub_process_id
             AND position_id = _sub_position_id
             AND step_id = _step_id
             ;
        END IF;
        
        -- perform check approver routine
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);

        -- if approver routine passed
        IF _response IS NULL OR length(_response)=0 
        THEN
          
          SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            
          SET _step_status = 'ended';
          
          -- below logic is to preserve current location, if lot is not at those
          -- ship steps
          IF _step_type NOT IN ('ship to location', 'ship outof warehouse', 'deliver to customer')
          THEN
            SELECT _location_id = location_id
              FROM lot_status
              WHERE id = _lot_id;
          END IF;     
          
          IF _product_made = 1
          THEN
            SET _quantity_status = 'made';
          END IF;
          
          -- record this step into lot history
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
            equipment_id,
            device_id,
            result,
            comment,
            location_id,
            quantity_status
          )
          VALUES (
            _lot_id,
            _lot_alias,
            _start_timecode,
            _start_timecode,
            _process_id,
            _sub_process_id,
            _position_id,
            _sub_position_id,
            _step_id,
            _operator_id,
            _operator_id,
            _step_status,
            _actual_quantity_p,
            _quantity,
            _uomid ,
            _equipment_id,
            _device_id,
            _short_result,
            _comment,
            _location_id,
            _quantity_status
          ); 
          -- now that lot history is logged. update current lot information and order detail
          IF row_count() > 0 THEN
            -- look beyond the step just passed to see if at the last step
            CALL get_next_step_for_lot(_lot_id, 
                                  _lot_alias, 
                                  _lot_status, 
                                  _process_id_p,
                                  _sub_process_id_n,
                                  _position_id_n,
                                  _sub_position_id_n,
                                  _step_id_n,
                                  _result,
                                  _sub_process_id_nn,
                                  _position_id_nn,
                                  _sub_position_id_nn,
                                  _step_id_nn,
                                  _step_type,
                                  _rework_limit,
                                  _if_autostart,
                                  _response);
          -- check next position id, if NULL then workflow completes
            -- if no more step to perform and not special steps
            IF (_response IS NULL OR length(_response)=0) AND _position_id_nn IS NULL THEN 
              SET _lot_status = 'done';
            ELSE
              SET _lot_status = 'in transit';
            END IF;
            
  
            UPDATE lot_status
              SET status = _lot_status
                  ,actual_quantity = _quantity
                  ,update_timecode = _start_timecode
                  ,comment=_comment
                  ,location_id = _location_id
                  ,quantity_status = _quantity_status
            WHERE id=_lot_id;
			  
            
            -- if actual quantity changed, update quantity_in_process in order_detail
            IF _actual_quantity_p != _quantity
            THEN
              UPDATE order_detail
                 SET quantity_in_Process = quantity_in_process - _actual_quantity_p + _quantity
              WHERE order_id= _order_id
                And source_id = _product_id
                And source_type = 'product'
                And line_num = _line_num;
            END IF;
					  
            -- if product is made at the step, deduct the quantity from quantity_in_process and add it to quantity_made in order_detail
            IF _product_made = 1
            THEN
              UPDATE order_detail
              SET quantity_made = quantity_made + _quantity
                  ,quantity_in_process = quantity_in_process - _quantity
              WHERE order_id= _order_id
              And source_id = _product_id
              And source_type = 'product'
              And line_num = _line_num;
            End IF;
            ELSE
              SET _response="Error when recording step pass in batch history.";
            END IF; 
            -- if lot is not done
            -- below process is for auto start next step. if call to start_lot_step return _autostart_timecode
            -- we know next step is auto-started, thus, set output parameters to next step
            IF (_response IS NULL OR length(_response)=0) and _lot_status != 'done' THEN
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
                _quantity,
                null,
                null,
                'Step started automatically',
                _process_id_p,
                _sub_process_id_n,
                _position_id_n,
                _sub_position_id_n,
                _step_id_n,
                _location_id,
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
            END IF;
          
          END IF;
        END IF;
  
  
      END IF;
    END IF;
  END IF;
END$
