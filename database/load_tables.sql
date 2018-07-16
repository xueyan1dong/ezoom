/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : load_tables.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
-- company table
DROP TABLE IF EXISTS `company`$
CREATE TABLE  `company` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `db_name` varchar(50) NOT NULL,
  `domain_name` varchar(50) NOT NULL,
  `status` enum('inactive','active') NOT NULL,
  `timezone` char(6) NOT NULL,
  `daylightsaving_starttime` datetime DEFAULT NULL,
  `daylightsaving_endtime` datetime DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  `plan` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `state` varchar(60) DEFAULT NULL,
  `country` varchar(60) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` varchar(60) NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` varchar(60) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$

-- client table
DROP TABLE IF EXISTS `client`$
CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `type` enum('supplier', 'customer', 'both') NOT NULL,
  `internal_contact_id` int(10) unsigned NOT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `country` varchar(20) DEFAULT 'USA',
  `address2` varchar(255) DEFAULT NULL,
  `city2` varchar(20) DEFAULT NULL,
  `state2` varchar(20) DEFAULT NULL,
  `zip2` varchar(10) DEFAULT NULL,
  `contact_person1` varchar(20) NOT NULL,
  `contact_person2` varchar(20) DEFAULT NULL,
  `person1_workphone` varchar(20) DEFAULT NULL,
  `person1_cellphone` varchar(20) DEFAULT NULL,
  `person1_email` varchar(40) NOT NULL,
  `person2_workphone` varchar(20) DEFAULT NULL,
  `person2_cellphone` varchar(20) DEFAULT NULL,
  `person2_email` varchar(20) DEFAULT NULL,
  `firstlistdate` date NOT NULL,
  `updateddate` date DEFAULT NULL,
  `ifactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `comment` text,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- attribute_history table
DROP TABLE IF EXISTS `attribute_history`$
CREATE TABLE `attribute_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `parent_type` enum('product', 'equipment','dc_def_main') NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_type` enum('in','out','both') NOT NULL DEFAULT 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time', 'text', 'mediumtext', 'longtext','enum') DEFAULT NULL,
  `length` tinyint(3) unsigned DEFAULT NULL,
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,
  `data_table_name` varchar(60) DEFAULT NULL,
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0', 
  `uom_id` smallint(3) unsigned DEFAULT NULL,
  `attr_value` varchar(255) DEFAULT NULL,
  `max_value` varchar(255) DEFAULT NULL,
  `min_value` varchar(255) DEFAULT NULL,
  `enum_values` varchar(255) DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`event_time`,`parent_type`, `parent_id`, `attr_id`)
) ENGINE=InnoDB$


-- config_history table
DROP TABLE IF EXISTS `config_history`$
CREATE TABLE `config_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_time` datetime NOT NULL,
  `source_table` varchar(20) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','production','frozen','checkout','checkin','engineer'),
  `new_state` enum('inactive','production','frozen','checkout','checkin','engineer','deleted') NOT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text,
  `new_record` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- organization table
DROP TABLE IF EXISTS `organization`$
CREATE TABLE `organization` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `parent_organization` int(10) unsigned DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- employee_group table
DROP TABLE IF EXISTS `employee_group`$
CREATE TABLE `employee_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `or_id` int(10) unsigned NOT NULL,
  `ifprivilege` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- employee table
DROP TABLE IF EXISTS `employee`$
CREATE TABLE  `employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `status` enum('active','inactive','removed') NOT NULL DEFAULT 'active',
  `or_id` int(10) unsigned NOT NULL,
  `eg_id` int(10) unsigned DEFAULT NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) NOT NULL,
  `middlename` varchar(20) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `report_to` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `em_un1` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


﻿/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_location.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    6/27/2018: Xueyan Dong: changed name and description from VARCHAR to NVARCHAR, and parent_loc_id from varchar to integer
						     also, enlarge the id and parent_loc_id byte size from INTEGER(5) TO INTEGER(11)
*/
DELIMITER $
DROP TABLE IF EXISTS `location` $
CREATE TABLE `location` (
  `id` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` NVARCHAR(45) NOT NULL,
  `parent_loc_id` INTEGER(11),
  `create_time` DATETIME NOT NULL,
  `update_time` DATETIME,
  `contact_employee` INTEGER(10) UNSIGNED NOT NULL,
  `adjacent_loc_id1` INTEGER(5) UNSIGNED,
  `adjacent_loc_id2` INTEGER(5) UNSIGNED,
  `adjacent_loc_id3` INTEGER(5) UNSIGNED,
  `adjacent_loc_id4` INTEGER(5) UNSIGNED,
  `description` NVARCHAR(255),
  `comment` TEXT,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB $


