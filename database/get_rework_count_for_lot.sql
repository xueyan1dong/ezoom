/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `get_rework_count_for_lot`$
CREATE PROCEDURE `get_rework_count_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  OUT _rework_count smallint(2) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "Please select a process.";
  ELSEIF _position_id IS NULL
  THEN
    SET _response = "Please supply a position.";
  ELSE
 

    SELECT count(*) into _rework_count
      FROM lot_history
     WHERE lot_id = _lot_id
       AND process_id = _process_id
       AND sub_process_id <=> _sub_process_id
       AND step_id = _step_id
       AND status in ('ended', 'started', 'finished')
       AND position_id = _position_id
       AND sub_position_id <=>_sub_position_id
;
          
  END IF;

 END$