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