-- equipment_group table
DROP TABLE IF EXISTS `equipment_group`$
CREATE TABLE  `equipment_group` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `location_id` int(5) unsigned DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `eg_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- equipment table
DROP TABLE IF EXISTS `equipment`$
CREATE TABLE  `equipment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eg_id` int(10) unsigned zerofill DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `state` enum('inactive','up','down','qual','checkout','checkin') NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `manufacture_date` date DEFAULT NULL,
  `manufacturer` varchar(255) DEFAULT NULL,
  `manufacturer_phone` varchar(50) DEFAULT NULL,
  `online_date` date DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `eq_un1` (`eg_id`,`name`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- eq_attributes table
DROP TABLE IF EXISTS `eq_attributes`$
CREATE TABLE  `eq_attributes` (
  `eq_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `attr_value` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `attr_type` enum('in','out','both') NOT NULL DEFAULT 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime') NOT NULL,
  `length` int(4) unsigned DEFAULT NULL,
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `max_value` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `min_value` varchar(255) DEFAULT NULL,
  `enum_values` text,
  `description` text,
  `comment` text,
  PRIMARY KEY (`eq_id`,`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- equip_history table
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


-- uom table
DROP TABLE IF EXISTS `uom`$
CREATE TABLE `uom` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `alias` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

-- uom_conversion table
DROP TABLE IF EXISTS `uom_conversion`$
CREATE TABLE `uom_conversion` (
  `from_id` smallint(3) unsigned NOT NULL ,
  `to_id` smallint(3) unsigned NOT NULL ,
  `method` enum('ratio', 'reduction', 'addtion') NOT NULL,
  `constant` decimal(16,4) unsigned NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`from_id`, `to_id`)
) ENGINE=InnoDB$

-- recipe table
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


-- ingredients table
DROP TABLE IF EXISTS `ingredients`$
CREATE TABLE `ingredients` (
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product', 'material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`recipe_id`,`source_type`,`ingredient_id`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

-- ingredients_history table
DROP TABLE IF EXISTS `ingredients_history`$
CREATE TABLE `ingredients_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`event_time`, `recipe_id`,`source_type`,`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- inventory table
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_un01` (`source_type`,`pd_or_mt_id`, `supplier_id`, `lot_id`, `serial_no`)
) ENGINE=InnoDB$


-- inventory_consumption table
DROP TABLE IF EXISTS `inventory_consumption`$
CREATE TABLE `inventory_consumption` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `inventory_id` int(10) unsigned NOT NULL,
  `quantity_used` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `operator_id` int(10) unsigned NOT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (lot_id, start_timecode, inventory_id)
) ENGINE=InnoDB$


-- material_group table
DROP TABLE IF EXISTS `material_group`$
CREATE TABLE `material_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- material table
DROP TABLE IF EXISTS `material`$
CREATE TABLE `material` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mg_id` int(10) unsigned NOT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `alert_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `lot_size` decimal(16,4) unsigned DEFAULT NULL,
  `material_form` enum('solid','liquid','gas') NOT NULL,
  `status` enum('inactive','production','frozen') NOT NULL,
  `enlist_time` datetime NOT NULL,
  `enlisted_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_un1` (`name`,`alias`,`mg_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- order_general table
