/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `system_roles`$
CREATE TABLE `system_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Admin');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Manager');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'QA');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Engineer');

DROP TABLE IF EXISTS `users_in_roles`;
CREATE TABLE `users_in_roles` (
  `userId` int(11) NOT NULL DEFAULT '0',
  `roleId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userId`,`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

Insert into `users_in_roles` (`userId`, `roleId`) values(1, 1);
Insert into `users_in_roles` (`userId`, `roleId`) values(2, 1);
Insert into `users_in_roles` (`userId`, `roleId`) values(3, 3)$