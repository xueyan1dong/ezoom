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
DROP PROCEDURE IF EXISTS `select_lot_info_for_start_step`$
CREATE PROCEDURE `select_lot_info_for_start_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  IN _process_id int(10) unsigned,
  IN _sub_process_id_p int(10) unsigned,
  IN _position_id_p int(5) unsigned,
  IN _sub_position_id_p int(5) unsigned,
  IN _step_id_p int(10) unsigned,
  IN _eq_id_p int(10) unsigned,
  IN _result char(1)
)
BEGIN
  
  DECLARE  _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_n int(10) unsigned;
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _rework_count smallint(2) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _eq_usage enum('equipment group', 'equipment');
  DECLARE _eq_id int(10) unsigned;
  DECLARE _eq_name varchar(255);
  DECLARE _response varchar(255);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSE
 
    SET _result =substring(ifnull(_result, 'T'), 1, 1);
          
    IF _lot_status IN ('dispatched', 'in transit')
    THEN      
      IF _sub_process_id_p IS NOT NULL AND _response IS NULL THEN  
      -- the lot was in a sub process
        SELECT if(_result = "F" AND st.name='condition', ps.false_step_pos, ps.next_step_pos)
          INTO _sub_position_id_n           
          FROM process_step ps, step s, step_type st
        WHERE ps.process_id=_sub_process_id_p
          AND ps.position_id = _sub_position_id_p
          AND ps.step_id = s.id
          AND st.id = s.step_type_id;
  
        IF _sub_position_id_n IS NULL THEN  -- the lot just finished the sub process it was in
          
          SELECT if(_result="F" AND st.name='condition', ps0.false_step_pos,ps0.next_step_pos )
            INTO _position_id_n
            FROM process_step ps0, step s, step_type st
          WHERE ps0.process_id = _process_id
            AND ps0.position_id = _position_id_p
            AND ps0.step_id = s.id
            AND st.id = s.step_type_id;
              
          SELECT step_id,
                if_sub_process,
                rework_limit
            INTO _step_id_n, _if_sub_process, _rework_limit
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n;
              
          IF _if_sub_process = 1 THEN  
            -- next step is a process, collect information
            
            SET _sub_process_id_n = _step_id_n;
            
            SELECT step_id,
                   position_id,
                   rework_limit
              INTO _step_id_n, _sub_position_id_n, _rework_limit
              FROM process_step
            WHERE process_id = _sub_process_id_n
              AND position_id = (SELECT min(position_id) 
                                   FROM process_step 
                                  WHERE process_id = _sub_process_id_n);
              
          END IF;
        ELSE  -- next step is within the same sub process, collect information
          SET _position_id_n = position_id_p;
          SET _sub_process_id_n = _sub_process_id_p;
          
          SELECT step_id,
                 rework_limit
            INTO _step_id_n, _rework_limit
            FROM process_step
          WHERE process_id=_sub_process_id_n
            AND position_id = _sub_position_id_n;
        END IF;
          
      ELSE
        
        -- the lot was not in a sub process
        IF _position_id_p =0
        THEN
          SELECT min(position_id)
            INTO _position_id_n
            FROM process_step
          WHERE process_id=_process_id;
        ELSE    
          SELECT if(_result = "F" AND st.name = 'condition', ps.false_step_pos,ps.next_step_pos )
            INTO _position_id_n           
            FROM process_step ps, step s, step_type st
          WHERE ps.process_id=_process_id
            AND ps.position_id =_position_id_p
            AND ps.step_id = s.id
            AND st.id = s.step_type_id;   
        END IF;
        -- Select 'position'||ifnull(_position_id_p,_result) ;
        SELECT step_id,
              if_sub_process,
              rework_limit
          INTO _step_id_n, _if_sub_process, _rework_limit
          FROM process_step
        WHERE process_id = _process_id
          AND position_id = _position_id_n; 
            
        IF _if_sub_process = 1 THEN  
        -- next step is a process, collect information
          
          SET _sub_process_id_n = _step_id_n;
          
          SELECT step_id,
                 position_id,
                 rework_limit
            INTO _step_id_n, _sub_position_id_n, _rework_limit
            FROM process_step
          WHERE process_id = _sub_process_id_n
            AND position_id = (SELECT min(position_id)
                                 FROM process_step
                                WHERE process_id = _sub_process_id_n
                               )
          ;
            
        END IF;           
      END IF;
      SELECT count(*) into _rework_count
        FROM lot_history
       WHERE lot_id = _lot_id
         AND position_id = _position_id_n
         AND sub_position_id <=>_sub_position_id_n
         AND process_id = _process_id
         AND sub_process_id <=> _sub_process_id_n
         AND status in ('ended', 'started', 'finished');
          
        
      SELECT eq_usage, eq_id
        INTO _eq_usage,_eq_id
        FROM step
       WHERE id = _step_id_n;
      
      IF _eq_usage IS NOT NULL
      THEN
        IF _eq_usage = 'equipment group'
        THEN
          SELECT name INTO _eq_name
            FROM equipment_group
           WHERE id = _eq_id;
         
        ELSEIF _eq_usage = 'equipment'
        THEN
          SELECT name INTO _eq_name
            FROM equipment
           WHERE id=_eq_id;
        END IF;
      END IF;
    END IF;  
    SELECT  _sub_process_id_n AS "Next Sub Process ID",
           (SELECT name
              FROM process
             WHERE id <=> _sub_process_id_n) AS "Next Sub Process Name",
           _position_id_n AS "Next Position ID",
           _sub_position_id_n AS "Next Sub Position ID",
           _step_id_n AS "Next Step ID",
                s.name AS "Next Step Name",
                s.step_type_id,
                st.name as step_type,
           _eq_usage AS "Next Equipment Usage",
           _eq_id AS "Next Equipment ID",
           _eq_name AS "Next Equipment Name"
      FROM step s LEFT JOIN step_type st ON st.id = s.step_type_id
     WHERE s.id <=>_step_id_n
       ;
          
    END IF;

 END$