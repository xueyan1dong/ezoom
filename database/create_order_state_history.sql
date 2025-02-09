/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_state_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    02/16/2020: Shelby Simpson: Altered state_date column from datetime to date type.				
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `order_state_history`$
CREATE TABLE `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `state_date` date NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `state`, `state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$