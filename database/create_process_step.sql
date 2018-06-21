/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `process_step`$
CREATE TABLE `process_step` (
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
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
  PRIMARY KEY (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB$