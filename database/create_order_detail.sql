/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_detail.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `order_detail`$
CREATE TABLE `order_detail` (
  `order_id` int(10) unsigned NOT NULL,
  `source_type` enum('product', 'material') NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `unit_price` decimal(10,2) unsigned DEFAULT NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `uomid` smallint(3) unsigned NOT NULL,
  `output_date` datetime DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `actual_deliver_date` datetime DEFAULT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `source_type`, `source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$