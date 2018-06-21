/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_consumption_return.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `consumption_return`$
CREATE TABLE `consumption_return` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `return_timecode` char(15) NOT NULL,
  `inventory_id` int(10) unsigned NOT NULL,
  `quantity_before` decimal(16,4) unsigned NOT NULL,
  `quantity_returned` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL, 
  `operator_id` int(10) unsigned NOT NULL,
  `step_start_timecode` char(15) NOT NULL,
  `consumption_start_timecode` char(15) NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (lot_id, return_timecode, inventory_id)
) ENGINE=InnoDB$