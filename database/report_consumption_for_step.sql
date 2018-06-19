/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_consumption_for_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : output the consumption information for a given lot/batch and given step
                              This is used in Consume Material step or Disassemble step.
                              In Consume step, the final consumption is recorded in inventory_consumption table,
                              thus, this procedure retrieve the quantity_used from this table
                              In Disassemble step, this procedure actually output quantity_returned from consumption_return
                              table to the quantity_used column in output resultset, so that application can show it on UI
*    example	            : 
call report_consumption_for_step (21, 'WWMTOFauce0000000006', 3, 38, '201806190044480', @_response);
select @_response
*    Log                    :
*    6/18/2018: xdong: added logic to count inventory returned for disassemble step. 					
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `report_consumption_for_step`$
CREATE PROCEDURE `report_consumption_for_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
-- the procedure uses _start_timecode,  to locate the consumption record if possible
-- otherwise, it will use the 
  DECLARE _end_timecode char(15);
  DECLARE _step_type varchar(20);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "The batch has no workflow assigned.";
  ELSEIF _step_id IS NULL
  THEN
    SET _response = "The batch is not inside a step.";
  ELSE
  
	SELECT st.name
      INTO _step_type
      FROM step_type st
	  JOIN step s
        ON s.step_type_id = st.id
           AND s.id = _step_id;
           
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_consumption 
      (
        source_type varchar(20),
        ingredient_id int(10) unsigned,
        name varchar(255),
        `order` tinyint(3) unsigned,
        description text,
        required_quantity decimal(16,4),
        uom_id smallint(6) unsigned,
        uom_name varchar(20),
        mintime int(10) unsigned,
        maxtime int(10) unsigned,
        restriction varchar(255),
        comment text,
        used_quantity decimal(16,4)
      ) DEFAULT CHARSET=utf8;
    
    INSERT INTO temp_consumption
    SELECT v.source_type, 
           v.ingredient_id,
           v.name, 
           v.order,
           v.description, 
           v.quantity, 
           v.uom_id,
           v.uom_name, 
           v.mintime, 
           v.maxtime,
           CASE
             WHEN v.mintime>0 AND v.maxtime>0 
                 THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part, but no more than ", v.maxtime, " minutes.")
             WHEN v.mintime>0
              THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part.")
             WHEN v.maxtime>0
              THEN CONCAT("You have to add the part within ", v.maxtime, " minutes.")
             ELSE
               ''
           END,
           v.comment,
           null
      FROM step s JOIN view_ingredient v ON v.recipe_id = s.recipe_id
    WHERE s.id =_step_id;
    
    SELECT end_timecode
      INTO _end_timecode
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _start_timecode
       AND step_id = _step_id;
    

	IF _step_type = 'consume material'
    THEN
		UPDATE temp_consumption t LEFT JOIN 
		  (SELECT i.source_type,
				  i.pd_or_mt_id,
				  sum(c.quantity_used) as total_used
			 FROM inventory_consumption c INNER JOIN inventory i
			   ON i.id = c.inventory_id
			WHERE c.lot_id = _lot_id
			  AND c.start_timecode >= _start_timecode
			  AND (_end_timecode IS NULL OR c.end_timecode<=_end_timecode)
			  AND c.step_id = _step_id
			GROUP BY i.source_type, i.pd_or_mt_id) a
		   ON a.source_type = t.source_type
			  AND a.pd_or_mt_id = t.ingredient_id
		 SET t.used_quantity = a.total_used;
	ELSEIF _step_type = 'disassemble'
    THEN
		UPDATE temp_consumption t LEFT JOIN 
		  (SELECT i.source_type,
				  i.pd_or_mt_id,
				  sum(c.quantity_returned) as total_used
			 FROM consumption_return c INNER JOIN inventory i
			   ON i.id = c.inventory_id
			WHERE c.lot_id = _lot_id
			  AND c.consumption_start_timecode >= _start_timecode
			  AND c.step_id = _step_id
			GROUP BY i.source_type, i.pd_or_mt_id) a
		   ON a.source_type = t.source_type
			  AND a.pd_or_mt_id = t.ingredient_id
		 SET t.used_quantity = a.total_used;    
    END IF;
    
    SELECT 
        source_type,
        ingredient_id,
        name,
        `order`,
        description,
        required_quantity,
        ifnull(used_quantity,0) as used_quantity,      
        uom_id,
        uom_name,
        mintime,
        maxtime,
        restriction,
        comment
      FROM temp_consumption
      ORDER BY `order`
      ;
    DROP TABLE temp_consumption;
  END IF;
 
END$
