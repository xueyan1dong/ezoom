/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : end_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for ending a lot at a step
*    Log                    :
*    6/5/2018: xdong: adding handling to new step type -- disassemble
*	 8/2/2018: peiyu: added an new variable location_id and added to call 'start_lot_step' 
*	 11/28/2018: peiyu: added status 'done' to lot_status enum; 
*                update lot_status to 'done' when the workflow completed 
*                and then update quantity_made and quantity_in_process in order_detail when product_made of current step is true (in process_step). 
*  12/04/2018: Xueyan Dong: corrected the logic around identifying last step of the workflow. Added logic to update quantities in order_detail in
*                           case of batch quantity change.
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
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _product_made tinyint(1) unsigned;
  DECLARE _quantity_status, _quantity_status_p ENUM('in process', 'made', 'shipped');
  DECLARE _order_id int(10) unsigned;
  DECLARE _product_id int(10) unsigned;
  DECLARE _line_num smallint(5) unsigned;
  DECLARE _start_quantity decimal(16,4) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  
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
--       SELECT process_id,
--              sub_process_id,
--              position_id,
--              sub_position_id,
--              step_id,
--              uomid,
--              start_quantity,
--              quantity_status
--         INTO _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p, _step_id_p, _uomid, _start_quantity, _quantity_status_p
--         FROM lot_history
--        WHERE lot_id = _lot_id
--          AND start_timecode = _start_timecode
--          AND status IN ('started', 'restarted') 
--          AND end_timecode IS NULL
--        ;
   SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid,
             actual_quantity,
             quantity_status,
             order_id,
             product_id,
             order_line_num,
             lot_status
        INTO _process_id_p, 
             _sub_process_id_p, 
             _position_id_p, 
             _sub_position_id_p, 
             _step_id_p, 
             _uomid, 
             _start_quantity, 
             _quantity_status_p,
             _order_id,
             _product_id,
             _line_num,
             _lot_status
        FROM view_lot_in_process
       WHERE id = _lot_id;

         
         
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
          
          -- check approver information and product_made information
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
           SELECT need_approval, approve_emp_usage, approve_emp_id, product_made
             INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made
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
			
            IF _product_made = 1
            THEN
              SET _quantity_status = 'made';
            ELSE
              SET _quantity_status = 'in process';
            END IF;
            
            SET _end_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            -- note that this sp currently only handle below four step types
            IF _step_type in ('consume material', 'disassemble', 'condition', 'hold lot')
            THEN
              SET _step_status = 'ended';
              
              -- mark the end for current step in lot_history table
              UPDATE lot_history
                 SET end_timecode = _end_timecode
                  , end_operator_id = _operator_id
                  , status = _step_status
                  , end_quantity = _end_quantity
                  , uomid = _uomid
                  , approver_id = _approver_id
                  , result = _short_result
                  , comment = _result_comment
                  , quantity_status = _quantity_status
              WHERE lot_id = _lot_id
                AND start_timecode = _start_timecode
                AND status IN ('started', 'restarted')
                AND end_timecode IS NULL;
            
            IF row_count() > 0 THEN -- look forward to next step
                -- get next position, if Null, Lot Done
               CALL get_next_step_for_lot(_lot_id, 
                                    _lot_alias, 
                                    'in transit', -- before knowing whether current step is the last, lot status is always in transit after step ending
                                    _process_id_p,
                                    _sub_process_id_p,
                                    _position_id_p,
                                    _sub_position_id_p,
                                    _step_id_p,
                                    _short_result,
                                    _sub_process_id_n,
                                    _position_id_n,
                                    _sub_position_id_n,
                                    _step_id_n,
                                    _step_type,
                                    _rework_limit,
                                    _if_autostart,
                                    _response);
                
            IF _position_id_n IS NULL THEN  -- if no next step
              SET _lot_status = 'done';
            ELSE
              SET _lot_status = 'in transit';
                        -- SET _quantity_status = 'in process'; default is in process
            END IF;
            
            UPDATE lot_status
              SET status = _lot_status
                  ,actual_quantity = _end_quantity
                  ,update_timecode = _end_timecode
                  ,comment = _result_comment
                  ,quantity_status = _quantity_status
            WHERE id=_lot_id;


            -- if end_quantity changed from start_quantity, adjust quantities in order_detail. quantity_shipped will never need adjust, 
            -- because once product is shipped to customer, the quantity record should not change
            IF _start_quantity != _end_quantity
            THEN
              IF _quantity_status_p = 'in process' THEN
                UPDATE order_detail
                   SET quantity_in_Process = quantity_in_process - _start_quantity + _end_quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;
              ELSEIF _quantity_status_p = 'made' THEN
                 UPDATE order_detail
                   SET quantity_made = quantity_made - _start_quantity + _end_quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;             
              END IF;
            END IF;           
            
            -- check product_made flag in process_step table, if 1, update quantity_made, quantity_in_process in order_detail table 
            
            IF _product_made = 1 Then
              UPDATE order_detail
              SET quantity_made = quantity_made + _end_quantity
                ,quantity_in_process = quantity_in_process - _end_quantity
              WHERE order_id= _order_id
              And source_id = _product_id
              And source_type = 'product'
              And line_num = _line_num;
            End IF;
                
                
            SET _process_id_p = null;
            SET _sub_process_id_n = null;
            SET _position_id_n = null;
            SET _sub_position_id_n = null;
            SET _step_id_n = null;
                  
                
            IF _lot_status not in ('done') Then
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
