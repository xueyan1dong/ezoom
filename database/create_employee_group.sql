/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_employee_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : this table name should be user_group. It is for holding a group of users that may have access
*                             to same resources. Users belong to different organization or having different roles may join
*                             the same group. For now (as of 7/12/2019), one user can only belong to one group. In the future
*                              one user may belong to multiple groups.
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    7/12/2019: Xueyan Dong: Change or_id column name to org_id and value from not null to null, e.g. a group may or may not belong to an organization.			
*/
DELIMITER $  
DROP TABLE IF EXISTS `employee_group`$
CREATE TABLE `employee_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `org_id` int(10) unsigned DEFAULT NULL,
  `ifprivilege` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$