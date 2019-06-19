/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : dispatch_order.sql
*    Created By             : Xueyan Dong
*    Date Created           : 06/04/2019
*    Platform Dependencies  : MySql
*    Description            : Diapatch the selected line items of an order. It dispatch selected lines of the order. The process used will be the
*                             default process of the product or highest proioritized process of the product. Each line will be dispatched to 1 batch,
                              unless the quantity requested is larger than max batch size, then dispatch overflow quantities to more batch.
*    example	            : 
SET @_response = NULL;
CALL dispatch_order( 7, '5', 'WWMTONEW_', null, 2, 4, 'test', 2, @_response);
select @_response;
*    Log                    :
*    06/04/2019: Xueyan Dong: Created
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `dispatch_order`$
CREATE PROCEDURE `dispatch_order`(
  IN _order_id int(10) unsigned, -- the id of the order it dispatch from
  IN _line_numbers varchar(20000), -- the line numbers in the given order, to be dispatched, separated by commas
  IN _alias_prefix varchar(23), -- prefix to use in producing the batch alias (batch name). Application will use the order PO as default prefix
  IN _location_id int(11) unsigned,  -- id of location to dispatch to. Application will use the default location of the login user. Can be null.
  IN _lot_contact int(10) unsigned, -- employee id of the contact person for the batch. 
  IN _lot_priority tinyint(2) unsigned, -- priority of the batch. Applicatio will use the priority of the order as default. User can change.
  IN _comment text,  -- any comment on the batch
  IN _dispatcher int(10) unsigned, -- person dispatched the batch, e.g. the login user
  OUT _response varchar(255)  -- any error or message from this stored procedure
)
BEGIN

  DECLARE _the_line_number VARCHAR(25);
  DECLARE _ppos SMALLINT(5);
  DECLARE _pstring VARCHAR(20000);
  DECLARE _if_non_num smallint(5);
  
  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(30);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
  DECLARE _new_id int(10) unsigned;
  DECLARE _total_quantity decimal(16,4) unsigned;

 
  SET autocommit=0;

  
  IF _order_id IS NULL  -- ensure order id is provided
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id) -- ensure it is an valid order
  THEN
    SET _response = "The order you selected doesn't exist in database.";    
  ELSEIF _line_numbers IS NULL or LENGTH(TRIM(_line_numbers)) < 1 -- ensure line number is provided
  THEN
    SET _response = 'No line item selected for dispatch. Please fill in line numbers separated by comma for dispatching.';
  ELSEIF _dispatcher IS NULL  -- ensure dispatch person information is provided
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher AND STATUS = 'active')  -- ensure dispatcher is an active employee
  THEN
    SET _response = "Dispatcher is not active or not set up in the system.";
  ELSE  -- process the dispatch
  
  -- parse _line_numbers to get the lines to be dispatched
    CREATE TEMPORARY TABLE IF NOT EXISTS lineitems 
    (line_number smallint(5),
     source_type enum('product', 'material'), -- line item can be product or material, but only product is dispatchable
     source_id int(10),   -- correspond to the product id or material id of the line
     quantity_to_dispatch decimal(16,4),  -- it is the quantity requested - quantity in process, quantity made and quantity shipped
     order_uom_id smallint(3),  -- uom id of the order line
     process_uom_id smallint(3),  -- uom id used in the product definition and  process workflow
     process_id int,  -- workflow id used to produce the product
     lot_alias varchar(30),  -- batch number assigned to the line
     if_alias_good tinyint(1),  -- whether the batch number assigned is good for dispatch
     uom_ratio decimal(16,4)  -- 
    ); 
  
    SET _pstring = TRIM(_line_numbers);
    SET _ppos = INSTR(_pstring, ',');
    IF _ppos = 0 -- there is a single line number in the _line_numbers
    THEN
      SET _ppos = LENGTH(_pstring)+1;
    END IF;
    SET _the_line_number = '';
    OLOOP:  WHILE _ppos> 0
      DO
        SET _the_line_number = TRIM(SUBSTRING(_pstring, 1, _ppos-1));
        IF _ppos < LENGTH(_pstring)
        THEN 
          SET _pstring = SUBSTRING(_pstring, _ppos+1);
          SET _ppos = INSTR(_pstring, ',');
          IF _ppos=0  -- _pstring now contains the last line number
          THEN
            SET _ppos=LENGTH(_pstring)+1;
          END IF;
        ELSE
          SET _ppos = 0;
        END IF;
        SET _if_non_num = _the_line_number NOT REGEXP '^[0-9]';
        
        IF LENGTH(TRIM(_the_line_number)) > 0 AND _if_non_num = 0
        THEN
          INSERT INTO lineitems (line_number)
          VALUES (_the_line_number);
        ELSE
          SET _response = 'There are non-numeric characters in line numbers input. Please remove them';
          LEAVE OLOOP;
        END IF;
      END WHILE;  
    -- if line numbers parsed without issue
    IF _response IS NULL OR length(_response) = 0
    THEN
    
      -- pull in product id and quantity to be dispatched
      UPDATE lineitems i
      INNER JOIN order_detail d
        ON d.order_id = _order_id
           AND d.line_num = i.line_number
       SET i.source_type = d.source_type,
           i.source_id = d.source_id,
           i.quantity_to_dispatch = IFNULL(d.quantity_requested,0) 
                                        - IFNULL(quantity_made,0) 
                                        - IFNULL(quantity_in_process,0)
                                        - IFNULL(quantity_shipped,0),
           i.order_uom_id = d.uomid;
      
       SET _the_line_number = NULL;
       SELECT line_number INTO _the_line_number
         FROM lineitems
        WHERE source_type = 'material'
           OR quantity_to_dispatch = 0;
           
      IF _the_line_number IS NOT NULL
      THEN
        SET _response = CONCAT('Line ', _the_line_number, ' has either already been dispatched or is a material that do not need process.');
      ELSE  -- start dispatch these lines
        -- collect default process for these line
        UPDATE lineitems i
        INNER JOIN product p
           ON p.id = i.source_id
              AND p.state = 'production'
        INNER JOIN product_process pp
          ON  pp.product_id = p.id
              AND PP.if_default = 1
         SET i.process_id = pp.process_id,
             i.process_uom_id = p.uomid;
        
         -- see if there is any line that do not have a default process defined
         SELECT line_number INTO _the_line_number
           FROM lineitems 
          WHERE process_id IS NULL;
          
        IF _the_line_number IS NOT NULL
        THEN
          SET _response = CONCAT('Product at line ', _the_line_number, ' does not have a default process defined. Please define its default process first.');
        ELSE  -- process good
          -- check for uom conversions, in case process uom is different than order uom
          UPDATE lineitems
             SET uom_ratio = 1
           WHERE order_uom_id = process_uom_id;
          
          -- use the constant to convert from product unit to ordered unit 
          UPDATE lineitems i
            JOIN uom_conversion c
              ON c.from_id = i.process_uom_id
                 AND c.to_id = i.order_uom_id
                 AND c.method = 'ratio'
             SET i.uom_ratio = c.constant
           WHERE i.uom_ratio IS NULL;
           
           -- if no conversion factor defined for from product unit to ordered unit, use reverse factor and reverse it
           UPDATE lineitems i
            JOIN uom_conversion c
              ON c.to_id = i.process_uom_id
                 AND c.from_id = i.order_uom_id
                 AND c.method = 'ratio'
                 AND c.constant != 0
             SET i.uom_ratio = 1.0000/c.constant
           WHERE i.uom_ratio IS NULL;
           
           SELECT line_number INTO _the_line_number
             FROM lineitems
            WHERE uom_ratio IS NULL OR uom_ratio = 0;
          
          -- the uom in order line do not match uom defined for product and process and no conversion ratio defined between the two uoms
          IF _the_line_number IS NOT NULL  
          THEN
            SET _response = '';
 --            SET _response = CONCAT('Can''t find the conversion ratio in system to convert the unit of measure at line ', 
--             _the_line_number, ' to the unit of measure used by the process. Please configure the conversion ratio in system first.');
          ELSE  -- so far so good. start assigning lot_alias
          -- assign each line a batch number. Batch number is in the format of <prefix>_<line number paded on the left to 3 digits><0000 or rolling up for uniqueness>
            UPDATE lineitems
               SET lot_alias = CONCAT(_alias_prefix, LPAD(line_number, 3, '0'), '0000'),
                   if_alias_good = 1;
            
            -- ensure lot alias is unique
            SET _ppos=0;

            
            START TRANSACTION;        
            WLOOP: WHILE _ppos<1000 DO 

              SET _ppos = _ppos+1;
              SET _the_line_number = NULL;
              
              UPDATE lineitems i
              INNER JOIN lot_status ls
                 ON ls.alias = i.lot_alias
                SET i.if_alias_good = 0;
                
              SELECT i.line_number
                INTO _the_line_number
                FROM lineitems i
               WHERE i.if_alias_good=0;
               
              IF _the_line_number IS NOT NULL
              THEN
                UPDATE line_items
                SET lot_alias = CONCAT(_alias_prefix, LPAD(line_number, 3, '0'), LPAD(_ppos, 4, '0')),
                   if_alias_good = 1
                WHERE i.if_alias_good = 0;   
              ELSE 
                LEAVE WLOOP;
              END IF;
            END WHILE;
            
            IF _the_line_number IS NOT NULL  -- there are lines can not find a good alias name
            THEN
              ROLLBACK;
        --      SET _response = CONCAT('For line ', _the_line_number, ', it is impossible to generate a unique batch number with current algorithm. Please use dispatch form to dispatch this line individually.');
            ELSE  -- everything is good, just short of the east wind: inserting to lot_status table
            --  select * from lineitems;
              SET _dispatch_time = utc_timestamp();
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
              SELECT
                lot_alias,
                _order_id,
                line_number,
                source_id,
                process_id,
                'dispatched',
                quantity_to_dispatch/uom_ratio,
                quantity_to_dispatch/uom_ratio,
                process_uom_id,
                DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
                _lot_contact,
                _lot_priority,
                _dispatcher,
                _dispatch_time,
                _location_id,
                _comment,
                'in process'
                FROM lineitems;
                
                IF row_count() > 0 
                THEN
                
                    -- insert to lot_history and update order_detail table with quantities and final commit
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
                    SELECT l.id,
                           l.alias,
                           l.update_timecode,
                           l.update_timecode,
                           l.process_id,
                           0,
                           0,
                           l.dispatcher,
                           l.dispatcher,
                           l.status,
                           l.start_quantity,
                           l.actual_quantity,
                           l.uomid,
                           l.location_id,
                           l.comment,
                           l.order_line_num,
                           l.quantity_status
                      FROM lot_status l
                      JOIN lineitems i
                        ON i.lot_alias = l.alias
                     WHERE l.order_id = _order_id;
                        
                   UPDATE `order_detail` od
                     JOIN lineitems i 
                       ON i.line_number = od.line_num
                     SET quantity_in_process = ifnull(quantity_in_process, 0) +  i.quantity_to_dispatch
                   WHERE order_id=_order_id;
                  COMMIT;    
                ELSE
                   -- error out and roll back
                  ROLLBACK;
                  SET _response = 'Encountered issue when recording new batch into database. Please contact system administrator.';
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  DROP TABLE lineitems;
  SET autocommit=1;

END$
