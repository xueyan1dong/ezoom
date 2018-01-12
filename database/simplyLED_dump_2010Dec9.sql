-- phpMyAdmin SQL Dump
-- version 2.11.6
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Dec 09, 2010 at 12:27 PM
-- Server version: 5.0.45
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `testSimplyleds`
--

-- --------------------------------------------------------

--
-- Table structure for table `attribute_history`
--

DROP TABLE IF EXISTS `attribute_history`;
CREATE TABLE IF NOT EXISTS `attribute_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `parent_type` enum('product','equipment') NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_value` varchar(255) default NULL,
  `attr_type` enum('in','out','both') NOT NULL default 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime') NOT NULL,
  `length` int(4) unsigned default NULL,
  `decimal_length` tinyint(1) unsigned default NULL,
  `key_attr` tinyint(1) unsigned NOT NULL default '0',
  `optional` tinyint(1) unsigned NOT NULL default '0',
  `max_value` varchar(255) default NULL,
  `min_value` varchar(255) default NULL,
  `enum_values` varchar(255) default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`event_time`,`parent_type`,`parent_id`,`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `attribute_history`
--


-- --------------------------------------------------------

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  `type` enum('supplier','customer','both') NOT NULL,
  `internal_contact_id` int(10) unsigned NOT NULL,
  `company_phone` varchar(20) default NULL,
  `address` varchar(255) default NULL,
  `city` varchar(20) default NULL,
  `state` varchar(20) default NULL,
  `zip` varchar(10) default NULL,
  `country` varchar(20) default 'USA',
  `address2` varchar(255) default NULL,
  `city2` varchar(20) default NULL,
  `state2` varchar(20) default NULL,
  `zip2` varchar(10) default NULL,
  `contact_person1` varchar(20) NOT NULL,
  `contact_person2` varchar(20) default NULL,
  `person1_workphone` varchar(20) default NULL,
  `person1_cellphone` varchar(20) default NULL,
  `person1_email` varchar(40) NOT NULL,
  `person2_workphone` varchar(20) default NULL,
  `person2_cellphone` varchar(20) default NULL,
  `person2_email` varchar(20) default NULL,
  `firstlistdate` date NOT NULL,
  `updateddate` date default NULL,
  `ifactive` tinyint(1) unsigned NOT NULL default '1',
  `comment` text,
  PRIMARY KEY  (`id`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(1, 'Excelsys', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'sales@simplyleds.com', NULL, NULL, NULL, '2010-09-27', '2010-09-27', 1, 'supplier for power supply');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(2, 'AeroLEDs', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'supplier of leds');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(3, 'Nelsons', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'supplier of plate and standoffs.');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(4, 'Industrial HW', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'Other hardwares used in assembly');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(5, 'Digi-Key', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'supplier of connectors and pins');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(6, 'Shipping Supplies', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'supplier of shipping products (labels, wraps, box)');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(7, 'Tool Supplies', 'supplier', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, 'n/a', NULL, NULL, NULL, '2010-09-27', NULL, 1, 'Tools used: sanding discs, drill, taps, templates.');
INSERT INTO `client` (`id`, `name`, `type`, `internal_contact_id`, `company_phone`, `address`, `city`, `state`, `zip`, `country`, `address2`, `city2`, `state2`, `zip2`, `contact_person1`, `contact_person2`, `person1_workphone`, `person1_cellphone`, `person1_email`, `person2_workphone`, `person2_cellphone`, `person2_email`, `firstlistdate`, `updateddate`, `ifactive`, `comment`) VALUES(8, 'testBuyer', 'customer', 3, '860-799831', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Jane', NULL, NULL, NULL, 'janey@yahoo.com', NULL, NULL, NULL, '2010-10-05', NULL, 1, 'test');

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
CREATE TABLE IF NOT EXISTS `company` (
  `id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `db_name` varchar(50) NOT NULL,
  `domain_name` varchar(50) NOT NULL,
  `status` enum('inactive','active') NOT NULL,
  `timezone` char(6) NOT NULL,
  `daylightsaving_starttime` datetime default NULL,
  `daylightsaving_endtime` datetime default NULL,
  `password` varchar(20) NOT NULL,
  `plan` varchar(255) default NULL,
  `contact` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `city` varchar(60) default NULL,
  `state` varchar(60) default NULL,
  `country` varchar(60) default NULL,
  `create_time` datetime NOT NULL,
  `created_by` varchar(60) NOT NULL,
  `state_change_time` datetime default NULL,
  `state_changed_by` varchar(60) default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `name`, `db_name`, `domain_name`, `status`, `timezone`, `daylightsaving_starttime`, `daylightsaving_endtime`, `password`, `plan`, `contact`, `address`, `city`, `state`, `country`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `description`, `comment`) VALUES(1, 'SimplyLEDs', 'testSimplyleds', 'simplyleds.ambersoftsys.com', 'active', '-7:00', '2010-03-13 02:00:00', '2010-11-07 02:00:00', 'test', 'basic', NULL, NULL, NULL, NULL, NULL, '2010-11-09 17:56:33', 'Xueyan Dong', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `config_history`
--

DROP TABLE IF EXISTS `config_history`;
CREATE TABLE IF NOT EXISTS `config_history` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `event_time` datetime NOT NULL,
  `source_table` varchar(20) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','production','frozen','checkout','checkin','engineer') default NULL,
  `new_state` enum('inactive','production','frozen','checkout','checkin','engineer','deleted') NOT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text,
  `new_record` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `config_history`
--

INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(1, '2010-09-24 07:17:59', 'process', 1, NULL, 'production', 1, '0', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(2, '2010-09-24 11:39:07', 'product', 1, NULL, 'production', 3, 'product RACN-ASL-6001N-P0000N-E075277-050 is created', '<PRODUCT><PG_ID>14</PG_ID><NAME>RACN-ASL-6001N-P0000N-E075277-050</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>5</LIFESPAN><CREATE_TIME>2010-09-24 11:39:07</CREATE_TIME><CREATED_BY>3</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>JosephOregon</DESCRIPTION><COMMENT></COMMENT></PRODUCT>');
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(3, '2010-09-26 20:19:10', 'step', 1, NULL, 'production', 3, 'Step JO Display Diagram is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(4, '2010-09-27 08:38:22', 'step', 2, NULL, 'production', 3, 'Step Prepare Base Plate is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(5, '2010-09-27 08:38:48', 'step', 3, NULL, 'production', 3, 'Step LED Bundle Assembly is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(6, '2010-09-27 08:41:46', 'step', 1, 'production', 'production', 3, 'step Display Complete Wiring Diagram updated', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(7, '2010-09-28 08:14:39', 'step', 4, NULL, 'production', 3, 'Step Power Supply is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(8, '2010-09-28 08:14:59', 'step', 4, 'production', 'production', 3, 'step Power Supply updated', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(9, '2010-09-28 08:33:44', 'step', 5, NULL, 'production', 3, 'Step LED Mounting is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(10, '2010-09-28 08:43:16', 'step', 6, NULL, 'production', 3, 'Step Wiring is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(11, '2010-09-28 08:50:09', 'step', 7, NULL, 'production', 3, 'Step Pack Finished Product is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(12, '2010-09-28 08:50:39', 'step', 7, 'production', 'production', 3, 'step Pack Finished Product updated', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(13, '2010-10-06 18:36:24', 'step', 8, NULL, 'production', 5, 'Step step1 is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(14, '2010-10-06 18:36:53', 'step', 9, NULL, 'production', 5, 'Step step2 is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(15, '2010-10-06 18:37:08', 'step', 10, NULL, 'production', 5, 'Step step3 is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(16, '2010-10-06 18:37:54', 'process', 2, NULL, 'production', 5, 'processprocess1is created', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(17, '2010-10-06 18:42:08', 'product', 2, NULL, 'production', 5, 'product product1 is created', '<PRODUCT><PG_ID>14</PG_ID><NAME>product1</NAME><STATE>production</STATE><LOT_SIZE>4.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>30</LIFESPAN><CREATE_TIME>2010-10-06 18:42:08</CREATE_TIME><CREATED_BY>5</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>desc</DESCRIPTION><COMMENT>comm</COMMENT></PRODUCT>');
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(18, '2010-10-21 08:18:38', 'product', 2, 'production', 'production', 3, 'product product1 updated', '<PRODUCT><PG_ID>14</PG_ID><NAME>product1</NAME><STATE>production</STATE><LOT_SIZE>4.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>30</LIFESPAN><CREATE_TIME>2010-10-06 18:42:08</CREATE_TIME><CREATED_BY>5</CREATED_BY><STATE_CHANGE_TIME>2010-10-21 08:18:38</STATE_CHANGE_TIME><STATE_CHANGED_BY>3</STATE_CHANGED_BY><DESCRIPTION>desc</DESCRIPTION><COMMENT>test time</COMMENT></PRODUCT>');
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(19, '2010-11-29 09:57:43', 'step', 1, 'production', 'production', 3, 'step Display Complete Wiring Diagram updated', NULL);
INSERT INTO `config_history` (`id`, `event_time`, `source_table`, `source_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES(20, '2010-12-04 12:40:03', 'step', 1, 'production', 'production', 3, 'step Display Complete Wiring Diagram updated', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
CREATE TABLE IF NOT EXISTS `document` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `source_table` varchar(50) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `key_words` varchar(255) default NULL,
  `title` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `version` varchar(10) default NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `contact_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `updated_by` int(10) unsigned default NULL,
  `update_time` datetime default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `source_table` (`source_table`,`source_id`,`key_words`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `document`
--


-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE IF NOT EXISTS `employee` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `company_id` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `status` enum('active','inactive','removed') NOT NULL default 'active',
  `or_id` int(10) unsigned NOT NULL,
  `eg_id` int(10) unsigned default NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) NOT NULL,
  `middlename` varchar(20) default NULL,
  `email` varchar(45) default NULL,
  `phone` varchar(45) default NULL,
  `report_to` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `em_un1` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(1, '00000', 'admin', '@dmin', 'active', 1, 1, 'admin', 'admin', NULL, 'info@ambersoftsys.com', NULL, NULL, 'This is the first virtual user used by admins');
INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(2, '1', 'feix', 'test', 'active', 1, 1, 'Faye', 'Xue', NULL, 'faye_xue@yahoo.com', '703-888-8888', NULL, 'test');
INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(3, '1', 'susand', 'test', 'active', 1, 1, 'Susan', 'Dong', NULL, 'susan.dong@ambersoftsys.com', '8607998321', NULL, 'test');
INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(4, '1', 'janey', 'utah', 'inactive', 1, 1, 'Jie', 'Yu', NULL, 'cjaneyu@yahoo.com', NULL, NULL, NULL);
INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(5, '1', 'changqiw', 'china', 'inactive', 1, 1, 'Changqi', 'Wang', NULL, 'changqi_wang@hotmail.com', NULL, NULL, NULL);
INSERT INTO `employee` (`id`, `company_id`, `username`, `password`, `status`, `or_id`, `eg_id`, `firstname`, `lastname`, `middlename`, `email`, `phone`, `report_to`, `comment`) VALUES(6, '1', 'colin', 'colin', 'inactive', 1, 1, 'wang', 'colin', 'M', 'changqi_wang@hotmail.com', '1234567', 1, 'aaaa');

-- --------------------------------------------------------

--
-- Table structure for table `employee_group`
--

DROP TABLE IF EXISTS `employee_group`;
CREATE TABLE IF NOT EXISTS `employee_group` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `or_id` int(10) unsigned NOT NULL,
  `ifprivilege` tinyint(1) unsigned NOT NULL default '0',
  `email` varchar(45) default NULL,
  `phone` varchar(45) default NULL,
  `lead_employee` int(10) unsigned default NULL,
  `description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `employee_group`
--

INSERT INTO `employee_group` (`id`, `name`, `or_id`, `ifprivilege`, `email`, `phone`, `lead_employee`, `description`) VALUES(1, 'general', 1, 0, NULL, NULL, NULL, 'This group represents the whole company');

-- --------------------------------------------------------

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
CREATE TABLE IF NOT EXISTS `equipment` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `eg_id` int(10) unsigned zerofill default NULL,
  `name` varchar(255) NOT NULL,
  `state` enum('inactive','up','down','qual','checkout','checkin') NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `create_time` datetime default NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime default NULL,
  `state_changed_by` int(10) unsigned default NULL,
  `contact_employee` int(10) unsigned default NULL,
  `manufacture_date` date default NULL,
  `manufacturer` varchar(255) default NULL,
  `manufacturer_phone` varchar(50) default NULL,
  `online_date` date default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `eq_un1` (`eg_id`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `equipment`
--

INSERT INTO `equipment` (`id`, `eg_id`, `name`, `state`, `location_id`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `contact_employee`, `manufacture_date`, `manufacturer`, `manufacturer_phone`, `online_date`, `description`, `comment`) VALUES(1, 0000000001, 'Dummy', 'up', 1, '2010-10-06 18:32:35', 5, NULL, NULL, 1, '2010-10-04', 'amat', '211ffasd', NULL, 'asdf', 'asdasd');
INSERT INTO `equipment` (`id`, `eg_id`, `name`, `state`, `location_id`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `contact_employee`, `manufacture_date`, `manufacturer`, `manufacturer_phone`, `online_date`, `description`, `comment`) VALUES(2, 0000000001, 'Dummy2', 'inactive', 1, '2010-10-06 18:34:54', 5, NULL, NULL, 1, '2010-10-05', NULL, NULL, NULL, NULL, 'aa');
INSERT INTO `equipment` (`id`, `eg_id`, `name`, `state`, `location_id`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `contact_employee`, `manufacture_date`, `manufacturer`, `manufacturer_phone`, `online_date`, `description`, `comment`) VALUES(3, 0000000001, 'Dummy3', 'inactive', 1, '2010-10-06 18:35:04', 5, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `equipment_group`
--

DROP TABLE IF EXISTS `equipment_group`;
CREATE TABLE IF NOT EXISTS `equipment_group` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) default NULL,
  `location_id` int(5) unsigned default NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `eg_un1` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `equipment_group`
--

INSERT INTO `equipment_group` (`id`, `name`, `prefix`, `location_id`, `create_time`, `created_by`, `description`, `comment`) VALUES(1, 'general', NULL, 1, '2010-09-22 19:49:42', 1, 'This group is a general group that can be used by any equipment', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `equip_history`
--

DROP TABLE IF EXISTS `equip_history`;
CREATE TABLE IF NOT EXISTS `equip_history` (
  `event_time` datetime NOT NULL,
  `equip_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','up','down','qual','checkout','checkin') default NULL,
  `new_state` enum('inactive','up','down','qual','checkout','checkin') default NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text character set latin1 NOT NULL,
  `new_record` text character set latin1,
  PRIMARY KEY  (`equip_id`,`event_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `equip_history`
--

INSERT INTO `equip_history` (`event_time`, `equip_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES('2010-10-06 18:32:35', 1, NULL, 'up', 5, 'equipment Dummy is created', NULL);
INSERT INTO `equip_history` (`event_time`, `equip_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES('2010-10-06 18:34:54', 2, NULL, 'inactive', 5, 'equipment Dummy2 is created', NULL);
INSERT INTO `equip_history` (`event_time`, `equip_id`, `old_state`, `new_state`, `employee`, `comment`, `new_record`) VALUES('2010-10-06 18:35:04', 3, NULL, 'inactive', 5, 'equipment Dummy3 is created', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `eq_attributes`
--

DROP TABLE IF EXISTS `eq_attributes`;
CREATE TABLE IF NOT EXISTS `eq_attributes` (
  `eq_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_value` varchar(255) default NULL,
  `attr_type` enum('in','out','both') NOT NULL default 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime') NOT NULL,
  `length` int(4) unsigned default NULL,
  `decimal_length` tinyint(1) unsigned default NULL,
  `key_attr` tinyint(1) unsigned NOT NULL default '0',
  `optional` tinyint(1) unsigned NOT NULL default '0',
  `max_value` varchar(255) default NULL,
  `min_value` varchar(255) default NULL,
  `enum_values` text,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`eq_id`,`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `eq_attributes`
--


-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `create_time` datetime NOT NULL,
  `noter_id` int(10) unsigned NOT NULL,
  `contact_info` varchar(255) default NULL,
  `state` enum('issued','queued','in process','closed') default NULL,
  `priority_id` smallint(3) default NULL,
  `last_noter_id` int(10) unsigned default NULL,
  `last_note_time` datetime default NULL,
  `responder` varchar(20) default NULL,
  `last_respond_time` datetime default NULL,
  `subject` varchar(255) default NULL,
  `note` text,
  `response` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `create_time`, `noter_id`, `contact_info`, `state`, `priority_id`, `last_noter_id`, `last_note_time`, `responder`, `last_respond_time`, `subject`, `note`, `response`) VALUES(1, '2010-10-06 18:47:10', 5, '', 'issued', NULL, NULL, NULL, NULL, NULL, 'aaaaaaaa', 'test', NULL);
INSERT INTO `feedback` (`id`, `create_time`, `noter_id`, `contact_info`, `state`, `priority_id`, `last_noter_id`, `last_note_time`, `responder`, `last_respond_time`, `subject`, `note`, `response`) VALUES(2, '2010-10-06 18:47:46', 5, 'asdaf', 'issued', NULL, NULL, NULL, NULL, NULL, 'aaaaaaaa', 'test', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
CREATE TABLE IF NOT EXISTS `ingredients` (
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned NOT NULL default '0',
  `mintime` int(10) unsigned default NULL,
  `maxtime` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`recipe_id`,`source_type`,`ingredient_id`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(2, 'material', 3, '1.0000', 1, 1, 0, 0, 'Metal Plate');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(2, 'material', 8, '3.0000', 1, 2, 0, 0, 'Screw');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(3, 'material', 2, '5.0000', 1, 1, 0, 0, 'Rebel LEDs');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(3, 'material', 5, '8.0000', 2, 2, 0, 0, 'shrink tube');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 1, '1.0000', 1, 1, 0, 0, 'Power supply');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 6, '2.0000', 1, 5, 0, 0, '8-32x1/4 socket cap screws');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 7, '2.0000', 1, 6, 0, 0, '10-32x1/2 SS socket cap screws');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 10, '2.0000', 1, 4, 0, 0, 'Flat wahser');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 13, '1.0000', 1, 3, 0, 0, 'Female connector');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(4, 'material', 14, '3.0000', 1, 2, 0, 0, 'Female pins');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(5, 'material', 4, '5.0000', 1, 1, 0, 0, 'Standoffs');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(5, 'material', 7, '10.0000', 1, 2, 0, 0, '10-32x1/2 socket cap screws');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(5, 'material', 9, '5.0000', 1, 4, 0, 0, '1/4-20x1/2 socket cap screw');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(5, 'material', 11, '5.0000', 1, 3, 0, 0, 'Lock washer');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(6, 'material', 12, '3.0000', 1, 0, 0, 0, 'orange wire nut');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(6, 'material', 18, '2.0000', 1, 0, 0, 0, 'black zip tie');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 15, '1.0000', 1, 0, 0, 0, 'Product label');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 16, '1.0000', 1, 0, 0, 0, 'Dimensions label');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 17, '1.0000', 1, 0, 0, 0, 'Warning label');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 19, '1.0000', 1, 0, 0, 0, 'Shipping box');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 20, '1.0000', 1, 0, 0, 0, 'Shipping tape');
INSERT INTO `ingredients` (`recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES(7, 'material', 21, '4.0000', 3, 0, 0, 0, 'Shipping bubble wrap');

-- --------------------------------------------------------

--
-- Table structure for table `ingredients_history`
--

DROP TABLE IF EXISTS `ingredients_history`;
CREATE TABLE IF NOT EXISTS `ingredients_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned default NULL,
  `mintime` int(10) unsigned default NULL,
  `maxtime` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`event_time`,`recipe_id`,`source_type`,`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ingredients_history`
--

INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-27 08:10:11', 3, 'insert', 2, 'material', 3, '1.0000', 1, 1, 0, 0, 'Metal Plate');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-27 08:11:07', 3, 'insert', 2, 'material', 8, '3.0000', 1, 2, 0, 0, 'Screw');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-27 08:36:37', 3, 'insert', 3, 'material', 2, '5.0000', 1, 1, 0, 0, 'Rebel LEDs');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-27 08:37:10', 3, 'insert', 3, 'material', 5, '8.0000', 2, 2, 0, 0, 'shrink tube');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:49:46', 3, 'insert', 4, 'material', 1, '1.0000', 1, 0, 0, 0, 'Power supply');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:50:29', 3, 'insert', 4, 'material', 14, '3.0000', 1, 0, 0, 0, 'Female pins');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:51:02', 3, 'insert', 4, 'material', 13, '1.0000', 1, 0, 0, 0, 'Female connector');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:51:58', 3, 'insert', 4, 'material', 10, '2.0000', 1, 4, 0, 0, 'Flat wahser');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:55:47', 3, 'modify', 4, 'material', 1, '1.0000', 1, 1, 0, 0, 'Power supply');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:56:31', 3, 'modify', 4, 'material', 14, '3.0000', 1, 2, 0, 0, 'Female pins');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:56:39', 3, 'modify', 4, 'material', 13, '1.0000', 1, 3, 0, 0, 'Female connector');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:57:27', 3, 'insert', 4, 'material', 6, '2.0000', 1, 5, 0, 0, '8-32x1/4 socket cap screws');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 07:58:03', 3, 'insert', 4, 'material', 7, '2.0000', 1, 6, 0, 0, '10-32x1/2 SS socket cap screws');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:30:17', 3, 'insert', 5, 'material', 7, '10.0000', 1, 1, 0, 0, '10-32x1/2 socket cap screws');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:30:57', 3, 'insert', 5, 'material', 11, '5.0000', 1, 2, 0, 0, '');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:31:08', 3, 'modify', 5, 'material', 11, '5.0000', 1, 2, 0, 0, 'Lock washer');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:31:52', 3, 'insert', 5, 'material', 9, '5.0000', 1, 3, 0, 0, '1/4-20x1/2 socket cap screw');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:41:54', 3, 'insert', 6, 'material', 12, '3.0000', 1, 0, 0, 0, 'orange wire nut');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:42:21', 3, 'insert', 6, 'material', 18, '2.0000', 1, 0, 0, 0, 'black zip tie');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:47:31', 3, 'insert', 7, 'material', 15, '1.0000', 1, 0, 0, 0, 'Product label');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:47:53', 3, 'insert', 7, 'material', 16, '1.0000', 1, 0, 0, 0, 'Dimensions label');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:48:12', 3, 'insert', 7, 'material', 17, '1.0000', 1, 0, 0, 0, 'Warning label');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:48:32', 3, 'insert', 7, 'material', 19, '1.0000', 1, 0, 0, 0, 'Shipping box');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:48:48', 3, 'insert', 7, 'material', 20, '1.0000', 1, 0, 0, 0, 'Shipping tape');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-28 08:49:15', 3, 'insert', 7, 'material', 21, '4.0000', 3, 0, 0, 0, 'Shipping bubble wrap');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-29 06:46:31', 3, 'insert', 5, 'material', 4, '5.0000', 1, 1, 0, 0, 'Standoffs');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-29 06:47:02', 3, 'modify', 5, 'material', 9, '5.0000', 1, 4, 0, 0, '1/4-20x1/2 socket cap screw');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-29 06:47:11', 3, 'modify', 5, 'material', 11, '5.0000', 1, 3, 0, 0, 'Lock washer');
INSERT INTO `ingredients_history` (`event_time`, `employee_id`, `action`, `recipe_id`, `source_type`, `ingredient_id`, `quantity`, `uom_id`, `order`, `mintime`, `maxtime`, `comment`) VALUES('2010-09-29 06:47:20', 3, 'modify', 5, 'material', 7, '10.0000', 1, 2, 0, 0, '10-32x1/2 socket cap screws');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
CREATE TABLE IF NOT EXISTS `inventory` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `source_type` enum('manufactured','purchased') NOT NULL,
  `pd_or_mt_id` int(10) unsigned NOT NULL COMMENT 'product or material id',
  `supplier_id` int(10) unsigned NOT NULL COMMENT 'manufactured product has client id as 0, otherwise, the client id should be from client table',
  `lot_id` varchar(20) NOT NULL COMMENT 'if the inventory is purchased, the lot id may come from client, otherwise, it is the lot id',
  `serial_no` varchar(20) default NULL,
  `out_order_id` varchar(20) default NULL COMMENT 'This is the order id issued to supplier to purchase.',
  `in_order_id` varchar(20) default NULL COMMENT 'This is the order id from order table, which issued by client to buy products.',
  `original_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `manufacture_date` datetime NOT NULL,
  `expiration_date` datetime default NULL,
  `arrive_date` datetime NOT NULL,
  `recorded_by` int(10) unsigned NOT NULL,
  `contact_employee` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `inventory_un01` (`source_type`,`pd_or_mt_id`,`supplier_id`,`lot_id`,`serial_no`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `source_type`, `pd_or_mt_id`, `supplier_id`, `lot_id`, `serial_no`, `out_order_id`, `in_order_id`, `original_quantity`, `actual_quantity`, `uom_id`, `manufacture_date`, `expiration_date`, `arrive_date`, `recorded_by`, `contact_employee`, `comment`) VALUES(1, 'manufactured', 2, 0, 'lot1', NULL, NULL, '1', '3.0000', '2.0000', 1, '2010-10-05 00:00:00', NULL, '2010-10-10 00:00:00', 5, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_consumption`
