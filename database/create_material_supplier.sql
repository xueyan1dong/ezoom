/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_material_supplier.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `material_supplier`$
CREATE TABLE `material_supplier` (
  `material_id` int(10) unsigned NOT NULL,
  `supplier_id` int(10)unsigned NOT NULL,
  `preference` smallint(3) unsigned DEFAULT NULL,
  `mpn` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) unsigned DEFAULT NULL,
  `price_uom_id` smallint(3) unsigned DEFAULT NULL,
  `lead_days` int(5) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`material_id`, `supplier_id`)
) ENGINE=InnoDB$