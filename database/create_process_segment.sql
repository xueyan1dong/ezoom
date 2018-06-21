/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_segment.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `process_segment`$
CREATE TABLE `process_segment` (
  `process_id` int(10) unsigned NOT NULL,
  `segment_id` int(5) unsigned NOT NULL,  
  `name` varchar(255) NOT NULL,
  `position` smallint(2) unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`process_id`, `segment_id`)
) ENGINE=InnoDB$
