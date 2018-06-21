/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : view_process_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP VIEW IF EXISTS `view_process_step`$
CREATE ALGORITHM = MERGE VIEW `view_process_step` AS
    SELECT ps.process_id,
         ps.position_id,
         ps.step_id, 
         ps.prev_step_pos,
         ps.next_step_pos,
         ps.false_step_pos,
         ps.rework_limit,
         ps.if_sub_process,
         IF(ps.if_sub_process, 'Y', 'N') AS YN_sub_process,
         ps.prompt,
         ps.if_autostart,
         IF(ps.if_autostart, 'Y', 'N') AS YN_autostart,
         ps.need_approval,
         IF(ps.need_approval, 'Y', 'N') AS YN_need_approval,
         ps.approve_emp_usage,
         ps.approve_emp_id,
         IF (ps.approve_emp_usage = 'employee',
             (SELECT concat(e.firstname, ' ', e.lastname) FROM employee e WHERE e.id = ps.approve_emp_id),
             (SELECT eg.name FROM employee_group eg WHERE eg.id = ps.approve_emp_id)) AS approve_emp_name
     FROM process_step ps 
     $
