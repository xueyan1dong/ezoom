/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_lot_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : table to hold historical lot/batch information
*    Log                    :
*    6/5/2018: xdong: add a new column, location, to log batch/lot location
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `lot_history`$
CREATE TABLE `lot_history` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `start_operator_id` int(10) unsigned NOT NULL,
  `end_operator_id` int(10) unsigned DEFAULT NULL,
  `status` enum('dispatched', 'started', 'restarted','ended','error','stopped','scrapped','shipped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `end_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned DEFAULT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `approver_id` int(10) unsigned DEFAULT NULL,
  `result` text,
  `comment` text,
  `location` nvarchar(255) DEFAULT NULL,  
  PRIMARY KEY `lh_un1` (`lot_id`,`start_timecode`, process_id, step_id)
) ENGINE=InnoDB$