/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_lot_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : table to hold historical lot/batch information
*    Log                    :
*    6/5/2018: xdong: add a new column, location, to log batch/lot location
*    7/16/2018 peiyu: modified column `location` nvarchar to `location_id` int(11)
*    11/09/2018: xdong: added a column, quantity_status to indicate whether the lot/batch's quantity goes to quantity_in_process
*                       or quantity_made or quantity_shipped in the corresponding line in order general
*                       added a column, order_line_num to hold the line_num that the batch is dispatched from in order_detail table
*                       added enum value 'done' to status column to mark a lot has done the last step, if not shipped or scrapped, 
*                       e.g. a final status for a batch can be: shipped or scrapped or done.
*    01/29/2019: xdong: added three columns for logging extra informtion collected from current transaction
*    02/05/2019: xdong: widen lot_alias column from varchar(20) to varchar(30)
*/
DELIMITER $  
DROP TABLE IF EXISTS `lot_history`$
CREATE TABLE `lot_history` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(30) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `start_operator_id` int(10) unsigned NOT NULL,
  `end_operator_id` int(10) unsigned DEFAULT NULL,
  `status` enum('dispatched', 'started', 'restarted','ended','error','stopped','scrapped','shipped', 'done') NOT NULL,
  `start_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `end_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned DEFAULT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `approver_id` int(10) unsigned DEFAULT NULL,
  `result` text,
  `comment` text,
  `location_id` int(11) unsigned DEFAULT NULL,  
  `order_line_num` smallint(5) unsigned NOT NULL DEFAULT 1, -- line number in the order_detail, from which the batch is dispatched from
  `quantity_status` enum('in process', 'made', 'shipped') DEFAULT 'in process',  -- quantity accounting status: 
   -- in process: quantity is counted toward quantity_in_process in order_detail record
   -- made: quantity is counted toward quantity_made in order_detail record
   -- shipped: quantity is counted toward quantity_shipped in order_detail record
  `value1` varchar(255), -- reserved for storing extra info collected at each transaction. For "ship to location" step, this field store tracking number logged
  `value2` varchar(500), -- reserved for storing extra info collected at each transaction. For now, it is not used
  `value3` varchar(2000), -- reserved for storing extra info collected at each transaction. for now, it is not used
  PRIMARY KEY `lh_un1` (`lot_id`,`start_timecode`, process_id, step_id)
) ENGINE=InnoDB$