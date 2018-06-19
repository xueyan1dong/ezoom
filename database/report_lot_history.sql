/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : start_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for ending a lot at a step
*    Log                    :
*    6/5/2018: xdong: adding handling to new step type -- disassemble
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `report_lot_history`$
CREATE PROCEDURE `report_lot_history`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  
 CREATE TEMPORARY TABLE IF NOT EXISTS lot_history_report
 (
    start_time datetime,
    end_time datetime,
    process_id int(10) unsigned,
    process_name varchar(255),
    sub_process_id int(10) unsigned,
    sub_process_name varchar(255),
    position_id int(5) unsigned,
    sub_position_id int(5) unsigned,
    step_id int(10) unsigned,
    step_name varchar(255),
    step_type varchar(20),
    start_operator_id int(10) unsigned,
    start_operator_name varchar(60),
    end_operator_id int(10) unsigned,
    end_operator_name varchar(60),
    status varchar(20),
    start_quantity decimal(16,4) unsigned,
    end_quantity decimal(16,4) unsigned,
    uomid smallint(3) unsigned,
    uom_name  varchar(20),
    location nvarchar(255),
    equipment_id int(10) unsigned,
    equipment_name varchar(255),
    device_id int(10) unsigned,
    approver_id int(10) unsigned,
    approver_name varchar(60),
    result text,
    comment text
 );
 
 INSERT INTO lot_history_report
 SELECT get_local_time(str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' )),
        get_local_time(str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' )),
        l.process_id,
        p.name,
        sub_process_id,
        null,
        position_id,
        sub_position_id,
        l.step_id,
        s.name,
        st.name,
        l.start_operator_id,
        concat(e.firstname, ' ', e.lastname),
        l.end_operator_id,
        concat(e2.firstname, ' ', e2.lastname),
        l.status,
        l.start_quantity,
        l.end_quantity,
        l.uomid,
        u.name,
        l.location,
        l.equipment_id,
        null,
        l.device_id,
        l.approver_id,
        null,
        CASE 
          WHEN st.name='condition' AND l.result='true' THEN 'Pass'
          WHEN st.name='condition' AND l.result='false' THEN 'Fail'
          ELSE l.result
        END,
        l.comment
  FROM lot_history l
  LEFT JOIN process p ON p.id = l.process_id
  LEFT JOIN step s ON  s.id = l.step_id 
  LEFT JOIN step_type st ON st.id=s.step_type_id
  LEFT JOIN employee e ON e.id = l.start_operator_id
  LEFT JOIN employee e2 ON e2.id = l.end_operator_id
  LEFT JOIN uom u ON u.id = l.uomid
 WHERE l.lot_id <=> _lot_id
 ORDER BY start_timecode
;

 UPDATE lot_history_report
   SET result=CONCAT('Reposition to --> position ',
   substring_index(right(result,length(result)-length(substring_index(result, ',', 1))-1),',',1),
   ', Step ',
   (SELECT NAME FROM step WHERE id=substring_index(result, ',', -1)))
  WHERE step_type='reposition';
  
 UPDATE lot_history_report l, process p
    SET l.sub_process_name = p.name
  WHERE l.sub_process_id IS NOT NULL
    AND p.id = l.sub_process_id
 ;
 
 UPDATE lot_history_report l, equipment eq
    SET l.equipment_name = eq.name
  WHERE l.equipment_id IS NOT NULL
    AND eq.id = l.equipment_id
 ;
 
 UPDATE lot_history_report l, employee e
    SET l.approver_name = concat(e.firstname, ' ', e.lastname)
  WHERE l.approver_id IS NOT NULL
    AND e.id = l.approver_id
 ;
 
 SELECT 
    start_time,
    end_time,
    process_id,
    process_name,
    sub_process_id,
    sub_process_name,
    position_id,
    sub_position_id,
    step_id,
    step_name,
    start_operator_id,
    start_operator_name,
    end_operator_id,
    end_operator_name,
    status,
    start_quantity,
    end_quantity,
    uomid,
    uom_name,
    -- location,
    equipment_id,
    equipment_name,
    device_id,
    approver_id,
    approver_name,
    result,
    comment
  FROM lot_history_report;
  DROP TABLE lot_history_report;
 END$