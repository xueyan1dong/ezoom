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
  `person2_email` varchar(40) DEFAULT NULL,
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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_organization.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table is used for holding the organization structure of both the 
*                             owning company of the eZOOM instance or the client company of the owning company
*                             so that eZOOM can intepret its users' organizational structure
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    7/09/2019: Xueyan Dong: added root_org_type column	
*    11/23/2019: xueyan Dong: added root_company column	
*	 11/25/2019: Shelby Simpson: added status column
*/
DELIMITER $ 
DROP TABLE IF EXISTS `organization`$
CREATE TABLE `organization` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- auto generated id in ezoom 
  `name` varchar(255) NOT NULL,
  `status` enum('active','inactive','removed') NOT NULL DEFAULT 'active', -- whether the organization is active, inactive or removed from the system 
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `root_company` INT(10) NOT NULL, -- the top organization under host company or client will have either id from company table
                                                        -- or id from client table as parent_organization, depending on root_organization_type
  `parent_organization` int(10) unsigned DEFAULT NULL, -- ID FROM organization table
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `description` text,
  `root_org_type` enum('host','client') DEFAULT NULL,  -- indicate whether the org is under the company who host/operates on eZOOM 
                                                                -- or under a particular client
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$

-- root_org_type table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_root_org_type.sql
*    Created By             : Shelby Simpson
*    Date Created           : 12/2/2019
*    Platform Dependencies  : MySql
*    Description            : This table is used for storing available root organization types.
*							  There is no foreign key from the organization table to this one but 
							  root_org_type attribute (in organization table) must be restricted to
							  one of the types in this table.
