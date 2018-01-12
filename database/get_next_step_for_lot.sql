DROP PROCEDURE IF EXISTS `get_next_step_for_lot`;
CREATE PROCEDURE `get_next_step_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  IN _process_id int(10) unsigned,
  IN _sub_process_id_p int(10) unsigned,
  IN _position_id_p int(5) unsigned,
  IN _sub_position_id_p int(5) unsigned,
  IN _step_id_p int(10) unsigned,
  IN _result varchar(255),
  OUT _sub_process_id_n int(10) unsigned,
  OUT _position_id_n int(5) unsigned,
  OUT _sub_position_id_n int(5) unsigned,
  OUT _step_id_n int(10) unsigned,
  OUT _step_type varchar(20),
  OUT _rework_limit smallint(2) unsigned,
  OUT _if_autostart tinyint(1) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _step_type_p varchar(20);
  DECLARE _sub_process_id_str VARCHAR(10);
  DECLARE _sub_position_id_str VARCHAR(10);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSE
 
    
          
    IF _lot_status IN ('dispatched', 'in transit')
    THEN      
      
      SELECT st.name
        INTO _step_type_p
        FROM step s, step_type st
       WHERE s.id=_step_id_p
         AND st.id=s.step_type_id;
      
 
      CASE
      WHEN _step_type_p='reposition' THEN
        -- _result has all next step information in the format: sub_process_id_n,position_id_n,sub_position_id_n,step_id_n
        SET _sub_process_id_str=substring_index(_result,',',1);
        SET _sub_process_id_n=if(length(_sub_process_id_str)>0, _sub_process_id_str, null);

        SET _step_id_n=substring_index(_result,',',-1);     
        SET _position_id_n=substring_index(right(_result,length(_result)-length(_sub_process_id_str)-1),',',1);
        
        SET _sub_position_id_str=substring_index(left(_result, length(_result)-length(_step_id_n)-1),',',-1);
        SET _sub_position_id_n=if(length(_sub_position_id_str)>0, _sub_position_id_str, null);
        
        IF _sub_process_id_n IS NOT NULL AND _sub_position_id_n IS NOT NULL
        THEN
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _sub_process_id_n
            AND position_id = _sub_position_id_n
            AND step_id=_step_id_n;    
        ELSE
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n
            AND step_id=_step_id_n; 
        END IF;
      ELSE
        SET _result =substring(ifnull(_result, 'T'), 1, 1);
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
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _if_sub_process, _rework_limit,_if_autostart
              FROM process_step
            WHERE process_id = _process_id
              AND position_id = _position_id_n;
                
            IF _if_sub_process = 1 THEN  
              -- next step is a process, collect information
              
              SET _sub_process_id_n = _step_id_n;
              
              SELECT step_id,
                    position_id,
                    rework_limit,
                    if_autostart
                INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
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
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _rework_limit, _if_autostart
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
                rework_limit,
                if_autostart
            INTO _step_id_n, _if_sub_process, _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n; 
              
          IF _if_sub_process = 1 THEN  
          -- next step is a process, collect information
            
            SET _sub_process_id_n = _step_id_n;
            
            SELECT step_id,
                  position_id,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
              FROM process_step
            WHERE process_id = _sub_process_id_n
              AND position_id = (SELECT min(position_id)
                                  FROM process_step
                                  WHERE process_id = _sub_process_id_n
                                )
            ;
              
          END IF;           
        END IF;
      END CASE;
          
     SELECT st.name INTO _step_type
     FROM step s, step_type st
     WHERE st.id = s.step_type_id
       AND s.id = _step_id_n;
         

    END IF;  

          
  END IF;

 END;