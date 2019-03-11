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
