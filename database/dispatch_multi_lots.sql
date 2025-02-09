/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : dispatch_multi_lots.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Diapatch a lot/batch from a order detail line. The dispatch routine will dispatch 1-n batches depending on _num_lots input
*                             and each batch contains 1-n unit of final products depending on _lot_size
*    example	            : 
SET @_response = NULL;
CALL dispatch_multi_lots( 7, 2, 5, 5, 2, 1, '08-34170-12274', 1, 2, 4, null, 2, @_response);
select @_response;
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 				
*   11/11/2018: xdong: added input _line_num now that order_detail can have multi lines of the same product	
*   12/01/2018: xdong: fixed a bug that updated the quantity_in_process of all order detail lines of the same product, by missed line_num in where clause
*   02/05/2019: xdong: widen _alias_prefix parameter from varchar(10) to varchar(20), following widen alias column in lot_status table
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `dispatch_multi_lots`$
CREATE PROCEDURE `dispatch_multi_lots`(
  IN _order_id int(10) unsigned, -- the id of the order it dispatch from
  IN _line_num smallint(5) unsigned, -- the line number in the order detail to dispatch from
  IN _product_id int(10) unsigned, -- the product id to produce with the batch
  IN _process_id int(10) unsigned, -- the id of the process that the batch will assume
  IN _lot_size decimal(16,4) unsigned, -- the size of the final product in the batch
  IN _num_lots int(10) unsigned, -- number of batch to dispatch in this call
  IN _alias_prefix varchar(20), -- prefix to use in producing the batch alias (batch name)
  IN _location_id int(11) unsigned,  -- id of location to dispatch to
  IN _lot_contact int(10) unsigned, -- employee id of the contact person for the batch
  IN _lot_priority tinyint(2) unsigned, -- priority of the batch
  IN _comment text,  -- any comment on the batch
  IN _dispatcher int(10) unsigned, -- person dispatched the batch
  OUT _response varchar(255)  -- any error or message from this stored procedure
)
BEGIN

  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(30);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
  DECLARE _new_id int(10) unsigned;
  DECLARE _total_quantity decimal(16,4) unsigned;
 
  SET autocommit=0;

  
  IF _order_id IS NULL
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id)
  THEN
    SET _response = "The order you selected doesn't exist in database.";    
    ELSEIF NOT EXISTS (SELECT * FROM order_detail WHERE order_id=_order_id AND line_num = _line_num )
  THEN
    SET _response = "The order line you selected doesn't exist in database.";    
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'Process is required. Please select a process to dispatch lots to';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
  THEN
    SET _response = "The process you selected doesn't exist in database.";
  ELSEIF _num_lots IS NULL or _num_lots < 1
  THEN
    SET _response = 'Number of lots to dispatch is incorrect. Please dispatch at least one lot.';
  ELSEIF _dispatcher IS NULL
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher)
  THEN
    SET _response = "Dispatcher information doesn't exist in our database.";
  ELSEIF _product_id IS NULL
  THEN
      SET _response = 'The order you selected does not exist in database.';
  ELSEIF NOT EXISTS
  (   SELECT *
        FROM product_process
      WHERE process_id = _process_id
        AND product_id = _product_id
   )  
  THEN
        SET _response = 'The process you selected can not be used to manufacture the ordered product.';
  ELSE
    IF _lot_size IS NULL
    THEN
      SELECT lot_size into _lot_size
        FROM product
       WHERE id = _product_id;
    ELSEIF _lot_size > (SELECT lot_size FROM product WHERE id = _product_id)
    THEN
      SET _response ="The lot size you selected is bigger than the maximum lot size limit for the product. Please adjust your lot size.";
    END IF;
        
    IF _lot_priority IS NULL
    THEN
      SELECT priority INTO _lot_priority
        FROM `order`
       WHERE id = _order_id;
    END IF;
        
    IF _lot_size IS NULL
    THEN
      SET _response = 'Lot size information can not be found. Please enter the size for a single lot.';
    ELSE
