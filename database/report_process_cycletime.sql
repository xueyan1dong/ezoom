DROP PROCEDURE IF EXISTS `report_process_cycletime`;
CREATE PROCEDURE `report_process_cycletime`(
  IN _process_id int(10) unsigned,
  IN _product_id int(10) unsigned
)
BEGIN


    
  IF _process_id IS NOT NULL AND _product_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_cycletime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      step_id int(10) unsigned,
      step varchar(255),
      step_type varchar(20),
      description varchar(255),
      min_time int(10) unsigned,
      max_time int(10) unsigned,
      average_time int(10) unsigned,
      average_yield tinyint(2) unsigned,
      prev_step_pos varchar(5),
      next_step_pos varchar(5),
      false_step_pos varchar(5),
      rework_limit smallint(2) unsigned 
    );

    -- collect step information for steps/non-subprocess in the flow
    INSERT INTO process_cycletime
    SELECT p.position_id,
          null,
          p.step_id,
          s.name,
          t.name,
          if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
          s.mintime,
          s.maxtime,
          null,
          null,
          p.prev_step_pos,
          p.next_step_pos,
          p.false_step_pos,
          p.rework_limit
      FROM process_step p, step s, step_type t
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      ;
    
    -- collect step information for steps in sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_cycletime
    SELECT  p.position_id,
            concat('s', p1.position_id),
            p1.step_id,
            s.name,
            t.name,
            if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
            s.mintime,
            s.maxtime,
            null,
            null,
            concat('s',p1.prev_step_pos),
            concat('s',p1.next_step_pos),
            concat('s',p1.false_step_pos),
            p1.rework_limit

      FROM process_step p, process_step p1, step s, step_type t
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      ;
      CREATE TEMPORARY TABLE IF NOT EXISTS process_actualtime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      through_count int(5) unsigned,
      total_time int(10) unsigned,
      average_yield tinyint(2) unsigned
    );    
    
    INSERT INTO process_actualtime
    SELECT position_id,
           sub_position_id,
           sum(if(h.status in ('error', 'stopped'), 0, 1)),
           sum(timestampdiff(minute, str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' ), str_to_date(h.end_timecode, '%Y%m%d%H%i%s0') )),
           avg(100 * h.end_quantity/h.start_quantity)
      FROM lot_status l, lot_history h 
     WHERE l.product_id = _product_id
       AND l.process_id = _process_id
       AND h.lot_id = l.id
       AND h.status not in ('dispatched', 'started', 'restarted')
       AND h.start_quantity != 0
     GROUP BY position_id, sub_position_id;
    
    UPDATE process_cycletime pc, process_actualtime pa
       SET pc.average_time =  pa.total_time/pa.through_count
          ,pc.average_yield = pa.average_yield
     WHERE pc.position_id = pa.position_id
       AND pc.sub_position_id <=> pc.sub_position_id;
       
    SELECT position_id,
           sub_position_id,
           step_id,
           step,
           step_type,
           description,
           min_time,
           max_time,
           average_time,
           average_yield,
           prev_step_pos,
           next_step_pos,
           false_step_pos,
           rework_limit
      FROM process_cycletime
   ORDER BY position_id, sub_position_id
  ;

    DROP TABLE process_cycletime;
    DROP TABLE process_actualtime;
  END IF;

  

END;
