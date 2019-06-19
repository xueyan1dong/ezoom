/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_product_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    06/13/2019: Xueyan Dong: added new column if_default.			
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `product_process`$
CREATE TABLE `product_process` (
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `recorder` int(10) unsigned NOT NULL,
  `comment` text,
  `if_default` tinyint(1) unsigned NOT NULL DEFAULT '1'  -- if the process is a default process for the product. Only one default per product
) ENGINE=InnoDB 