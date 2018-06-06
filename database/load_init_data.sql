-- insert into priorty table
Insert into priority (name) value("Low");
Insert into priority (name) value("Normal");
Insert into priority (name) value("High");
Insert into priority (name) value("Critical");
Insert into priority (name) value("Showstopper");
-- insert company into organization table at set up
INSERT INTO organization (name, description)
VALUES ('company', 'This is the most top level organization for the company');

-- insert company specific information
 INSERT INTO company (name, 
                   db_name, 
                   domain_name, 
                   status, 
                   timezone, 
                   daylightsaving_starttime, 
                   daylightsaving_endtime, 
                   password, 
                   plan, 
                   contact, 
                   address, 
                   city, 
                   state, 
                   country, 
                   create_time, 
                   created_by, 
                   description, 
                   comment)
  VALUES('SimplyLEDs', 
         'ezMES',
         'simplyleds.ambersoftsys.com',
         'active',
         '-05:00',
         '2010-04-03',
         '2010-11-13',
         'test',
         'vip',
         'info@ambersoftsys.com',
         '25 park city',
         'boise',
         'ID',
         'USA',
         now(),
         'Xueyan Dong',
         'test',
         'test');

-- insert a dummy employee group to be used by everybody initially.
INSERT INTO employee_group (name, or_id, ifprivilege, description)
VALUES('general', 1, 0, 'This group represents the whole company');

-- insert an admin account
INSERT INTO employee 
  (company_id, 
  username, 
  `password`, 
  status, 
  or_id,
  eg_id,
  firstname,
  lastname,
  comment)
 VALUES ( '00000', 'admin','admin', 'active', 1, 1, 'admin', 'admin',  
      'This is the first virtual user used by admins');
 
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Admin');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Manager');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'QA');
Insert into `system_roles` ( `applicationId`, `name`) values (1, 'Engineer');

Insert into `users_in_roles` (`userId`, `roleId`) values(1, 1);

 -- insert a dummy location to be used by all equipments and equipment groups
INSERT INTO location (name, create_time, contact_employee, description)
VALUES ('company', now(), 1, 'This is the location representing the whole company');

-- insert a dummy equipment group to be used by all equipments
INSERT INTO equipment_group (name, location_id, create_time, created_by, description)
VALUES ('general', 1, now(), 1, 'This group is a general group that can be used by any equipment');

-- insert a dummy material group to be used by all materials
INSERT INTO material_group (name, description)
VALUES ('general', 'This group is a general group that can be used by any material');

-- insert a dummy process group to be used by all processes
INSERT INTO process_group (name, create_time, created_by, description)
VALUES('general', now(), 1, 'This group is a general group that can be used by any process');

-- insert a dummy product group to be used by all products
INSERT INTO product_group (name, create_time, created_by, description)
VALUES ('general', now(), 1, 'This group is a general group that can be used by any product');

-- insert step type
-- 6/5/2018:xdong: added new step_stype Add Product To Inventory
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('condition',10,3,now(),'Condition takes at least three parameters: x operator Y');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('display message',10,1,now(),'Dispaly message is the only required parameter.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`update_time`,`description`) 
VALUES ('call api',10,1,now(),null,'api name is the required parameter.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('check list',0,1,now(),'At list one item is required.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('hold lot',0,0,now(),'No parameter required and lot number is supplied when executed.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`)
VALUES ('hold equipment',0,0,now(),'No parameter required and equiipment id is supplied when executed.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('email',10,3,now(),'email address, subject, and content are required');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('consume material',0,0,now(),'recipe is supplied as a column value.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('reposition',0,0,now(),'No parameter is needed.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('ship to warehouse',0,0,now(),'No parameter is needed.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('scrap',0,0,now(),'No parameter is needed.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES ('deliver to customer',0,0,now(),'No parameter is needed.Receiving information carried in lot comment');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES('disassemble', 0, 0, now(),  'disassemble products into one or multiple components. recipe is supplied as a column value.');
INSERT INTO `step_type`(`name`,`max_para_count`,`min_para_count`,`create_time`,`description`) 
VALUES('Add Product To Inv', 0, 0, now(),  'Add final product to the product inventory pool. No parameter needed.');
