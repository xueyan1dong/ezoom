/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_step_type.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    5/30/2018:sdong:added new step_type: disassemble for disassemble a product into multiple components
*    6/19/2018: Peiyu Ge: added header info. 					
*/

DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `step_type`$
CREATE TABLE `step_type` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `max_para_count` tinyint(3) NOT NULL DEFAULT '10',
  `min_para_count` tinyint(3) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sc_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

