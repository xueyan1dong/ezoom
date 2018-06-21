/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_consumption_details.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_consumption_details`$
CREATE PROCEDURE `report_consumption_details`(
  IN _lot_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _source_type enum('product', 'material'),
  IN _source_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
-- If _step_start_timecode is supplied, the resultset only shows
-- the consumption for the step that started at the _step_start_timecode
-- otherwise, it shows the consumption of the whole workflow/process.

-- If _source_type is supplied, the resultset only shows the consumption of the specified source type,
-- otherwise, it shows consumption of all source type.

-- If _source_id is supplied, the resultset only shows the consumption of the particular source/ingredient,
-- otherwise, it will show the consumption of all sources.

-- _lot_id is required. The other three parameters can be used in combinations or all null.

  DECLARE _end_timecode char(15);

  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSE
     SELECT l.lot_id,
            l.lot_alias,
            str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' ) as step_start,
            str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' ) as step_end,
            l.process_id,
            l.sub_process_id,
            l.position_id,
            l.sub_position_id,
            l.step_id,
            s.name as step_name,
            str_to_date(ic.start_timecode, '%Y%m%d%H%i%s0' ) as consumption_start,
            str_to_date(ic.end_timecode, '%Y%m%d%H%i%s0' ) as consumption_end,
            ic.inventory_id,
            CASE WHEN i.source_type = 'product' THEN p.name ELSE m.name END AS part_name,
            i.lot_id as inv_lot_id,
            i.serial_no as inv_serial_no,
            ic.quantity_used,
            ic.uom_id,
            u.name as uom_name,
            ic.operator_id,
            CONCAT(e.firstname, ' ', e.lastname) AS operator,
            ic.comment
       FROM lot_history l
       INNER JOIN step s ON s.id = l.step_id 
       INNER JOIN step_type st ON st.id = s.step_type_id AND st.name = 'consume material'
       INNER JOIN inventory_consumption ic 
             ON ic.start_timecode >=l.start_timecode 
             AND (l.end_timecode IS NULL or ic.end_timecode <= l.end_timecode)
       INNER JOIN inventory i 
             ON i.id = ic.inventory_id 
             AND (_source_type IS NULL OR i.source_type = _source_type)
             AND (_source_id IS NULL OR i.pd_or_mt_id = _source_id)
       INNER JOIN uom u ON u.id = ic.uom_id
       LEFT JOIN employee e ON e.id = ic.operator_id
       LEFT JOIN product p ON i.source_type = 'product' AND p.id = i.pd_or_mt_id
       LEFT JOIN material m ON i.source_type = 'material' AND m.id = i.pd_or_mt_id
      WHERE l.lot_id =_lot_id 
        AND (_step_start_timecode IS NULL OR l.start_timecode = _step_start_timecode)
        ;

   END IF;
END$
