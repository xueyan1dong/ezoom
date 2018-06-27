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
