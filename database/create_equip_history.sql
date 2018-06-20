/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `equip_history`$
CREATE TABLE `equip_history` (
  `event_time`  datetime NOT NULL,
  `equip_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','up','down','qual','checkout','checkin') DEFAULT NULL,
  `new_state` enum('inactive','up','down','qual','checkout','checkin') DEFAULT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text CHARACTER SET latin1 NOT NULL,
  `new_record` text CHARACTER SET latin1,
  PRIMARY KEY (`equip_id`,`event_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$