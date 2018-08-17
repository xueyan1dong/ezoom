/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_inventory.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    8/16/2018: Peiyu Ge: added location info.					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `inventory`$
CREATE TABLE `inventory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_type` enum('product','material') NOT NULL,
  `pd_or_mt_id` int(10) unsigned NOT NULL COMMENT 'product or material id',
  `supplier_id` int(10) unsigned NOT NULL COMMENT 'manufactured product has client id as 0, otherwise, the client id should be from client table',
  `lot_id` varchar(20) NOT NULL COMMENT 'if the inventory is purchased, the lot id may come from client, otherwise, it is the lot id',
  `serial_no` varchar(20) DEFAULT NULL,
  `out_order_id` varchar(20) DEFAULT NULL COMMENT 'This is the order id issued to supplier to purchase.',
  `in_order_id` varchar(20) DEFAULT NULL COMMENT 'This is the order id from order table, which issued by client to buy products.',
  `original_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `manufacture_date` datetime NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `arrive_date` datetime NOT NULL,
  `recorded_by` int(10) unsigned NOT NULL,
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `comment` text,
  `location_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_un01` (`source_type`,`pd_or_mt_id`, `supplier_id`, `lot_id`, `serial_no`)
) ENGINE=InnoDB$