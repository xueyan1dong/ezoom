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
DROP TABLE IF EXISTS `recipe`$
CREATE TABLE `recipe` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `exec_method` enum('ordered','random') NOT NULL DEFAULT 'random',
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `instruction` text DEFAULT NULL,
  `diagram_filename` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$