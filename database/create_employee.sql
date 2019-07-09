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
  PRIMARY KEY (`id`),
  UNIQUE KEY `em_un1` (`username`)
) ENGINE=InnoDB$