--       SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
--                             between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
--                             and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
--                         substring(addtime(timezone, '01:00'), 1, 6),
--                         timezone)  
--               FROM company c, employee e
--               WHERE e.id = _dispatcher AND c.id = e.company_id);       
      
      SET _dispatch_time = utc_timestamp();
      
      SET _alias_suffix = 0;
      SET _total_quantity = 0;
      
      IF _alias_prefix IS NULL
      THEN
        SET _alias_prefix = '';
      END IF;
      
      SELECT uomid INTO _uom_id
        FROM product
      WHERE id = _product_id;    
      
       SET _ratio = null;
      IF EXISTS (SELECT * 
                FROM order_detail
                WHERE order_id = _order_id
                  AND line_num = _line_num
                  AND source_type = 'product'
                  AND source_id = _product_id
                  AND uomid = _uom_id
              )
      THEN
        SET _ratio = 1;
      ELSE
        SELECT constant INTO _ratio
          FROM uom_conversion u 
          JOIN order_detail o ON o.order_id = _order_id 
                                AND o.line_num = _line_num
                                AND o.source_type = 'product' 
                                AND o.source_id = _product_id
        WHERE from_id = _uom_id
          AND to_id = o.uomid
          AND method = 'ratio';
        
        IF _ratio IS NULL
        THEN
          SELECT constant INTO _ratio
            FROM uom_conversion u 
            JOIN order_detail o ON o.order_id = _order_id 
                                  AND o.line_num = _line_num
                                  AND o.source_type = 'product' 
                                  AND o.source_id = _product_id
                                  AND o.line_num = _line_num
          WHERE to_id = _uom_id
            AND from_id = o.uomid
            AND method = 'ratio';  
        
          IF _ratio IS NULL OR _ratio = 0
          THEN
            SET _response = "There is no valid conversion between the unit of measure used in traveler and the unit of measure used in order. Please add conversion between the two UoMs.";
          ELSE
            SET _ratio = 1.00/_ratio;
          END IF;
        END IF;
      END IF;      
      IF _ratio IS NOT NULL AND NOT EXISTS (SELECT * FROM order_detail o
                    WHERE o.order_id = _order_id
                      AND o.line_num = _line_num
                      AND o.source_type = 'product'
                      AND o.source_id = _product_id
                      AND o.quantity_requested >= (quantity_in_process + _lot_size*_ratio*_num_lots+quantity_made+quantity_shipped))
      THEN
        SET _response = "You are dispatching more product than requested. Please adjust lot size.";
      END IF;
      
      CREATE TEMPORARY TABLE IF NOT EXISTS multilots (lot_id int(10) unsigned, lot_alias varchar(30));
      
      START TRANSACTION;
      WLOOP: WHILE _num_lots >0 DO
        SET _num_lots = _num_lots - 1;
        
        -- IF _alias_suffix = 3 THEN
        IF _alias_suffix = 4294967295 THEN
          ROLLBACK;
          SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
          LEAVE WLOOP;
          
        END IF;
        
        SET _alias_suffix = _alias_suffix + 1;
        SET _alias = CONCAT(trim(_alias_prefix), _alias_suffix);
        
        ALOOP: WHILE EXISTS (SELECT * FROM lot_status WHERE alias=_alias)
        DO
           -- IF _alias_suffix = 3 THEN 
          IF _alias_suffix = 4294967295 THEN
          
            ROLLBACK;
            SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
            LEAVE ALOOP;
          END IF;
        
          SET _alias_suffix = _alias_suffix + 1;
          SET _alias = CONCAT(_alias_prefix, _alias_suffix);    
          
        END WHILE;
        
        IF _response IS NULL OR length(_response) = 0
        THEN
          INSERT INTO lot_status(
            alias,
            order_id,
            order_line_num,
            product_id,
            process_id,
            status,
            start_quantity,
            actual_quantity,
            uomid,
            update_timecode,
            contact,
            priority,
            dispatcher,
            dispatch_time,
			location_id,
            comment,
            quantity_status
            )
            VALUES
            (
              _alias,
              _order_id,
              _line_num,
              _product_id,
              _process_id,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _lot_contact,
              _lot_priority,
              _dispatcher,
              _dispatch_time,
			  _location_id,
              _comment ,
              'in process'
            );
          SET _new_id = last_insert_id();
            
          IF _new_id IS NOT NULL
          THEN
            INSERT INTO lot_history (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
			  location_id,
              comment,
              order_line_num,
              quantity_status
              )
            VALUES (
              _new_id,
              _alias,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _process_id,
              0,
              0,
              _dispatcher,
              _dispatcher,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
			  _location_id,
              _comment,
              _line_num,
              'in process'
              );
  
            INSERT INTO multilots (lot_id, lot_alias)
            VALUES (_new_id, _alias);
            
            SET _total_quantity = _total_quantity + _lot_size;
          ELSE
            ROLLBACK;
            SET _response = "Error countered when dispatching lot.";
            LEAVE WLOOP;
          END IF;
        ELSE
          LEAVE WLOOP;
        END IF;
 
        
        
      END WHILE;
      
      IF _response IS NULL OR length(_response) = 0
      THEN
        UPDATE `order_detail`
           SET quantity_in_process = ifnull(quantity_in_process, 0) +  _total_quantity*_ratio
         WHERE order_id=_order_id
           AND line_num = _line_num;
        COMMIT;
      
      END IF;
      
      SELECT lot_id, lot_alias
        FROM multilots;
        
      DROP TABLE multilots;
      
    END IF;
   
   
  END IF;


END$
