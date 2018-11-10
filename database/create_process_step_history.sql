/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table records snapshots of process_step, so that to track changes made to processes
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info.
*    11/09/2018: xdong: added new column product_made to mark whether a final step produces the product desired	 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `process_step_history`$
CREATE TABLE `process_step_history` (
  `event_time` datetime NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,  
  `action` enum('insert','modify','delete') NOT NULL,
  `employee_id` int(10) unsigned NOT NULL, 
  `prev_step_pos` int(5) unsigned DEFAULT NULL,
  `next_step_pos` int(5) unsigned DEFAULT NULL,
  `false_step_pos` int(5) unsigned DEFAULT NULL,
  `segment_id` int(5) unsigned DEFAULT NULL,
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0',  
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prompt` varchar(255) DEFAULT NULL,  
  `if_autostart` tinyint(1) unsigned NOT NULL default '1',
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL,
  `approve_emp_id` int(10) unsigned DEFAULT NULL,  
  `product_made` tinyint(1) unsigned NOT NULL DEFAULT 0,  -- it will only be 1 if completion of the step produce the final product ordered
  PRIMARY KEY (`event_time`, process_id, position_id)
) ENGINE=InnoDB$