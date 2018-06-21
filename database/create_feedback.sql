/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_feedback.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `feedback`$
CREATE TABLE `feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
  `noter_id` int(10) unsigned NOT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `state` enum('issued', 'queued', 'in process', 'closed'),
  `priority_id` smallint(3) DEFAULT NULL,
  `last_noter_id` int(10) unsigned DEFAULT NULL,
  `last_note_time` datetime DEFAULT NULL,
  `responder` varchar(20) DEFAULT NULL,
  `last_respond_time` datetime DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `response` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$