--

DROP TABLE IF EXISTS `inventory_consumption`;
CREATE TABLE IF NOT EXISTS `inventory_consumption` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) default NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) default NULL,
  `inventory_id` int(10) unsigned NOT NULL,
  `quantity_used` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned default NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned default NULL,
  `step_id` int(10) unsigned NOT NULL,
  `operator_id` int(10) unsigned NOT NULL,
  `equipment_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`lot_id`,`start_timecode`,`inventory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `inventory_consumption`
--


-- --------------------------------------------------------

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `parent_loc_id` varchar(45) default NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime default NULL,
  `contact_employee` int(10) unsigned NOT NULL,
  `adjacent_loc_id1` int(5) unsigned default NULL,
  `adjacent_loc_id2` int(5) unsigned default NULL,
  `adjacent_loc_id3` int(5) unsigned default NULL,
  `adjacent_loc_id4` int(5) unsigned default NULL,
  `description` varchar(255) default NULL,
  `comment` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`id`, `name`, `parent_loc_id`, `create_time`, `update_time`, `contact_employee`, `adjacent_loc_id1`, `adjacent_loc_id2`, `adjacent_loc_id3`, `adjacent_loc_id4`, `description`, `comment`) VALUES(1, 'company', NULL, '2010-09-22 19:49:42', NULL, 1, NULL, NULL, NULL, NULL, 'This is the location representing the whole company', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lot_history`
--

DROP TABLE IF EXISTS `lot_history`;
CREATE TABLE IF NOT EXISTS `lot_history` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) default NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) default NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned default NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned default NULL,
  `step_id` int(10) unsigned NOT NULL,
  `start_operator_id` int(10) unsigned NOT NULL,
  `end_operator_id` int(10) unsigned default NULL,
  `status` enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned default NULL,
  `end_quantity` decimal(16,4) unsigned default NULL,
  `uomid` smallint(3) unsigned default NULL,
  `equipment_id` int(10) unsigned default NULL,
  `device_id` int(10) unsigned default NULL,
  `approver_id` int(10) unsigned default NULL,
  `result` text,
  PRIMARY KEY  (`lot_id`,`start_timecode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lot_history`
--

INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(2, 'RACN-ASL-60000000001', '201011091602520', '201011091602520', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(2, 'RACN-ASL-60000000001', '201012050356300', '201012050356300', 1, NULL, 1, NULL, 1, 2, 2, 'ended', '1.0000', '1.0000', 1, NULL, NULL, NULL, 'T');
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(2, 'RACN-ASL-60000000001', '201012050357000', NULL, 1, NULL, 2, NULL, 2, 2, NULL, 'started', '1.0000', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(3, 'RACN-ASL-60000000002', '201011091602520', '201011091602520', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(4, 'RACN-ASL-60000000003', '201011091602570', '201011091602570', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(5, 'RACN-ASL-60000000004', '201011091602570', '201011091602570', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(6, 'RACN-ASL-60000000005', '201011091602590', '201011091602590', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(6, 'RACN-ASL-60000000005', '201012050357310', '201012050357310', 1, NULL, 1, NULL, 1, 2, 2, 'ended', '1.0000', '1.0000', 1, NULL, NULL, NULL, 'T');
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(6, 'RACN-ASL-60000000005', '201012050357350', NULL, 1, NULL, 2, NULL, 2, 2, NULL, 'started', '1.0000', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(7, 'RACN-ASL-60000000006', '201011091602590', '201011091602590', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(8, 'RACN-ASL-60000000007', '201011091603130', '201011091603130', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(9, 'RACN-ASL-60000000008', '201011091603130', '201011091603130', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(10, 'RACN-ASL-60000000009', '201011091603280', '201011091603280', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(11, 'RACN-ASL-60000000010', '201011091614160', '201011091614160', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(12, 'RACN-ASL-60000000011', '201011091619230', '201011091619230', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(13, 'RACN-ASL-60000000012', '201011091622080', '201011091622080', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(14, 'RACN-ASL-60000000013', '201011091646000', '201011091646000', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(15, 'RACN-ASL-60000000014', '201011091646000', '201011091646000', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(16, 'RACN-ASL-60000000015', '201011091738170', '201011091738170', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(17, 'RACN-ASL-60000000016', '201011120904590', '201011120904590', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(18, 'RACN-ASL-60000000017', '201011121116080', '201011121116080', 1, NULL, 0, NULL, 0, 3, 3, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(19, 'RACN-ASL-60000000018', '201011291233170', '201011291233170', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(19, 'RACN-ASL-60000000018', '201012042040360', '201012042040360', 1, NULL, 1, NULL, 1, 3, 3, 'ended', '1.0000', '1.0000', 1, NULL, NULL, NULL, 'T');
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(20, 'RACN-ASL-60000000019', '201011291233330', '201011291233330', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(20, 'RACN-ASL-60000000019', '201012050351100', '201012050351100', 1, NULL, 1, NULL, 1, 2, 2, 'ended', '1.0000', '1.0000', 1, NULL, NULL, NULL, 'T');
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(20, 'RACN-ASL-60000000019', '201012050352180', NULL, 1, NULL, 2, NULL, 2, 2, NULL, 'started', '1.0000', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(21, 'RACN-ASL-60000000020', '201011291233550', '201011291233550', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(22, 'RACN-ASL-60000000021', '201011291235240', '201011291235240', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(23, 'RACN-ASL-60000000022', '201011292118000', '201011292118000', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(24, 'RACN-ASL-60000000023', '201011292118000', '201011292118000', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(24, 'RACN-ASL-60000000023', '201012092020400', '201012092020400', 1, NULL, 1, NULL, 1, 3, 3, 'ended', '1.0000', '1.0000', 1, NULL, NULL, NULL, 'T');
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(24, 'RACN-ASL-60000000023', '201012092020450', NULL, 1, NULL, 2, NULL, 2, 3, NULL, 'started', '1.0000', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `lot_history` (`lot_id`, `lot_alias`, `start_timecode`, `end_timecode`, `process_id`, `sub_process_id`, `position_id`, `sub_position_id`, `step_id`, `start_operator_id`, `end_operator_id`, `status`, `start_quantity`, `end_quantity`, `uomid`, `equipment_id`, `device_id`, `approver_id`, `result`) VALUES(25, 'RACN-ASL-60000000024', '201011292118000', '201011292118000', 1, NULL, 0, NULL, 0, 2, 2, 'dispatched', '1.0000', '1.0000', 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lot_status`
--

DROP TABLE IF EXISTS `lot_status`;
CREATE TABLE IF NOT EXISTS `lot_status` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `alias` varchar(20) default NULL,
  `order_id` int(10) unsigned default NULL,
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `status` enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned default NULL,
  `uomid` smallint(5) unsigned NOT NULL,
  `update_timecode` char(15) default NULL,
  `contact` int(10) unsigned default NULL,
  `priority` tinyint(2) unsigned NOT NULL default '0',
  `dispatcher` int(10) unsigned NOT NULL,
  `dispatch_time` datetime NOT NULL,
  `output_time` datetime default NULL,
  `comment` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `lot_status`
--

INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(2, 'RACN-ASL-60000000001', 1, 1, 1, 'in process', '1.0000', '1.0000', 1, '201012050357000', 3, 2, 3, '2010-11-09 16:02:52', NULL, '');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(3, 'RACN-ASL-60000000002', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091602520', 3, 2, 3, '2010-11-09 16:02:52', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(4, 'RACN-ASL-60000000003', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091602570', 3, 2, 3, '2010-11-09 16:02:57', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(5, 'RACN-ASL-60000000004', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091602570', 3, 2, 3, '2010-11-09 16:02:57', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(6, 'RACN-ASL-60000000005', 1, 1, 1, 'in process', '1.0000', '1.0000', 1, '201012050357350', 3, 2, 3, '2010-11-09 16:02:59', NULL, '');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(7, 'RACN-ASL-60000000006', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091602590', 3, 2, 3, '2010-11-09 16:02:59', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(8, 'RACN-ASL-60000000007', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091603130', 3, 2, 3, '2010-11-09 16:03:13', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(9, 'RACN-ASL-60000000008', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091603130', 3, 2, 3, '2010-11-09 16:03:13', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(10, 'RACN-ASL-60000000009', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091603280', 3, 2, 3, '2010-11-09 16:03:28', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(11, 'RACN-ASL-60000000010', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091614160', 3, 2, 3, '2010-11-09 16:14:16', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(12, 'RACN-ASL-60000000011', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091619230', 3, 2, 3, '2010-11-09 16:19:23', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(13, 'RACN-ASL-60000000012', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091622080', 3, 2, 3, '2010-11-09 16:22:08', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(14, 'RACN-ASL-60000000013', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091646000', 3, 2, 3, '2010-11-09 16:46:00', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(15, 'RACN-ASL-60000000014', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091646000', 3, 2, 3, '2010-11-09 16:46:00', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(16, 'RACN-ASL-60000000015', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011091738170', 3, 2, 3, '2010-11-09 17:38:17', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(17, 'RACN-ASL-60000000016', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011120904590', 3, 2, 3, '2010-11-12 09:04:59', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(18, 'RACN-ASL-60000000017', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011121116080', 3, 2, 3, '2010-11-12 11:16:08', NULL, 'restored');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(19, 'RACN-ASL-60000000018', 1, 1, 1, 'in transit', '1.0000', '1.0000', 1, '201012042040360', 3, 1, 2, '2010-11-29 12:33:17', NULL, NULL);
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(20, 'RACN-ASL-60000000019', 1, 1, 1, 'in process', '1.0000', '1.0000', 1, '201012050352180', 3, 1, 2, '2010-11-29 12:33:33', NULL, '');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(21, 'RACN-ASL-60000000020', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011291233550', 3, 1, 2, '2010-11-29 12:33:55', NULL, NULL);
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(22, 'RACN-ASL-60000000021', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011291235240', 3, 1, 2, '2010-11-29 12:35:24', NULL, NULL);
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(23, 'RACN-ASL-60000000022', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011292118000', 3, 1, 2, '2010-11-29 21:18:00', NULL, NULL);
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(24, 'RACN-ASL-60000000023', 1, 1, 1, 'in process', '1.0000', '1.0000', 1, '201012092020450', 3, 1, 2, '2010-11-29 21:18:00', NULL, 'test');
INSERT INTO `lot_status` (`id`, `alias`, `order_id`, `product_id`, `process_id`, `status`, `start_quantity`, `actual_quantity`, `uomid`, `update_timecode`, `contact`, `priority`, `dispatcher`, `dispatch_time`, `output_time`, `comment`) VALUES(25, 'RACN-ASL-60000000024', 1, 1, 1, 'dispatched', '1.0000', '1.0000', 1, '201011292118000', 3, 1, 2, '2010-11-29 21:18:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
CREATE TABLE IF NOT EXISTS `material` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `mg_id` int(10) unsigned NOT NULL,
  `alias` varchar(255) default NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `lot_size` decimal(16,4) unsigned default NULL,
  `material_form` enum('solid','liquid','gas') NOT NULL,
  `status` enum('inactive','production','frozen') NOT NULL,
  `enlist_time` datetime NOT NULL,
  `enlisted_by` int(10) unsigned NOT NULL,
  `update_time` datetime default NULL,
  `updated_by` int(10) unsigned default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `ma_un1` (`name`,`alias`,`mg_id`,`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- Dumping data for table `material`
--

INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(1, 'LXV75-24SW', 1, '1', 1, '1.0000', 'solid', 'production', '2010-09-27 07:37:29', 3, NULL, NULL, 'Power supply', '$1.01/unit for shipping');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(2, 'Itineris 6001', 1, '2', 1, '100.0000', 'solid', 'production', '2010-09-27 07:38:21', 3, '2010-09-27 07:43:44', 3, 'LED Module', 'UL Listing E327051');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(3, 'BSPL-0001', 1, '3', 1, '10.0000', 'solid', 'production', '2010-09-27 07:38:55', 3, '2010-09-27 07:44:11', 3, 'AL Base Plate', 'Alum 0.1”');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(4, 'STOF-0001', 1, '3', 1, '10.0000', 'solid', 'production', '2010-09-27 07:39:32', 3, '2010-09-27 07:44:18', 3, 'AL Standoffs', 'Alum 0.1”');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(5, 'HS 08B ST221', 1, '4', 2, '1000.0000', 'solid', 'production', '2010-09-27 07:40:18', 3, '2010-09-27 07:41:43', 3, '½” Heat Shrink Tube', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(6, 'SSSH008104', 1, '4', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:43:12', 3, '2010-09-27 07:44:32', 3, 'SS Socket Cap Screw', '8-32x1/4');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(7, 'SSSH011008', 1, '4', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:45:06', 3, NULL, NULL, 'SS Socket Cap Screw', '10-32X1/2');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(8, 'SSSB040200', 1, '4', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:45:39', 3, NULL, NULL, 'SS Socket Cap Screw', '¼-20x2');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(9, 'SSSH040008', 1, '4', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:46:20', 3, NULL, NULL, 'SS Socket Cap Screw', '¼-20x1/2');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(10, 'SSFW008', 1, '4', 1, '100.0000', 'solid', 'production', '2010-09-27 07:47:18', 3, NULL, NULL, 'SS Flat Washer #8', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(11, 'SSLW040', 1, '4', 1, '100.0000', 'solid', 'production', '2010-09-27 07:47:43', 3, NULL, NULL, 'SS Lock Washer 1/4', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(12, 'TER6400 20503', 1, '4', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:48:09', 3, NULL, NULL, 'Wire Nuts', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(13, '1-480701-0', 1, 'A1451-ND', 1, '100.0000', 'solid', 'production', '2010-09-27 07:48:57', 3, NULL, NULL, 'Female Connector', '3 position');
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(14, '350550-1', 1, '5', 1, '100.0000', 'solid', 'production', '2010-09-27 07:49:42', 3, NULL, NULL, 'Female pins', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(15, 'ShipLabel_product', 1, NULL, 1, '1000.0000', 'solid', 'production', '2010-09-27 07:50:50', 3, NULL, NULL, 'Product Label', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(16, 'ShipLabel_dimension', 1, '6', 1, '1000.0000', 'solid', 'production', '2010-09-27 07:51:23', 3, '2010-10-27 10:42:00', 3, 'Dimensions Label', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(17, 'ShipLabel_warning', 1, NULL, 1, '1000.0000', 'solid', 'production', '2010-09-27 07:51:59', 3, NULL, NULL, 'Warning Label', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(18, 'ShipTieWraps', 1, NULL, 1, '1000.0000', 'solid', 'production', '2010-09-27 07:53:06', 3, NULL, NULL, 'Black Tie Wraps', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(19, 'ShipBox', 1, NULL, 1, '50.0000', 'solid', 'production', '2010-09-27 07:53:38', 3, NULL, NULL, 'Shipping Box', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(20, 'ShipTape', 1, NULL, 1, '100.0000', 'solid', 'production', '2010-09-27 07:54:08', 3, NULL, NULL, 'Shipping Tape', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(21, 'ShipBubbleWrap', 1, NULL, 3, '50.0000', 'solid', 'production', '2010-09-27 07:54:58', 3, '2010-09-27 07:55:29', 3, 'Shipping Bubble Wrap', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(22, 'testClothBlue', 1, 'ONBlue', 3, '1000.0000', 'solid', 'production', '2010-10-05 07:48:06', 3, NULL, NULL, 'test uom', NULL);
INSERT INTO `material` (`id`, `name`, `mg_id`, `alias`, `uom_id`, `lot_size`, `material_form`, `status`, `enlist_time`, `enlisted_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(24, 'heating oil', 1, '6', 3, '100.0000', 'liquid', 'production', '2010-10-27 10:42:41', 3, NULL, NULL, 'test', 'test');

-- --------------------------------------------------------

--
-- Table structure for table `material_group`
--

DROP TABLE IF EXISTS `material_group`;
CREATE TABLE IF NOT EXISTS `material_group` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `material_group`
--

INSERT INTO `material_group` (`id`, `name`, `description`, `comment`) VALUES(1, 'general', 'This group is a general group that can be used by any material', NULL);
INSERT INTO `material_group` (`id`, `name`, `description`, `comment`) VALUES(2, 'Industrial HW', 'Industrial HW', 'Industrial HW.');

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE IF NOT EXISTS `order_detail` (
  `order_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `unit_price` decimal(10,2) unsigned default NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL default '0.0000',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL default '0.0000',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL default '0.0000',
  `uomid` smallint(3) unsigned NOT NULL,
  `output_date` datetime default NULL,
  `expected_deliver_date` datetime default NULL,
  `actual_deliver_date` datetime default NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `comment` text,
  PRIMARY KEY  (`order_id`,`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`order_id`, `source_type`, `source_id`, `quantity_requested`, `unit_price`, `quantity_made`, `quantity_in_process`, `quantity_shipped`, `uomid`, `output_date`, `expected_deliver_date`, `actual_deliver_date`, `recorder_id`, `record_time`, `comment`) VALUES(1, 'product', 1, '200.0000', '100.00', '0.0000', '24.0000', '0.0000', 1, NULL, '2010-10-30 00:00:00', NULL, 2, '2010-12-09 08:06:45', '');
INSERT INTO `order_detail` (`order_id`, `source_type`, `source_id`, `quantity_requested`, `unit_price`, `quantity_made`, `quantity_in_process`, `quantity_shipped`, `uomid`, `output_date`, `expected_deliver_date`, `actual_deliver_date`, `recorder_id`, `record_time`, `comment`) VALUES(1, 'product', 2, '100.0000', '10.00', '0.0000', '0.0000', '0.0000', 1, NULL, NULL, NULL, 2, '2010-12-09 08:07:12', '');

-- --------------------------------------------------------

--
-- Table structure for table `order_general`
--

DROP TABLE IF EXISTS `order_general`;
CREATE TABLE IF NOT EXISTS `order_general` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `order_type` enum('inventory','customer','supplier') NOT NULL,
  `ponumber` varchar(40) default NULL,
  `client_id` int(10) unsigned default NULL,
  `priority` tinyint(2) unsigned NOT NULL default '0',
  `state` enum('quoted','POed','scheduled','produced','shipped','delivered','invoiced','paid') NOT NULL,
  `net_total` decimal(16,2) unsigned default NULL,
  `tax_percentage` tinyint(2) unsigned default NULL,
  `tax_amount` decimal(14,2) unsigned default NULL,
  `other_fees` decimal(16,2) unsigned default NULL,
  `total_price` decimal(16,2) unsigned default NULL,
  `expected_deliver_date` datetime default NULL,
  `internal_contact` int(10) unsigned NOT NULL,
  `external_contact` varchar(255) default NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`,`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `order_general`
--

INSERT INTO `order_general` (`id`, `order_type`, `ponumber`, `client_id`, `priority`, `state`, `net_total`, `tax_percentage`, `tax_amount`, `other_fees`, `total_price`, `expected_deliver_date`, `internal_contact`, `external_contact`, `comment`) VALUES(1, 'customer', 'test00001', 8, 1, 'POed', '100.00', 0, '0.00', '0.00', '0.00', '2010-10-14 00:00:00', 3, 'Jane Yu', '');

-- --------------------------------------------------------

--
-- Table structure for table `order_state_history`
--

DROP TABLE IF EXISTS `order_state_history`;
CREATE TABLE IF NOT EXISTS `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted','POed','scheduled','produced','shipped','delivered','invoiced','paid') NOT NULL,
  `state_date` datetime NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY  (`order_id`,`state`,`state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_state_history`
--

INSERT INTO `order_state_history` (`order_id`, `state`, `state_date`, `recorder_id`, `comment`) VALUES(1, 'POed', '2010-10-01 00:00:00', 3, '');

-- --------------------------------------------------------

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
CREATE TABLE IF NOT EXISTS `organization` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `lead_employee` int(10) unsigned default NULL,
  `parent_organization` int(10) unsigned default NULL,
  `phone` varchar(45) default NULL,
  `email` varchar(45) default NULL,
  `description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `organization`
--

INSERT INTO `organization` (`id`, `name`, `lead_employee`, `parent_organization`, `phone`, `email`, `description`) VALUES(1, 'company', NULL, NULL, NULL, NULL, 'This is the most top level organization for the company');

-- --------------------------------------------------------

--
-- Table structure for table `pd_attributes`
--

DROP TABLE IF EXISTS `pd_attributes`;
CREATE TABLE IF NOT EXISTS `pd_attributes` (
  `pd_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_value` varchar(255) default NULL,
  `attr_type` enum('in','out','both') NOT NULL default 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime') NOT NULL,
  `length` int(4) unsigned default NULL,
  `decimal_length` tinyint(1) unsigned default NULL,
  `key_attr` tinyint(1) unsigned NOT NULL default '0',
  `optional` tinyint(1) unsigned NOT NULL default '0',
  `max_value` varchar(255) default NULL,
  `min_value` varchar(255) default NULL,
  `enum_values` varchar(255) default NULL,
  `description` text character set latin1,
  `comment` text character set latin1,
  PRIMARY KEY  (`pd_id`,`attr_id`,`attr_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pd_attributes`
--


-- --------------------------------------------------------

--
-- Table structure for table `priority`
--

DROP TABLE IF EXISTS `priority`;
CREATE TABLE IF NOT EXISTS `priority` (
  `id` smallint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `priority`
--

INSERT INTO `priority` (`id`, `name`) VALUES(1, 'Low');
INSERT INTO `priority` (`id`, `name`) VALUES(2, 'Normal');
INSERT INTO `priority` (`id`, `name`) VALUES(3, 'High');
INSERT INTO `priority` (`id`, `name`) VALUES(4, 'Critical');
INSERT INTO `priority` (`id`, `name`) VALUES(5, 'Showstopper');

-- --------------------------------------------------------

--
-- Table structure for table `process`
--

DROP TABLE IF EXISTS `process`;
CREATE TABLE IF NOT EXISTS `process` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `prg_id` int(10) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `start_pos_id` int(5) unsigned default NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL default '0',
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime default NULL,
  `state_changed_by` int(10) unsigned default NULL,
  `usage` enum('sub process only','main process only','both') NOT NULL default 'both',
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pr_un1` (`name`,`version`,`prg_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `process`
--

INSERT INTO `process` (`id`, `name`, `version`, `prg_id`, `state`, `start_pos_id`, `owner_id`, `if_default_version`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `usage`, `description`, `comment`) VALUES(1, 'RACN-ASL-6001N-P000N-E075277-050', 1, 1, 'production', NULL, 3, 1, '2010-09-24 07:17:59', 1, '2010-09-28 09:06:44', 3, 'main process only', 'Assembly traveler flow for product with the same name.', '');
INSERT INTO `process` (`id`, `name`, `version`, `prg_id`, `state`, `start_pos_id`, `owner_id`, `if_default_version`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `usage`, `description`, `comment`) VALUES(2, 'process1', 1, 1, 'production', NULL, 1, 1, '2010-10-06 18:37:54', 5, '2010-10-06 18:39:23', 5, 'both', 'desc', 'comm');

-- --------------------------------------------------------

--
-- Table structure for table `process_group`
--

DROP TABLE IF EXISTS `process_group`;
CREATE TABLE IF NOT EXISTS `process_group` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) default NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime default NULL,
  `updated_by` int(10) unsigned default NULL,
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `prg_un1` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `process_group`
--

INSERT INTO `process_group` (`id`, `name`, `prefix`, `create_time`, `created_by`, `update_time`, `updated_by`, `description`, `comment`) VALUES(1, 'general', NULL, '2010-09-22 19:49:42', 1, NULL, NULL, 'This group is a general group that can be used by any process', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `process_step`
--

DROP TABLE IF EXISTS `process_step`;
CREATE TABLE IF NOT EXISTS `process_step` (
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `prev_step_pos` int(5) unsigned default NULL,
  `next_step_pos` int(5) unsigned default NULL,
  `false_step_pos` int(5) unsigned default NULL,
  `rework_limit` smallint(2) unsigned NOT NULL default '0',
  `if_sub_process` tinyint(1) unsigned NOT NULL default '0',
  `prompt` varchar(255) default NULL,
  `if_autostart` tinyint(1) unsigned NOT NULL default '1',
  `need_approval` tinyint(1) unsigned NOT NULL default '0',
  `approve_emp_usage` enum('employee group','employee category','employee') default NULL,
  `approve_emp_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `process_step`
--

INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 1, 1, NULL, 2, NULL, 0, 0, 'Please read and understand the diagram.', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 2, 2, 1, 3, NULL, 0, 0, 'Step 1', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 3, 3, 2, 4, NULL, 0, 0, 'Step 2', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 4, 4, 3, 5, NULL, 0, 0, 'step 3', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 5, 5, 4, 6, NULL, 0, 0, 'step 4', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 6, 6, 5, 7, NULL, 0, 0, 'step 5', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(1, 7, 7, 6, NULL, NULL, 0, 0, 'last step', 1, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(2, 1000, 8, NULL, NULL, NULL, 0, 0, '', 1, 1, 'employee', 1);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(2, 1010, 9, 1000, NULL, NULL, 0, 0, '', 0, 0, NULL, NULL);
INSERT INTO `process_step` (`process_id`, `position_id`, `step_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES(2, 1030, 1, 1000, NULL, NULL, 0, 0, '', 0, 1, 'employee', 1);

-- --------------------------------------------------------

--
-- Table structure for table `process_step_history`
--

DROP TABLE IF EXISTS `process_step_history`;
CREATE TABLE IF NOT EXISTS `process_step_history` (
  `event_time` datetime NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `prev_step_pos` int(5) unsigned default NULL,
  `next_step_pos` int(5) unsigned default NULL,
  `false_step_pos` int(5) unsigned default NULL,
  `rework_limit` smallint(2) unsigned NOT NULL default '0',
  `if_sub_process` tinyint(1) unsigned NOT NULL default '0',
  `prompt` varchar(255) default NULL,
  `if_autostart` tinyint(1) unsigned NOT NULL default '1',
  `need_approval` tinyint(1) unsigned NOT NULL default '0',
  `approve_emp_usage` enum('employee group','employee category','employee') default NULL,
  `approve_emp_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`event_time`,`process_id`,`position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `process_step_history`
--

INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-26 20:20:01', 1, 1, 1, 'insert', 3, NULL, 2, NULL, 0, 0, 'Please read and understand the diagram.', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-27 08:39:44', 1, 2, 2, 'insert', 3, 1, 3, NULL, 0, 0, 'Follow Instruction', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-27 08:40:20', 1, 3, 3, 'insert', 3, 2, 4, NULL, 0, 0, 'Step 2', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-27 08:40:29', 1, 2, 2, 'modify', 3, 1, 3, NULL, 0, 0, 'Step 1', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 08:15:47', 1, 4, 4, 'insert', 3, 3, 5, NULL, 0, 0, 'step 3', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 08:34:27', 1, 5, 5, 'insert', 3, 4, 6, NULL, 0, 0, 'step 4', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 08:43:51', 1, 6, 6, 'insert', 3, 5, 7, NULL, 0, 0, '', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 08:44:02', 1, 6, 6, 'modify', 3, 5, 7, NULL, 0, 0, 'step 5', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 08:53:49', 1, 7, 7, 'insert', 3, 6, NULL, NULL, 0, 0, 'last step', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-09-28 09:06:44', 1, 7, 7, 'modify', 3, 6, NULL, NULL, 0, 0, 'last step', 1, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-10-06 18:38:38', 2, 1000, 8, 'insert', 5, NULL, NULL, NULL, 0, 0, '', 1, 1, 'employee', 1);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-10-06 18:39:10', 2, 1010, 9, 'insert', 5, 1000, NULL, NULL, 0, 0, '', 0, 0, NULL, NULL);
INSERT INTO `process_step_history` (`event_time`, `process_id`, `position_id`, `step_id`, `action`, `employee_id`, `prev_step_pos`, `next_step_pos`, `false_step_pos`, `rework_limit`, `if_sub_process`, `prompt`, `if_autostart`, `need_approval`, `approve_emp_usage`, `approve_emp_id`) VALUES('2010-10-06 18:39:23', 2, 1030, 1, 'insert', 5, 1000, NULL, NULL, 0, 0, '', 0, 1, 'employee', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pg_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `lot_size` decimal(16,4) unsigned default NULL,
  `uomid` smallint(3) unsigned NOT NULL,
  `lifespan` int(10) unsigned NOT NULL default '0',
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime default NULL,
  `state_changed_by` int(10) unsigned default NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `pd_un1` (`pg_id`,`name`,`version`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `pg_id`, `name`, `version`, `state`, `lot_size`, `uomid`, `lifespan`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `description`, `comment`) VALUES(1, 14, 'RACN-ASL-6001N-P0000N-E075277-050', 1, 'production', '1.0000', 1, 5, '2010-09-24 11:39:07', 3, NULL, NULL, 'JosephOregon', NULL);
INSERT INTO `product` (`id`, `pg_id`, `name`, `version`, `state`, `lot_size`, `uomid`, `lifespan`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `description`, `comment`) VALUES(2, 14, 'product1', 1, 'production', '4.0000', 1, 30, '2010-10-06 18:42:08', 5, '2010-10-21 08:18:38', 3, 'desc', 'test time');

-- --------------------------------------------------------

--
-- Table structure for table `product_group`
--

DROP TABLE IF EXISTS `product_group`;
CREATE TABLE IF NOT EXISTS `product_group` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) default NULL,
  `surfix` varchar(20) default NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pg_un1` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `product_group`
--

INSERT INTO `product_group` (`id`, `name`, `prefix`, `surfix`, `create_time`, `created_by`, `description`, `comment`) VALUES(14, 'general', NULL, NULL, '2010-09-22 19:49:42', 1, 'This group is a general group that can be used by any product', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_process`
--

DROP TABLE IF EXISTS `product_process`;
CREATE TABLE IF NOT EXISTS `product_process` (
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `priority` tinyint(2) unsigned NOT NULL default '0',
  `recorder` int(10) unsigned NOT NULL,
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_process`
--

INSERT INTO `product_process` (`product_id`, `process_id`, `priority`, `recorder`, `comment`) VALUES(1, 1, 2, 3, NULL);
INSERT INTO `product_process` (`product_id`, `process_id`, `priority`, `recorder`, `comment`) VALUES(2, 2, 4, 5, 'asdf');

-- --------------------------------------------------------

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
CREATE TABLE IF NOT EXISTS `recipe` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `exec_method` enum('ordered','random') NOT NULL default 'random',
  `contact_employee` int(10) unsigned default NULL,
  `instruction` text,
  `diagram_filename` varchar(255) default NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime default NULL,
  `updated_by` int(10) unsigned default NULL,
  `comment` text,
  PRIMARY KEY  (`id`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `recipe`
--

INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(1, 'josephoregon diagram', 'random', 3, 'complete wiring diagram for RACN-ASL-6001N-P0000N-E075277-50', 'jo_rp1.jpg', '2010-09-26 20:00:37', 3, '2010-10-06 08:07:42', 3, 'this is a diagram holder.');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(2, 'jo_rp_2', 'ordered', 3, 'Take custom Metal Plate BSPL-0001 and screw in (3) 1/4-20x1” socket cap mounting screws. They should be pointing out as shown in picture. Screw them in so the end of the screw is approx. flush with the bottom of the plate.', 'JO_rp2.jpg', '2010-09-27 07:08:23', 3, '2010-10-06 12:47:07', 3, 'The installation begins from here.');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(3, 'jo_rp_3', 'ordered', 1, 'Line up 5 Rebel LED’s on the table. Bundle the leads together, and slip into 7-8” of 1/2” heat shrink tubing. Leave at about 2” of leads between the end of the heat shrink tubing and the LED module. Heat the tubing with a heat gun to shrink it around the leads. Note: Do not overheat, because this can melt the wire insulation and possibly cause a fire or short circuits.', 'JO_rp3.jpg', '2010-09-27 08:35:56', 3, '2010-10-06 12:48:30', 3, '');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(4, 'jo_rp_4', 'ordered', 3, 'Power Supply Instructions:\r\n\r\na. Crimp female pin connectors on the three wires of the primary side of the power supply using crimping tool.\r\n\r\nb. Insert the female pin connectors into the female quick connector. When properly mounted, you should hear a “click” as each pin connector is inserted. Green to pin 3, white to pin 2 and black to pin 1 as shown.\r\n\r\nc. Attach the power supply to its mounting bracket with (2) #8 flat washers and (2) 8-32x1/4” socket cap screws. Mount the power supply with the secondary side towards the mounting flange, with the flange facing away from the power supply.\r\n\r\nd. Attach power supply bracket to custom plate with (2) 10-32x1/2” SS socket cap Screws, using the two tapped screw holes near the center of the plate. The bracket is on the opposite side of the mounting screw heads. Once mounted, the secondary power supply wires should be over the feed through hole in the plate.\r\nNote: Don’t feed wire through the hole; the LED leads will be fed through this hole.', 'jo_rp4.jpg', '2010-09-28 07:48:52', 3, '2010-10-06 12:53:05', 3, 'Pictures are combined');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(5, 'jo_rp_5', 'ordered', 3, 'LED Mounting Instructions\r\na. On the opposite side of the plate, mount the five LED\r\nmounting brackets, using (2) 10-32x1/2” socket cap screws.\r\n\r\nb. Attach each of the 5 LED’s in the LED Bundle Assembly to their mounting brackets with (5) ¼” lock washers and (5) 1/4-20x1/2” socket cap screws. Run the wire bundle through the feed through hole.', 'jo_rp5.jpg', '2010-09-28 08:21:30', 3, '2010-09-29 06:47:20', 3, '');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(6, 'jo_rp_6', 'random', 3, 'Wiring Instructions:\r\n\r\na. Strip insulation of red and black wires approx ½” and do not strip yellow wires. Match up the wires from the 5 LEDs by color. Twist ends of each bundle together.\r\n\r\nb. Connect the Red LED bundle to the Red Power Supply Secondary wire with an orange wire nut. Connect the\r\nBlack LED bundle to the black Power Supply\r\nsecondary wire. Use another wire nut to cap off the yellow\r\nLED bundle. Test for a firm connection by gently pulling on each wire and the wire nut. Wires should not pull\r\nfree.\r\n\r\nc. Bundle wires together with two zip ties. Cut the loose ends of the zip ties off.', 'jo_rp6.jpg', '2010-09-28 08:41:17', 3, '2010-09-28 08:42:21', 3, '');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(7, 'jo_rp_7', 'random', 3, 'Pack the finished product.', 'jo_rp7.jpg', '2010-09-28 08:47:13', 3, '2010-09-28 08:49:15', 3, 'The attached image provides a view of finished product.');
INSERT INTO `recipe` (`id`, `name`, `exec_method`, `contact_employee`, `instruction`, `diagram_filename`, `create_time`, `created_by`, `update_time`, `updated_by`, `comment`) VALUES(8, 'receipe1', 'ordered', 1, 'asd', '', '2010-10-06 18:40:31', 5, NULL, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `step`
--

DROP TABLE IF EXISTS `step`;
CREATE TABLE IF NOT EXISTS `step` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `step_type_id` int(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL default '0',
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') character set latin1 default NULL,
  `eq_usage` enum('equipment group','equipment') default NULL,
  `eq_id` int(10) unsigned default NULL,
  `emp_usage` enum('employee group','employee') default NULL,
  `emp_id` int(10) unsigned default NULL,
  `recipe_id` int(10) unsigned default NULL,
  `mintime` int(10) unsigned default NULL,
  `maxtime` int(10) unsigned default NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime default NULL,
  `state_changed_by` int(10) unsigned default NULL,
  `para_count` tinyint(3) default NULL,
  `description` text,
  `comment` text,
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
  PRIMARY KEY  (`id`),
  UNIQUE KEY `st_un1` (`step_type_id`,`name`,`version`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `step`
--

INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(1, 2, 'Display Complete Wiring Diagram', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 1, NULL, NULL, '2010-09-26 20:19:10', 3, '2010-12-04 12:40:03', 3, 0, 'Display complete wiring diagram', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(2, 8, 'Prepare Base Plate', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 2, NULL, NULL, '2010-09-27 08:38:22', 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(3, 8, 'LED Bundle Assembly', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 3, NULL, NULL, '2010-09-27 08:38:48', 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(4, 8, 'Power Supply', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 4, NULL, NULL, '2010-09-28 08:14:39', 3, '2010-09-28 08:14:59', 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(5, 8, 'LED Mounting', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 5, NULL, NULL, '2010-09-28 08:33:44', 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(6, 8, 'Wiring', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 6, NULL, NULL, '2010-09-28 08:43:16', 3, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(7, 8, 'Pack Finished Product', 1, 1, 'production', 'equipment', NULL, 'employee group', 1, 7, NULL, NULL, '2010-09-28 08:50:09', 3, '2010-09-28 08:50:39', 3, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(8, 3, 'step1', 1, 1, 'production', 'equipment', 1, 'employee group', 1, 2, NULL, NULL, '2010-10-06 18:36:24', 5, NULL, NULL, 3, NULL, NULL, 'aa', 'bb', 'cc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(9, 3, 'step2', 1, 1, 'production', 'equipment', 2, 'employee group', 1, NULL, NULL, NULL, '2010-10-06 18:36:53', 5, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `step` (`id`, `step_type_id`, `name`, `version`, `if_default_version`, `state`, `eq_usage`, `eq_id`, `emp_usage`, `emp_id`, `recipe_id`, `mintime`, `maxtime`, `create_time`, `created_by`, `state_change_time`, `state_changed_by`, `para_count`, `description`, `comment`, `para1`, `para2`, `para3`, `para4`, `para5`, `para6`, `para7`, `para8`, `para9`, `para10`) VALUES(10, 3, 'step3', 1, 1, 'production', 'equipment', 3, 'employee group', 1, 6, NULL, NULL, '2010-10-06 18:37:08', 5, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'a', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `step_type`
--

DROP TABLE IF EXISTS `step_type`;
CREATE TABLE IF NOT EXISTS `step_type` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `max_para_count` tinyint(3) NOT NULL default '10',
  `min_para_count` tinyint(3) NOT NULL default '0',
  `create_time` datetime NOT NULL,
  `update_time` datetime default NULL,
  `description` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sc_un1` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `step_type`
--

INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(1, 'condition', 10, 3, '2010-09-22 19:49:42', NULL, 'Condition takes at least three parameters: x operator Y');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(2, 'display message', 10, 1, '2010-09-22 19:49:42', NULL, 'Dispaly message is the only required parameter.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(3, 'call api', 10, 1, '2010-09-22 19:49:42', NULL, 'api name is the required parameter.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(4, 'check list', 0, 1, '2010-09-22 19:49:42', NULL, 'At list one item is required.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(5, 'hold lot', 0, 0, '2010-09-22 19:49:42', NULL, 'No parameter required and lot number is supplied when executed.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(6, 'hold equipment', 0, 0, '2010-09-22 19:49:42', NULL, 'No parameter required and equiipment id is supplied when executed.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(7, 'email', 10, 3, '2010-09-22 19:49:42', NULL, 'email address, subject, and content are required');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(8, 'consume material', 0, 0, '2010-09-22 19:49:42', NULL, 'recipe is supplied as a column value.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(9, 'reposition', 0, 0, '2010-09-22 19:49:42', NULL, 'No parameter is needed.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(10, 'ship to warehouse', 0, 0, '2010-09-22 19:49:42', NULL, 'No parameter is needed.');
INSERT INTO `step_type` (`id`, `name`, `max_para_count`, `min_para_count`, `create_time`, `update_time`, `description`) VALUES(11, 'scrap', 0, 0, '2010-09-22 19:49:42', NULL, 'No parameter is needed.');

-- --------------------------------------------------------

--
-- Table structure for table `system_roles`
--

DROP TABLE IF EXISTS `system_roles`;
CREATE TABLE IF NOT EXISTS `system_roles` (
  `id` int(11) NOT NULL auto_increment,
  `applicationId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=5 ;

--
-- Dumping data for table `system_roles`
--

INSERT INTO `system_roles` (`id`, `applicationId`, `name`) VALUES(1, 1, 'Admin');
INSERT INTO `system_roles` (`id`, `applicationId`, `name`) VALUES(2, 1, 'Manager');
INSERT INTO `system_roles` (`id`, `applicationId`, `name`) VALUES(3, 1, 'QA');
INSERT INTO `system_roles` (`id`, `applicationId`, `name`) VALUES(4, 1, 'Engineer');

-- --------------------------------------------------------

--
-- Table structure for table `uom`
--

DROP TABLE IF EXISTS `uom`;
CREATE TABLE IF NOT EXISTS `uom` (
  `id` smallint(3) unsigned NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  `alias` varchar(20) default NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `uom`
--

INSERT INTO `uom` (`id`, `name`, `alias`, `description`) VALUES(1, 'unit', 'unit', 'For device or parts.');
INSERT INTO `uom` (`id`, `name`, `alias`, `description`) VALUES(2, 'inch', '"', 'Length');
INSERT INTO `uom` (`id`, `name`, `alias`, `description`) VALUES(3, 'feet', '''', 'Length');
INSERT INTO `uom` (`id`, `name`, `alias`, `description`) VALUES(4, 'seed', 've', 'import from China');
INSERT INTO `uom` (`id`, `name`, `alias`, `description`) VALUES(5, 'Uom1', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `uom_conversion`
--

DROP TABLE IF EXISTS `uom_conversion`;
CREATE TABLE IF NOT EXISTS `uom_conversion` (
  `from_id` smallint(3) unsigned NOT NULL,
  `to_id` smallint(3) unsigned NOT NULL,
  `method` enum('ratio','reduction','addition') NOT NULL,
  `constant` decimal(16,4) unsigned NOT NULL,
  `comment` varchar(255) default NULL,
  PRIMARY KEY  (`from_id`,`to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `uom_conversion`
--

INSERT INTO `uom_conversion` (`from_id`, `to_id`, `method`, `constant`, `comment`) VALUES(2, 3, 'ratio', '0.3300', NULL);
INSERT INTO `uom_conversion` (`from_id`, `to_id`, `method`, `constant`, `comment`) VALUES(3, 2, 'ratio', '12.0000', NULL);
INSERT INTO `uom_conversion` (`from_id`, `to_id`, `method`, `constant`, `comment`) VALUES(4, 4, 'ratio', '3.0000', 'just for test');

-- --------------------------------------------------------

--
-- Table structure for table `users_in_roles`
--

DROP TABLE IF EXISTS `users_in_roles`;
CREATE TABLE IF NOT EXISTS `users_in_roles` (
  `userId` int(11) NOT NULL default '0',
  `roleId` int(11) NOT NULL default '0',
  PRIMARY KEY  (`userId`,`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `users_in_roles`
--

INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(1, 1);
INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(2, 1);
INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(3, 1);
INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(4, 1);
INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(5, 1);
INSERT INTO `users_in_roles` (`userId`, `roleId`) VALUES(6, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_ingredient`
--
DROP VIEW IF EXISTS `view_ingredient`;
CREATE TABLE IF NOT EXISTS `view_ingredient` (
`recipe_id` int(11) unsigned
,`source_type` varchar(8)
,`ingredient_id` int(11) unsigned
,`name` varchar(255)
,`description` text
,`quantity` decimal(16,4) unsigned
,`uom_id` smallint(6) unsigned
,`uom_name` varchar(20)
,`order` tinyint(4) unsigned
,`mintime` int(11) unsigned
,`maxtime` int(11) unsigned
,`comment` text
);

DROP VIEW IF EXISTS `view_lot_in_process`;
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
                                                          WHERE h1.lot_id = h.lot_id)
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
     ;
     
  DROP VIEW IF EXISTS `view_process_step`;
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
     ;