*    example	            : 
*    Log                    :
*      12/04/2019:Xueyan Dong:Added value set up to the table script
*/
DELIMITER $ 
DROP TABLE IF EXISTS `root_org_type`$
CREATE TABLE `root_org_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- auto generated id in ezoom 
  `name` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$

INSERT INTO `root_org_type` (`name`)
VALUES ('host'), ('client')
$

-- employee_group table
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
  `ifprivilege` tinyint(1) unsigned NOT NULL DEFAULT '0',  -- whether the group has approval privilege
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$


-- employee table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_employee.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : The name of the table is a little misleading. This table is used for holding all eZOOM users, including
*                              both employees of the ezoom instance owner and the users from clients of the ezoom instance owner.
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    6/17/2019: Xueyan Dong: added column location_id for recording employee default location		
*    7/9/2019: Xueyan Dong: added column user_type, to indicate whether the user is employee or client user	
*    12/27/2019: Xueyan Dong: added column creation_date and update_datetime to table
*/
DELIMITER $  
DROP TABLE IF EXISTS `employee`$
CREATE TABLE  `employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` varchar(20) NOT NULL,  -- if the user_type is host, the company_id corresponds to the id in company table
                                      -- if the user_type is client, the company_id corresponds to the id in client table
  `username` varchar(20) NOT NULL,  -- username assigned for ezoom
  `password` varchar(20) NOT NULL,  -- password username assigned for ezoom 
  `status` enum('active','inactive','removed') NOT NULL DEFAULT 'active', -- whether the employee is active, inactive or removed from the system
  `or_id` int(10) unsigned NOT NULL,  -- id of its belonging organization within its company
  `eg_id` int(10) unsigned DEFAULT NULL,  -- id of its belonging employee group. in the future, a user may belong to multiple groups. for now, only one
  `firstname` varchar(20) NOT NULL,  -- first name of the user
  `lastname` varchar(20) NOT NULL,  -- last name of the user
  `middlename` varchar(20) DEFAULT NULL,  -- middle name of the user
  `email` varchar(45) DEFAULT NULL,  -- email of the user
  `phone` varchar(45) DEFAULT NULL,  -- phone number
  `report_to` int(10) unsigned DEFAULT NULL,  -- ezoom user id of that this user reports to
  `comment` text,  -- comment/note that recorded with the user info
  `location_id` int(11) unsigned DEFAULT NULL,  -- default location that the user positioned at
  `user_type` enum('host','client') DEFAULT NULL, -- indicate whether the user is the employee of the company who host/operates on eZOOM 
                                         -- or the employee of the client of the company
  `creation_date` date, -- date when the user was created
  `update_datetime` datetime, -- datetime when the user info was updated.
  PRIMARY KEY (`id`),
  UNIQUE KEY `em_un1` (`username`)
) ENGINE=InnoDB$
/*
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
     01/31/2019: Xueyan Dong: remove the not null restriction on contact_employee column. Added explanation for each column as comment
*/
DELIMITER $
DROP TABLE IF EXISTS `location` $
CREATE TABLE `location` (
  `id` INTEGER(11) UNSIGNED NOT NULL AUTO_INCREMENT, -- unique identifier of the location
  `name` NVARCHAR(45) NOT NULL,  -- name of the location
  `parent_loc_id` INTEGER(11),  -- parent location that current location belongs to
  `create_time` DATETIME NOT NULL,  -- date time that location is created
  `update_time` DATETIME, -- datetime that location is updated
  `contact_employee` INTEGER(10) UNSIGNED,  -- id of contact employee
  `adjacent_loc_id1` INTEGER(5) UNSIGNED,  -- id of adjacent loction that helps to locate the current location
  `adjacent_loc_id2` INTEGER(5) UNSIGNED,  -- id of adjacent location that helps to locate the current location
  `adjacent_loc_id3` INTEGER(5) UNSIGNED,  -- id of adjacent location that helps to locate the current location
  `adjacent_loc_id4` INTEGER(5) UNSIGNED,  -- id of adjacent location that helps to locate the current location
  `description` NVARCHAR(255),  -- description of the location
  `comment` TEXT,  -- any comment needed to store
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
*    10/17/2018: xdong: added location_id to unique key index			
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
  `location_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_un01` (`source_type`,`pd_or_mt_id`, `supplier_id`, `lot_id`, `serial_no`, `location_id`)
) ENGINE=InnoDB$


-- inventory_consumption table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_inventory_consumption.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    06/19/2018: Peiyu Ge: added header info. 		
*    02/05/2019: xdong: widen lot_alias input from varchar(20) to varchar(30) following changes of the same column in lot_history and lot_status				
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `inventory_consumption`$
CREATE TABLE `inventory_consumption` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(30) DEFAULT NULL,
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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_material.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*	 8/26/2018: Peiyu Ge: added if_persistent flag to indicate if an item is an intermediate item/part 				
*/

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
  `if_persistent` boolean,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_un1` (`name`,`alias`,`mg_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- order_general table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Stores general header information of orders.
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    09/25/2018: Xueyan Dong: removed id from the defined key, so that orders have to have unique po number within the same 
*                             type, client
*    02/16/2020: Shelby Simpson: Modified expected_deliery_date from datetime to date type.
*/
DELIMITER $  -- for escaping purpose
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
  `expected_deliver_date` date DEFAULT NULL,  
  `internal_contact` int(10) unsigned NOT NULL,
  `external_contact` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

-- order_detail table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_detail.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : record products being ordered
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    09/10/2018: Xueyan Dong: added new column line_num. also changed some int column size
				
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `order_detail`$
CREATE TABLE `order_detail` (
  `order_id` int(11) unsigned NOT NULL,
  `source_type` enum('product', 'material') NOT NULL,
  `source_id` int(11) unsigned NOT NULL,
  `line_num` smallint(5) unsigned NOT NULL DEFAULT 1,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `unit_price` decimal(10,2) unsigned DEFAULT NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `uomid` smallint(3) unsigned NOT NULL,
  `output_date` datetime DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `actual_deliver_date` datetime DEFAULT NULL,
  `recorder_id` int(11) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `source_type`, `source_id`, `line_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- order_state_history table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_state_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    02/16/2020: Shelby Simpson: Altered state_date column from datetime to date type.				
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `order_state_history`$
CREATE TABLE `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `state_date` date NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `state`, `state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$


-- product_group table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_product_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table host the grouping infor of products
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    09/07/2018: Xueyan Dong: added default_location_id to the table					
*/
DROP TABLE IF EXISTS `product_group`$
CREATE TABLE `product_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,  --unique identifier automatcially generated
  `name` varchar(255) NOT NULL,     -- name of the product group
  `prefix` varchar(20) DEFAULT NULL,  -- prefix used in the name of products belonging to the group
  `surfix` varchar(20) DEFAULT NULL,  -- surfix used in the name of products belonging to the group
  `create_time` datetime NOT NULL,  -- time of the group created
  `created_by` int(11) unsigned NOT NULL,  -- user id who created this group
  `description` text,  -- description of the product group
  `comment` text,  -- any comment for the group
  `default_location_id` int(11) DEFAULT NULL,  -- id of default location for the product group
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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table holds the relationship between process and its contained steps or sub processes.
*                             If if_sub_process=1, the step_id correspond to a process_id that constitutes the sub process at the position
*                             Recursive process only limit to 1 level deep in this software
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/09/2018: xdong: added new column product_made to mark whether a final step produces the product desired				
*/
DELIMITER $ 
DROP TABLE IF EXISTS `process_step`$
CREATE TABLE `process_step` (
  `process_id` int(10) unsigned NOT NULL,  -- id of the workflow/process
  `position_id` int(5) unsigned NOT NULL,  -- position of the step, starting from 1, unique within a process
  `step_id` int(10) unsigned NOT NULL,   -- id of the step or sub process at the position
  `prev_step_pos` int(5) unsigned DEFAULT NULL,  -- previous step position id
  `next_step_pos` int(5) unsigned DEFAULT NULL, -- next step position id
  `false_step_pos` int(5) unsigned DEFAULT NULL,  -- for condition step, if failed condition, the step/position id to go
  `segment_id` int(5) unsigned DEFAULT NULL,  -- process can be dividied into segments. The segment that the position/step belong to.
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0', -- the max number of times that the position/step can be revisited by a batch. 0 means no limit
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0', -- if the step points to a sub process. If 1, step_id corresponds to an id in process table. 
                                                             -- otherwise, it correpsonds to an id in step table
  `prompt` varchar(255) DEFAULT NULL,  -- prompt for user when batch comes to the step/position
  `if_autostart` tinyint(1) unsigned NOT NULL default '1', -- whether to automatically start this step after previous step finished
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether need another employee or employee group or employ category to approve when ending the step
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL, -- if need_approval = 1, this field determine whether a particular employee
                                                                                          -- or a particular employee category or a partcular employee group can
                                                                                          -- approve the execution of the step
  `approve_emp_id` int(10) unsigned DEFAULT NULL, -- approved employee or group or category id
  `product_made` tinyint(1) unsigned NOT NULL DEFAULT 0,  -- it will only be 1 if completion of the step produce the final product ordered
                                                          -- however, even at the step, the product is made, the process may not finish,
                                                          -- there can still be more steps after product made as post processing, such as ship or warranty etc
  PRIMARY KEY (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB$

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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table holds the relationship between process and its contained steps or sub processes.
*                             If if_sub_process=1, the step_id correspond to a process_id that constitutes the sub process at the position
*                             Recursive process only limit to 1 level deep in this software
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/09/2018: xdong: added new column product_made to mark whether a final step produces the product desired				
*/
DELIMITER $ 
DROP TABLE IF EXISTS `process_step`$
CREATE TABLE `process_step` (
  `process_id` int(10) unsigned NOT NULL,  -- id of the workflow/process
  `position_id` int(5) unsigned NOT NULL,  -- position of the step, starting from 1, unique within a process
  `step_id` int(10) unsigned NOT NULL,   -- id of the step or sub process at the position
  `prev_step_pos` int(5) unsigned DEFAULT NULL,  -- previous step position id
  `next_step_pos` int(5) unsigned DEFAULT NULL, -- next step position id
  `false_step_pos` int(5) unsigned DEFAULT NULL,  -- for condition step, if failed condition, the step/position id to go
  `segment_id` int(5) unsigned DEFAULT NULL,  -- process can be dividied into segments. The segment that the position/step belong to.
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0', -- the max number of times that the position/step can be revisited by a batch. 0 means no limit
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0', -- if the step points to a sub process. If 1, step_id corresponds to an id in process table. 
                                                             -- otherwise, it correpsonds to an id in step table
  `prompt` varchar(255) DEFAULT NULL,  -- prompt for user when batch comes to the step/position
  `if_autostart` tinyint(1) unsigned NOT NULL default '1', -- whether to automatically start this step after previous step finished
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether need another employee or employee group or employ category to approve when ending the step
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL, -- if need_approval = 1, this field determine whether a particular employee
                                                                                          -- or a particular employee category or a partcular employee group can
                                                                                          -- approve the execution of the step
  `approve_emp_id` int(10) unsigned DEFAULT NULL, -- approved employee or group or category id
  `product_made` tinyint(1) unsigned NOT NULL DEFAULT 0,  -- it will only be 1 if completion of the step produce the final product ordered
                                                          -- however, even at the step, the product is made, the process may not finish,
                                                          -- there can still be more steps after product made as post processing, such as ship or warranty etc
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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table records snapshots of process_step, so that to track changes made to processes
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info.
*    11/09/2018: xdong: added new column product_made to mark whether a final step produces the product desired	 					
*/
DELIMITER $ 
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
  `product_made` tinyint(1) unsigned NOT NULL DEFAULT 0,  -- it will only be 1 if completion of the step produce the final product ordered
  PRIMARY KEY (`event_time`, process_id, position_id)
) ENGINE=InnoDB$

-- product_process table
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
*    7/16/2018 peiyu: modified column `location` nvarchar to `location_id` int(11)
*    11/09/2018: xdong: added a column, quantity_status to indicate whether the lot/batch's quantity goes to quantity_in_process
*                       or quantity_made or quantity_shipped in the corresponding line in order general
*                       added a column, order_line_num to hold the line_num that the batch is dispatched from in order_detail table
*                       added enum value 'done' to status column to mark a lot has done the last step, if not shipped or scrapped, 
*                       e.g. a final status for a batch can be: shipped or scrapped or done.
*    01/29/2019: xdong: added three columns for logging extra informtion collected from current transaction
*    02/05/2019: xdong: widen alias column from varchar(20) to varchar(30)
*/
DELIMITER $  
DROP TABLE IF EXISTS `lot_status`$
CREATE TABLE `lot_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- the id of the batch
  `alias` varchar(30) DEFAULT NULL,  -- the unique alias of the batch. This is to hold user viewable batch number. Can be customized to specific format that user require
  `order_id` int(10) unsigned DEFAULT NULL,  -- the id of the order that the batch/lot is dispatched from
  `product_id` int(10) unsigned NOT NULL, -- the id of the product that the batch is to produce
  `process_id` int(10) unsigned NOT NULL,  -- the id of the process that the batch is to follow
  `status` enum('dispatched','in process','in transit', 'hold', 'to warehouse', 'shipped', 'scrapped', 'done') NOT NULL, -- the status of the batch. 
  -- dispatched: when batch was just created and haven't started any process step
  -- in process: batch is at at a step, has started, but not finished the step
  -- in transit: batch has gone through some steps, but now is in between steps
  -- hold: batch is put on hold from going into next step. Has to be explicitly unhold, in order to continue its process
  -- to warehouse: batch has been relocated into warehouse
  -- shipped: batch has been shipped to customer. Batch can not change to other status after this status, e.g. this is a final status.
  -- scrapped: batch has been scrapped. Batch can not change to other status after this status, e.g. this is a final status.
  -- done: batch has completed it is process, but not shipped, neigher scrapped. Batch can not change to other status after this status, e.g. this is a final status.
  `start_quantity` decimal(16,4) unsigned NOT NULL,  -- quantity that the batch starts with
  `actual_quantity` decimal(16,4) unsigned DEFAULT NULL,  -- actually quantity at current position
  `uomid` smallint(5) unsigned NOT NULL,  -- id of its unit of measure
  `update_timecode` char(15) DEFAULT NULL,   -- time code for latest update time, using code for faster sorting and data manipulation
  `contact` int(10) unsigned DEFAULT NULL,  -- contact employee id
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',  -- priority of the batch. 
  `dispatcher` int(10) unsigned NOT NULL,  -- employee id who dispatched the batch
  `dispatch_time` datetime NOT NULL,  -- datetime the batch was dispatched
  `output_time` datetime DEFAULT NULL,  --  time when batch is done
  `comment` text,  -- comment put in at current step
  `location_id` int(11) unsigned DEFAULT NULL, -- id of its current location
  `order_line_num` smallint(5) unsigned NOT NULL DEFAULT 1, -- line number in the order_detail, from which the batch is dispatched from
  `quantity_status` enum('in process', 'made', 'shipped') DEFAULT 'in process',  -- quantity accounting status: 
   -- in process: quantity is counted toward quantity_in_process in order_detail record
   -- made: quantity is counted toward quantity_made in order_detail record
   -- shipped: quantity is counted toward quantity_shipped in order_detail record
   `value1` varchar(255), -- reserved for storing extra info collected at each transaction. For "ship to location" step, this field store tracking number logged
   `value2` varchar(500), -- reserved for storing extra info collected at each transaction. For now, it is not used
   `value3` varchar(2000), -- reserved for storing extra info collected at each transaction. for now, it is not used
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
*    7/16/2018 peiyu: modified column `location` nvarchar to `location_id` int(11)
*    11/09/2018: xdong: added a column, quantity_status to indicate whether the lot/batch's quantity goes to quantity_in_process
*                       or quantity_made or quantity_shipped in the corresponding line in order general
*                       added a column, order_line_num to hold the line_num that the batch is dispatched from in order_detail table
*                       added enum value 'done' to status column to mark a lot has done the last step, if not shipped or scrapped, 
*                       e.g. a final status for a batch can be: shipped or scrapped or done.
*    01/29/2019: xdong: added three columns for logging extra informtion collected from current transaction
*    02/05/2019: xdong: widen lot_alias column from varchar(20) to varchar(30)
*/
DELIMITER $  
DROP TABLE IF EXISTS `lot_history`$
CREATE TABLE `lot_history` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(30) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `start_operator_id` int(10) unsigned NOT NULL,
  `end_operator_id` int(10) unsigned DEFAULT NULL,
  `status` enum('dispatched', 'started', 'restarted','ended','error','stopped','scrapped','shipped', 'done') NOT NULL,
  `start_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `end_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned DEFAULT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `approver_id` int(10) unsigned DEFAULT NULL,
  `result` text,
  `comment` text,
  `location_id` int(11) unsigned DEFAULT NULL,  
  `order_line_num` smallint(5) unsigned NOT NULL DEFAULT 1, -- line number in the order_detail, from which the batch is dispatched from
  `quantity_status` enum('in process', 'made', 'shipped') DEFAULT 'in process',  -- quantity accounting status: 
   -- in process: quantity is counted toward quantity_in_process in order_detail record
   -- made: quantity is counted toward quantity_made in order_detail record
   -- shipped: quantity is counted toward quantity_shipped in order_detail record
  `value1` varchar(255), -- reserved for storing extra info collected at each transaction. For "ship to location" step, this field store tracking number logged
  `value2` varchar(500), -- reserved for storing extra info collected at each transaction. For now, it is not used
  `value3` varchar(2000), -- reserved for storing extra info collected at each transaction. for now, it is not used
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
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : Create_Role_Table.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    7/8/2019: Xueyan Dong: added column: description	to hold the description of privileges of the role
*    7/10/2019: Xueyan Dong: inserted a new role, Operator, to the table		
*    7/11/2019: Xueyan Dong: inserted a new role, ClientQA, to the table. 
*/
DELIMITER $ 
DROP TABLE IF EXISTS `system_roles`$
CREATE TABLE `system_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,  -- internal db id of the role
  `applicationId` int(11) NOT NULL,  -- the id of the ezoom version. for now, it defaults to 1
  `name` varchar(255) NOT NULL,  -- name of the role
  `description` TEXT NULL,  -- describe the privileges that the role enjoy here
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC$

Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'Admin', 'Administrator of eZOOM. Has access to all forms')$
Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'Manager', 'Manager on Shop floor. Has access to all forms')$
Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'QA', 'Quality Assurance. Has access to all forms')$
Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'Engineer', 'Product Engineer. Has access to all forms')$
Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'Operator', 'Operator on Shop floor. Has access to Move Product by Operator form')$
Insert into `system_roles` ( `applicationId`, `name`, `description`) values (1, 'ClientQA', 'Quality Assurance person from client. They only move qa orders assigned to them')$

DROP TABLE IF EXISTS `users_in_roles`$
CREATE TABLE `users_in_roles` (
  `userId` int(11) NOT NULL DEFAULT '0',
  `roleId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userId`,`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC$

Insert into `users_in_roles` (`userId`, `roleId`) values(1, 1)$
Insert into `users_in_roles` (`userId`, `roleId`) values(2, 1)$
Insert into `users_in_roles` (`userId`, `roleId`) values(3, 3)$

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
*	 7/27/2018: Peiyu Ge: added selection of location_id to view 					
*/
  
 -- view_lot_in_process view
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : view_lot_in_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    11/29/2018: Junlu Luo: Added order_line_num and finish columns to output	
*    12/02/2018: Xueyan Dong: Added order_id column to output	
*    12/04/2018: Xueyan Dong: Added quantity_status to output	
*    01/29/2019: Xueyan Dong: Added value1 to output
*/
DELIMITER $ 
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
        st.emp_id,
		h.location_id,
		og.ponumber,
		s.order_line_num,
		pr.description as finish,
    s.order_id,
    s.quantity_status,
    s.value1
   FROM lot_status s 
	JOIN order_general as og ON s.order_id = og.id
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
  /* and h.lot_id not in 
        (Select lot_id from process_step ps, lot_history lh
			where lh.position_id = ps.position_id 
				and lh.step_id = ps.step_id 
                and lh.process_id = ps.process_id
                and ps.next_step_pos is null
                and lh.status = 'ended') */
  ORDER BY s.product_id, s.priority, s.dispatch_time
     $


-- consumption_return table
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_consumption_return.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    02/05/2019: xdong: widen lot_alias input from varchar(20) to varchar(30) following changes of the same column in lot_history and lot_status				
*/
DELIMITER $  
DROP TABLE IF EXISTS `consumption_return`$
CREATE TABLE `consumption_return` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(30) DEFAULT NULL,
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
﻿/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_attribute_definition.sql
*    Created By             : Xueyan Dong
*    Date Created           : 06/19/2019
*    Platform Dependencies  : MySql
*    Description            : This table stores attribute defintions. Attribute can be for materials or for products or potentially for any objects in eZOOM'
*                             this table describes the defintion of these attributes. Actual values will be stored in the attribute value table. Attributes are
*                             for storing charateristics of object instances that may not be rudimentary for the software, but needed for actual operation.alter
*                             Each object may have values of different attributes.
*    example	            : 
*    Log                    :
*    6/19/2018: Xueyan Dong: First Created. 					
*/
DELIMITER $ 
DROP TABLE IF EXISTS `attribute_definition`$
CREATE TABLE `attribute_definition` (
  `attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- unique id of the attribute
  `attr_name` nvarchar(255) NOT NULL,  -- name of the attribute
  `attr_usage` enum('in','out','both') NOT NULL DEFAULT 'both', -- used as input or output or both
  -- the object type that the attribute belongs to. for example product attributes, material attributes or employeeattributes
  `attr_parent_type` enum('product', 'material','employee'), 
  -- data type of the attribute. 
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time', 'text', 'mediumtext', 'longtext','enum') NOT NULL,
  `length` smallint(5) unsigned DEFAULT NULL,  -- max length of the value. For decimal, the max length of the integral part
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,  -- max length of the decimal part of the value
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether the attribute is key attribute, which requires value by the parent object
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether the attribute is optional, which the parent object may not set up value
  `uom_id` smallint(3) unsigned DEFAULT NULL,  -- unit of measure of the attribute value if data_type is numerical measurement
  `max_value` text DEFAULT NULL,  -- max value of the attribute value can have
  `min_value` text DEFAULT NULL,  -- min value of the attribute value can have
  `enum_values` text DEFAULT NULL,  -- all possible enumeration values of the attribute can have
  `description` text DEFAULT NULL,  -- description of the attribute definition
  `comment` text DEFAULT NULL, -- extra comment for the attribute, if any
  `create_date` datetime DEFAULT NULL,  -- datetime that the attribute definitoin is created here
  `update_date` datetime DEFAULT NULL -- datetime that the attribute defintion is updated
) ENGINE=InnoDB$

﻿/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_attribute_value.sql
*    Created By             : Xueyan Dong
*    Date Created           : 06/19/2019
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Xueyan Dong: First Created					
*/
DELIMITER $  
DROP TABLE IF EXISTS `attribute_value`$
CREATE TABLE `attribute_value` (
  `parent_id` int(10) unsigned NOT NULL,  -- the id of the parent object. For example, if parent type is product, then it is a product id
  `attr_id` int(11) unsigned NOT NULL,  -- id of the attribute definition
  `attr_value` text DEFAULT NULL,  -- value of the attribute for the parent object
  `create_date` datetime DEFAULT NULL, -- datetime that the value is created
  `update_date` datetime DEFAULT NULL, -- datetime that the value is updated
  `recorder` int(10) DEFAULT NULL, -- the id of the employee who input the value in ezoom
  `comment` text,  -- any comment regarding the value
  PRIMARY KEY (`parent_id`,`attr_id`)
) ENGINE=InnoDB$