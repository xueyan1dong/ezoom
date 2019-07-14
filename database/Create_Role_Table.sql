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