DROP TABLE IF EXISTS `order_general`$
CREATE TABLE `order_general` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_type` enum('inventory', 'customer','supplier') NOT NULL,
  `ponumber` varchar(40) DEFAULT NULL,
  `client_id` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `net_total` decimal(16,2) unsigned DEFAULT NULL,
  `tax_percentage` tinyint(2) unsigned DEFAULT NULL,
  `tax_amount` decimal(14,2) unsigned DEFAULT NULL,
  `other_fees` decimal(16,2) unsigned DEFAULT NULL,
  `total_price` decimal(16,2) unsigned DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `internal_contact` int(10) unsigned NOT NULL,
  `external_contact` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- order_detail table
DROP TABLE IF EXISTS `order_detail`$
CREATE TABLE `order_detail` (
  `order_id` int(10) unsigned NOT NULL,
  `source_type` enum('product', 'material') NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `unit_price` decimal(10,2) unsigned DEFAULT NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `uomid` smallint(3) unsigned NOT NULL,
  `output_date` datetime DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `actual_deliver_date` datetime DEFAULT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `source_type`, `source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- order_state_history table
DROP TABLE IF EXISTS `order_state_history`$
CREATE TABLE `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `state_date` datetime NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `state`, `state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- product_group table
DROP TABLE IF EXISTS `product_group`$
CREATE TABLE `product_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `surfix` varchar(20) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pg_un1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8$


-- product table
DROP TABLE IF EXISTS `product`$
CREATE TABLE  `product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pg_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `lot_size` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned NOT NULL,  
  `lifespan` int(10) unsigned NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `pd_un1` (`pg_id`,`name`,`version`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- pd_attributes table
DROP TABLE IF EXISTS `pd_attributes`$
CREATE TABLE `pd_attributes` (
  `pd_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_value` varchar(255) DEFAULT NULL,
  `attr_type` enum('in','out','both') NOT NULL DEFAULT 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime') NOT NULL,
  `length` int(4) unsigned DEFAULT NULL,
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0',  
  `max_value` varchar(255) DEFAULT NULL,
  `min_value` varchar(255) DEFAULT NULL,
  `enum_values` varchar(255) DEFAULT NULL,
  `description` text CHARACTER SET latin1,
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`pd_id`,`attr_id`, `attr_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- step_type table
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

-- step table
DROP TABLE IF EXISTS `step`$
CREATE TABLE `step` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `step_type_id` int(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') CHARACTER SET latin1 DEFAULT NULL,
  `eq_usage` enum('eq group','equipment')  DEFAULT NULL,
  `eq_id` int(10) unsigned DEFAULT NULL,
  `emp_usage` enum('employee group','employee')  DEFAULT NULL,
  `emp_id` int(10) unsigned DEFAULT NULL,
  `recipe_id` int(10) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `para_count` tinyint(3) DEFAULT NULL,
  `description` text ,
  `comment` text ,  
  `para1` text,
  `para2` text,
  `para3` text,
  `para4` text,
  `para5` text,
  `para6` text,
  `para7` text,
  `para8` text,
  `para9` text,
  `para10` text,  
  PRIMARY KEY (`id`),
  UNIQUE KEY `st_un1` (`name`,`version`)
) ENGINE=InnoDB$


-- process_group
DROP TABLE IF EXISTS `process_group`$
CREATE TABLE `process_group` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prg_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- process table
DROP TABLE IF EXISTS `process`$
CREATE TABLE `process` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `prg_id` int(10) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin', 'engineer') NOT NULL,
  `start_pos_id` int(5) unsigned,
  `owner_id` int(10) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `usage` enum('sub process only','main process only','both') NOT NULL DEFAULT 'both',
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pr_un1` (`name`,`version`,`prg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

-- process_segment table
DROP TABLE IF EXISTS `process_segment`$
CREATE TABLE `process_segment` (
  `process_id` int(10) unsigned NOT NULL,
  `segment_id` int(5) unsigned NOT NULL,  
  `name` varchar(255) NOT NULL,
  `position` smallint(2) unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`process_id`, `segment_id`)
) ENGINE=InnoDB$

-- process_step table
DROP TABLE IF EXISTS `process_step`$
CREATE TABLE `process_step` (
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `prev_step_pos` int(5) unsigned DEFAULT NULL,
  `next_step_pos` int(5) unsigned DEFAULT NULL,
  `false_step_pos` int(5) unsigned DEFAULT NULL,
  `segment_id` int(5) unsigned DEFAULT NULL,
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0',
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prompt` varchar(255) DEFAULT NULL,
  `if_autostart` tinyint(1) unsigned NOT NULL default '1',
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL,
  `approve_emp_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB$

-- process_step view
DROP VIEW IF EXISTS `view_process_step`$
CREATE ALGORITHM = MERGE VIEW `view_process_step` AS
    SELECT ps.process_id,
         ps.position_id,
         ps.step_id,
         ps.prev_step_pos,
         ps.next_step_pos,
         ps.false_step_pos,
         ps.rework_limit,
         ps.if_sub_process,
         IF(ps.if_sub_process, 'Y', 'N') AS YN_sub_process,
         ps.prompt,
         ps.if_autostart,
         IF(ps.if_autostart, 'Y', 'N') AS YN_autostart,
         ps.need_approval,
         IF(ps.need_approval, 'Y', 'N') AS YN_need_approval,
         ps.approve_emp_usage,
         ps.approve_emp_id,
         IF (ps.approve_emp_usage = 'employee',
             (SELECT concat(e.firstname, ' ', e.lastname) FROM employee e WHERE e.id = ps.approve_emp_id),
             (SELECT eg.name FROM employee_group eg WHERE eg.id = ps.approve_emp_id)) AS approve_emp_name
     FROM process_step ps 
     $

     
-- process_step_history
DROP TABLE IF EXISTS `process_step_history`$
CREATE TABLE `process_step_history` (
  `event_time` datetime NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,  
  `action` enum('insert','modify','delete') NOT NULL,
  `employee_id` int(10) unsigned NOT NULL, 
  `prev_step_pos` int(5) unsigned DEFAULT NULL,
  `next_step_pos` int(5) unsigned DEFAULT NULL,
  `false_step_pos` int(5) unsigned DEFAULT NULL,
  `segment_id` int(5) unsigned DEFAULT NULL,
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0',  
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prompt` varchar(255) DEFAULT NULL,  
  `if_autostart` tinyint(1) unsigned NOT NULL default '1',
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL,
  `approve_emp_id` int(10) unsigned DEFAULT NULL,  
  PRIMARY KEY (`event_time`, process_id, position_id)
) ENGINE=InnoDB$


-- product_process table
DROP TABLE IF EXISTS `product_process`$
CREATE TABLE `product_process` (
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `recorder` int(10) unsigned NOT NULL,
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- lot_status table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_lot_status.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : table to hold current lot/batch status information
*    Log                    :
*    6/5/2018: xdong: add a new column, location, to record batch/lot location
*	 7/16/2018 peiyu: modified column `location` nvarchar to `location_id` int(11)
*/
DROP TABLE IF EXISTS `lot_status`$
CREATE TABLE `lot_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(20) DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `status` enum('dispatched','in process','in transit', 'hold', 'to warehouse', 'shipped', 'scrapped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(5) unsigned NOT NULL,
  `update_timecode` char(15) DEFAULT NULL,  
  `contact` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `dispatcher` int(10) unsigned NOT NULL,
  `dispatch_time` datetime NOT NULL,
  `output_time` datetime DEFAULT NULL,
  `comment` text,
  `location_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$


-- lot_history table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_lot_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : table to hold historical lot/batch information
*    Log                    :
*    6/5/2018: xdong: add a new column, location, to log batch/lot location
*	 7/16/2018 peiyu: modified column `location` nvarchar to `location_id` int(11)
*/
DROP TABLE IF EXISTS `lot_history`$
CREATE TABLE `lot_history` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `start_operator_id` int(10) unsigned NOT NULL,
  `end_operator_id` int(10) unsigned DEFAULT NULL,
  `status` enum('dispatched', 'started', 'restarted','ended','error','stopped','scrapped','shipped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `end_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned DEFAULT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `approver_id` int(10) unsigned DEFAULT NULL,
  `result` text,
  `comment` text,
  `location_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY `lh_un1` (`lot_id`,`start_timecode`, process_id, step_id)
) ENGINE=InnoDB$

-- priority table
DROP Table IF EXISTS `priority`$
CREATE TABLE `priority` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- document table
DROP TABLE IF EXISTS `document`$
CREATE TABLE  `document` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_table` varchar(50) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `key_words` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `version` varchar(10) DEFAULT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `contact_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY(`id`),
  KEY (`source_table`, `source_id`, `key_words`, `title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

-- feedback table
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

-- system_roles table
DROP TABLE IF EXISTS `system_roles`$
CREATE TABLE `system_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC$

-- users_in_roles table

DROP TABLE IF EXISTS `users_in_roles`$
CREATE TABLE `users_in_roles` (
  `userId` int(11) NOT NULL DEFAULT '0',
  `roleId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userId`,`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC$

-- view_ingredient view
DROP VIEW IF EXISTS `view_ingredient`$
CREATE ALGORITHM = MERGE VIEW `view_ingredient` AS
SELECT i.recipe_id,
        -- CONCAT('self-manufactured ', i.source_type) AS source_type,
        i.source_type,
        i.ingredient_id,
        p.name,
        p.description,
        i.quantity, 
        i.uom_id,
        u.name as uom_name, 
        i.`order`,
        i.mintime,
        i.maxtime,
        i.comment
   FROM ingredients i 
   LEFT JOIN product p ON p.id = i.ingredient_id
   LEFT JOIN uom u ON u.id = i.uom_id
  WHERE i.source_type = 'product'
  UNION 
 SELECT i1.recipe_id,
        -- CONCAT('supplied ' , i1.source_type) AS source_type,
        i1.source_type,
        i1.ingredient_id,
         m.name,
         m.description,
        i1.quantity, 
        i1.uom_id,
        u1.name as uom_name, 
        i1.`order`,
        i1.mintime,
        i1.maxtime,
        i1.comment
   FROM ingredients i1
   LEFT JOIN material m ON m.id = i1.ingredient_id
   LEFT JOIN uom u1 ON u1.id = i1.uom_id
  WHERE i1.source_type = 'material'
     $
     
 -- view_lot_in_process view
DROP VIEW IF EXISTS `view_lot_in_process`$
CREATE ALGORITHM = MERGE VIEW `view_lot_in_process` AS
 SELECT s.id,
        s.alias,
        s.product_id,
        pr.name as product,
        s.priority,
        p.name as priority_name,
        get_local_time(s.dispatch_time) as dispatch_time,
        s.process_id,
        pc.name as process,       
        h.sub_process_id,
        ifnull(null, (SELECT pcs.name FROM process pcs WHERE pcs.id = h.sub_process_id)) AS sub_process,
        h.position_id,
        h.sub_position_id,
        h.step_id,
        st.name AS step,
        s.status AS lot_status,
        h.status AS step_status,
        get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) AS start_time,
        get_local_time(str_to_date(h.end_timecode, '%Y%m%d%H%i%s0' )) AS end_time,
        h.start_timecode,
        s.actual_quantity,
        s.uomid,
        u.name AS uom,
        s.contact,
        CONCAT(e.firstname, ' ', e.lastname) AS contact_name,
        h.equipment_id,
        eq.name as equipment,
        h.device_id,
        h.approver_id,
        s.comment,
        h.result,
        st.emp_usage,
        st.emp_id
   FROM lot_status s 
        INNER JOIN lot_history h ON h.lot_id = s.id
                                 AND h.process_id = s.process_id
                                 AND h.start_timecode = (SELECT max(h1.start_timecode)
                                                           FROM lot_history h1
                                                          WHERE h1.lot_id = h.lot_id
                                                         )
                                 AND (h.end_timecode IS NULL OR 
                                         NOT EXISTS (SELECT * FROM lot_history h2
                                                      WHERE h2.lot_id = h.lot_id
                                                        AND h2.start_timecode = h.start_timecode
                                                        AND h2.end_timecode IS NULL))
        LEFT JOIN product pr ON pr.id = s.product_id
        LEFT JOIN process pc ON pc.id = s.process_id
        LEFT JOIN step st ON st.id = h.step_id
        LEFT JOIN uom u ON u.id = s.uomid
        LEFT JOIN priority p ON p.id = s.priority
        LEFT JOIN employee e ON e.id = s.contact
        LEFT JOIN equipment eq ON eq.id = h.equipment_id
        LEFT JOIN employee ea ON ea.id = h.approver_id
  WHERE s.status NOT IN ('shipped', 'scrapped')
  ORDER BY s.product_id, s.priority, s.dispatch_time
     ;DROP VIEW IF EXISTS `view_lot_in_process`;
CREATE ALGORITHM = MERGE VIEW `view_lot_in_process` AS
 SELECT s.id,
        s.alias,
        s.product_id,
        pr.name as product,
        s.priority,
        p.name as priority_name,
        get_local_time(s.dispatch_time) as dispatch_time,
        s.process_id,
        pc.name as process,       
        h.sub_process_id,
        ifnull(null, (SELECT pcs.name FROM process pcs WHERE pcs.id = h.sub_process_id)) AS sub_process,
        h.position_id,
        h.sub_position_id,
        h.step_id,
        st.name AS step,
        s.status AS lot_status,
        h.status AS step_status,
        get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) AS start_time,
        get_local_time(str_to_date(h.end_timecode, '%Y%m%d%H%i%s0' )) AS end_time,
        h.start_timecode,
        s.actual_quantity,
        s.uomid,
        u.name AS uom,
        s.contact,
        CONCAT(e.firstname, ' ', e.lastname) AS contact_name,
        h.equipment_id,
        eq.name as equipment,
        h.device_id,
        h.approver_id,
        s.comment,
        h.result,
        st.emp_usage,
        st.emp_id
   FROM lot_status s 
        INNER JOIN lot_history h ON h.lot_id = s.id
                                 AND h.process_id = s.process_id
                                 AND h.start_timecode = (SELECT max(h1.start_timecode)
                                                           FROM lot_history h1
                                                          WHERE h1.lot_id = h.lot_id
                                                         )
                                 AND (h.end_timecode IS NULL OR 
                                         (
                                         NOT EXISTS (SELECT * FROM lot_history h2
                                                      WHERE h2.lot_id = h.lot_id
                                                        AND h2.start_timecode = h.start_timecode
                                                        AND h2.end_timecode IS NULL)
                                          AND h.end_timecode = (SELECT max(h3.end_timecode)
                                                                  FROM lot_history h3
                                                                 WHERE h3.lot_id = h.lot_id)))
        LEFT JOIN product pr ON pr.id = s.product_id
        LEFT JOIN process pc ON pc.id = s.process_id
        LEFT JOIN step st ON st.id = h.step_id
        LEFT JOIN uom u ON u.id = s.uomid
        LEFT JOIN priority p ON p.id = s.priority
        LEFT JOIN employee e ON e.id = s.contact
        LEFT JOIN equipment eq ON eq.id = h.equipment_id
        LEFT JOIN employee ea ON ea.id = h.approver_id
  WHERE s.status NOT IN ('shipped', 'scrapped')
  ORDER BY s.product_id, s.priority, s.dispatch_time
     $

-- consumption_return table
DROP TABLE IF EXISTS `consumption_return`$
CREATE TABLE `consumption_return` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `return_timecode` char(15) NOT NULL,
  `inventory_id` int(10) unsigned NOT NULL,
  `quantity_before` decimal(16,4) unsigned NOT NULL,
  `quantity_returned` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL, 
  `operator_id` int(10) unsigned NOT NULL,
  `step_start_timecode` char(15) NOT NULL,
  `consumption_start_timecode` char(15) NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (lot_id, return_timecode, inventory_id)
) ENGINE=InnoDB$

-- material_supplier table
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