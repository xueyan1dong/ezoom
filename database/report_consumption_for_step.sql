DROP PROCEDURE IF EXISTS `report_consumption_for_step`;
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
           V.ingredient_id,
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
 
END;
