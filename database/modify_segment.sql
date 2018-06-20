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
DROP PROCEDURE IF EXISTS `modify_segment`$
CREATE PROCEDURE `modify_segment`(
  IN _process_id int(10) unsigned,
  INOUT _segment_id int(5) unsigned, 
  IN _name varchar(255),
  IN _position smallint(2),
  IN _description text,
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Segment name is required. Please give the segment a name.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response='Workflow is required. Please select a workflow for the segment.';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
  THEN
    SET _response="The workflow you chose doesn't exist in database.";
  ELSE
    IF _segment_id IS NULL
    THEN

      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another segment. Please change the segment name and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND `position`=_position)
      THEN
        SET _response = 'There is already another segment for the same position, please make the position available before adding new segment to it.';
      ELSE
        INSERT INTO process_segment (process_id, segment_id, name, `position`, description)
        SELECT _process_id,
               ifnull(MAX(segment_id),0)+1,
               _name,
               _position,
               _description
          FROM process_segment
         WHERE process_id = _process_id;

      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id!=_segment_id AND name=_name)
      THEN
        SET _response= concat('The segment name ', _name,' is already used by another segment. Please change it and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND segment_id!=_segment_id AND `position`=_position) 
      THEN
        SET _response=concat('The position ', _position, ' is already occupied by another segment. Please make it available before using the position.');
      ELSE
          
        UPDATE process_segment
          SET name = _name,
              `position`=_position,
              description = _description
        WHERE process_id=_process_id
          AND segment_id=_segment_id;
      END IF;
    END IF; 
  END IF;
END$

