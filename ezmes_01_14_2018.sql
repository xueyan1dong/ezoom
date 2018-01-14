-- MySQL dump 10.13  Distrib 5.1.39, for Win32 (ia32)
--
-- Host: localhost    Database: ezmes
-- ------------------------------------------------------
-- Server version	5.1.39-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attribute_history`
--

DROP TABLE IF EXISTS `attribute_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `parent_type` enum('product','equipment','dc_def_main') NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_type` enum('in','out','both') NOT NULL DEFAULT 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum') DEFAULT NULL,
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
  PRIMARY KEY (`event_time`,`parent_type`,`parent_id`,`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute_history`
--

LOCK TABLES `attribute_history` WRITE;
/*!40000 ALTER TABLE `attribute_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `attribute_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `type` enum('supplier','customer','both') NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES (1,'LEDbuyer','customer',2,'866-866-8666','n/a','n/a','n/a','00000','USA',NULL,NULL,NULL,NULL,'John',NULL,'6789045678',NULL,'info@buyer.com',NULL,NULL,NULL,'2011-01-06',NULL,1,NULL),(4,'Excelsys','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28','2010-09-28',1,'Supplier for Power supply'),(5,'AeroLEDs','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'LEDs supplier'),(6,'Nelsons','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'Supplier of base plates and standoffs.'),(7,'Industrial HW','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'Supply other hardwares, such as screws, etc.'),(8,'Digi-Key','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'Supplier for connectors and pins'),(9,'Shipping supplies','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'General suppliers for shipping supplies'),(10,'Tool supplies','supplier',7,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-09-28',NULL,1,'General suppliers for tool supplies'),(11,'Austin Hardware Inc','supplier',10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-10-27',NULL,1,NULL),(12,'High Country Plastic','supplier',10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-10-27',NULL,1,NULL),(13,'Maverick Label.com','supplier',10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'n/a',NULL,NULL,NULL,'2010-10-27',NULL,1,NULL),(14,'Tranex','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(15,'AUSTIN HARDWARE AND SUPPLY','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(16,'A.L.P Lighting Components','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(17,'Digi-Key Corporation','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(18,'Newark','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(19,'KimCo','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(20,'INDUSTRIAL HARDWARE IDAHO','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(21,'LEDnovation, Inc','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(22,'Future Electronics','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(23,'Nelson Metal Technology','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(24,'Bridgelux Inc.','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(25,'TRC ELECTRONICS,INC','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(26,'ECO-FIT LIGHTING','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(27,'Inventronics (Hangzhou) Co., Ltd.','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(28,'PEI GENESIS,INC','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(29,'Go Lighting Technologies','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(30,'High Country','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(31,'ERVAN','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(32,'Artis Metals Company, Inc.','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(33,'M AND M METALS','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(34,'Lighting and Electronic Design, Inc','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(35,'MATRIX LIGHTING INC.','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL),(36,'CHARCO Mfg, Inc','supplier',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'2011-02-10',NULL,1,NULL);
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
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
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'SimplyLEDs','ezOMM','ezOMM.ambersoftsys.com','active','-7:00','2010-03-13 02:00:00','2010-11-07 02:00:00','test','vip','',NULL,NULL,NULL,NULL,'2010-11-09 00:00:00','Xueyan Dong',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_history`
--

DROP TABLE IF EXISTS `config_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_time` datetime NOT NULL,
  `source_table` varchar(20) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','production','frozen','checkout','checkin','engineer') DEFAULT NULL,
  `new_state` enum('inactive','production','frozen','checkout','checkin','engineer','deleted') NOT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text,
  `new_record` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_history`
--

LOCK TABLES `config_history` WRITE;
/*!40000 ALTER TABLE `config_history` DISABLE KEYS */;
INSERT INTO `config_history` VALUES (1,'2010-08-18 14:28:27','product',1,NULL,'production',2,'product GD_01_A is created','<PRODUCT><PG_ID>14</PG_ID><NAME>GD_01_A</NAME><STATE>production</STATE><LOT_SIZE>10.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>10</LIFESPAN><CREATE_TIME>2010-08-18 14:28:27</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>test</DESCRIPTION><COMMENT>test</COMMENT></PRODUCT>'),(2,'2010-08-18 14:28:35','product',1,'production','production',3,'product GD_01_A updated','<PRODUCT><PG_ID>14</PG_ID><NAME>GD_01_A</NAME><STATE>production</STATE><LOT_SIZE>10.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>10</LIFESPAN><CREATE_TIME>2010-08-18 14:28:27</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME>2010-08-18 14:28:35</STATE_CHANGE_TIME><STATE_CHANGED_BY>3</STATE_CHANGED_BY><DESCRIPTION>test</DESCRIPTION><COMMENT>test</COMMENT></PRODUCT>'),(3,'2010-08-18 18:34:07','product',2,NULL,'production',2,'product GR_DC_01 is created','<PRODUCT><PG_ID>14</PG_ID><NAME>GR_DC_01</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>5</LIFESPAN><CREATE_TIME>2010-08-18 18:34:07</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>test</DESCRIPTION><COMMENT>test</COMMENT></PRODUCT>'),(4,'2010-08-18 18:34:54','process',1,NULL,'production',2,'0',NULL),(5,'2010-08-18 18:36:57','process',1,'production','production',2,'0',NULL),(6,'2010-08-18 20:03:43','step',1,NULL,'production',1,'Step ambership is created',NULL),(7,'2010-08-18 20:03:55','step',1,'production','production',1,'step ambership updated',NULL),(8,'2010-09-02 17:02:39','process',2,NULL,'production',2,'0',NULL),(9,'2010-09-02 17:13:43','process',3,NULL,'production',2,'0',NULL),(10,'2010-09-03 11:21:27','process',3,'production','deleted',2,'0',NULL),(11,'2010-09-03 11:21:43','process',2,'production','deleted',2,'0',NULL),(12,'2010-09-03 11:21:51','process',4,NULL,'production',2,'0',NULL),(13,'2010-09-03 11:29:25','process',5,NULL,'production',2,'0',NULL),(14,'2010-09-03 11:30:04','step',1,NULL,'production',2,'Step test is created',NULL),(15,'2010-09-03 11:30:48','process',5,'production','deleted',2,'0',NULL),(16,'2010-09-03 11:30:56','process',4,'production','deleted',2,'0',NULL),(17,'2010-09-07 11:22:01','process',1,'production','deleted',2,'0',NULL),(18,'2010-09-07 11:22:13','process',6,NULL,'production',2,'0',NULL),(19,'2010-09-16 10:02:13','step',2,NULL,'production',2,'Step test is created',NULL),(20,'2010-09-16 19:58:31','process',7,NULL,'production',2,'0',NULL),(21,'2010-09-16 19:59:02','process',8,NULL,'production',2,'0',NULL),(22,'2010-09-16 19:59:27','process',9,NULL,'production',2,'0',NULL),(23,'2010-09-16 20:00:04','process',10,NULL,'production',2,'0',NULL),(24,'2010-09-16 20:04:41','step',2,'production','production',2,'step Parts Inspection updated',NULL),(25,'2010-09-16 20:06:29','step',3,NULL,'production',2,'Step Assemble X is created',NULL),(26,'2010-09-16 20:07:41','step',4,NULL,'production',2,'Step Install Switch B is created',NULL),(27,'2010-09-16 20:09:06','step',5,NULL,'production',2,'Step Final Test is created',NULL),(28,'2010-09-16 20:10:07','step',6,NULL,'production',2,'Step Finish Parts is created',NULL),(29,'2010-09-16 20:10:34','step',6,'production','production',2,'step Finish Parts updated',NULL),(30,'2010-09-16 20:11:42','product',3,NULL,'production',2,'product LED01 is created','<PRODUCT><PG_ID>14</PG_ID><NAME>LED01</NAME><STATE>production</STATE><LOT_SIZE>200.0000</LOT_SIZE><UOMID>3</UOMID><LIFESPAN>0</LIFESPAN><CREATE_TIME>2010-09-16 20:11:42</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION></DESCRIPTION><COMMENT></COMMENT></PRODUCT>'),(31,'2010-09-17 09:15:36','product',3,'production','production',2,'product LED01 updated','<PRODUCT><PG_ID>14</PG_ID><NAME>LED01</NAME><STATE>production</STATE><LOT_SIZE>200.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>0</LIFESPAN><CREATE_TIME>2010-09-16 20:11:42</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME>2010-09-17 09:15:36</STATE_CHANGE_TIME><STATE_CHANGED_BY>2</STATE_CHANGED_BY><DESCRIPTION></DESCRIPTION><COMMENT></COMMENT></PRODUCT>'),(32,'2010-09-17 09:17:21','step',2,'production','production',2,'step Parts Inspection updated',NULL),(33,'2010-09-18 18:38:34','step',5,'production','production',2,'step Final Test updated',NULL),(34,'2010-09-18 18:38:57','step',4,'production','production',2,'step Install Switch B updated',NULL),(35,'2010-09-29 07:14:38','step',1,NULL,'production',2,'Step JO Display Diagram is created',NULL),(36,'2010-09-29 07:15:39','step',2,NULL,'production',2,'Step JO Step 1 is created',NULL),(37,'2010-09-29 07:16:18','step',3,NULL,'production',2,'Step JO Step 2 is created',NULL),(38,'2010-09-29 07:17:01','step',4,NULL,'production',2,'Step JO Step 3 is created',NULL),(39,'2010-09-29 07:17:39','step',5,NULL,'production',2,'Step JO Step 4 is created',NULL),(40,'2010-09-29 07:18:09','step',6,NULL,'production',2,'Step JO Step 5 is created',NULL),(41,'2010-09-29 07:18:50','step',7,NULL,'production',2,'Step JO Step 6 is created',NULL),(42,'2010-09-29 07:19:16','process',10,'production','deleted',2,'0',NULL),(43,'2010-09-29 07:19:20','process',8,'production','deleted',2,'0',NULL),(44,'2010-09-29 07:19:23','process',7,'production','deleted',2,'0',NULL),(45,'2010-09-29 07:19:26','process',9,'production','deleted',2,'0',NULL),(46,'2010-09-29 07:19:31','process',6,'production','deleted',2,'0',NULL),(47,'2010-09-29 07:20:26','process',1,NULL,'production',2,'0',NULL),(48,'2010-09-29 07:26:31','product',1,NULL,'production',2,'product RACN-ASL-6001N-P0000N-E075277-050 is created','<PRODUCT><PG_ID>14</PG_ID><NAME>RACN-ASL-6001N-P0000N-E075277-050</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>2126</LIFESPAN><CREATE_TIME>2010-09-29 07:26:31</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>LED Retrifit Kit</DESCRIPTION><COMMENT></COMMENT></PRODUCT>'),(49,'2010-10-01 10:36:38','product',1,'production','production',7,'product RACN-ASL-6001N-P0000N-E075277-050 updated','<PRODUCT><PG_ID>14</PG_ID><NAME>RACN-ASL-6001N-P0000N-E075277-050</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>2126</LIFESPAN><CREATE_TIME>2010-09-29 07:26:31</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME>2010-10-01 10:36:38</STATE_CHANGE_TIME><STATE_CHANGED_BY>7</STATE_CHANGED_BY><DESCRIPTION>LED Retrofit Kit\r\n\r\n</DESCRIPTION><COMMENT>Provided to Joseph Oregon\r\nElectrician John Hillock</COMMENT></PRODUCT>'),(50,'2010-10-01 10:40:32','product',2,NULL,'production',7,'product YMCA Uplight is created','<PRODUCT><PG_ID>14</PG_ID><NAME>YMCA Uplight</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>10</UOMID><LIFESPAN>2126</LIFESPAN><CREATE_TIME>2010-10-01 10:40:32</CREATE_TIME><CREATED_BY>7</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>Four AeroLEDs XP modules mounted on baffle w/ fans</DESCRIPTION><COMMENT>Developed for West YMCA</COMMENT></PRODUCT>'),(51,'2010-10-15 15:03:46','product',2,'production','production',10,'product YMCA Uplight updated','<PRODUCT><PG_ID>14</PG_ID><NAME>YMCA Uplight</NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>10</UOMID><LIFESPAN>1825</LIFESPAN><CREATE_TIME>2010-10-01 10:40:32</CREATE_TIME><CREATED_BY>7</CREATED_BY><STATE_CHANGE_TIME>2010-10-15 15:03:46</STATE_CHANGE_TIME><STATE_CHANGED_BY>10</STATE_CHANGED_BY><DESCRIPTION>Model#RXOR-SPLEI-6005F-D2002C-E100277-160\n(Four AeroLEDs XP modules mounted on baffle w/ fans)\n</DESCRIPTION><COMMENT>Developed for West YMCA</COMMENT></PRODUCT>'),(52,'2011-01-06 12:38:17','step',8,NULL,'production',2,'Step Installation Step 1 is created',NULL),(53,'2011-01-06 12:38:42','step',9,NULL,'production',2,'Step Install Step 2 is created',NULL),(54,'2011-01-06 12:39:02','step',10,NULL,'production',2,'Step Installation Step 3 is created',NULL),(55,'2011-01-06 12:39:12','step',9,'production','production',2,'step Installation Step 2 updated',NULL),(56,'2011-01-06 12:39:44','step',11,NULL,'production',2,'Step Installation Step 4 is created',NULL),(57,'2011-01-06 12:40:05','step',12,NULL,'production',2,'Step Installation Step 5 is created',NULL),(58,'2011-01-11 11:37:55','step',13,NULL,'production',2,'Step Final Delivery is created',NULL),(59,'2011-01-12 12:28:15','step',10,'production','production',2,'step Installation Step 3 updated',NULL),(60,'2011-02-28 10:37:00','product',3,NULL,'production',2,'product RXOR-SPLEI-6005(6)F-D2002C-E100277-160  is created','<PRODUCT><PG_ID>14</PG_ID><NAME>RXOR-SPLEI-6005(6)F-D2002C-E100277-160 </NAME><STATE>production</STATE><LOT_SIZE>1.0000</LOT_SIZE><UOMID>1</UOMID><LIFESPAN>1825</LIFESPAN><CREATE_TIME>2011-02-28 10:37:00</CREATE_TIME><CREATED_BY>2</CREATED_BY><STATE_CHANGE_TIME></STATE_CHANGE_TIME><STATE_CHANGED_BY></STATE_CHANGED_BY><DESCRIPTION>YMCA Top Level</DESCRIPTION><COMMENT></COMMENT></PRODUCT>'),(61,'2011-02-28 16:54:30','process',2,NULL,'production',2,'processRXOR-SPLEI-6005(6)F-D2002C-E100277-160 is created',NULL),(62,'2011-02-28 16:59:04','step',14,NULL,'production',2,'Step YMCA_160_Diagram is created',NULL),(63,'2011-02-28 17:16:49','step',14,'production','production',2,'step YMCA_160_Diagram updated',NULL),(64,'2011-02-28 19:17:42','step',15,NULL,'production',2,'Step YMCA_160_Step1 is created',NULL),(65,'2011-02-28 19:29:39','step',15,'production','production',2,'step YMCA_160_Step1 updated',NULL),(66,'2011-03-01 08:47:28','step',16,NULL,'production',2,'Step YMCA_160_Step2 is created',NULL),(67,'2011-03-02 07:22:42','step',17,NULL,'production',2,'Step YMCA_160_Step3 is created',NULL),(68,'2011-03-02 07:39:08','step',18,NULL,'production',2,'Step YMCA_160_Step4 is created',NULL),(69,'2011-03-02 07:51:28','step',19,NULL,'production',2,'Step YMCA_160_Step5 is created',NULL),(70,'2011-03-02 07:51:39','step',19,'production','production',2,'step YMCA_160_Step5 updated',NULL),(71,'2011-03-02 08:12:29','step',20,NULL,'production',2,'Step YMCA_160_Step6 is created',NULL),(72,'2011-03-02 08:15:03','step',20,'production','production',2,'step YMCA_160_Step6 updated',NULL),(73,'2011-03-02 08:35:21','step',21,NULL,'production',2,'Step YMCA_160_Step7 is created',NULL),(74,'2011-03-02 08:39:47','step',21,'production','production',2,'step YMCA_160_Step7 updated',NULL),(75,'2011-03-02 08:59:14','step',22,NULL,'production',2,'Step Hold Lot is created',NULL),(76,'2011-03-02 09:03:03','step',23,NULL,'production',2,'Step Reposition Lot is created',NULL),(77,'2011-03-02 09:05:53','step',24,NULL,'production',2,'Step Scrap is created',NULL),(78,'2011-03-02 09:06:17','step',22,'production','production',2,'step Hold updated',NULL),(79,'2011-03-02 09:06:33','step',23,'production','production',2,'step Reposition updated',NULL),(80,'2011-03-02 11:15:05','step',21,'production','production',2,'step YMCA_160_Step7 updated',NULL),(81,'2011-03-02 12:12:59','step',25,NULL,'production',7,'Step YMCA_160_Step8 is created',NULL),(82,'2011-03-02 12:16:53','step',26,NULL,'production',7,'Step YMCA_160_Step9 is created',NULL),(83,'2011-03-02 12:35:46','step',26,'production','production',7,'step YMCA_160_Step9 updated',NULL),(84,'2011-03-02 12:44:58','step',27,NULL,'production',7,'Step YMCA_160_Step10 is created',NULL),(85,'2011-03-04 08:24:49','step',21,'production','production',2,'step YMCA 160 Continuity Test updated',NULL),(86,'2011-03-04 08:25:07','step',26,'production','production',2,'step YMCA 160 Burn-in Test updated',NULL),(87,'2011-03-04 08:25:43','step',15,'production','production',2,'step YMCA 160 LED Mounting updated',NULL),(88,'2011-03-04 08:26:02','step',27,'production','production',2,'step YMCA 160 ETL Labeling updated',NULL),(89,'2011-03-04 08:26:29','step',16,'production','production',2,'step YMCA 160 Filter Mounting updated',NULL),(90,'2011-03-04 08:27:02','step',17,'production','production',2,'step YMCA 160 Fan Filter Assembly updated',NULL),(91,'2011-03-04 08:27:33','step',18,'production','production',2,'step YMCA 160 Fan Mounting updated',NULL),(92,'2011-03-04 08:27:57','step',19,'production','production',2,'step YMCA 160 Power Supply updated',NULL),(93,'2011-03-04 08:28:17','step',20,'production','production',2,'step YMCA 160 Wiring updated',NULL),(94,'2011-03-04 08:28:51','step',25,'production','production',2,'step YMCA 160 PSU Labeling updated',NULL),(95,'2011-03-04 08:29:48','step',28,NULL,'production',2,'Step YMCA 160 Packing is created',NULL),(96,'2011-03-04 08:55:02','step',26,'production','production',2,'step YMCA 160 Burn-in Test updated',NULL),(97,'2011-03-04 09:32:57','step',29,NULL,'production',2,'Step YMCA 160 Installation Wiring Diagram is created',NULL),(98,'2011-03-04 09:37:53','step',30,NULL,'production',2,'Step YMCA 160 Warning 1 is created',NULL),(99,'2011-03-04 09:47:51','step',30,'production','production',2,'step YMCA 160 Warning 1 updated',NULL),(100,'2011-03-04 09:54:38','step',31,NULL,'production',2,'Step YMCA 160 Warning 2 is created',NULL),(101,'2011-03-04 09:56:10','step',29,'production','production',2,'step YMCA 160 Installation Wiring Diagram updated',NULL),(102,'2011-03-04 10:12:17','step',32,NULL,'production',2,'Step YMCA 160 Installation Dissassembly 1 is created',NULL),(103,'2011-03-04 10:13:51','step',32,'production','production',2,'step YMCA 160 Dissassembly 1 updated',NULL),(104,'2011-03-04 10:23:22','step',33,NULL,'production',2,'Step YMCA 160 Dissas 2 is created',NULL),(105,'2011-03-04 10:31:07','step',34,NULL,'production',2,'Step YMCA 160 Dissas3 is created',NULL),(106,'2011-03-04 10:33:48','step',34,'production','production',2,'step YMCA 160 Dissas3 updated',NULL),(107,'2011-03-04 10:40:41','step',35,NULL,'production',2,'Step YMCA 160 Install 1 is created',NULL),(108,'2011-03-04 10:41:07','step',32,'production','production',2,'step YMCA 160 Dissassembly 1 updated',NULL),(109,'2011-03-04 10:47:24','step',36,NULL,'production',2,'Step YMCA 160 Install 2 is created',NULL),(110,'2011-03-04 10:48:35','step',37,NULL,'production',2,'Step YMCA 160 deliver is created',NULL),(111,'2011-03-08 09:19:23','step',28,'production','production',2,'step YMCA 160 Packing updated',NULL),(112,'2011-03-08 09:22:17','step',21,'production','production',2,'step YMCA 160 Continuity Test updated',NULL);
/*!40000 ALTER TABLE `config_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consumption_return`
--

DROP TABLE IF EXISTS `consumption_return`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`lot_id`,`return_timecode`,`inventory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consumption_return`
--

LOCK TABLES `consumption_return` WRITE;
/*!40000 ALTER TABLE `consumption_return` DISABLE KEYS */;
INSERT INTO `consumption_return` VALUES (1,'RACN-ASL-60000000001','201101041605220',3,'8.0000','2.0000',12,2,'201101041603490','201101041605090',1,3,NULL),(9,'RACN-ASL-60000000009','201101120430360',6,'1.0000','1.0000',1,2,'201101120358590','201101120418180',1,2,'test');
/*!40000 ALTER TABLE `consumption_return` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document` (
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
  PRIMARY KEY (`id`),
  KEY `source_table` (`source_table`,`source_id`,`key_words`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document`
--

LOCK TABLES `document` WRITE;
/*!40000 ALTER TABLE `document` DISABLE KEYS */;
/*!40000 ALTER TABLE `document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'00000','admin','admin','active',1,1,'admin','admin',NULL,NULL,NULL,1,'This is the first user'),(2,'1','susand','test','active',1,1,'Susan','Dong',NULL,'susan.dong@ambersoftsys.com',NULL,NULL,'test'),(3,'1','feix','test','active',1,1,'Fei','Xue',NULL,'fei.xue@ambersoftsys.com',NULL,NULL,'test'),(7,'1','simplyLEDs','test','active',1,1,'simply','LEDs',NULL,'sales@simplyLEDs',NULL,NULL,'common account'),(8,'1','test','test','removed',1,1,'test','test',NULL,NULL,NULL,1,NULL),(9,'1','Sam','sam','removed',1,1,'Sam','New',NULL,'sam@amber.com','1234',3,'new hire'),(10,'1','yingw','bright','active',1,1,'Ying','Wang',NULL,'yingd@cableone.net',NULL,7,NULL);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_group`
--

DROP TABLE IF EXISTS `employee_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_group`
--

LOCK TABLES `employee_group` WRITE;
/*!40000 ALTER TABLE `employee_group` DISABLE KEYS */;
INSERT INTO `employee_group` VALUES (1,'general',1,0,NULL,NULL,NULL,'This group represents the whole company');
/*!40000 ALTER TABLE `employee_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_attributes`
--

DROP TABLE IF EXISTS `eq_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eq_attributes` (
  `eq_id` int(10) unsigned NOT NULL,
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
  `enum_values` text,
  `description` text,
  `comment` text,
  PRIMARY KEY (`eq_id`,`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_attributes`
--

LOCK TABLES `eq_attributes` WRITE;
/*!40000 ALTER TABLE `eq_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equip_history`
--

DROP TABLE IF EXISTS `equip_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `equip_history` (
  `event_time` datetime NOT NULL,
  `equip_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','up','down','qual','checkout','checkin') DEFAULT NULL,
  `new_state` enum('inactive','up','down','qual','checkout','checkin') DEFAULT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text CHARACTER SET latin1 NOT NULL,
  `new_record` text CHARACTER SET latin1,
  PRIMARY KEY (`equip_id`,`event_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equip_history`
--

LOCK TABLES `equip_history` WRITE;
/*!40000 ALTER TABLE `equip_history` DISABLE KEYS */;
INSERT INTO `equip_history` VALUES ('2010-09-08 08:26:41',1,'up','up',2,'equipment amberlab updated',NULL),('2010-09-16 19:46:57',1,'up','up',2,'equipment Eq-Dummy updated',NULL),('2010-09-17 08:10:01',1,'up',NULL,2,'equipment Eq-Dummy is deleted',NULL),('2010-09-08 08:27:22',2,NULL,'up',2,'equipment test station is created','<EQUIPMENT><EG_ID>0000000001</EG_ID><NAME>test station</NAME><STATE>up</STATE><LOCATION_ID>1</LOCATION_ID><CONTACT_EMPLOYEE>2</CONTACT_EMPLOYEE><MANUFACTURE_DATE>2010-09-07</MANUFACTURE_DATE><MANUFACTURER>test</MANUFACTURER><MANUFACTURER_PHONE>8708708777</MANUFACTURER_PHONE><ONLINE_DATE>2010-09-08</ONLINE_DATE><DESCRIPTION>test</DESCRIPTION><COMMENT>test</COMMENT></EQUIPMENT>'),('2010-09-08 08:27:31',2,'up',NULL,2,'equipment test station is deleted','<EQUIPMENT><EG_ID>0000000001</EG_ID><NAME>test station</NAME><STATE>up</STATE><LOCATION_ID>1</LOCATION_ID><CONTACT_EMPLOYEE>2</CONTACT_EMPLOYEE><MANUFACTURE_DATE>2010-09-07</MANUFACTURE_DATE><MANUFACTURER>test</MANUFACTURER><MANUFACTURER_PHONE>8708708777</MANUFACTURER_PHONE><ONLINE_DATE>2010-09-08</ONLINE_DATE><DESCRIPTION>test</DESCRIPTION><COMMENT>test</COMMENT></EQUIPMENT>'),('2010-09-16 19:48:34',2,NULL,'up',2,'equipment Eq-Welder01 is created',NULL),('2010-09-17 10:44:31',2,'up','up',2,'equipment Eq-Welder01 updated',NULL),('2010-09-16 19:50:38',3,NULL,'up',2,'equipment Eq-Scope01 is created',NULL),('2010-09-17 08:10:12',3,'up',NULL,2,'equipment Eq-Scope01 is deleted',NULL);
/*!40000 ALTER TABLE `equip_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `equipment` (
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment`
--

LOCK TABLES `equipment` WRITE;
/*!40000 ALTER TABLE `equipment` DISABLE KEYS */;
INSERT INTO `equipment` VALUES (2,0000000001,'Eq-Welder01','up',1,'2010-09-16 19:48:34',2,'2010-09-17 10:44:31',2,1,'2010-09-01','ABC Co','800-1234567','2010-09-01','Welder 01',NULL);
/*!40000 ALTER TABLE `equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment_group`
--

DROP TABLE IF EXISTS `equipment_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `equipment_group` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment_group`
--

LOCK TABLES `equipment_group` WRITE;
/*!40000 ALTER TABLE `equipment_group` DISABLE KEYS */;
INSERT INTO `equipment_group` VALUES (1,'general',NULL,1,'2010-08-04 10:55:16',1,'This group is a general group that can be used by any equipment',NULL);
/*!40000 ALTER TABLE `equipment_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL,
  `noter_id` int(10) unsigned NOT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `state` enum('issued','queued','in process','closed') DEFAULT NULL,
  `priority_id` smallint(3) DEFAULT NULL,
  `last_noter_id` int(10) unsigned DEFAULT NULL,
  `last_note_time` datetime DEFAULT NULL,
  `responder` varchar(20) DEFAULT NULL,
  `last_respond_time` datetime DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `note` text,
  `response` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,'2010-09-15 20:56:01',2,'Susan mailto susan.dong@ambersoftsys.com','issued',NULL,NULL,NULL,NULL,NULL,'Welcome!','Please feel free to type your feedback here. We regard your feedback very important to us.\r\nThanks,\r\n\r\nSusan\r\n\r\nAmbersoft, LLC',NULL),(2,'2010-09-17 09:46:48',7,NULL,'issued',NULL,NULL,NULL,NULL,NULL,'bugs','rename to feedback',NULL),(3,'2010-09-22 11:35:12',2,'','issued',NULL,NULL,NULL,NULL,NULL,'Now feedback also send emails.','We just enhanced feedback form to also send email to us when you enter some feedback notes.',NULL),(4,'2010-10-15 16:07:14',10,'','issued',NULL,NULL,NULL,NULL,NULL,'List of vendors/suppliers','1. It would be nice for the system to have a list of vendors. When material is entered, one can pick a supplier from pull-down list.\r\n\r\n2. Is there a way to track a part once the order is placed?',NULL),(5,'2010-10-22 14:17:27',10,'','issued',NULL,NULL,NULL,NULL,NULL,'Updates','Hi Susan,\r\n\r\nI was in office but could not get hold of you. \r\n\r\nTony will send you the Traveler file we developed for tracking an order build. You can build that into the system.\r\n\r\nChange Material/Part -> Item/Part to be consistent with Quickbook\r\n\r\nNeed to add cost to Item/Part\r\n\r\nWe can have a phone conference on Monday and I will ask Tony to show you what he uses Quickbook for.\r\n\r\nThanks,\r\n\r\nYing',NULL);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredients` (
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`recipe_id`,`source_type`,`ingredient_id`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` VALUES (2,'material',9,'1.0000',1,1,0,0,'Metal plate'),(2,'material',14,'3.0000',1,2,0,0,'1/4-20x1 screw'),(3,'material',8,'5.0000',1,1,0,0,'Rebel LEDs'),(3,'material',11,'8.0000',10,2,0,0,'Shrink tube'),(4,'material',7,'1.0000',1,1,0,0,'Power supply'),(4,'material',12,'2.0000',1,5,0,0,'8-32x1/2 Socket cap screws'),(4,'material',13,'2.0000',1,6,0,0,'10-32x1/2 socket cap screws'),(4,'material',16,'2.0000',1,4,0,0,'Flash washer'),(4,'material',19,'1.0000',1,3,0,0,'Female connector'),(4,'material',20,'3.0000',1,2,0,0,'Female pins'),(5,'material',10,'5.0000',1,1,0,0,'Standoffs'),(5,'material',13,'10.0000',1,2,0,0,'10-32x1/2 socket cap screws'),(5,'material',15,'5.0000',1,4,0,0,'1/4-20x1/2 socket cap screws'),(5,'material',17,'5.0000',1,3,0,0,'Lock washer 1/4'),(6,'material',18,'3.0000',1,1,0,0,'Orange wire nut'),(6,'material',24,'2.0000',1,2,0,0,'Black zip tie'),(7,'material',21,'1.0000',1,0,0,0,'Product label'),(7,'material',22,'1.0000',1,0,0,0,'Dimension label'),(7,'material',23,'1.0000',1,0,0,0,'Warning label'),(7,'material',25,'1.0000',1,0,0,0,'Shipping box'),(7,'material',26,'1.0000',1,0,0,0,'Shipping tape'),(7,'material',27,'4.0000',12,0,0,0,'Bubble wrap'),(14,'material',13,'8.0000',1,0,0,0,''),(14,'material',36,'4.0000',1,0,0,0,'Grommet'),(14,'material',66,'4.0000',1,0,0,0,'Itineris XP heatsink'),(14,'material',97,'1.0000',17,0,0,0,''),(14,'material',128,'8.0000',1,0,0,0,'LED Array'),(14,'material',182,'4.0000',1,0,0,0,''),(14,'material',192,'4.0000',1,0,0,0,'XP Lens'),(15,'material',44,'3.0000',1,0,0,0,'Gasket'),(15,'material',138,'3.0000',1,0,0,0,''),(15,'material',244,'12.0000',1,0,0,0,''),(16,'material',138,'4.0000',1,0,0,0,'Fan filter'),(16,'material',198,'4.0000',1,0,0,0,'SUNON fans'),(16,'material',233,'16.0000',1,0,0,0,'4 for each fan'),(16,'material',248,'16.0000',1,0,0,0,'4 for each fan'),(17,'material',13,'8.0000',1,0,0,0,'2 for each fan.'),(17,'material',235,'8.0000',1,0,0,0,'2 for each fan'),(18,'material',162,'2.0000',1,0,0,0,'Power supply'),(18,'material',234,'4.0000',1,0,0,0,'2 for each power supply'),(18,'material',252,'4.0000',1,0,0,0,'2 for each power supply'),(18,'material',297,'4.0000',1,0,0,0,'2 for each power supply'),(19,'material',18,'4.0000',1,0,0,0,'Orange nut. 2 for each Power Supply.'),(19,'material',270,'4.0000',1,0,0,0,'Blue nut. 2 for each Power Supply.'),(19,'material',272,'4.0000',1,0,0,0,'Zip tie. 2 for each Power Supply.'),(21,'material',135,'1.0000',1,0,0,0,'Power Supply Label'),(23,'material',135,'1.0000',1,0,0,0,'Kit label'),(23,'material',136,'1.0000',1,0,0,0,'Itineris XP label'),(24,'material',25,'1.0000',1,0,0,0,'Box'),(24,'material',26,'1.0000',1,0,0,0,'Tape'),(24,'material',27,'4.0000',12,0,0,0,'bubbler Wrap'),(24,'material',300,'1.0000',17,0,0,0,'5 page of Installation Instruction');
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredients_history`
--

DROP TABLE IF EXISTS `ingredients_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`event_time`,`recipe_id`,`source_type`,`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients_history`
--

LOCK TABLES `ingredients_history` WRITE;
/*!40000 ALTER TABLE `ingredients_history` DISABLE KEYS */;
INSERT INTO `ingredients_history` VALUES ('2010-08-18 18:34:37',2,'insert',1,'product',2,'1.0000',1,1,1,2,'test'),('2010-09-02 17:55:28',2,'insert',5,'material',2,'1.0000',1,1,1,2,'test'),('2010-09-02 17:55:44',2,'insert',5,'product',2,'2.0000',1,2,1,1,'1'),('2010-09-02 17:55:58',2,'modify',5,'product',2,'2.0000',1,3,1,1,'1'),('2010-09-16 19:33:40',2,'insert',1,'material',2,'1.0000',1,0,0,0,''),('2010-09-17 08:07:51',2,'delete',1,'product',2,'1.0000',1,1,1,2,'delete recipe'),('2010-09-17 08:07:51',2,'delete',1,'material',2,'1.0000',1,0,0,0,'delete recipe'),('2010-09-17 08:08:12',2,'delete',5,'material',2,'1.0000',1,1,1,2,'delete recipe'),('2010-09-17 09:15:02',2,'insert',11,'material',2,'1.0000',1,1,0,0,''),('2010-09-17 09:15:54',2,'insert',11,'product',3,'10.0000',1,2,0,0,''),('2010-09-29 06:16:50',2,'delete',11,'product',3,'10.0000',1,2,0,0,'delete recipe'),('2010-09-29 06:16:50',2,'delete',11,'material',2,'1.0000',1,1,0,0,'delete recipe'),('2010-09-29 06:22:06',2,'insert',2,'material',9,'1.0000',1,1,0,0,'Metal plate'),('2010-09-29 06:22:46',2,'insert',2,'material',14,'3.0000',1,2,0,0,'1/4-20x1 screw'),('2010-09-29 06:25:37',2,'insert',3,'material',8,'5.0000',1,1,0,0,'Rebel LEDs'),('2010-09-29 06:27:09',2,'insert',3,'material',11,'8.0000',10,2,0,0,'Shrink tube'),('2010-09-29 06:36:54',2,'insert',4,'material',7,'1.0000',1,1,0,0,'Power supply'),('2010-09-29 06:37:30',2,'insert',4,'material',20,'3.0000',1,0,0,0,'Female pins'),('2010-09-29 06:38:02',2,'insert',4,'material',19,'1.0000',1,3,0,0,'Female connector'),('2010-09-29 06:38:09',2,'modify',4,'material',20,'3.0000',1,2,0,0,'Female pins'),('2010-09-29 06:38:40',2,'insert',4,'material',16,'2.0000',1,4,0,0,'Flash washer'),('2010-09-29 06:39:27',2,'insert',4,'material',12,'2.0000',1,5,0,0,'10-32x1/2 Socket cap screws'),('2010-09-29 06:39:56',2,'modify',4,'material',12,'2.0000',1,5,0,0,'8-32x1/2 Socket cap screws'),('2010-09-29 06:40:37',2,'insert',4,'material',13,'2.0000',1,6,0,0,'10-32x1/2 socket cap screws'),('2010-09-29 06:44:02',2,'insert',5,'material',13,'10.0000',1,1,0,0,'10-32x1/2 socket cap screws'),('2010-09-29 06:47:45',2,'insert',5,'material',10,'5.0000',1,1,0,0,'Standoffs'),('2010-09-29 06:47:57',2,'modify',5,'material',13,'10.0000',1,2,0,0,'10-32x1/2 socket cap screws'),('2010-09-29 06:49:26',2,'insert',5,'material',17,'5.0000',1,3,0,0,'Lock washer 1/4'),('2010-09-29 06:50:07',2,'insert',5,'material',15,'5.0000',1,4,0,0,'1/4-20x1/2 socket cap screws'),('2010-09-29 06:54:59',2,'insert',6,'material',18,'3.0000',1,1,0,0,'Orange wire nut'),('2010-09-29 06:55:24',2,'insert',6,'material',24,'2.0000',1,2,0,0,'Black zip tie'),('2010-09-29 06:56:31',2,'insert',7,'material',21,'1.0000',1,0,0,0,'Product label'),('2010-09-29 06:56:51',2,'insert',7,'material',22,'1.0000',1,0,0,0,'Dimension label'),('2010-09-29 06:57:04',2,'insert',7,'material',23,'1.0000',1,0,0,0,'Warning label'),('2010-09-29 06:57:24',2,'insert',7,'material',25,'1.0000',1,0,0,0,'Shipping box'),('2010-09-29 06:57:39',2,'insert',7,'material',26,'1.0000',1,0,0,0,'Shipping tape'),('2010-09-29 06:59:21',2,'insert',7,'material',27,'4.0000',12,0,0,0,'Bubble wrap'),('2011-02-28 19:27:59',2,'insert',14,'material',182,'8.0000',1,0,0,0,'4 for each module in the diagram.'),('2011-03-01 07:57:43',2,'insert',14,'material',13,'16.0000',1,0,0,0,'8 for each module'),('2011-03-01 08:08:54',2,'insert',15,'material',244,'24.0000',1,0,0,0,'4 for each filter, 12 for each module.'),('2011-03-01 08:14:43',2,'insert',14,'material',30,'2.0000',17,0,0,0,'1 for each module'),('2011-03-01 08:24:43',2,'insert',15,'material',31,'6.0000',1,0,0,0,'3 for each module'),('2011-03-01 08:30:02',2,'modify',15,'material',31,'6.0000',1,0,0,0,'SUNON Fans, 24VDC. 3 for each module'),('2011-03-01 08:34:05',2,'insert',15,'material',198,'6.0000',1,0,0,0,'SUNON Fans, 24VDC, 3 for each module.'),('2011-03-01 08:40:23',2,'insert',14,'material',97,'2.0000',17,0,0,0,'1 for each module'),('2011-03-01 08:41:52',2,'insert',15,'material',138,'6.0000',1,0,0,0,'1 for each filter, 3 for each module.'),('2011-03-01 08:46:15',2,'modify',15,'material',138,'6.0000',1,0,0,0,'3 for each module.'),('2011-03-01 11:35:21',2,'modify',14,'material',182,'4.0000',1,0,0,0,''),('2011-03-01 11:35:38',2,'modify',14,'material',97,'1.0000',17,0,0,0,''),('2011-03-01 11:35:49',2,'modify',14,'material',13,'8.0000',1,0,0,0,''),('2011-03-01 11:36:13',2,'modify',15,'material',138,'3.0000',1,0,0,0,''),('2011-03-01 11:36:25',2,'modify',15,'material',244,'12.0000',1,0,0,0,''),('2011-03-02 07:10:43',2,'insert',16,'material',138,'4.0000',1,0,0,0,'Fan filter'),('2011-03-02 07:18:08',2,'insert',16,'material',252,'16.0000',1,0,0,0,'4 for each fan filter.'),('2011-03-02 07:20:13',2,'insert',16,'material',198,'4.0000',1,0,0,0,'SUNON fans'),('2011-03-02 07:21:27',2,'insert',16,'material',234,'16.0000',1,0,0,0,'4 for each fan.'),('2011-03-02 07:35:33',2,'insert',17,'material',13,'8.0000',1,0,0,0,'2 for each fan.'),('2011-03-02 07:37:53',2,'insert',17,'material',235,'8.0000',1,0,0,0,'2 for each fan'),('2011-03-02 07:45:44',2,'insert',18,'material',252,'4.0000',1,0,0,0,'2 for each power supply'),('2011-03-02 07:49:42',2,'insert',18,'material',297,'4.0000',1,0,0,0,'2 for each power supply'),('2011-03-02 07:50:24',2,'insert',18,'material',234,'4.0000',1,0,0,0,'2 for each power supply'),('2011-03-02 08:06:09',2,'insert',19,'material',270,'4.0000',1,0,0,0,'Blue. 2 for each Power Supply.'),('2011-03-02 08:10:49',2,'insert',19,'material',18,'4.0000',1,0,0,0,'Orange nut. 2 for each Power Supply.'),('2011-03-02 08:11:06',2,'modify',19,'material',270,'4.0000',1,0,0,0,'Blue nut. 2 for each Power Supply.'),('2011-03-02 11:23:22',2,'insert',21,'material',135,'1.0000',1,0,0,0,'Power Supply Label'),('2011-03-02 12:02:10',2,'insert',18,'material',162,'2.0000',1,0,0,0,''),('2011-03-02 12:02:31',2,'modify',18,'material',162,'2.0000',1,0,0,0,'Power supply'),('2011-03-02 12:43:17',7,'insert',23,'material',135,'1.0000',1,0,0,0,'Kit label'),('2011-03-02 12:43:44',7,'insert',23,'material',136,'1.0000',1,0,0,0,'Itineris XP label'),('2011-03-04 07:01:09',2,'insert',19,'material',272,'4.0000',1,0,0,0,'Zip tie. 2 for each Power Supply.'),('2011-03-04 07:56:48',2,'insert',14,'material',66,'4.0000',1,0,0,0,''),('2011-03-04 07:57:17',2,'modify',14,'material',66,'4.0000',1,0,0,0,'Itineris XP heatsink'),('2011-03-04 07:57:48',2,'insert',14,'material',36,'4.0000',1,0,0,0,'Grommet'),('2011-03-04 08:01:21',2,'insert',14,'material',192,'4.0000',1,0,0,0,'XP Lens'),('2011-03-04 08:02:07',2,'insert',14,'material',128,'8.0000',1,0,0,0,'LED Array'),('2011-03-04 08:03:49',2,'insert',15,'material',44,'3.0000',1,0,0,0,'Gasket'),('2011-03-04 08:09:19',2,'insert',16,'material',248,'16.0000',1,0,0,0,'4 for each fan'),('2011-03-04 08:09:55',2,'insert',16,'material',233,'16.0000',1,0,0,0,'4 for each fan'),('2011-03-04 08:30:18',2,'insert',24,'material',26,'1.0000',1,0,0,0,'Tape'),('2011-03-04 08:30:32',2,'insert',24,'material',25,'1.0000',1,0,0,0,'Box'),('2011-03-04 08:31:04',2,'insert',24,'material',27,'4.0000',12,0,0,0,'bubbler Wrap'),('2011-03-04 08:49:51',2,'insert',24,'material',300,'1.0000',17,0,0,0,'5 page of Installation Instruction'),('2011-03-08 08:19:18',2,'insert',14,'material',39,'1.0000',1,0,0,0,'');
/*!40000 ALTER TABLE `ingredients_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_type` enum('product','material') CHARACTER SET latin1 NOT NULL,
  `pd_or_mt_id` int(10) unsigned NOT NULL COMMENT 'product or material id',
  `supplier_id` int(10) unsigned NOT NULL COMMENT 'manufactured product has client id as 0, otherwise, the client id should be from client table',
  `lot_id` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'if the inventory is purchased, the lot id may come from client, otherwise, it is the lot id',
  `serial_no` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `out_order_id` varchar(20) CHARACTER SET latin1 DEFAULT NULL COMMENT 'This is the order id issued to supplier to purchase.',
  `in_order_id` varchar(20) CHARACTER SET latin1 DEFAULT NULL COMMENT 'This is the order id from order table, which issued by client to buy products.',
  `original_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `manufacture_date` datetime NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `arrive_date` datetime NOT NULL,
  `recorded_by` int(10) unsigned NOT NULL,
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inventory_un01` (`source_type`,`pd_or_mt_id`,`supplier_id`,`lot_id`,`serial_no`)
) ENGINE=InnoDB AUTO_INCREMENT=194 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (3,'material',11,5,'HS000001','HS000001-001',NULL,NULL,'100.0000','97.3331',12,'2010-10-01 00:00:00','2015-10-01 00:00:00','2010-10-15 00:00:00',2,2,NULL),(4,'material',11,5,'HS000001','HS000001-002',NULL,NULL,'100.0000','99.8333',12,'2010-10-01 00:00:00','2015-10-01 00:00:00','2010-10-15 00:00:00',2,2,NULL),(5,'material',19,8,'1-480701-0-000A',NULL,NULL,NULL,'100.0000','99.0000',1,'2010-11-14 00:00:00',NULL,'2010-12-01 00:00:00',2,7,'Connector'),(6,'material',9,6,'BSPL-0001-000A',NULL,NULL,NULL,'100.0000','97.0000',1,'2010-02-02 00:00:00',NULL,'2010-03-02 00:00:00',2,7,'Base plate'),(7,'material',8,5,'It6001-000A',NULL,NULL,NULL,'100.0000','85.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-20 00:00:00',2,7,'led module'),(8,'material',14,7,'SSSB040200-000A',NULL,NULL,NULL,'500.0000','491.0000',1,'2010-12-01 00:00:00',NULL,'2011-01-01 00:00:00',2,7,'screwa'),(9,'material',10,6,'STOF-0001-00A',NULL,NULL,NULL,'100.0000','95.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-30 00:00:00',2,7,NULL),(10,'material',12,7,'SSSH008104-00A',NULL,NULL,NULL,'500.0000','498.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-01 00:00:00',2,7,'screw'),(11,'material',13,7,'SSSH011008-000A',NULL,NULL,NULL,'500.0000','464.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-30 00:00:00',2,10,NULL),(12,'material',16,7,'SSFW008-00A',NULL,NULL,NULL,'100.0000','98.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-30 00:00:00',2,10,NULL),(13,'material',17,7,'SSLW040-00A',NULL,NULL,NULL,'100.0000','95.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-21 00:00:00',2,10,NULL),(14,'material',18,7,'TER-000A',NULL,NULL,NULL,'500.0000','492.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-21 00:00:00',2,10,NULL),(15,'material',20,8,'pin-000A',NULL,NULL,NULL,'1000.0000','994.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-21 00:00:00',2,7,NULL),(16,'material',7,4,'POWER-000A',NULL,NULL,NULL,'50.0000','48.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-21 00:00:00',2,1,NULL),(17,'material',15,7,'H04008-000A',NULL,NULL,NULL,'500.0000','495.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-21 00:00:00',2,10,NULL),(18,'material',24,9,'tie-000A',NULL,NULL,NULL,'1000.0000','998.0000',1,'2010-01-01 00:00:00',NULL,'2010-01-20 00:00:00',2,10,NULL),(19,'material',35,5,'00-08519','2011-2-10',NULL,NULL,'30.0000','30.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(20,'material',36,0,'00-8501','2011-2-10',NULL,NULL,'300.0000','292.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(21,'material',37,5,'00-8510','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(22,'material',38,5,'00-8518','2011-2-10',NULL,NULL,'30.0000','30.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(23,'material',40,5,'00-8524','2011-2-10',NULL,NULL,'30.0000','30.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(24,'material',41,5,'00-8555 extrusion','2011-2-10',NULL,NULL,'504.0000','504.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(25,'material',42,14,'14-7917','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(26,'material',43,0,'1804030-1','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(27,'material',44,15,'1B150B2X1/8C','2011-2-10',NULL,NULL,'250.0000','244.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(28,'material',45,16,'209150','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(29,'material',46,16,'209190','2011-2-10',NULL,NULL,'4.0000','4.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(30,'material',47,16,'209192','2011-2-10',NULL,NULL,'22.0000','22.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(31,'material',51,18,'WHS20-00-100','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(32,'material',52,0,'WHS20-02-25','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(33,'material',53,0,'3M5462-ND','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(34,'material',59,5,'50-0002','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(35,'material',60,5,'50-0003 ITINERIS MC-','2011-2-10',NULL,NULL,'18.0000','18.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(36,'material',62,0,'565-1437-ND','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(37,'material',63,19,'60-0001-A-A-A','2011-2-10',NULL,NULL,'300.0000','300.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(38,'material',64,5,'60-0001-A-C-A','2011-2-10',NULL,NULL,'11.0000','11.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(39,'material',66,0,'60-0007','2011-2-10',NULL,NULL,'300.0000','292.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(40,'material',67,5,'60-0009','2011-2-10',NULL,NULL,'63.0000','63.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(41,'material',75,17,'730K-ND','2011-2-10',NULL,NULL,'1000.0000','1000.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(42,'material',76,16,'731173','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(43,'material',82,20,'94639A106','2011-2-10',NULL,NULL,'40.0000','40.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(44,'material',85,17,'A1441-ND','2011-2-10',NULL,NULL,'300.0000','300.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(45,'material',86,0,'A1450-ND','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(46,'material',87,17,'A1451-ND','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(47,'material',89,0,'A25343-ND','2011-2-10',NULL,NULL,'300.0000','300.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(48,'material',92,22,'AMN14112','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(49,'material',96,0,'AWG-20TefzelGrn','2011-2-10',NULL,NULL,'30.0000','30.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(50,'material',97,23,'Baffel Kit','2011-2-10',NULL,NULL,'66.0000','64.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(51,'material',118,23,'BracketKit-JosOR','2011-2-10',NULL,NULL,'60.0000','60.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(52,'material',120,0,'BRK-BFL-0001','2011-2-10',NULL,NULL,'16.0000','16.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(53,'material',122,0,'BRK-FAN-0001','2011-2-10',NULL,NULL,'20.0000','20.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(54,'material',123,0,'BRK-PSU-0001','2011-2-10',NULL,NULL,'16.0000','16.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(55,'material',124,0,'BXRA-C0802-00000','2011-2-10',NULL,NULL,'135.0000','135.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(56,'material',125,0,'BXRA-C0802-00G00','2011-2-10',NULL,NULL,'50.0000','50.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(57,'material',126,0,'BXRA-C1202-00000','2011-2-10',NULL,NULL,'20.0000','20.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(58,'material',127,24,'BXRA-C2002-00000','2011-2-10',NULL,NULL,'80.0000','80.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(59,'material',128,0,'BXRA-2002-00G00','2011-2-10',NULL,NULL,'610.0000','594.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(60,'material',129,0,'BXRA-N0802-00L00','2011-2-10',NULL,NULL,'40.0000','40.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(61,'material',130,0,'BXRA-N0802-00L10','2011-2-10',NULL,NULL,'40.0000','40.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(62,'material',131,0,'BXRA-W1202-00Q00','2011-2-10',NULL,NULL,'32.0000','32.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(63,'material',132,0,'CLG-100-24','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(64,'material',133,25,'CLG-60-24','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(65,'material',134,0,'CLG-60-24/277','2011-2-10',NULL,NULL,'45.0000','45.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(66,'material',135,0,'CM102-810-292','2011-2-10',NULL,NULL,'100.0000','98.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(67,'material',136,0,'CM102-810-294','2011-2-10',NULL,NULL,'100.0000','99.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(68,'material',137,0,'CMRB 10 D LT','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(69,'material',138,0,'CR212-ND','2011-2-10',NULL,NULL,'535.0000','521.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(70,'material',142,0,'DF04M-ND','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(71,'material',143,0,'ED2581-ND','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(72,'material',144,26,'ENDURA 63 LED 525MA','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(73,'material',145,27,'EUC-025-S105PS','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(74,'material',146,27,'EUC-025S070PS','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(75,'material',147,27,'EUC-075S070DT','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(76,'material',148,27,'EUC-075S105DT','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(77,'material',149,0,'euc-075S140DT','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(78,'material',150,0,'EUC-100S070DT','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(79,'material',151,27,'EUC-100S070ST','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(80,'material',152,0,'EUC-100S105DT','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(81,'material',153,27,'EUC-100S105ST','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(82,'material',154,0,'EUC-100S140DT','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(83,'material',155,27,'EUC-100S140ST','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(84,'material',157,0,'EUC-120S070DT','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(85,'material',158,0,'EUC-120S105DT','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(86,'material',159,0,'EUC-120S140DT','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(87,'material',160,27,'EUV-075S024ST','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(88,'material',161,0,'EUV-100S024ST','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(89,'material',162,0,'EXC LXV100-024SW','2011-2-10',NULL,NULL,'137.0000','135.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(90,'material',163,28,'EXC LXV150-024SW','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(91,'material',164,0,'EXC LXV75-024SW','2011-2-10',NULL,NULL,'90.0000','90.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(92,'material',165,20,'FILE570 SF-3','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(93,'material',167,29,'GDS06T-42','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(94,'material',170,20,'HK260 20912','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(95,'material',171,20,'HN2C06','2011-2-10',NULL,NULL,'1100.0000','1100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(96,'material',175,20,'HS12B ST221','2011-2-10',NULL,NULL,'11.0000','11.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(97,'material',178,22,'LED-INTA-700C-140F30','2011-2-10',NULL,NULL,'21.0000','21.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(98,'material',179,22,'INTA00224V41FO','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(99,'material',180,22,'LEDINTA700C105DHO','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(100,'material',182,0,'61-1003','2011-2-10',NULL,NULL,'216.0000','208.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(101,'material',184,0,'Itineris XP PCA','2011-2-10',NULL,NULL,'58.0000','58.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(102,'material',185,0,'L03F-18W','2011-2-10',NULL,NULL,'1105.0000','1105.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(103,'material',186,31,'L03F-9W','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(104,'material',187,0,'L03F Driver','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(105,'material',188,31,'L03F Replacement','2011-2-10',NULL,NULL,'4.0000','4.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(106,'material',189,0,'L04F','2011-2-10',NULL,NULL,'25.0000','25.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(107,'material',190,0,'L05G','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(108,'material',191,21,'LEDNOVATION LED A19-','2011-2-10',NULL,NULL,'15.0000','15.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(109,'material',192,30,'Led-XP','2011-2-10',NULL,NULL,'280.0000','272.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(110,'material',193,32,'LiteRing B','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(111,'material',194,32,'LiteRingA','2011-2-10',NULL,NULL,'10.0000','10.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(112,'material',195,0,'LM339ANFS-ND','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(113,'material',196,0,'LU725 03150','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(114,'material',197,20,'LW2006','2011-2-10',NULL,NULL,'1100.0000','1100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(115,'material',198,17,'ME80252V3','2011-2-10',NULL,NULL,'302.0000','294.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(116,'material',208,0,'PERMATEX 81789','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(117,'material',210,25,'PLN-30-24','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(118,'material',211,25,'PLN-60-24','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(119,'material',212,29,'RC01-KR REMOTE CON','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(120,'material',213,29,'RC02-KT REMOTE CONTR','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(121,'material',216,17,'RHM.15UCT-ND','2011-2-10',NULL,NULL,'50.0000','50.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(122,'material',224,5,'SOLDER MASK','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(123,'material',226,20,'SSFW006','2011-2-10',NULL,NULL,'900.0000','900.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(124,'material',16,20,'SSFW008','2011-2-10',NULL,NULL,'1140.0000','1140.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(125,'material',227,20,'SSFW010','2011-2-10',NULL,NULL,'800.0000','800.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(126,'material',228,20,'SSFW040U','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(127,'material',229,20,'SSHN0060','2011-2-10',NULL,NULL,'900.0000','900.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(128,'material',230,20,'SSHN0080','2011-2-10',NULL,NULL,'900.0000','900.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(129,'material',231,20,'SSHN0110','2011-2-10',NULL,NULL,'800.0000','800.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(130,'material',232,20,'SSHN040C','2011-2-10',NULL,NULL,'500.0000','500.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(131,'material',233,20,'SSLN060','2011-2-10',NULL,NULL,'2196.0000','2164.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(132,'material',234,20,'SSLN0080','2011-2-10',NULL,NULL,'1244.0000','1240.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(133,'material',235,20,'SSLN00110','2011-2-10',NULL,NULL,'868.0000','860.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(134,'material',236,20,'SSLN040C','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(135,'material',237,20,'SSLW006','2011-2-10',NULL,NULL,'900.0000','900.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(136,'material',238,20,'SSLW008','2011-2-10',NULL,NULL,'600.0000','600.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(137,'material',239,20,'SSLW010','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(138,'material',17,20,'SSLW040','2011-2-10',NULL,NULL,'700.0000','700.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(139,'material',240,0,'SSMSF004004P','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(140,'material',241,20,'SSSB011006','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(141,'material',14,20,'SSSB040200','2011-2-10',NULL,NULL,'190.0000','190.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(142,'material',242,20,'SSSH004004','2011-2-10',NULL,NULL,'800.0000','800.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(143,'material',243,20,'SSSH006004','2011-2-10',NULL,NULL,'600.0000','600.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(144,'material',244,20,'SSH006008','2011-2-10',NULL,NULL,'1552.0000','1528.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(145,'material',245,20,'SSSH006012','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(146,'material',246,20,'SSSH006100','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(147,'material',247,20,'SSSH006104','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(148,'material',248,20,'SSSH006108','2011-2-10',NULL,NULL,'1536.0000','1504.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(149,'material',249,20,'SSSH008004','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(150,'material',250,20,'SSSH008008','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(151,'material',251,20,'SSSH008012','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(152,'material',252,20,'SSSH008100','2011-2-10',NULL,NULL,'544.0000','540.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(153,'material',12,20,'SSSH008104','2011-2-10',NULL,NULL,'520.0000','520.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(154,'material',253,20,'SSSH008108','2011-2-10',NULL,NULL,'400.0000','400.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(155,'material',254,20,'SSSH008200','2011-2-10',NULL,NULL,'300.0000','300.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(156,'material',13,20,'SSSH011008','2011-2-10',NULL,NULL,'2116.0000','2116.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(157,'material',256,20,'SSSH011012','2011-2-10',NULL,NULL,'300.0000','300.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(158,'material',257,20,'SSSH011100','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(159,'material',15,20,'SSSH040008','2011-2-10',NULL,NULL,'700.0000','700.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(160,'material',258,20,'SSSH040012','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(161,'material',259,20,'SSSH040100','2011-2-10',NULL,NULL,'380.0000','380.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(162,'material',260,20,'SSSH040104','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(163,'material',261,20,'SSSH040108','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(164,'material',262,20,'SSSH040200','2011-2-10',NULL,NULL,'200.0000','200.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(165,'material',263,20,'SSSMP008008P','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(166,'material',264,20,'SSSMP008012P','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(167,'material',265,20,'SSSMP008100P','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(168,'material',269,20,'TER6200 20501','2011-2-10',NULL,NULL,'240.0000','240.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(169,'material',270,20,'TER6300 20502','2011-2-10',NULL,NULL,'704.0000','700.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(170,'material',18,20,'TER6400 20503','2011-2-10',NULL,NULL,'644.0000','644.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(171,'material',271,20,'TER7500 20311','2011-2-10',NULL,NULL,'50.0000','50.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(172,'material',272,20,'TIE1030 9624','2011-2-10',NULL,NULL,'400.0000','396.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(173,'material',273,20,'TLD0301','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(174,'material',274,0,'TLD0350 254306','2011-2-10',NULL,NULL,'4.0000','4.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(175,'material',275,0,'TLD0351','2011-2-10',NULL,NULL,'4.0000','4.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(176,'material',276,20,'TLD0389','2011-2-10',NULL,NULL,'3.0000','3.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(177,'material',277,14,'Transformer','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(178,'material',281,20,'VEL0200 66807','2011-2-10',NULL,NULL,'8.0000','8.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(179,'material',282,0,'VEL0201 77106','2011-2-10',NULL,NULL,'9.0000','9.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(180,'material',283,0,'VEL0204 59505','2011-2-10',NULL,NULL,'12.0000','12.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(181,'material',284,0,'VEL0301 66808','2011-2-10',NULL,NULL,'2.0000','2.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(182,'material',289,5,'XX-0001','2011-2-10',NULL,NULL,'1.0000','1.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(183,'material',290,5,'XX-0006','2011-2-10',NULL,NULL,'5.0000','5.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(184,'material',291,36,'YMCA Reflectors','2011-2-10',NULL,NULL,'66.0000','66.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(185,'material',292,20,'ZZ44014NYSHC','2011-2-10',NULL,NULL,'500.0000','500.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(186,'material',293,20,'ZZ812HWHDTSS','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(187,'material',294,0,'ZZ81HWHDTSS','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(188,'material',295,0,'ZZ834HWHDTSS','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(189,'material',296,20,'ZZ94639A103','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(190,'material',297,0,'ZZ94639A106','2011-2-10',NULL,NULL,'400.0000','396.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(191,'material',298,0,'ZZ94639A108','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(192,'material',299,0,'ZZ94639A110','2011-2-10',NULL,NULL,'100.0000','100.0000',1,'2011-02-10 00:00:00',NULL,'2011-02-10 00:00:00',2,NULL,NULL),(193,'material',300,0,'Y160Instruction-001','001',NULL,NULL,'100.0000','99.0000',17,'2011-02-27 00:00:00','2012-02-27 00:00:00','2011-03-04 00:00:00',2,2,'YMCA 160 Installation Instruction.');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_consumption`
--

DROP TABLE IF EXISTS `inventory_consumption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`lot_id`,`start_timecode`,`inventory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_consumption`
--

LOCK TABLES `inventory_consumption` WRITE;
/*!40000 ALTER TABLE `inventory_consumption` DISABLE KEYS */;
INSERT INTO `inventory_consumption` VALUES (1,'RACN-ASL-60000000001','201101041605090','201101041605090',3,'6.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,'test'),(1,'RACN-ASL-60000000001','201101041605330','201101041605330',4,'2.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(1,'RACN-ASL-60000000001','201101041606350','201101041606350',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(1,'RACN-ASL-60000000001','201101041607290','201101041607290',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(6,'RACN-ASL-60000000006','201101041608160','201101041608160',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120418480','201101120418480',8,'3.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120435060','201101120435060',6,'1.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120438020','201101120438020',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120438460','201101120438460',7,'5.0000',1,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122117120','201101122117120',6,'1.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122117220','201101122117220',8,'3.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122117440','201101122117440',7,'5.0000',1,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122117480','201101122117480',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122118220','201101122118220',5,'1.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122118290','201101122118290',12,'2.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122118350','201101122118350',10,'2.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122118390','201101122118390',11,'2.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122118430','201101122118430',15,'3.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122119580','201101122119580',16,'1.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122120110','201101122120110',9,'5.0000',1,1,NULL,5,NULL,5,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122120150','201101122120150',11,'10.0000',1,1,NULL,5,NULL,5,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122120190','201101122120190',13,'5.0000',1,1,NULL,5,NULL,5,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122121270','201101122121270',17,'5.0000',1,1,NULL,5,NULL,5,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122121370','201101122121370',14,'3.0000',1,1,NULL,6,NULL,6,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122130530','201101122130530',18,'2.0000',1,1,NULL,6,NULL,6,2,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122225150','201101122225150',14,'1.0000',1,1,NULL,6,NULL,6,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122150020','201101122150020',6,'1.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122150480','201101122150480',8,'3.0000',1,1,NULL,2,NULL,2,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122151380','201101122151380',7,'5.0000',1,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122151590','201101122151590',3,'8.0000',10,1,NULL,3,NULL,3,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122156510','201101122156510',16,'1.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122156550','201101122156550',15,'3.0000',1,1,NULL,4,NULL,4,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091921190','201103091921190',27,'3.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091921240','201103091921240',69,'3.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091921320','201103091921320',144,'12.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091921560','201103091921560',69,'4.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091922030','201103091922030',115,'4.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091922080','201103091922080',131,'16.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091922160','201103091922160',148,'16.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102034250','201103102034250',11,'8.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102034310','201103102034310',20,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102034440','201103102034440',39,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102035330','201103102035330',50,'1.0000',17,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102035380','201103102035380',59,'8.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102035530','201103102035530',100,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102037070','201103102037070',109,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102037220','201103102037220',27,'3.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102037310','201103102037310',69,'3.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102037350','201103102037350',144,'12.0000',1,2,NULL,3,NULL,16,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038030','201103102038030',69,'4.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038090','201103102038090',115,'4.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038150','201103102038150',131,'16.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038190','201103102038190',148,'16.0000',1,2,NULL,4,NULL,17,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038310','201103102038310',11,'8.0000',1,2,NULL,5,NULL,18,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038350','201103102038350',133,'8.0000',1,2,NULL,5,NULL,18,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038500','201103102038500',89,'2.0000',1,2,NULL,6,NULL,19,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038540','201103102038540',132,'4.0000',1,2,NULL,6,NULL,19,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102038580','201103102038580',152,'4.0000',1,2,NULL,6,NULL,19,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102039020','201103102039020',190,'4.0000',1,2,NULL,6,NULL,19,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102039140','201103102039140',14,'4.0000',1,2,NULL,7,NULL,20,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102039190','201103102039190',169,'4.0000',1,2,NULL,7,NULL,20,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102039240','201103102039240',172,'4.0000',1,2,NULL,7,NULL,20,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102040010','201103102040010',66,'1.0000',1,2,NULL,9,NULL,25,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102040270','201103102040270',66,'1.0000',1,2,NULL,11,NULL,27,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102040300','201103102040300',67,'1.0000',1,2,NULL,11,NULL,27,2,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102041040','201103102041040',193,'1.0000',17,2,NULL,12,NULL,28,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609200','201103211609200',11,'8.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609270','201103211609270',20,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609310','201103211609310',39,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609360','201103211609360',50,'1.0000',17,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609470','201103211609470',59,'8.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609510','201103211609510',100,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609540','201103211609540',109,'4.0000',1,2,NULL,2,NULL,15,2,NULL,NULL,NULL);
/*!40000 ALTER TABLE `inventory_consumption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `parent_loc_id` varchar(45) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `contact_employee` int(10) unsigned NOT NULL,
  `adjacent_loc_id1` int(5) unsigned DEFAULT NULL,
  `adjacent_loc_id2` int(5) unsigned DEFAULT NULL,
  `adjacent_loc_id3` int(5) unsigned DEFAULT NULL,
  `adjacent_loc_id4` int(5) unsigned DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'company',NULL,'2010-08-04 10:55:16',NULL,1,NULL,NULL,NULL,NULL,'This is the location representing the whole company',NULL);
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lot_history`
--

DROP TABLE IF EXISTS `lot_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `status` enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `end_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned DEFAULT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `approver_id` int(10) unsigned DEFAULT NULL,
  `result` text,
  `comment` text,
  PRIMARY KEY (`lot_id`,`start_timecode`,`process_id`,`step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lot_history`
--

LOCK TABLES `lot_history` WRITE;
/*!40000 ALTER TABLE `lot_history` DISABLE KEYS */;
INSERT INTO `lot_history` VALUES (1,'RACN-ASL-60000000001','201011091811470','201011091811470',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(1,'RACN-ASL-60000000001','201012071529170','201012071529170',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,'T',NULL),(1,'RACN-ASL-60000000001','201012071529250','201101041603490',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Susan reviewed first step.'),(1,'RACN-ASL-60000000001','201101041603490','201101041607480',1,NULL,3,NULL,3,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101041607480','201101111948450',1,NULL,4,NULL,4,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111948450','201101111949070',1,NULL,5,NULL,5,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949070','201101111949180',1,NULL,6,NULL,6,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949180','201101111949280',1,NULL,7,NULL,7,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949350','201101111949350',1,NULL,8,NULL,8,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949420','201101111949420',1,NULL,9,NULL,9,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949490','201101111949490',1,NULL,10,NULL,10,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111949560','201101111949560',1,NULL,11,NULL,11,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111950000','201101111950000',1,NULL,12,NULL,12,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(1,'RACN-ASL-60000000001','201101111950430','201101111950430',1,NULL,13,NULL,13,2,2,'shipped','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'RECIPIENT:Susan Dong\nRECIPIENT CONTACT:860-799-8321\nDELIVERY DATETIME:2011-01-11 11:50:00\nDELIVERY ADDRESS:Oregon\nCOMMENT:Step started automatically'),(2,'RACN-ASL-60000000002','201011091811470','201011091811470',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(3,'RACN-ASL-60000000003','201011121106520','201011121106520',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(4,'RACN-ASL-60000000004','201011300901150','201011300901150',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(5,'RACN-ASL-60000000005','201011300901150','201011300901150',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(6,'RACN-ASL-60000000006','201012071528240','201012071528240',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(6,'RACN-ASL-60000000006','201101041608000','201101041608000',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'test dispatch'),(6,'RACN-ASL-60000000006','201101041608000','201101041608050',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(6,'RACN-ASL-60000000006','201101041608050','201101111940010',1,NULL,3,NULL,3,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(6,'RACN-ASL-60000000006','201101111940010',NULL,1,NULL,4,NULL,4,2,NULL,'started','1.0000',NULL,1,NULL,NULL,NULL,NULL,'Step started automatically'),(7,'RACN-ASL-60000000007','201101041610370','201101041610370',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(8,'RACN-ASL-60000000008','201101041610370','201101041610370',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120357290','201101120357290',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(9,'RACN-ASL-60000000009','201101120358590','201101120358590',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(9,'RACN-ASL-60000000009','201101120358590','201101120437310',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(9,'RACN-ASL-60000000009','201101120437320','201101120439000',1,NULL,3,NULL,3,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Assembly smooth.'),(9,'RACN-ASL-60000000009','201101120439010',NULL,1,NULL,4,NULL,4,2,NULL,'started','1.0000',NULL,1,NULL,NULL,NULL,NULL,'Step started automatically'),(10,'RACN-ASL-60000000010','201101120357290','201101120357290',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(10,'RACN-ASL-60000000010','201101122117040','201101122117040',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(10,'RACN-ASL-60000000010','201101122117040','201101122117340',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Susan did it.'),(10,'RACN-ASL-60000000010','201101122117340','201101122117540',1,NULL,3,NULL,3,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(10,'RACN-ASL-60000000010','201101122117540','201101122120010',1,NULL,4,NULL,4,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(10,'RACN-ASL-60000000010','201101122120010','201101122121290',1,NULL,5,NULL,5,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(10,'RACN-ASL-60000000010','201101122121290',NULL,1,NULL,6,NULL,6,2,NULL,'started','1.0000',NULL,1,NULL,NULL,NULL,NULL,'Step started automatically'),(11,'RACN-ASL-60000000011','201101122136480','201101122136480',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(11,'RACN-ASL-60000000011','201101122219470','201101122219470',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(11,'RACN-ASL-60000000011','201101122219470','201102140433180',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(11,'RACN-ASL-60000000011','201102140433180',NULL,1,NULL,3,NULL,3,2,NULL,'started','1.0000',NULL,1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122145180','201101122145180',1,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(12,'RACN-ASL-60000000012','201101122148570','201101122148570',1,NULL,1,NULL,1,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(12,'RACN-ASL-60000000012','201101122148570','201101122150520',1,NULL,2,NULL,2,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122150520','201101122152080',1,NULL,3,NULL,3,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122156280','201101122157150',1,NULL,4,NULL,4,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'equipment was used'),(12,'RACN-ASL-60000000012','201101122157150','201101122157220',1,NULL,5,NULL,5,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122157220','201101122157290',1,NULL,6,NULL,6,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122157290','201101122157340',1,NULL,7,NULL,7,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122157540','201101122157540',1,NULL,8,NULL,8,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122157560','201101122157560',1,NULL,9,NULL,9,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122157580','201101122157580',1,NULL,10,NULL,10,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122158010','201101122158010',1,NULL,11,NULL,11,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122158060','201101122158060',1,NULL,12,NULL,12,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(12,'RACN-ASL-60000000012','201101122200580','201101122200580',1,NULL,13,NULL,13,2,2,'shipped','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'RECIPIENT:susan\nRECIPIENT CONTACT:8677998321\nDELIVERY DATETIME:2011-01-11 13:59:00\nDELIVERY ADDRESS:fgfgf\nCOMMENT:received'),(13,'RACN-ASL-60000000013','201103091904210','201103091904210',2,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(13,'RACN-ASL-60000000013','201103091904300','201103091904300',2,NULL,1,NULL,14,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(13,'RACN-ASL-60000000013','201103091904300','201103091921070',2,NULL,2,NULL,15,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(13,'RACN-ASL-60000000013','201103091921070','201103091921340',2,NULL,3,NULL,16,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(13,'RACN-ASL-60000000013','201103091921340','201103091922230',2,NULL,4,NULL,17,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(13,'RACN-ASL-60000000013','201103091922230',NULL,2,NULL,5,NULL,18,2,NULL,'started','1.0000',NULL,1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102033590','201103102033590',2,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(14,'YMCA_0000000001','201103102034120','201103102034120',2,NULL,1,NULL,14,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'test'),(14,'YMCA_0000000001','201103102034120','201103102037140',2,NULL,2,NULL,15,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102037140','201103102037370',2,NULL,3,NULL,16,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102037380','201103102038220',2,NULL,4,NULL,17,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102038220','201103102038370',2,NULL,5,NULL,18,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102038370','201103102039040',2,NULL,6,NULL,19,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102039040','201103102039270',2,NULL,7,NULL,20,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102039380','201103102039450',2,NULL,8,NULL,21,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,'True','test'),(14,'YMCA_0000000001','201103102039450','201103102040040',2,NULL,9,NULL,25,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102040100','201103102040180',2,NULL,10,NULL,26,2,2,'ended','1.0000','1.0000',1,NULL,NULL,7,'True',''),(14,'YMCA_0000000001','201103102040180','201103102040330',2,NULL,11,NULL,27,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102040330','201103102041070',2,NULL,12,NULL,28,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(14,'YMCA_0000000001','201103102041150','201103102041150',2,NULL,13,NULL,29,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041230','201103102041230',2,NULL,14,NULL,30,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041260','201103102041260',2,NULL,15,NULL,31,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041290','201103102041290',2,NULL,16,NULL,32,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041310','201103102041310',2,NULL,17,NULL,33,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041340','201103102041340',2,NULL,18,NULL,34,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102041450','201103102041450',2,NULL,19,NULL,35,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102046580','201103102046580',2,NULL,20,NULL,36,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(14,'YMCA_0000000001','201103102047200','201103102047200',2,NULL,21,NULL,37,2,2,'shipped','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'RECIPIENT:Susan\nRECIPIENT CONTACT:test\nDELIVERY DATETIME:2011-03-10 12:46:00\nDELIVERY ADDRESS:test\nCOMMENT:test'),(15,'RACN-ASL-60000000014','201103211608560','201103211608560',2,NULL,0,NULL,0,2,2,'dispatched','1.0000','1.0000',1,NULL,NULL,NULL,NULL,NULL),(15,'RACN-ASL-60000000014','201103211609130','201103211609130',2,NULL,1,NULL,14,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(15,'RACN-ASL-60000000014','201103211609130','201103211610040',2,NULL,2,NULL,15,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Finished well.'),(15,'RACN-ASL-60000000014','201103211610040','201103211610190',2,NULL,3,NULL,16,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211610190','201103211610370',2,NULL,4,NULL,17,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'skipped parts recording.'),(15,'RACN-ASL-60000000014','201103211610370','201103211610440',2,NULL,5,NULL,18,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211610440','201103211610500',2,NULL,6,NULL,19,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211610500','201103211611020',2,NULL,7,NULL,20,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211611170','201103211611270',2,NULL,8,NULL,21,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,'False','I am following procedures.'),(15,'RACN-ASL-60000000014','201103211611270','201103211618540',2,NULL,25,NULL,22,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211620320','201103211620320',2,NULL,26,NULL,23,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,',7,,20','Reposition to wiring step for rewiring.'),(15,'RACN-ASL-60000000014','201103211620430','201103211620550',2,NULL,7,NULL,20,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(15,'RACN-ASL-60000000014','201103211621030','201103211621240',2,NULL,8,NULL,21,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,'False','still failed. probably no rescue.'),(15,'RACN-ASL-60000000014','201103211621240','201103211621410',2,NULL,25,NULL,22,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Step started automatically'),(15,'RACN-ASL-60000000014','201103211633530','201103211633530',2,NULL,26,NULL,23,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,',7,,20','retry'),(15,'RACN-ASL-60000000014','201103211634030','201103211634070',2,NULL,7,NULL,20,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,''),(15,'RACN-ASL-60000000014','201103211634150','201103211634280',2,NULL,8,NULL,21,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,'False','not working'),(15,'RACN-ASL-60000000014','201103211634280','201103211637500',2,NULL,25,NULL,22,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'Batch RACN-ASL-60000000014 has been held due to the result from previous step.'),(15,'RACN-ASL-60000000014','201103211640080','201103211640080',2,NULL,26,NULL,23,2,2,'ended','1.0000','1.0000',1,NULL,NULL,NULL,',27,,24','scrap the batch'),(15,'RACN-ASL-60000000014','201103211640280','201103211640280',2,NULL,27,NULL,24,2,2,'scrapped','1.0000','1.0000',1,NULL,NULL,NULL,NULL,'the batch is no use.');
/*!40000 ALTER TABLE `lot_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lot_status`
--

DROP TABLE IF EXISTS `lot_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lot_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(20) DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `status` enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped') NOT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lot_status`
--

LOCK TABLES `lot_status` WRITE;
/*!40000 ALTER TABLE `lot_status` DISABLE KEYS */;
INSERT INTO `lot_status` VALUES (1,'RACN-ASL-60000000001',1,1,1,'shipped','1.0000','1.0000',1,'201101111950430',3,2,2,'2010-11-09 18:11:47',NULL,'Step started automatically'),(2,'RACN-ASL-60000000002',1,1,1,'dispatched','1.0000','1.0000',1,'201011091811470',3,2,2,'2010-11-09 18:11:47',NULL,NULL),(3,'RACN-ASL-60000000003',1,1,1,'dispatched','1.0000','1.0000',1,'201011121106520',3,2,2,'2010-11-12 11:06:52',NULL,NULL),(4,'RACN-ASL-60000000004',1,1,1,'dispatched','1.0000','1.0000',1,'201011300901150',3,2,2,'2010-11-30 09:01:15',NULL,'test'),(5,'RACN-ASL-60000000005',1,1,1,'dispatched','1.0000','1.0000',1,'201011300901150',3,2,2,'2010-11-30 09:01:15',NULL,'test'),(6,'RACN-ASL-60000000006',1,1,1,'in process','1.0000','1.0000',1,'201101111940010',3,2,2,'2010-12-07 15:28:24',NULL,'Step started automatically'),(7,'RACN-ASL-60000000007',1,1,1,'dispatched','1.0000','1.0000',1,'201101041610370',3,2,2,'2011-01-04 16:10:37',NULL,NULL),(8,'RACN-ASL-60000000008',1,1,1,'dispatched','1.0000','1.0000',1,'201101041610370',3,2,2,'2011-01-04 16:10:37',NULL,NULL),(9,'RACN-ASL-60000000009',2,1,1,'in process','1.0000','1.0000',1,'201101120439010',7,3,2,'2011-01-12 03:57:29',NULL,'Step started automatically'),(10,'RACN-ASL-60000000010',2,1,1,'in process','1.0000','1.0000',1,'201101122121290',7,3,2,'2011-01-12 03:57:29',NULL,'Step started automatically'),(11,'RACN-ASL-60000000011',2,1,1,'in process','1.0000','1.0000',1,'201102140433180',7,3,2,'2011-01-12 21:36:48',NULL,'Step started automatically'),(12,'RACN-ASL-60000000012',2,1,1,'shipped','1.0000','1.0000',1,'201101122200580',7,3,2,'2011-01-12 21:45:18',NULL,'received'),(13,'RACN-ASL-60000000013',2,1,2,'in process','1.0000','1.0000',1,'201103091922230',7,3,2,'2011-03-09 19:04:21',NULL,'Step started automatically'),(14,'YMCA_0000000001',3,1,2,'shipped','1.0000','1.0000',1,'201103102047200',2,2,2,'2011-03-10 20:33:59',NULL,'test'),(15,'RACN-ASL-60000000014',3,1,2,'scrapped','1.0000','1.0000',1,'201103211640280',2,2,2,'2011-03-21 16:08:56',NULL,'the batch is no use.');
/*!40000 ALTER TABLE `lot_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (7,'LXV75-24SW',1,'4',1,NULL,'1.0000','solid','production','2010-09-27 07:57:59',2,'2010-10-20 07:09:26',2,'Power Supply',NULL),(8,'Itineris 6001',1,'5',1,'100.0000','100.0000','solid','production','2010-09-27 07:38:21',2,'2011-02-16 19:06:25',2,'LED Module','UL Listing E327051'),(9,'BSPL-0001',1,'6',1,'1.0000','10.0000','solid','production','2010-09-27 07:38:55',2,'2011-02-11 12:46:33',2,'AL Base Plate','Alum 0.1â€'),(10,'STOF-0001',1,'6',1,NULL,'10.0000','solid','production','2010-09-27 07:39:32',2,NULL,NULL,'AL Standoffs','Alum 0.1â€'),(11,'HS 08B ST221',1,'7',10,NULL,'1000.0000','solid','production','2010-09-27 07:40:18',2,'2011-05-16 15:04:15',2,'1/2\" Heat Shrink Tube',NULL),(12,'SSSH008104',1,'7',1,NULL,'1000.0000','solid','production','2010-09-27 07:43:12',2,NULL,NULL,'SS Socket Cap Screw','8-32x1/4'),(13,'SSSH011008',1,'7',1,NULL,'1000.0000','solid','production','2010-09-27 07:45:06',2,NULL,NULL,'SS Socket Cap Screw','10-32X1/2'),(14,'SSSB040200',1,'7',1,NULL,'1000.0000','solid','production','2010-09-27 07:45:39',2,NULL,NULL,'SS Socket Cap Screw','Â¼-20x2'),(15,'SSSH040008',1,'7',1,NULL,'1000.0000','solid','production','2010-09-27 07:46:20',2,NULL,NULL,'SS Socket Cap Screw','Â¼-20x1/2'),(16,'SSFW008',1,'7',1,NULL,'100.0000','solid','production','2010-09-27 07:47:18',2,NULL,NULL,'SS Flat Washer #8',NULL),(17,'SSLW040',1,'7',1,NULL,'100.0000','solid','production','2010-09-27 07:47:43',2,NULL,NULL,'SS Lock Washer 1/4',NULL),(18,'TER6400 20503',1,'7',1,NULL,'1000.0000','solid','production','2010-09-27 07:48:09',2,NULL,NULL,'Wire Nuts',NULL),(19,'1-480701-0',1,'8',1,NULL,'100.0000','solid','production','2010-09-27 07:48:57',2,NULL,NULL,'Female Connector','3 position'),(20,'350550-1',1,'8',1,'100.0000','100.0000','solid','production','2010-09-27 07:49:42',2,'2011-02-16 19:04:07',2,'Female pins',NULL),(21,'ShipLabel_product',1,NULL,1,NULL,'1000.0000','solid','production','2010-09-27 07:50:50',2,NULL,NULL,'Product Label',NULL),(22,'ShipLabel_dimension',1,'9',1,NULL,'1000.0000','solid','production','2010-09-27 07:51:23',2,'2010-10-27 11:01:30',2,'Dimensions Label',NULL),(23,'ShipLabel_warning',1,'9',1,NULL,'1000.0000','solid','production','2010-09-27 07:51:59',2,'2011-01-12 13:24:18',2,'Warning Label',NULL),(24,'ShipTieWraps',1,'9',1,NULL,'1000.0000','solid','production','2010-09-27 07:53:06',2,'2011-01-12 13:24:28',2,'Black Tie Wraps',NULL),(25,'ShipBox',1,'9',1,NULL,'50.0000','solid','production','2010-09-27 07:53:38',2,'2011-01-12 13:24:38',2,'Shipping Box',NULL),(26,'ShipTape',1,'9',1,NULL,'100.0000','solid','production','2010-09-27 07:54:08',2,'2011-01-12 13:24:47',2,'Shipping Tape',NULL),(27,'ShipBubbleWrap',1,'9',12,NULL,'50.0000','solid','production','2010-09-27 07:54:58',2,'2011-01-12 13:24:56',2,'Shipping Bubble Wrap',NULL),(35,'00-0851934',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,'2011-04-12 11:43:48',2,'WIRELEAD 20GA 18INCH BLACK',NULL),(36,'00-8501',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Grommet, Flourosilicone, 50A',NULL),(37,'00-8510',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'EPOXY APPLICATOR',NULL),(38,'00-8518',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'WIRE LEAD 20GA 18 INCH RED',NULL),(39,'00-8519',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,NULL,NULL),(40,'00-8524',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'WIRE LEAD 20GA 18INCH YELLOW',NULL),(41,'00-8555extrusion',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS REBEL RAW HEAT SINK (AEROLEDS)',NULL),(42,'14-7917',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TRANEX TRANS 3 A(3-5-10 VER) 240-280',NULL),(43,'1804030-1',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TOOL EXTRACTION NI-MATE-II',NULL),(44,'1B150B2X1/8C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'D-BULB TRIM GASKET',NULL),(45,'209150',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LINDY RING HEAT SINK UN PAINTED',NULL),(46,'209190',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LINDY RING MOUNTING CLIPS',NULL),(47,'209192',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LINDY RING HEAT SINK, 18\" BLACK W/MOUNTING CLIPS..................LINDY RING HEAT SINK, BLACK W/ MOUNTING CLIPS....',NULL),(48,'259-1398-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'FAN 12VDC 40X10MM .6W 4.9CFM',NULL),(49,'259-1510-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'FAN BRUSHLES 92X92X25M 24VDC',NULL),(50,'311-1127-1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP 1000PF 50V CERAMIC X7R 0805',NULL),(51,'33C7208',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NTE ELECTRONICS WHS20-00-100, WIRE, 100FT,20AWG CU, BLACK',NULL),(52,'33C7213',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NTE ELECTRONICS WHS20-02-25, WIRE, 25FT,20AWG,CU,RED',NULL),(53,'3M5462-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'14 pin IC Socket',NULL),(54,'445-1273-1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP CER 22PF 50V C0G 5% 0603',NULL),(55,'445-5009-1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP CER 1.0PF 50V C0G 0603',NULL),(56,'478-1164-1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP CERM 12PF 5% 50V NP0 0603',NULL),(57,'490-1519-2-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP CER .1UF 50V 10% X7R 0603',NULL),(58,'490-1733-1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP CER 2.2UF 25V Y5V 0805',NULL),(59,'50-0002',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS PLUS MODULE',NULL),(60,'50-0003 MC-E',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS MC-E MODULE. 50-0003',NULL),(61,'50-4000',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MOTION SENSOR COMPLETE (AEROLEDS)',NULL),(62,'565-1437-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Capacitor 100uF, 200V',NULL),(63,'60-0001-A-A-A',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Itineris Rebel LED Module (Reflector Lens)',NULL),(64,'60-0001-A-C-A',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS REBEL MODULE 18 INCH LEADS NO LENS',NULL),(65,'60-0003-D',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS XP MODULES - 18 \" LEADS',NULL),(66,'60-0007',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Itineris XP Heatsink',NULL),(67,'60-0009',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ITINERIS XP PCA ONLY',NULL),(68,'60-6005-XP',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'6005-XP LED Module complete, 0.18 ohm R5, R6',NULL),(69,'60-6009-XP PCA',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'60-6009-XP PCA only, 0.18 ohm R5, R6',NULL),(70,'633-1097-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'633-1097-ND..Power Supply LED IP67 100W 24V..Sced B: 850440  ECCN: EAR99..Lead Free',NULL),(71,'708810',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Lindy 424 Refractor Type V Pac-LG w/V-Ring',NULL),(72,'709882',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SERIES 424 -MODEL 424 PREMIUM ACRYLIC-LG',NULL),(73,'709945',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SERIES 424- MODEL 439 PREM ACRYLIC-LG',NULL),(74,'728802',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Model 315, Acrylic, 12\"x12\"x2.5\" Diffuser',NULL),(75,'730K-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'GROMMET RUBBER .125\"DIA .312\"L',NULL),(76,'731173',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'351 D16\" Lens AC Counterbore Rim',NULL),(77,'732400',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ACRYLIC-LG WITH INSIDE LIFTING PRISMS MODEL# 350',NULL),(78,'804455',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'816CDL D16\" Lens, Model 16CDL',NULL),(79,'805328',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Lite lid perforated - Model # 409B',NULL),(80,'805340',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SERIES 424-MODEL 424 ALUMINUM NECK RING',NULL),(81,'805348',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SERIES 424-MODEL 424- MOGAL BASE',NULL),(82,'94639A106',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PLASTIC STAND OFF 1/4X1/2',NULL),(83,'983980',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Type 5 Globe - Model #408',NULL),(84,'984021',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Globe Top - Model #408',NULL),(85,'A1441-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CONN SOCKET 14-20AWG TIN CRIMP',NULL),(86,'A1450-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CONN PLUG 3POS 94V-2 UNI-MATE',NULL),(87,'A1451-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CONN CAP 3POS 94V-2 UNI-MATE',NULL),(88,'A19-100-1LD-12',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-100-1LD-12',NULL),(89,'A25343-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CONN PIN 14-20AWG TIN CRIMP LEAD FREE',NULL),(90,'A34344-40-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CONN HEADR BRKWAY .100 80POS STR',NULL),(91,'AMN14111',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'DIGITAL MOTION SENSOR-(BLACK) PART NUMBER AMN14111',NULL),(92,'AMN14112',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHOTO SENSOR (AEROLEDS)',NULL),(93,'AT AVR128RFA1-EK1-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BOARD EVAL 802.15.4 ATMEGA 128',NULL),(94,'ATC08003',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ALL THREAD USS 1/2\" X 3\'',NULL),(95,'Atmel Processor',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Atmel Processor, ATmega 128RFA1',NULL),(96,'AWG-20TefzelGrn',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'AWG-20, Green, 18 inch',NULL),(97,'Baffel Kit',1,NULL,17,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,'2011-03-01 08:38:37',2,'YMCA Baffle kit, 1- four module mounting plate. 100\" alum. and four fan mounting brackets.',NULL),(98,'BLB-10-C-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-100-1D-I, 9.8 WATTS',NULL),(99,'BLB-10-N-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-75-1N-I, 9.8 WATT 3500K',NULL),(100,'BLB-10-W-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-100-1ID-12,  10 WATT 2700K',NULL),(101,'BLB-12-W-NB-30L',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R30L-75-1WD-INF,  12.4 WATTS 3000K',NULL),(102,'BLB-12-W-NB-30S',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R30S-75-1WD-INF,  12.4 WATTS 3000K',NULL),(103,'BLB-13-W-NB-38',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R38-75-1WD-INF,  12.7 WATTS 3000K',NULL),(104,'BLB-19-W-NB-38',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R38-1WD-INF, 19 WATT 3000K',NULL),(105,'BLB-2-N-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-25-1N-I,  2.1 WATT 3500K',NULL),(106,'BLB-3-C-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-40-1D-I,  3.45 WATT 5000K',NULL),(107,'BLB-3-W-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-60-1ID-12,  3 WATT 2700K',NULL),(108,'BLB-3-W-NB-20',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R20-35-1WD-INF,  3.1 WATTS 3000K',NULL),(109,'BLB-4-N-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-40-1N-I,  3.8 WATT 3500K',NULL),(110,'BLB-4-W-NB-16',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-MR16-75-12WD-INF, 3.9 WATTS 3000K',NULL),(111,'BLB-6-W-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-75-1ID-12,  5.5 WATT 2700K',NULL),(112,'BLB-6-W-NB-16',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-MR16-35-12WD-INF,  6 WATTS 3000K',NULL),(113,'BLB-6-W-NB-20',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R20-50-1WD-INF, 6 WATTS 3000K',NULL),(114,'BLB-7-C-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-60-1D-I, 6.95 WATTS 5000K',NULL),(115,'BLB-8-C-19',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-A19-75-1D-I,  8.15 WATTS 5000K',NULL),(116,'BLB-8-W-NB-30L',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R30L-50-1WD-INF, 8 WATTS 3000K',NULL),(117,'BLB-8-W-NB-30S',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-R30S-1WD-INF,  8 WATTS 3000K',NULL),(118,'BracketKit-JosOR',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Joseph OR 7 piece LED light bracket kit',NULL),(119,'Bridgelux LEDs',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-C2002-00G00, 5000K LED',NULL),(120,'BRK-BFL-0001',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Baffle bracket for single XP module',NULL),(121,'BRK-BFL-0002',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Baffle Bracket for Single XP Module for Small Wall Pack',NULL),(122,'BRK-FAN-0001',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Fan Bracket for Sunon 80mm fan',NULL),(123,'BRK-PSU-0001',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Power Supply Bracket for Meanwell CLG60/24',NULL),(124,'BXRA-C0802-00000',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-C0802 800 Lumen LED Array',NULL),(125,'BXRA-C0802-00G00',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-C0802-00G00, LED ARRAY, 5000K',NULL),(126,'BXRA-C1202-00000',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-C1202-00000 1200 Lumen LED Array',NULL),(127,'BXRA-C2002-00000',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'2000 Lumen Cool White Led Ray',NULL),(128,'BXRA-C2002-00G00',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-C2002-00G00, LED Array, 5000K',NULL),(129,'BXRA-N0802-00L00',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-N0802-00L00 (ONLY M BINS), LED ARRAY, 3750K',NULL),(130,'BXRA-N0802-00L10',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BXRA-N0802-00L10',NULL),(131,'BXRA-W1202-00Q00',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'XRA-W1202-00Q00 (Q3, Q4)',NULL),(132,'CLG-100-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100 WATT, 100-277VAC INPUT, 24VDC OUTPUT, CONSTANT VOLTAGE POWER SUPPLY',NULL),(133,'CLG-60-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MEANWELL 24VDC PFC POWER SUPPLY',NULL),(134,'CLG-60-24/277',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Meanwell Constant Voltage PSU, CLG-60-24/277, 60 watts, 24VDC output',NULL),(135,'CM102-810-292',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Fixture Label UL969, 1.25\" x 2.0\"',NULL),(136,'CM102-810-294',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Itineris XP Label UL969, 1.60\" x .92\"',NULL),(137,'CMRB 10 D LT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MOTION SENSOR LOW TEMP',NULL),(138,'CR212-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CR212 - Plastic Fan Filter Assembly, 80MM, 30PPI',NULL),(139,'CR214-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CR214-ND..Finger/Filtr ASM 80MM Plas 45 PPI....Sched B: 841490  ECCN: EAR99..Lead free',NULL),(140,'CR283-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CR283-ND Finger/Filtr ASM 60MM Plasm..3PPI ..Sched B 841490..ECCN: EAR99, Lead free',NULL),(141,'DBO.0938 T1D',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'DRILL HSS JBR SP 3/32',NULL),(142,'DF04M-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Bridge Rectifier',NULL),(143,'ED2581-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'3 Wire Terminal Connector',NULL),(144,'ENDURA 63 LED',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'63 LED 525 MA STREET LIGHT RETRO COBRA HEAD',NULL),(145,'EUC-025-S105PS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'25W/1.05A, CC',NULL),(146,'EUC-025S070PS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'25W/0.7A, CC',NULL),(147,'EUC-075S070DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'75W/0.7A, CC, Dimming',NULL),(148,'EUC-075S105DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'75W/1.05A, CC, Dimming',NULL),(149,'euc-075S140DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'75W/1.4A, CC, Dimming',NULL),(150,'EUC-100S070DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/0.7A, CC, Dimming',NULL),(151,'EUC-100S070ST',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/0.7A, CC',NULL),(152,'EUC-100S105DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/1.05A, CC, Dimming',NULL),(153,'EUC-100S105ST',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/1.05A, CC',NULL),(154,'EUC-100S140DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/1.4A, CC, Dimming',NULL),(155,'EUC-100S140ST',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/1.4A, CC',NULL),(156,'EUC-120070DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'120W/0.7A, CC, Dimming',NULL),(157,'EUC-120S070DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'120W/0.7A, CC, Dimming',NULL),(158,'EUC-120S105DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'120W/1.05A, CC, Dimming',NULL),(159,'EUC-120S140DT',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'120W/1.4A, CC, Dimming',NULL),(160,'EUV-075S024ST',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'75W/24Vdc, CV',NULL),(161,'EUV-100S024ST',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100W/24DC,CV',NULL),(162,'EXC LXV100-024SW',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LXV100-024SW Excelsys Power Supply 100W, 24VDC, IP67',NULL),(163,'EXC LXV150-024SW',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'EXC LXV150-024SW POWER SUPPLY',NULL),(164,'EXC LXV75-024SW',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED POWER SUPPLY IP-67 75W 24VDC ..EXCELSYS TECHNOLOGIES LTD.277 VAC',NULL),(165,'FILE570 SF-3',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BURS 3/8 X 3/4 1/4 SHANK',NULL),(166,'FW2U008',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'FLATWASHER GR2 USS 1/2',NULL),(167,'GDS06T-42',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'600 X 600 19 58 WATT',NULL),(168,'GFC01SER-42',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'600 X 600 X19 42 WATT',NULL),(169,'GTS03T40',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'GTS03T40, Troffer, 4000K, 62 Watts',NULL),(170,'HK260 20912',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'HEX KEY SET .050 - 5/16\"',NULL),(171,'HN2C06',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'HEX NUT GR2 USS 3/8',NULL),(172,'HN2C08',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'HEX NUT GR2 USS 1/2',NULL),(173,'HS03B ST221',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'HEAT SHRINK 4\' BLK 3/16\'\"',NULL),(174,'HS04B ST221',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'HEAT SHRINK 4\' BLK 1/4\"',NULL),(175,'HS12B ST221',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'3/4 HEAT SHRINK TUBE 48 INCHES LONG',NULL),(176,'INTA-0024V-28FO',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHILLIPS ADVANCE LED-INTA-0024V-28FO',NULL),(177,'INTA-0024V41FOMS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHILLIPS ADVANCE POWER SUPPLY-PART# LED-INTA-0024V41FO',NULL),(178,'INTA-700C-140F30',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHILLIPS ADVANCE CC DRIVER 700MA',NULL),(179,'INTA00224V41FO',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'100 WATT, 100-277VAC INPUT, 24VDC OUTPUT, CONSTANT VOLTAGE POWER SUPPLY',NULL),(180,'INTA700C105DHO',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHILIPS ADVANCE 75W 0.70A 0-10V DIMMING',NULL),(181,'INTA700C140F30',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'PHILIPS ADVANCE 100W 0.35A-0.70A',NULL),(182,'Itineris XP',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Itineris XP Module 61-1003',NULL),(183,'Itineris XP Lens',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'XP Lens Cover',NULL),(184,'Itineris XP PCA',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Itineris XP PCA 60-0009',NULL),(185,'L03F-18W',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'T8, 18W, Milky PC Lens, Daylight White 4000-4500K,288PCS',NULL),(186,'L03F-9W',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'T8, 9W, Milky PC Lens, Daylight White 4000-4500K,144PCS',NULL),(187,'L03F Driver',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'L03F Driver for Spare Parts',NULL),(188,'L03F Replacement',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'L03F Replacements, T8, Milky Lens, 4000-4500K',NULL),(189,'L04F',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'L04F Clear PC, 18W, White 4000-4500K',NULL),(190,'L05G',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'L05G, Milky PC Lens, 18W, 4000-4500K, 1200mm',NULL),(191,'LED-A19-75-1N-1',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LEDNOVATION A19-75-1N-1',NULL),(192,'Led-XP',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,NULL,NULL),(193,'LiteRing B',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Light Ring B from Artis Metals Co.',NULL),(194,'LiteRingA',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Ling Ring A from Artis Metals Co',NULL),(195,'LM339ANFS-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LM339ANFS-ND',NULL),(196,'LU725 03150',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CRC CONTACT CLEANER 2000',NULL),(197,'LW2006',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LOCKWASHER GR2 3/8',NULL),(198,'ME80252V3',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Brushless 80x80x25mm 24VDC SUNON FANS',NULL),(199,'MEO-65PN-02',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MICROPHONE (AEROLEDS)',NULL),(200,'MM34000',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'EXTRUDED HEAT SINK MM34000',NULL),(201,'MR16-35-12WD-INF',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED-MR16-35-12WD-INF, 6 watt, 12VAC',NULL),(202,'N100-30B',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'N100-30B, 100x100x30mm, Anodized',NULL),(203,'N100-40B',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'N100-40B, Anodized Heatsink, 100x100x40 mm',NULL),(204,'N100-50B',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'N100-50, Custom Heatsink, 100x100x50 mm, No anodization, no pins on corners.',NULL),(205,'PAR-CV-300-A',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Acrylic lens only',NULL),(206,'PAR-CV-300-H',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Housing Only....',NULL),(207,'PCE3816CT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'CAP ELECT 47UF 50V FK SMD',NULL),(208,'PERMATEX 81789',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LOCKNUT REMOV THRD LCK 50ML',NULL),(209,'PIXI LIGHT 4000K',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'LED PIXI LIGHT 4000K',NULL),(210,'PLN-30-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MEAWELL 24VDC PFC POWER SUPPLY PLN 30-24',NULL),(211,'PLN-60-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MEANWELL 24VDC PFC POWER SUPPLY',NULL),(212,'RC01-KR REMOTE',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'REMOTE CONTROL GO LIGHTING',NULL),(213,'RC02-KT REMOTE',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RC02-KT REMOTE CONTROL GO LIGHTING',NULL),(214,'RHM.12UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .12 OHM 1/2W 1% 2010 SMD',NULL),(215,'RHM.13UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .13OHM 1/2W 1% 2010 SMD',NULL),(216,'RHM.15UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .15 OHM 1/2W 1% 2010 SMD',NULL),(217,'RHM.18UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .18 OHM 1/2W 1% 2010 SMD',NULL),(218,'RHM.22UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .22 OHM 1/2W 1% 2010 SMD',NULL),(219,'RHM.25UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .25 OHM 1/2W 1% 2010 SMD',NULL),(220,'RHM.33UCT-ND',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'RES .33 OHM 1/2W 1% 2010 SMD',NULL),(221,'RS-50-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MEANWELL RS-50-24 POWER SUPPLY',NULL),(222,'RS-75-24',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'MEANWELL RS-75-24 POWER SUPPLY',NULL),(223,'SHEET METAL BOX',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'18\" X 18\" SHEET METAL BOX - REMOVABLE TOP - RECTANGULAR HOLES IN TOP',NULL),(224,'SOLDER MASK',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'XP SOLDER MASK STENCIL',NULL),(225,'Solder Mask Stencil',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Solder Mask Stencil',NULL),(226,'SSFW006',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS FLAT WASHER #6',NULL),(227,'SSFW010',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS FLAT WASHER #10',NULL),(228,'SSFW040U',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS FLAT WASHER USS 1/4',NULL),(229,'SSHN0060',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS M/S HEX NUT 6-32',NULL),(230,'SSHN0080',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS M/S HEX NUT 8-32',NULL),(231,'SSHN0110',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS M/S HEX NUT 10-32',NULL),(232,'SSHN040C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS HEX NUT USS 1/4',NULL),(233,'SSLN0060',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS NYLON LOCKNUT 6-32',NULL),(234,'SSLN0080',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS NYLON LOCKNUT 8-32',NULL),(235,'SSLN0110',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS NYLON LOCKNUT 10-32',NULL),(236,'SSLN040C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS NYLON LOCKNUT USS 1/4',NULL),(237,'SSLW006',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS LOCK WASHER #6',NULL),(238,'SSLW008',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS LOCK WASHER #8',NULL),(239,'SSLW010',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'S/S lockwasher #10',NULL),(240,'SSMSF004004P',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'S/S M/S FL PH 4-40X1/4',NULL),(241,'SSSB011006',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'S/S BHSC 10 - 32 X 3 / 8',NULL),(242,'SSSH004004',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 4-40X1/4',NULL),(243,'SSSH006004',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 6-32X1/4',NULL),(244,'SSSH006008',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 6-32X1/2',NULL),(245,'SSSH006012',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 6-32X3/4',NULL),(246,'SSSH006100',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 6-32X1',NULL),(247,'SSSH006104',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'S/S SHCS 6/32 X 1-1/4',NULL),(248,'SSSH006108',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 6-32X1-1/2',NULL),(249,'SSSH008004',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X1/4',NULL),(250,'SSSH008008',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X1/2',NULL),(251,'SSSH008012',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X3/4',NULL),(252,'SSSH008100',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X1',NULL),(253,'SSSH008108',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X1-1/2',NULL),(254,'SSSH008200',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 8-32X2',NULL),(255,'SSSH008202',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'S/S SHCS 8/3 2X2-1/2',NULL),(256,'SSSH011012',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 10-32X3/4',NULL),(257,'SSSH011100',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 10-32X1',NULL),(258,'SSSH040012',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 1/4X3/4',NULL),(259,'SSSH040100',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 1/4-20 X 1',NULL),(260,'SSSH040104',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 1/4X1-1/4',NULL),(261,'SSSH040108',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 1/4X1-1/2',NULL),(262,'SSSH040200',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SHCS 1/4X2',NULL),(263,'SSSMP008008P',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SMS PN PH #8X1/2',NULL),(264,'SSSMP008012P',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SMS PN PH # 8X3/4',NULL),(265,'SSSMP008100P',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SS SMS PN PH #8X1',NULL),(266,'SSW-PAR-100-BK',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'SAMPLE FOR EVALUATION',NULL),(267,'T-8 LED TUBE 48\" NATURAL',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'73114 LED TUBE 48\" UL NATURAL 15 WATT',NULL),(268,'T-8 LED TUBE 48\" WARM',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'73075 LED TUBE 48\" UL WARM 15 WATT',NULL),(269,'TER6200 20501',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'WIRE NUT 22-16 GRAY',NULL),(270,'TER6300 20502',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'WIRE NUT 22-14 BLUE',NULL),(271,'TER7500 20311',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'BUTT CONN NYL 12-10 YELLOW',NULL),(272,'TIE1030 9624',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NYLON TIE BLK 5-1/8\"',NULL),(273,'TLD0301',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TWIST LOCK 1 1/2 HOLDER',NULL),(274,'TLD0350 254306',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TWIST LOCK 2\" 80 GRIT',NULL),(275,'TLD0351',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TWIST LOCK 2\" 120 GRIT',NULL),(276,'TLD0389',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'TWIST LOCK 3\" 120 GRIT',NULL),(277,'Transformer',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'Transformer, TXT1000',NULL),(278,'UPL-150-C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'4* NEW PIAZZA,8*2002C,1050 MA,FANS,150W,5000K+',NULL),(279,'UPL-40-C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'2* NEW PIAZZA,2*1202C,1050 MA,40W,5000K+',NULL),(280,'UPL-55-C',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'3* NEW PIAZZA,3*1202C,1050 MA,55W,5000K+',NULL),(281,'VEL0200 66807',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'VELCRO DISC 2\" MEDIUM',NULL),(282,'VEL0201 77106',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'VELCRO DISC 2\" COARSE',NULL),(283,'VEL0204 59505',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'VELCRO ROLOC 2\" FINE',NULL),(284,'VEL0301 66808',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'VELCRO DISC 3\" COARSE',NULL),(285,'WLP-60-N',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NEW PIAZA, 3*1203N, 200W HIID,4000+',NULL),(286,'WLP-60-N-L',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NEW PIAZZA, 3*1203N,W,REFLECTORS FOR LONGER THROW,4000+,200W HIID',NULL),(287,'WSF008112P',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'W/S FL PH # 8X1 - 3/4',NULL),(288,'XP Rev 2 PCB',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'XP Rev 2 PCB Only, White',NULL),(289,'XX-0001',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'ADHESIVE DP460 1.7 FL OZ 89C3393',NULL),(290,'XX-0006',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'EPOXY NOZZLE MIXING',NULL),(291,'YMCA Reflectors',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'YMCA Reflectors. Fabricate and assemble 4\'x5\' reflector assemly per drawings.',NULL),(292,'ZZ44014NYSHC',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'4-40X1/4\" NYLON SOC HD CAP',NULL),(293,'ZZ812HWHDTSS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'#8 x 1/2 HWH TEK SCR S/S..ZZ812HWHDTSS',NULL),(294,'ZZ81HWHDTSS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'#8 x 1 HWH TEK SCR S/S..ZZ81HWHDTSS',NULL),(295,'ZZ834HWHDTSS',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'#8 x 3/4 HWH TEK SCR S/S..ZZ834HWHDTSS',NULL),(296,'ZZ94639A103',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NYLON SPACER 1/4 \" 1/2 \"..ZZ94639A103',NULL),(297,'ZZ94639A106',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NYLON SPACER 1/4 \" 1/2\"..ZZ94639A106',NULL),(298,'ZZ94639A108',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NYLONG SPACER 1/4\" 3/4\"..ZZ94639A108',NULL),(299,'ZZ94639A110',1,NULL,1,NULL,NULL,'solid','production','2011-02-10 10:22:11',2,NULL,NULL,'NYLON SPACER 1/4\" x 1\"..ZZ94639A110',NULL),(300,'YMCA 160 Installation Instruction',1,NULL,17,'50.0000',NULL,'solid','production','2011-03-04 08:33:39',2,NULL,NULL,'a kit of instruction includes 5 pages of printed installation instructions.',NULL);
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_group`
--

DROP TABLE IF EXISTS `material_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_group`
--

LOCK TABLES `material_group` WRITE;
/*!40000 ALTER TABLE `material_group` DISABLE KEYS */;
INSERT INTO `material_group` VALUES (1,'general','This group is a general group that can be used by any material',NULL),(2,'Industrial HW','This group has supplies supplied by Industrial HW.',NULL);
/*!40000 ALTER TABLE `material_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_supplier`
--

DROP TABLE IF EXISTS `material_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_supplier` (
  `material_id` int(10) unsigned NOT NULL,
  `supplier_id` int(10) unsigned NOT NULL,
  `preference` smallint(3) unsigned DEFAULT NULL,
  `mpn` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) unsigned DEFAULT NULL,
  `price_uom_id` smallint(3) unsigned DEFAULT NULL,
  `lead_days` int(5) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`material_id`,`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_supplier`
--

LOCK TABLES `material_supplier` WRITE;
/*!40000 ALTER TABLE `material_supplier` DISABLE KEYS */;
INSERT INTO `material_supplier` VALUES (12,20,NULL,'SSSH008104','0.00',1,NULL,NULL),(13,20,NULL,'SSSH011008','0.00',1,NULL,NULL),(14,20,NULL,NULL,'0.00',1,NULL,NULL),(15,20,NULL,'SSSH040008','0.00',1,NULL,NULL),(16,20,NULL,'SSFW008','0.00',1,NULL,NULL),(17,20,NULL,'SSLW040','0.00',1,NULL,NULL),(18,20,NULL,'TER6400 20503','0.00',1,NULL,NULL),(35,5,NULL,'00-08519','0.00',1,NULL,NULL),(37,5,NULL,'00-8510','0.00',1,NULL,NULL),(38,5,NULL,'00-8518','0.00',1,NULL,NULL),(39,5,NULL,'00-8519','0.00',1,NULL,NULL),(40,5,NULL,'00-8524','0.00',1,NULL,NULL),(41,5,NULL,'00-8555 extrusion','0.00',1,NULL,NULL),(42,14,NULL,'14-7917','0.00',1,NULL,NULL),(44,15,NULL,'1B150B2X1/8C','0.94',1,NULL,NULL),(45,16,NULL,'209150','0.00',1,NULL,NULL),(46,16,NULL,'209190','0.00',1,NULL,NULL),(47,16,NULL,'209192','0.00',1,NULL,NULL),(48,17,NULL,NULL,'0.00',1,NULL,NULL),(49,17,NULL,NULL,'0.00',1,NULL,NULL),(50,17,NULL,NULL,'0.00',1,NULL,NULL),(51,18,NULL,'WHS20-00-100','0.00',1,NULL,NULL),(54,17,NULL,NULL,'0.00',1,NULL,NULL),(55,17,NULL,NULL,'0.00',1,NULL,NULL),(56,17,NULL,NULL,'0.00',1,NULL,NULL),(57,17,NULL,NULL,'0.00',1,NULL,NULL),(58,17,NULL,NULL,'0.00',1,NULL,NULL),(59,5,NULL,'50-0002','0.00',1,NULL,NULL),(60,5,NULL,'50-0003 ITINERIS MC-E','0.00',1,NULL,NULL),(61,5,NULL,'50-4000','0.00',1,NULL,NULL),(63,19,NULL,NULL,'0.00',1,NULL,NULL),(64,5,NULL,'60-0001-A-C-A','0.00',1,NULL,NULL),(67,5,NULL,'60-0009','0.00',1,NULL,NULL),(68,19,NULL,NULL,'0.00',1,NULL,NULL),(70,17,NULL,NULL,'0.00',1,NULL,NULL),(71,16,NULL,'708810','0.00',1,NULL,NULL),(72,16,NULL,'709882','0.00',1,NULL,NULL),(73,16,NULL,'709945','0.00',1,NULL,NULL),(75,17,NULL,NULL,'0.00',1,NULL,NULL),(76,16,NULL,'731173','0.00',1,NULL,NULL),(77,16,NULL,'732400','0.00',1,NULL,NULL),(79,16,NULL,NULL,'0.00',1,NULL,NULL),(80,16,NULL,'805340','0.00',1,NULL,NULL),(81,16,NULL,'805348','0.00',1,NULL,NULL),(82,20,NULL,'94639A106','0.00',1,NULL,NULL),(83,16,NULL,NULL,'0.00',1,NULL,NULL),(84,16,NULL,NULL,'0.00',1,NULL,NULL),(85,17,NULL,NULL,'0.00',1,NULL,NULL),(87,17,NULL,NULL,'0.00',1,NULL,NULL),(88,21,NULL,'LEDNOVATION LED-A19-100-1LD-12','0.00',1,NULL,NULL),(90,17,NULL,NULL,'0.00',1,NULL,NULL),(91,22,NULL,'AMN14111','0.00',1,NULL,NULL),(92,22,NULL,'AMN14112','0.00',1,NULL,NULL),(93,17,NULL,NULL,'0.00',1,NULL,NULL),(97,23,NULL,NULL,'0.00',1,NULL,NULL),(98,21,NULL,'LED-A19-100-1D-I','73.00',1,NULL,NULL),(99,21,NULL,'LED-A19-75-1N-I','73.00',1,NULL,NULL),(100,21,NULL,'LED-A19-100-1ID-12','91.00',1,NULL,NULL),(101,21,NULL,'LED-R30L-75-1WD-INF','69.00',1,NULL,NULL),(102,21,NULL,'LED-R30S-75-1WD-INF','69.00',1,NULL,NULL),(103,21,NULL,'LED-R38-75-1WD-INF','80.00',1,NULL,NULL),(104,21,NULL,'LED-R38-90-1WD-INF','86.00',1,NULL,NULL),(105,21,NULL,'LED-A19-25-1N-I','63.00',1,NULL,NULL),(106,21,NULL,'LED-A19-40-1D-I','63.00',1,NULL,NULL),(107,21,NULL,'LED-A19-60-1ID-12','85.00',1,NULL,NULL),(108,21,NULL,'LED-R20-35-1WD-INF','48.00',1,NULL,NULL),(109,21,NULL,'LED-A19-40-1N-I','63.00',1,NULL,NULL),(110,21,NULL,'LED-MR16-75-12WD-INF','37.00',1,NULL,NULL),(111,21,NULL,'LED-A19-75-1ID-12','89.00',1,NULL,NULL),(112,21,NULL,'LED-MR16-35-12WD-INF','41.00',1,NULL,NULL),(113,21,NULL,'LED-R20-50-1WD-INF','51.00',1,NULL,NULL),(114,21,NULL,'LED-A19-60-1D-I','69.00',1,NULL,NULL),(115,21,NULL,'LED-A19-75-1D-I','73.00',1,NULL,NULL),(116,21,NULL,'LED-R30L-50-1WD-INF','64.00',1,NULL,NULL),(117,21,NULL,'LED-R30S-50-1WD-INF','64.00',1,NULL,NULL),(118,23,NULL,NULL,'0.00',1,NULL,NULL),(127,24,NULL,NULL,'0.00',1,NULL,NULL),(133,25,NULL,'CLG-60-24','0.00',1,NULL,NULL),(139,17,NULL,NULL,'0.00',1,NULL,NULL),(140,17,NULL,NULL,'0.00',1,NULL,NULL),(141,20,NULL,NULL,'0.00',1,NULL,NULL),(144,26,NULL,'ENDURA 63 LED 525MA','0.00',1,NULL,NULL),(145,27,NULL,'EUC-025-S105PS','0.00',1,NULL,NULL),(146,27,NULL,'EUC-025S070PS','0.00',1,NULL,NULL),(147,27,NULL,'EUC-075S070DT','0.00',1,NULL,NULL),(148,27,NULL,'EUC-075S105DT','0.00',1,NULL,NULL),(151,27,NULL,'EUC-100S070ST','0.00',1,NULL,NULL),(153,27,NULL,'EUC-100S105ST','0.00',1,NULL,NULL),(155,27,NULL,'EUC-100S140ST','0.00',1,NULL,NULL),(160,27,NULL,'EUV-075S024ST','0.00',1,NULL,NULL),(163,28,NULL,'EXC LXV150-024SW','0.00',1,NULL,NULL),(165,20,NULL,NULL,'0.00',1,NULL,NULL),(166,20,NULL,NULL,'0.00',1,NULL,NULL),(167,29,NULL,'GDS06T-42','0.00',1,NULL,NULL),(168,29,NULL,'GFC01SER-42','0.00',1,NULL,NULL),(170,20,NULL,NULL,'0.00',1,NULL,NULL),(171,20,NULL,NULL,'0.00',1,NULL,NULL),(172,20,NULL,NULL,'0.00',1,NULL,NULL),(173,20,NULL,NULL,'0.00',1,NULL,NULL),(174,20,NULL,NULL,'0.00',1,NULL,NULL),(175,20,NULL,'HS12B ST221','0.00',1,NULL,NULL),(176,22,NULL,'LED-INTA-0024V-28FO','0.00',1,NULL,NULL),(177,22,NULL,'ED-INTA-0024V41FO-MS','0.00',1,NULL,NULL),(178,22,NULL,'LED-INTA-700C-140F30','0.00',1,NULL,NULL),(179,22,NULL,NULL,'72.27',1,NULL,NULL),(180,22,NULL,'LEDINTA700C105DHO','0.00',1,NULL,NULL),(183,30,NULL,NULL,'0.00',1,NULL,NULL),(186,31,NULL,NULL,'0.00',1,NULL,NULL),(188,31,NULL,NULL,'0.00',1,NULL,NULL),(191,21,NULL,'LEDNOVATION LED A19-75-1N-1','0.00',1,NULL,NULL),(192,30,NULL,NULL,'0.00',1,NULL,NULL),(193,32,NULL,NULL,'0.00',1,NULL,NULL),(194,32,NULL,NULL,'0.00',1,NULL,NULL),(197,20,NULL,NULL,'0.00',1,NULL,NULL),(198,17,NULL,NULL,'0.00',1,NULL,NULL),(199,22,NULL,'MEO-65PN-02','0.00',1,NULL,NULL),(200,33,NULL,'MM34000','0.00',1,NULL,NULL),(201,21,NULL,'LED-MR16-35-12WD-INF','0.00',1,NULL,NULL),(207,17,NULL,NULL,'0.00',1,NULL,NULL),(209,34,NULL,'LED PIXI LIGHT 4000K','0.00',1,NULL,NULL),(210,25,NULL,'PLN-30-24','0.00',1,NULL,NULL),(211,25,NULL,'PLN-60-24','0.00',1,NULL,NULL),(212,29,NULL,'RC01-KR REMOTE CON','0.00',1,NULL,NULL),(213,29,NULL,'RC02-KT REMOTE CONTROL','0.00',1,NULL,NULL),(214,17,NULL,NULL,'0.00',1,NULL,NULL),(215,17,NULL,NULL,'0.00',1,NULL,NULL),(216,17,NULL,NULL,'0.00',1,NULL,NULL),(217,17,NULL,NULL,'0.00',1,NULL,NULL),(218,17,NULL,NULL,'0.00',1,NULL,NULL),(219,17,NULL,NULL,'0.00',1,NULL,NULL),(220,17,NULL,NULL,'0.00',1,NULL,NULL),(221,25,NULL,'RS-50-24','0.00',1,NULL,NULL),(222,25,NULL,'RS-75-24','0.00',1,NULL,NULL),(224,5,NULL,'SOLDER MASK','0.00',1,NULL,NULL),(226,20,NULL,'SSFW006','0.00',1,NULL,NULL),(227,20,NULL,'SSFW010','0.00',1,NULL,NULL),(228,20,NULL,'SSFW040U','0.00',1,NULL,NULL),(229,20,NULL,'SSHN0060','0.00',1,NULL,NULL),(230,20,NULL,'SSHN0080','0.00',1,NULL,NULL),(231,20,NULL,'SSHN0110','0.00',1,NULL,NULL),(232,20,NULL,'SSHN040C','0.00',1,NULL,NULL),(233,20,NULL,'SSLN060','0.00',1,NULL,NULL),(234,20,NULL,'SSLN0080','0.00',1,NULL,NULL),(235,20,NULL,'SSLN00110','0.00',1,NULL,NULL),(236,20,NULL,'SSLN040C','0.00',1,NULL,NULL),(237,20,NULL,'SSLW006','0.00',1,NULL,NULL),(238,20,NULL,'SSLW008','0.00',1,NULL,NULL),(239,20,NULL,NULL,'0.00',1,NULL,NULL),(241,20,NULL,NULL,'0.00',1,NULL,NULL),(242,20,NULL,'SSSH004004','0.00',1,NULL,NULL),(243,20,NULL,'SSSH006004','0.00',1,NULL,NULL),(244,20,NULL,'SSH006008','0.00',1,NULL,NULL),(245,20,NULL,'SSSH006012','0.00',1,NULL,NULL),(246,20,NULL,'SSSH006100','0.00',1,NULL,NULL),(247,20,NULL,NULL,'0.00',1,NULL,NULL),(248,20,NULL,'SSSH006108','0.00',1,NULL,NULL),(249,20,NULL,'SSSH008004','0.00',1,NULL,NULL),(250,20,NULL,'SSSH008008','0.00',1,NULL,NULL),(251,20,NULL,'SSSH008012','0.00',1,NULL,NULL),(252,20,NULL,'SSSH008100','0.00',1,NULL,NULL),(253,20,NULL,'SSSH008108','0.00',1,NULL,NULL),(254,20,NULL,'SSSH008200','0.00',1,NULL,NULL),(255,20,NULL,NULL,'0.00',1,NULL,NULL),(256,20,NULL,'SSSH011012','0.00',1,NULL,NULL),(257,20,NULL,'SSSH011100','0.00',1,NULL,NULL),(258,20,NULL,'SSSH040012','0.00',1,NULL,NULL),(259,20,NULL,'SSSH040100','0.00',1,NULL,NULL),(260,20,NULL,'SSSH040104','0.00',1,NULL,NULL),(261,20,NULL,'SSSH040108','0.00',1,NULL,NULL),(262,20,NULL,'SSSH040200','0.00',1,NULL,NULL),(263,20,NULL,'SSSMP008008P','0.00',1,NULL,NULL),(264,20,NULL,'SSSMP008012P','0.00',1,NULL,NULL),(265,20,NULL,'SSSMP008100P','0.00',1,NULL,NULL),(267,35,NULL,'73114 LED TUBE 48\" NATURAL','35.06',1,NULL,NULL),(268,35,NULL,'73075 48\" LED TUBE UL WARM','35.06',1,NULL,NULL),(269,20,NULL,'TER6200 20501','0.00',1,NULL,NULL),(270,20,NULL,'TER6300 20502','0.00',1,NULL,NULL),(271,20,NULL,NULL,'0.00',1,NULL,NULL),(272,20,NULL,NULL,'0.00',1,NULL,NULL),(273,20,NULL,NULL,'0.00',1,NULL,NULL),(276,20,NULL,NULL,'0.00',1,NULL,NULL),(277,14,NULL,NULL,'0.00',1,NULL,NULL),(281,20,NULL,NULL,'0.00',1,NULL,NULL),(287,20,NULL,NULL,'0.00',1,NULL,NULL),(288,19,NULL,NULL,'0.00',1,NULL,NULL),(289,5,NULL,'XX-0001','0.00',1,NULL,NULL),(290,5,NULL,'XX-0006','0.00',1,NULL,NULL),(291,36,NULL,NULL,'125.00',1,NULL,NULL),(292,20,NULL,NULL,'0.00',1,NULL,NULL),(293,20,NULL,NULL,'0.00',1,NULL,NULL),(296,20,NULL,NULL,'0.00',1,NULL,NULL);
/*!40000 ALTER TABLE `material_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_detail` (
  `order_id` int(10) unsigned NOT NULL,
  `source_type` enum('product','material') NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `unit_price` decimal(10,2) unsigned DEFAULT NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL DEFAULT '0.0000',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL DEFAULT '0.0000',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL DEFAULT '0.0000',
  `uomid` smallint(3) unsigned NOT NULL,
  `output_date` datetime DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,
  `actual_deliver_date` datetime DEFAULT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`,`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,'product',1,'10.0000','10.00','0.0000','7.0000','1.0000',1,NULL,NULL,'2011-01-11 11:50:00',2,'2010-11-09 17:01:05',''),(1,'product',3,'10.0000','10.00','1.0000','0.0000','0.0000',1,NULL,'2011-05-28 00:00:00',NULL,2,'2011-05-17 13:22:07','test'),(2,'product',1,'100.0000','100.00','0.0000','4.0000','1.0000',1,NULL,'2011-01-22 00:00:00','2011-01-11 13:59:00',2,'2011-01-11 12:08:08','This is the only product in the order.'),(3,'product',1,'20.0000','0.00','0.0000','0.0000','1.0000',1,NULL,NULL,'2011-03-10 12:46:00',2,'2011-03-10 12:33:31','');
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_general`
--

DROP TABLE IF EXISTS `order_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_general` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_type` enum('inventory','customer','supplier') NOT NULL,
  `ponumber` varchar(40) DEFAULT NULL,
  `client_id` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `state` enum('quoted','POed','scheduled','produced','shipped','delivered','invoiced','paid') NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_general`
--

LOCK TABLES `order_general` WRITE;
/*!40000 ALTER TABLE `order_general` DISABLE KEYS */;
INSERT INTO `order_general` VALUES (1,'customer','123456',1,2,'quoted','1000.00',5,'50.00','100.00','1050.00','2010-10-15 00:00:00',3,'John','regular order'),(2,'customer','NewYear1',1,3,'POed','10000.00',6,'600.00','0.00','10600.00','2011-04-22 00:00:00',7,'Best Guy','test'),(3,'customer','TEST_YMCA_01',1,2,'POed','0.00',0,'0.00','0.00','0.00','2011-03-24 00:00:00',2,'test',''),(4,'supplier','ih-0001',7,1,'POed','1000.00',6,'60.00','0.00','1060.00','2011-04-22 00:00:00',2,'John','');
/*!40000 ALTER TABLE `order_general` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_state_history`
--

DROP TABLE IF EXISTS `order_state_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted','POed','scheduled','produced','shipped','delivered','invoiced','paid') NOT NULL,
  `state_date` datetime NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`,`state`,`state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_state_history`
--

LOCK TABLES `order_state_history` WRITE;
/*!40000 ALTER TABLE `order_state_history` DISABLE KEYS */;
INSERT INTO `order_state_history` VALUES (1,'quoted','2010-09-16 00:00:00',2,'regular order'),(2,'POed','2011-01-01 00:00:00',2,'test'),(3,'POed','2011-03-09 00:00:00',2,''),(4,'POed','2011-04-06 00:00:00',2,'');
/*!40000 ALTER TABLE `order_state_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `lead_employee` int(10) unsigned DEFAULT NULL,
  `parent_organization` int(10) unsigned DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization`
--

LOCK TABLES `organization` WRITE;
/*!40000 ALTER TABLE `organization` DISABLE KEYS */;
INSERT INTO `organization` VALUES (1,'company',NULL,NULL,NULL,NULL,'This is the most top level organization for the company');
/*!40000 ALTER TABLE `organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pd_attributes`
--

DROP TABLE IF EXISTS `pd_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`pd_id`,`attr_id`,`attr_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pd_attributes`
--

LOCK TABLES `pd_attributes` WRITE;
/*!40000 ALTER TABLE `pd_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `pd_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `priority`
--

DROP TABLE IF EXISTS `priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `priority` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `priority`
--

LOCK TABLES `priority` WRITE;
/*!40000 ALTER TABLE `priority` DISABLE KEYS */;
INSERT INTO `priority` VALUES (1,'Low'),(2,'Normal'),(3,'High'),(4,'Critical'),(5,'Showstopper');
/*!40000 ALTER TABLE `priority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process`
--

DROP TABLE IF EXISTS `process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `prg_id` int(10) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `start_pos_id` int(5) unsigned DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process`
--

LOCK TABLES `process` WRITE;
/*!40000 ALTER TABLE `process` DISABLE KEYS */;
INSERT INTO `process` VALUES (1,'RACN-ASL-6001N-P0000N-E075277-050',1,1,'production',NULL,7,1,'2010-09-29 07:20:26',2,'2011-05-16 11:17:38',2,'main process only','Assembly workflow for product RACN-ASL-6001N-P0000N-E075277-050.',''),(2,'RXOR-SPLEI-6005(6)F-D2002C-E100277-160 ',1,1,'production',NULL,2,1,'2011-02-28 16:54:30',2,'2011-03-21 09:19:50',2,'both','','');
/*!40000 ALTER TABLE `process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_group`
--

DROP TABLE IF EXISTS `process_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_group`
--

LOCK TABLES `process_group` WRITE;
/*!40000 ALTER TABLE `process_group` DISABLE KEYS */;
INSERT INTO `process_group` VALUES (1,'general',NULL,'2010-08-04 10:55:16',1,NULL,NULL,'This group is a general group that can be used by any process',NULL);
/*!40000 ALTER TABLE `process_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_segment`
--

DROP TABLE IF EXISTS `process_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_segment` (
  `process_id` int(10) unsigned NOT NULL,
  `segment_id` int(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `position` smallint(2) unsigned NOT NULL,
  `description` text,
  PRIMARY KEY (`process_id`,`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_segment`
--

LOCK TABLES `process_segment` WRITE;
/*!40000 ALTER TABLE `process_segment` DISABLE KEYS */;
INSERT INTO `process_segment` VALUES (1,1,'Assembly',1,'Assembly Steps'),(1,3,'Installation',3,'Installation Steps'),(1,4,'Test',2,'Test Steps');
/*!40000 ALTER TABLE `process_segment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_step`
--

DROP TABLE IF EXISTS `process_step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `if_autostart` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL,
  `approve_emp_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_step`
--

LOCK TABLES `process_step` WRITE;
/*!40000 ALTER TABLE `process_step` DISABLE KEYS */;
INSERT INTO `process_step` VALUES (1,1,1,NULL,2,NULL,1,0,0,'Please open and review diagram file',1,0,NULL,NULL),(1,2,2,1,3,NULL,1,0,0,'Assembly Step 1',1,0,NULL,NULL),(1,3,3,2,4,NULL,1,0,0,'Assembly Step 2',1,0,NULL,NULL),(1,4,4,3,5,NULL,1,0,0,'Assembly Step 3',0,0,NULL,NULL),(1,5,5,4,6,NULL,1,0,0,'Assembly Step 4',1,0,NULL,NULL),(1,6,6,5,7,NULL,1,0,0,'Assembly Step 5',1,0,NULL,NULL),(1,7,7,6,8,NULL,1,0,0,'Assembly Step 6',1,0,NULL,NULL),(1,8,8,7,9,NULL,3,0,0,'',0,0,NULL,NULL),(1,9,9,8,10,NULL,3,0,0,'',0,0,NULL,NULL),(1,10,10,9,11,NULL,3,0,0,'',0,0,NULL,NULL),(1,11,11,10,12,NULL,3,0,0,'',0,0,NULL,NULL),(1,12,12,11,13,NULL,3,0,0,'',0,0,NULL,NULL),(1,13,13,12,NULL,NULL,3,0,0,'Please have approver type in password.',0,1,'employee',7),(2,1,14,NULL,2,NULL,NULL,0,0,'',0,0,NULL,NULL),(2,2,15,1,3,NULL,NULL,0,0,'LED Module Mounting',1,0,NULL,NULL),(2,3,16,2,4,NULL,NULL,0,0,'Filter to Baffle Plate Mounting',1,0,NULL,NULL),(2,4,17,3,5,NULL,NULL,0,0,'Fan and Filter Assembly',1,0,NULL,NULL),(2,5,18,4,6,NULL,NULL,0,0,'Fan and Filter to Baffle Plate Mounting',1,0,NULL,NULL),(2,6,19,5,7,NULL,NULL,0,0,'Power Supply Installation',1,0,NULL,NULL),(2,7,20,6,8,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',0,0,NULL,NULL),(2,8,21,7,9,25,NULL,0,0,'Continuity Test for each power supply',0,0,NULL,NULL),(2,9,25,8,10,NULL,NULL,0,0,'Labeling the Power Supply',1,0,NULL,NULL),(2,10,26,9,11,25,NULL,0,0,'Burn-in Test',0,1,'employee',7),(2,11,27,10,12,NULL,NULL,0,0,'ETL Labeling',1,0,NULL,NULL),(2,12,28,11,13,NULL,NULL,0,0,'Finish Assembly and Pack',1,0,NULL,NULL),(2,13,29,12,14,NULL,NULL,0,0,'Wiring Diagram for Each Power Supply (2)',0,0,NULL,NULL),(2,14,30,13,15,NULL,NULL,0,0,'WARNINGS AND CAUTIONS',0,0,NULL,NULL),(2,15,31,14,16,NULL,NULL,0,0,'Warnings and Cautions',0,0,NULL,NULL),(2,16,32,15,17,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE',0,0,NULL,NULL),(2,17,33,16,18,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE (CONTINUED)',0,0,NULL,NULL),(2,18,34,17,19,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE (LAST)',0,0,NULL,NULL),(2,19,35,18,20,NULL,NULL,0,0,'ASSEMBLY PROCEDURE',0,0,NULL,NULL),(2,20,36,19,21,NULL,NULL,0,0,'ASSEMBLY PROCEDURE (CONTINUED)',0,0,NULL,NULL),(2,21,37,20,NULL,NULL,NULL,0,0,'Final Deliver to Customer',0,1,'employee',7),(2,25,22,NULL,26,NULL,NULL,0,0,'Hold batch',1,0,NULL,NULL),(2,26,23,25,NULL,NULL,NULL,0,0,'Reposition batch',0,1,'employee',7),(2,27,24,NULL,NULL,NULL,NULL,0,0,'Scrap batch',0,1,'employee',7);
/*!40000 ALTER TABLE `process_step` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_step_history`
--

DROP TABLE IF EXISTS `process_step_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `segment_id` int(5) DEFAULT NULL,
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0',
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prompt` varchar(255) DEFAULT NULL,
  `if_autostart` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `approve_emp_usage` enum('employee group','employee category','employee') DEFAULT NULL,
  `approve_emp_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`event_time`,`process_id`,`position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_step_history`
--

LOCK TABLES `process_step_history` WRITE;
/*!40000 ALTER TABLE `process_step_history` DISABLE KEYS */;
INSERT INTO `process_step_history` VALUES ('2010-09-03 11:30:39',5,1,1,'insert',2,NULL,2,1,NULL,2,0,'test',1,1,'employee',3),('2010-09-03 11:30:46',5,1,1,'delete',1,NULL,2,1,NULL,2,0,'test',1,1,'employee',3),('2010-09-08 08:25:05',6,1,1,'insert',2,NULL,2,3,NULL,1,0,'test',1,1,'employee',2),('2010-09-08 08:25:27',6,2,1,'insert',2,1,3,4,NULL,1,0,'test',0,1,'employee',3),('2010-09-08 08:25:45',6,3,1,'insert',2,2,4,NULL,NULL,1,0,'test',0,0,NULL,NULL),('2010-09-08 08:25:49',6,2,1,'delete',2,1,3,4,NULL,1,0,'test',0,1,'employee',3),('2010-09-08 08:25:57',6,3,1,'delete',2,2,4,NULL,NULL,1,0,'test',0,0,NULL,NULL),('2010-09-20 20:23:54',10,1,8,'insert',2,NULL,2,NULL,NULL,1,1,'test',1,1,'employee',7),('2010-09-20 20:24:06',10,1,9,'modify',2,NULL,2,NULL,NULL,1,1,'test',1,1,'employee',7),('2010-09-29 07:19:16',10,1,9,'delete',2,NULL,2,NULL,NULL,0,1,NULL,1,1,'employee',7),('2010-09-29 07:19:31',6,1,1,'delete',2,NULL,2,3,NULL,0,0,NULL,1,1,'employee',2),('2010-09-29 07:21:15',1,1,1,'insert',2,NULL,2,NULL,NULL,0,0,'Please open and review diagram file',1,0,NULL,NULL),('2010-09-29 07:22:02',1,2,2,'insert',2,1,3,NULL,NULL,0,0,'Assembly Step 1',1,0,NULL,NULL),('2010-09-29 07:22:27',1,3,3,'insert',2,2,4,NULL,NULL,0,0,'Assembly Step 2',1,0,NULL,NULL),('2010-09-29 07:23:00',1,4,4,'insert',2,3,5,NULL,NULL,0,0,'Assembly Step 3',1,0,NULL,NULL),('2010-09-29 07:23:29',1,5,5,'insert',2,4,6,NULL,NULL,0,0,'Assembly Step 4',1,0,NULL,NULL),('2010-09-29 07:24:03',1,6,6,'insert',2,5,7,NULL,NULL,0,0,'Assembly Step 5',1,0,NULL,NULL),('2010-09-29 07:24:40',1,7,7,'insert',2,6,NULL,NULL,NULL,0,0,'Assembly Step 6 (Last Step)',1,0,NULL,NULL),('2010-10-07 10:58:14',1,1,1,'modify',2,NULL,2,NULL,NULL,0,0,'Please open and review diagram file',1,1,'employee',2),('2010-10-07 10:58:44',1,1,1,'modify',2,NULL,2,NULL,NULL,0,0,'Please open and review diagram file',1,0,NULL,NULL),('2011-01-06 12:40:33',1,8,8,'insert',2,7,9,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-06 12:40:52',1,7,7,'modify',2,6,8,NULL,NULL,0,0,'Assembly Step 6',1,0,NULL,NULL),('2011-01-06 12:41:10',1,9,9,'insert',2,8,10,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-06 12:41:25',1,10,10,'insert',2,9,11,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-06 12:41:40',1,11,11,'insert',2,10,12,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-06 12:41:55',1,12,12,'insert',2,11,NULL,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-11 11:38:34',1,13,13,'insert',2,12,NULL,NULL,NULL,0,0,'',0,1,'employee',7),('2011-01-11 11:38:49',1,12,12,'modify',2,11,13,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-11 11:39:25',1,13,13,'modify',2,12,NULL,NULL,NULL,0,0,'Please have approver type in password.',0,1,'employee',7),('2011-01-12 12:33:42',1,10,10,'modify',2,9,11,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-01-12 13:51:22',1,4,4,'modify',2,3,5,NULL,NULL,0,0,'Assembly Step 3',0,0,NULL,NULL),('2011-02-28 17:18:35',2,1,14,'insert',2,NULL,2,NULL,NULL,0,0,'',0,0,NULL,NULL),('2011-02-28 19:30:37',2,2,15,'insert',2,1,3,NULL,NULL,0,0,'LED Module Mounting',1,0,NULL,NULL),('2011-03-01 08:47:54',2,3,16,'insert',2,2,NULL,NULL,NULL,0,0,'',1,0,NULL,NULL),('2011-03-01 08:48:18',2,3,16,'modify',2,2,NULL,NULL,NULL,0,0,'Filter to Baffle Plate Mounting',1,0,NULL,NULL),('2011-03-02 07:23:16',2,4,17,'insert',2,3,NULL,NULL,NULL,0,0,'',1,0,NULL,NULL),('2011-03-02 07:23:27',2,3,16,'modify',2,2,4,NULL,NULL,0,0,'Filter to Baffle Plate Mounting',1,0,NULL,NULL),('2011-03-02 07:23:45',2,4,17,'modify',2,3,5,NULL,NULL,0,0,'Fan and Filter Assembly',1,0,NULL,NULL),('2011-03-02 07:39:46',2,5,18,'insert',2,4,6,NULL,NULL,0,0,'Fan and Filter to Baffle Plate Mounting',1,0,NULL,NULL),('2011-03-02 07:52:16',2,6,19,'insert',2,5,7,NULL,NULL,0,0,'',1,0,NULL,NULL),('2011-03-02 07:52:32',2,6,19,'modify',2,5,7,NULL,NULL,0,0,'Power Supply Installation',1,0,NULL,NULL),('2011-03-02 08:12:58',2,7,20,'insert',2,6,NULL,NULL,NULL,0,0,'',1,0,NULL,NULL),('2011-03-02 08:13:34',2,7,20,'modify',2,6,NULL,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',1,0,NULL,NULL),('2011-03-02 08:41:42',2,8,21,'insert',2,7,9,25,NULL,0,0,'Cotinuity Test for each power supply',0,0,NULL,NULL),('2011-03-02 08:41:57',2,7,20,'modify',2,6,7,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',1,0,NULL,NULL),('2011-03-02 08:42:07',2,7,20,'modify',2,6,7,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',1,0,NULL,NULL),('2011-03-02 09:00:25',2,25,22,'insert',2,NULL,26,NULL,NULL,0,0,'Hold Lot',0,0,NULL,NULL),('2011-03-02 09:04:34',2,26,21,'insert',2,25,NULL,NULL,NULL,0,0,'Reposition Lot',0,1,'employee',7),('2011-03-02 09:07:55',2,7,20,'modify',2,6,8,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',1,0,NULL,NULL),('2011-03-02 09:14:12',2,27,24,'insert',2,NULL,NULL,NULL,NULL,0,0,'Scrap batch',0,1,'employee',7),('2011-03-02 09:14:23',2,26,21,'modify',2,25,NULL,NULL,NULL,0,0,'Reposition batch',0,1,'employee',7),('2011-03-02 09:14:32',2,25,22,'modify',2,NULL,26,NULL,NULL,0,0,'Hold batch',0,0,NULL,NULL),('2011-03-02 09:16:38',2,25,22,'modify',2,NULL,26,NULL,NULL,0,0,'Hold batch',1,0,NULL,NULL),('2011-03-02 12:12:14',2,26,23,'modify',7,25,NULL,NULL,NULL,0,0,'Reposition batch',0,1,'employee',7),('2011-03-02 12:13:34',2,9,25,'insert',7,8,10,NULL,NULL,0,0,'Labeling the Power Supply',1,0,NULL,NULL),('2011-03-02 12:45:36',2,10,27,'insert',7,9,NULL,NULL,NULL,0,0,'ETL Labeling',1,0,NULL,NULL),('2011-03-04 08:50:25',2,10,27,'modify',2,9,11,NULL,NULL,0,0,'ETL Labeling',1,0,NULL,NULL),('2011-03-04 08:51:06',2,11,28,'insert',2,10,NULL,NULL,NULL,0,0,'Finish Assembly and Pack',1,0,NULL,NULL),('2011-03-04 08:56:08',2,10,26,'modify',2,9,11,NULL,NULL,0,0,'Burn-in Test',1,0,NULL,NULL),('2011-03-04 08:56:20',2,10,26,'modify',2,9,11,NULL,NULL,0,0,'Burn-in Test',0,0,NULL,NULL),('2011-03-04 08:56:47',2,11,27,'modify',2,10,12,NULL,NULL,0,0,'ETL Labeling',1,0,NULL,NULL),('2011-03-04 08:57:27',2,12,28,'insert',2,11,NULL,NULL,NULL,0,0,'Finish Assembly and Pack',1,0,NULL,NULL),('2011-03-04 08:57:38',2,10,26,'modify',2,9,11,NULL,NULL,0,0,'Burn-in Test',0,1,'employee',7),('2011-03-04 09:39:26',2,12,28,'modify',2,11,13,NULL,NULL,0,0,'Finish Assembly and Pack',1,0,NULL,NULL),('2011-03-04 09:40:25',2,13,29,'insert',2,12,14,NULL,NULL,0,0,'Wiring Diagram for Each Power Supply (2)',0,0,NULL,NULL),('2011-03-04 09:41:08',2,14,30,'insert',2,13,NULL,NULL,NULL,0,0,'WARNINGS AND CAUTIONS',0,0,NULL,NULL),('2011-03-04 09:56:41',2,14,30,'modify',2,13,15,NULL,NULL,0,0,'WARNINGS AND CAUTIONS',0,0,NULL,NULL),('2011-03-04 09:57:08',2,15,31,'insert',2,14,16,NULL,NULL,0,0,'Warnings and Cautions',0,0,NULL,NULL),('2011-03-04 10:14:40',2,16,32,'insert',2,15,17,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE',0,0,NULL,NULL),('2011-03-04 10:24:29',2,17,33,'insert',2,16,18,NULL,NULL,0,0,'Dissassembly Procedure',0,0,NULL,NULL),('2011-03-04 10:32:29',2,18,34,'insert',2,17,19,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE (LAST)',0,0,NULL,NULL),('2011-03-04 10:32:47',2,17,33,'modify',2,16,18,NULL,NULL,0,0,'DISSASSEMBLY PROCEDURE (CONTINUED)',0,0,NULL,NULL),('2011-03-04 10:42:09',2,19,35,'insert',2,18,20,NULL,NULL,0,0,'ASSEMBLY PROCEDURE',0,0,NULL,NULL),('2011-03-04 10:49:19',2,20,36,'insert',2,19,21,NULL,NULL,0,0,'ASSEMBLY PROCEDURE (CONTINUED)',0,0,NULL,NULL),('2011-03-04 10:50:04',2,21,37,'insert',2,20,NULL,NULL,NULL,0,0,'Final Deliver to Customer',0,1,'employee',7),('2011-03-08 10:01:18',2,8,21,'modify',2,7,9,25,NULL,0,0,'Continuity Test for each power supply',0,0,NULL,NULL),('2011-03-08 10:02:58',2,10,26,'modify',2,9,11,25,NULL,0,0,'Burn-in Test',0,1,'employee',7),('2011-03-21 09:19:50',2,7,20,'modify',2,6,8,NULL,NULL,0,0,'Wiring Instruction for each power suppply and LED Module combination',0,0,NULL,NULL),('2011-05-16 10:47:11',1,1,1,'modify',2,NULL,2,NULL,1,0,0,'Please open and review diagram file',1,0,NULL,NULL),('2011-05-16 10:47:27',1,9,9,'modify',2,8,10,NULL,3,0,0,'',0,0,NULL,NULL),('2011-05-16 11:11:02',1,2,2,'modify',2,1,3,NULL,1,0,0,'Assembly Step 1',1,0,NULL,NULL),('2011-05-16 11:11:08',1,3,3,'modify',2,2,4,NULL,1,0,0,'Assembly Step 2',1,0,NULL,NULL),('2011-05-16 11:11:12',1,3,3,'modify',2,2,4,NULL,1,0,0,'Assembly Step 2',1,0,NULL,NULL),('2011-05-16 11:11:18',1,4,4,'modify',2,3,5,NULL,1,0,0,'Assembly Step 3',0,0,NULL,NULL),('2011-05-16 11:11:25',1,5,5,'modify',2,4,6,NULL,1,0,0,'Assembly Step 4',1,0,NULL,NULL),('2011-05-16 11:11:32',1,6,6,'modify',2,5,7,NULL,1,0,0,'Assembly Step 5',1,0,NULL,NULL),('2011-05-16 11:11:38',1,7,7,'modify',2,6,8,NULL,1,0,0,'Assembly Step 6',1,0,NULL,NULL),('2011-05-16 11:11:44',1,8,8,'modify',2,7,9,NULL,3,0,0,'',0,0,NULL,NULL),('2011-05-16 11:11:51',1,10,10,'modify',2,9,11,NULL,3,0,0,'',0,0,NULL,NULL),('2011-05-16 11:11:58',1,11,11,'modify',2,10,12,NULL,3,0,0,'',0,0,NULL,NULL),('2011-05-16 11:12:04',1,12,12,'modify',2,11,13,NULL,3,0,0,'',0,0,NULL,NULL),('2011-05-16 11:12:18',1,13,13,'modify',2,12,NULL,NULL,3,0,0,'Please have approver type in password.',0,1,'employee',7),('2011-05-16 11:17:32',1,14,26,'insert',2,13,NULL,12,4,0,0,'test',0,0,NULL,NULL),('2011-05-16 11:17:38',1,14,26,'delete',2,13,NULL,12,4,0,0,'test',0,0,NULL,NULL);
/*!40000 ALTER TABLE `process_step_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pg_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `lot_size` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned NOT NULL,
  `lifespan` int(10) unsigned NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `pd_un1` (`pg_id`,`name`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,14,'RACN-ASL-6001N-P0000N-E075277-050',1,'production','1.0000',1,2126,'2010-09-29 07:26:31',2,'2010-10-01 10:36:38',7,'LED Retrofit Kit\r\n\r\n','Provided to Joseph Oregon\r\nElectrician John Hillock'),(2,14,'YMCA Uplight',1,'production','1.0000',10,1825,'2010-10-01 10:40:32',7,'2010-10-15 15:03:46',10,'Model#RXOR-SPLEI-6005F-D2002C-E100277-160\n(Four AeroLEDs XP modules mounted on baffle w/ fans)\n','Developed for West YMCA'),(3,14,'RXOR-SPLEI-6005(6)F-D2002C-E100277-160 ',1,'production','1.0000',1,1825,'2011-02-28 10:37:00',2,NULL,NULL,'YMCA Top Level',NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_group`
--

DROP TABLE IF EXISTS `product_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_group`
--

LOCK TABLES `product_group` WRITE;
/*!40000 ALTER TABLE `product_group` DISABLE KEYS */;
INSERT INTO `product_group` VALUES (14,'general',NULL,NULL,'2010-08-04 10:55:16',1,'This group is a general group that can be used by any product',NULL);
/*!40000 ALTER TABLE `product_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_process`
--

DROP TABLE IF EXISTS `product_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_process` (
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `recorder` int(10) unsigned NOT NULL,
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_process`
--

LOCK TABLES `product_process` WRITE;
/*!40000 ALTER TABLE `product_process` DISABLE KEYS */;
INSERT INTO `product_process` VALUES (1,1,2,2,'The only workflow for it.'),(2,1,4,2,NULL),(1,2,4,2,'YMCA'),(3,2,4,2,NULL);
/*!40000 ALTER TABLE `product_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recipe` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `exec_method` enum('ordered','random') NOT NULL DEFAULT 'random',
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `instruction` text,
  `diagram_filename` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe`
--

LOCK TABLES `recipe` WRITE;
/*!40000 ALTER TABLE `recipe` DISABLE KEYS */;
INSERT INTO `recipe` VALUES (1,'jo_diagram','random',7,'complete wiring diagram for RACN-ASL-6001N-P0000N-E075277-50','jo_rp1.jpg','2010-09-29 06:18:51',2,'2011-01-06 12:47:28',2,'This recipe serves as diagram file holder.'),(2,'jo_rp2','ordered',7,'Take Custom Metal Plate (Part #) and screw in (3) 1/4-20x1â€ socket cap mounting screws. They should be pointing out as shown\r\nin picture. Screw them in so the end of the screw is approx. flush\r\nwith the bottom of the plate.','JO_rp2.jpg','2010-09-29 06:21:35',2,'2010-09-29 06:22:46',2,''),(3,'jo_rp3','ordered',7,'LED Bundle Assembly:\r\nLine up 5 Rebel LEDâ€™s on the table. Bundle the leads together, and slip into 7-8â€ of 1/2â€ heat shrink tubing. Leave at about 2â€ of leads between the end of the heat shrink tubing and the LED module. Heat the tubing with a heat gun to shrink it around the leads. Note: Do not overheat, because this can melt the wire insulation and possibly cause a fire or short circuits.','JO_rp3.jpg','2010-09-29 06:24:58',2,'2010-09-29 06:27:09',2,''),(4,'jo_rp4','ordered',7,'Power Supply Instructions:\r\na. Crimp female pin connectors on the three wires of the primary side of the power supply using crimping tool.\r\nb. Insert the female pin connectors into the female quick connector. When properly mounted, you should hear a â€œclickâ€ as each pin connector is inserted. Green to pin 3, white to pin 2 and black to pin 1 as shown.\r\nLED Retrofit Kit #RACN-ASL-6001N-P0000N-E075277-50\r\nRevision 2, 8/05/2010\r\nc. Attach the power supply to its mounting bracket with (2) #8 flat washers and (2) 8-32x1/4â€ socket cap screws. Mount the power\r\nsupply with the secondary side towards the mounting flange, with the flange facing away from the power supply.\r\nd. Attach power supply bracket to custom plate with (2) 10-32x1/2â€ SS socket cap Screws, using the two tapped screw holes near the center of the plate. The bracket is on the opposite side of the mounting screw heads. Once mounted, the secondary power supply wires should be over the feed through hole in the plate. Note: Donâ€™t feed wire through the hole; the LED leads will be fed\r\nthrough this hole.','jo_rp4.jpg','2010-09-29 06:31:07',2,'2010-09-29 06:40:37',2,'Pictures have numbers that match the instruction.'),(5,'jo_rp5','ordered',7,'LED Mounting Instructions:\r\na. On the opposite side of the plate, mount the five LED mounting brackets, using (2) 10-32x1/2â€ socket cap screws.\r\nb. Attach each of the 5 LEDâ€™s in the LED Bundle Assembly to their mounting brackets with (5) Â¼â€ lock washers and (5) 1/4-20x1/2â€ socket cap screws. Run the wire bundle through the feed through hole.','jo_rp5.jpg','2010-09-29 06:43:20',2,'2010-09-29 06:50:07',2,''),(6,'jo_rp6','ordered',7,'Wiring Instructions:\r\na. Strip insulation of red and black wires approx Â½â€ and do not strip yellow wires. Match up the wires from the 5 LEDs by color. Twist ends of each bundle together.\r\nb. Connect the Red LED bundle to the Red Power Supply Secondary wire with an orange wire nut. Connect the Black LED bundle to the\r\nblack Power Supply secondary wire. Use another wire nut to cap off the yellow LED bundle. Test for a firm connection by gently pulling on each wire and the wire nut. Wires should not pull free.\r\nc. Bundle wires together with two zip ties. Cut the loose ends of the zip ties off.','jo_rp6.jpg','2010-09-29 06:54:29',2,'2010-09-29 06:55:24',2,''),(7,'jo_rp7','random',7,'Pack the finished product.','jo_rp7.jpg','2010-09-29 06:56:11',2,'2010-09-29 06:59:21',2,''),(8,'jo_ins_1','random',7,'1. Turn off power to luminaire.\r\n2. Remove diffuser.','jo_ins_1.jpg','2011-01-06 12:34:07',2,NULL,NULL,''),(9,'jo_ins_2','random',7,'Remove lamp assembly. Unplug quick connect.','jp_ins_2.jpg','2011-01-06 12:34:46',2,NULL,NULL,''),(10,'jo_ins_3','random',7,'Plug in quick connect for new LED subassembly to supply.\r\n\r\nWARNING - To provent wiring damage or abrassion, do not expose wiring to edges of sheet metal or other sharp objects.','jp_ins_3.jpg','2011-01-06 12:36:04',2,NULL,NULL,''),(11,'jo_ins_4','random',7,'Install LED subassembly on fixture. Tighten mounting screws.','jp_ins_4.jpg','2011-01-06 12:36:49',2,NULL,NULL,''),(12,'jo_ins_5','random',7,'1. Install diffuser. Tighten moutning lugs.\r\n2. Turn on power. Test unit.','jp_ins_5.jpg','2011-01-06 12:37:40',2,NULL,NULL,''),(13,'YMCA_160_Diagram','random',2,'Complete Wiring Diagram x2 per KIT','YMCA_160_Diagram.jpg','2011-02-28 17:15:55',2,'2011-03-01 11:34:51',2,'The diagram shows half of the kit. The full kit is x2 of the diagram.'),(14,'YMCA_160_LED','random',2,'Take the custom metal Baffle Plate and four (4) Itineris XP LED Modules and attach Modules to Plate using eight (8) 10-32x1/2â€ socket cap mounting screws. Tighten securely.','YMCA_160_1.jpg','2011-02-28 19:19:54',2,'2011-03-08 08:19:25',2,'LED Module Mounting'),(15,'YMCA_160_Filter','random',2,'Using four 6-32x1/2â€™ screws mount the plastic filter base to the Baffle Plate and tighten securely. Placing the filter into the top piece snap the top piece with filter onto the plastic base. Repeat two more times for the remaining two holes in the Baffle Plate.','YMCA_160_2.jpg','2011-03-01 08:03:27',2,'2011-03-04 08:19:53',2,'Filter to Baffle Plate Mounting.'),(16,'YMCA_160_Fan','random',2,'1. Using four (4) 8-32x1â€ screws place the screws through the fan filter base and fan and place onto the fan bracket as shown in figure 1.\r\n2. As shown in figure 2, orient the fan label towards the bracket legs and tighten the fan and filter base to the bracket using four (4) 8-32 nylon locknuts. Do not over tighten. Place the fan filter into the filter top piece and placing onto the fan snap into place. Repeat three more times to build a total of four (4) fan and filter assemblies.','YMCA_160_3.jpg','2011-03-02 07:09:56',2,'2011-03-04 08:20:26',2,'Fan and Filter Assembly.'),(17,'YMCA_160_Fan_Mount','random',2,'Using two (2) 10-32 screws and two (2) 10-32 nylon locknuts mount the fan and filter assembly to the back side of the Baffle Plate and LED Modules. Tighten securely.','YMCA_160_4.jpg','2011-03-02 07:33:22',2,'2011-03-04 08:21:13',2,'Fan and Filter to Baffle Plate Mounting.'),(18,'YMCA_160_PowerUnit','random',2,'The power supplies mount between the end two LED Modules above the vent holes. Using two (2) 8-32x1â€ screws, two (2)1/4x1/2â€ standoffs and two (2) 8-32x1/2â€ nylon locknuts attach the power supply as shown.','YMCA_160_5.jpg','2011-03-02 07:43:31',2,'2011-03-04 08:21:41',2,'Power Supply Installation.'),(19,'YMCA_160_Wiring','random',2,'a. Strip insulation of red and black wires approx Â½â€ and do not strip yellow or green wires from the LED Module. Trim the end of the yellow and green wires so no exposed wire is showing.\r\n\r\nb. Using a blue wire nut connect the two yellow wires together. Using a blue wire nut connect the two green wires together. Connect the Red LED Module bundle and the red fan wire to the Red Power Supply Secondary wire with an orange wire nut. Connect the Black LED Module bundle and the black fan wire to the black Power Supply secondary wire. Test for a firm connection by gently pulling on each wire and the wire nut. Wires should not pull free.\r\n\r\nc. Bundle wires together with two zip ties. Cut the loose ends of the zip ties off.','YMCA_160_6.jpg','2011-03-02 08:04:27',2,'2011-03-04 08:22:05',2,'Wiring Instructions for each power supply and LED Module combination.'),(20,'YMCA_160_ContinuityT','random',2,'Using a multi-meter set to ohms test for continuity from the green wire of each power supply to the Baffle Plate. It should read zero ohms. If not then there is an error and engineering should be called for an inspection.','YMCA_160_7.jpg','2011-03-02 08:37:52',2,'2011-03-04 08:22:35',2,'Continuity Test for each power supply.'),(21,'YMCA_160_Label','random',2,'Place four labels as shown below.\r\na. Power Supply Label on the back side of the Baffle Plate by one power supply.','YMCA_160_8.jpg','2011-03-02 11:20:53',2,'2011-03-04 08:22:57',2,'Labeling the power supply.'),(22,'YMCA_160_BurnInTest','random',2,'Wire the assembly with the appropriate connector and place on burn-in cart. Plug in assembly and burn-in for a minimum of 12 hours. If any failures occur log failures and notify engineering.','YMCA_160_9.jpg','2011-03-02 12:16:01',7,'2011-03-04 08:23:22',2,''),(23,'YMCA_160_ETLLabel','random',2,'This final step is performed after a successful burn-in without failure.\r\n\r\na. Place the LED Module Label in close proximity to one of the LED Modules in the center of the front of the Baffle.\r\n\r\nb. Place the Retrofit ETL Kit Label on the top surface in the approximate location shown.','YMCA_160_10.jpg','2011-03-02 12:42:25',7,'2011-03-04 08:23:43',2,''),(24,'YMCA_160_Pack','random',2,'Assembly is finished. Pack the product.','YMCA_160_9.jpg','2011-03-04 08:15:16',2,'2011-03-04 08:58:57',2,''),(25,'YMCA_160_Install_Dia','random',2,'Review wiring diagram for each power supply (2)','YMCA_160_Diagram2.jpg','2011-03-04 09:31:38',2,NULL,NULL,'Wiring Diagram For Each Power Supply'),(26,'YMCA_160_Install_Ale','random',2,'','YMCA_160_Warning1.jpg','2011-03-04 09:36:59',2,'2011-03-04 09:44:38',2,'Warningand Cautions'),(27,'YMCA_160_Ins_Alert2','random',2,'','YMCA_160_Warning2.jpg','2011-03-04 09:53:53',2,'2011-03-04 09:59:08',2,'warning and caution'),(28,'YMCA_160_Disass1','random',2,'1. Turn off power to luminaire. Install lock/tab out for circuit breakers.\r\n\r\n2. Cordon off area and ensure no unauthorized people are in work area or under\r\nluminaries.\r\n\r\n3. Remove ballast cover of luminaire at both ends of the light fixture.\r\n\r\n4. Disconnect and Remove the ballast assembly from both ends of the luminaire fixture.','YMCS_160_Disassembly1.jpg','2011-03-04 10:10:50',2,'2011-03-08 10:16:31',2,'Dissassembly Procedure'),(29,'YMCA_160_Disass2','random',2,'5. Remove ballast mounting brackets (x4) from each end of the luminaire fixture and save screws for installation of LED kit assembly.\r\n\r\n6. Unscrew lamp assembly mounting bracket at each end of luminaire housing.\r\n\r\n7. Remove glass from lamp assembly.\r\n\r\nCAUTION: Leave HID light bulbs in housing during disassembly to minimize potential breakage. HID BULBS ARE HAZARDOUS MATERIAL AND MUST BE DISPOSED OF ACCORDING TO STATE AND LOCAL REGULATIONS.','YMCS_160_Disassembly2.jpg','2011-03-04 10:22:07',2,NULL,NULL,'Dissassembly instruction 2.'),(30,'YMCA_160_Disass3','random',2,'8. Lift and position lamp assembly to the side, disconnect electrical wiring at each end and feed wiring back through the lamp assembly mouting brackets. Then remove lamp assembly from luminaire housing.\r\n\r\n9. Thoroughly clean, vacuum and wash inside of luminaire housing. This is critical for proper long-life operation of the LED retrofit kit.\r\n\r\nWARNING:FAILURE TO PROPERLY CLEAN AND REMOVE DUST, DIRT AND DEBRIS WILL VOID THE MANUFACTURERâ€™S WARRANTY.','YMCA_160_Disassembly3.jpg','2011-03-04 10:29:55',2,NULL,NULL,'Dissassembly Procedure 3'),(31,'YMCA_160_Install1','random',2,'1. Ensure the luminaire housing is thoroughly clean before beginning assembly of the LED retrofit kit.\r\n\r\nWARNING:FAILURE TO PROPERLY CLEAN AND REMOVE DUST, DIRT AND DEBRIS WILL VOID THE MANUFACTURERâ€™S WARRANTY.\r\n\r\n2. Install LED kit assembly into luminaire housing and position to the side as shown.\r\n\r\nWARNING â€“ To prevent wiring damage or abrasion, do not expose wiring to edges of sheet metal or other sharp objects.\r\n\r\n3. For each incoming luminaire circuit connect power supply black lead to line voltage and power supply white lead to neutral and green to ground.','YMCA_160_Ins1.jpg','2011-03-04 10:39:05',2,'2011-03-04 10:51:30',2,'Installation procedure.'),(32,'YMCS_160_Install2','random',2,'4. Install LED assembly on luminaire housing and tighten six (6) mounting screws saved from Step 5 of the disassembly process.\r\n\r\n5. Clean LED assembly and lens with a cleaning solution (not solvent).\r\n\r\n6. Turn on power. Check unit.\r\n\r\n7. See installation instructions for reflector assembly and installation.','YMCA_160_Ins2.jpg','2011-03-04 10:46:25',2,NULL,NULL,'Installation Procedure 2');
/*!40000 ALTER TABLE `recipe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `step`
--

DROP TABLE IF EXISTS `step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `step_type_id` int(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') CHARACTER SET latin1 DEFAULT NULL,
  `eq_usage` enum('equipment group','equipment') DEFAULT NULL,
  `eq_id` int(10) unsigned DEFAULT NULL,
  `emp_usage` enum('employee group','employee') DEFAULT NULL,
  `emp_id` int(10) unsigned DEFAULT NULL,
  `recipe_id` int(10) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `para_count` tinyint(3) DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `st_un1` (`step_type_id`,`name`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `step`
--

LOCK TABLES `step` WRITE;
/*!40000 ALTER TABLE `step` DISABLE KEYS */;
INSERT INTO `step` VALUES (1,2,'JO Display Diagram',1,1,'production','equipment',NULL,'employee group',1,1,NULL,NULL,'2010-09-29 07:14:38',2,NULL,NULL,0,'Display Complete Diagram.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,8,'JO Step 1',1,1,'production','equipment',NULL,'employee group',1,2,NULL,NULL,'2010-09-29 07:15:39',2,NULL,NULL,0,'Prepare metal plate',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,8,'JO Step 2',1,1,'production','equipment',NULL,'employee group',1,3,NULL,NULL,'2010-09-29 07:16:18',2,NULL,NULL,0,'LED bundle assembly',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,8,'JO Step 3',1,1,'production','equipment',NULL,'employee group',1,4,NULL,NULL,'2010-09-29 07:17:01',2,NULL,NULL,0,'Prepare power supply',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,8,'JO Step 4',1,1,'production','equipment',NULL,'employee group',1,5,NULL,NULL,'2010-09-29 07:17:39',2,NULL,NULL,0,'Prepare LED mounting',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,8,'JO Step 5',1,1,'production','equipment',NULL,'employee group',1,6,NULL,NULL,'2010-09-29 07:18:09',2,NULL,NULL,0,'Wiring assembly',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,8,'JO Step 6',1,1,'production','equipment',NULL,'employee group',1,7,NULL,NULL,'2010-09-29 07:18:50',2,NULL,NULL,0,'Packing fished product',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,2,'Installation Step 1',1,1,'production','equipment',NULL,'employee group',NULL,8,NULL,NULL,'2011-01-06 12:38:17',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,2,'Installation Step 2',1,1,'production','equipment',NULL,'employee group',NULL,9,NULL,NULL,'2011-01-06 12:38:42',2,'2011-01-06 12:39:12',2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,2,'Installation Step 3',1,1,'production','equipment',NULL,'employee group',NULL,10,0,0,'2011-01-06 12:39:02',2,'2011-01-12 12:28:15',2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,2,'Installation Step 4',1,1,'production','equipment',NULL,'employee group',NULL,11,NULL,NULL,'2011-01-06 12:39:44',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,2,'Installation Step 5',1,1,'production','equipment',NULL,'employee group',NULL,12,NULL,NULL,'2011-01-06 12:40:05',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,12,'Final Delivery',1,1,'production','equipment',NULL,'employee group',1,NULL,NULL,NULL,'2011-01-11 11:37:55',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,2,'YMCA_160_Diagram',1,1,'production','equipment',NULL,'employee group',NULL,13,NULL,NULL,'2011-02-28 16:59:04',2,'2011-02-28 17:16:49',2,0,'Review Wiring Diagram',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,8,'YMCA 160 LED Mounting',1,1,'production','equipment',NULL,'employee group',NULL,14,NULL,NULL,'2011-02-28 19:17:42',2,'2011-03-04 08:25:43',2,0,'LED Module Mounting',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,8,'YMCA 160 Filter Mounting',1,1,'production','equipment',NULL,'employee group',NULL,15,NULL,NULL,'2011-03-01 08:47:28',2,'2011-03-04 08:26:29',2,0,'Filter to Baffle Plate Mounting',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,8,'YMCA 160 Fan Filter Assembly',1,1,'production','equipment',NULL,'employee group',NULL,16,NULL,NULL,'2011-03-02 07:22:42',2,'2011-03-04 08:27:02',2,0,'Fan and Filter Assembly',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(18,8,'YMCA 160 Fan Mounting',1,1,'production','equipment',NULL,'employee group',NULL,17,NULL,NULL,'2011-03-02 07:39:08',2,'2011-03-04 08:27:33',2,0,'Fan and Filter to Baffle Plate Mounting',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,8,'YMCA 160 Power Supply',1,1,'production','equipment',NULL,'employee group',NULL,18,NULL,NULL,'2011-03-02 07:51:28',2,'2011-03-04 08:27:57',2,0,'Power Supply Installation',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,8,'YMCA 160 Wiring',1,1,'production','equipment',NULL,'employee group',NULL,19,NULL,NULL,'2011-03-02 08:12:29',2,'2011-03-04 08:28:17',2,0,'Wirng Instructions for each power supply and LED Module combination',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,1,'YMCA 160 Continuity Test',1,1,'production','equipment',NULL,'employee group',NULL,20,NULL,NULL,'2011-03-02 08:35:21',2,'2011-03-08 09:22:17',2,3,'Continuity Test for each power supply',NULL,'current=0','integer','ohms',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,5,'Hold',1,1,'production','equipment',NULL,'employee group',NULL,NULL,NULL,NULL,'2011-03-02 08:59:14',2,'2011-03-02 09:06:17',2,0,'Hold batch due to any reason.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,9,'Reposition',1,1,'production','equipment',NULL,'employee group',NULL,NULL,NULL,NULL,'2011-03-02 09:03:03',2,'2011-03-02 09:06:33',2,0,'Reposition batch to a step',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,11,'Scrap',1,1,'production','equipment',NULL,'employee group',NULL,NULL,NULL,NULL,'2011-03-02 09:05:53',2,NULL,NULL,0,'Scrap batch due to irrepairable error',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,8,'YMCA 160 PSU Labeling',1,1,'production','equipment',NULL,'employee group',NULL,21,NULL,NULL,'2011-03-02 12:12:59',7,'2011-03-04 08:28:51',2,0,'Labeling the Power Supply',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,1,'YMCA 160 Burn-in Test',1,1,'production','equipment',NULL,'employee group',NULL,22,NULL,NULL,'2011-03-02 12:16:53',7,'2011-03-04 08:55:02',2,2,'Burn-in Test',NULL,'Result=Pass','Pass, Fail',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,8,'YMCA 160 ETL Labeling',1,1,'production','equipment',NULL,'employee group',NULL,23,NULL,NULL,'2011-03-02 12:44:58',7,'2011-03-04 08:26:02',2,0,'ETL Labeling',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,8,'YMCA 160 Packing',1,1,'production','equipment',NULL,'employee group',NULL,24,NULL,NULL,'2011-03-04 08:29:48',2,'2011-03-08 09:19:23',2,0,'Finish and Packing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,2,'YMCA 160 Installation Wiring Diagram',1,1,'production','equipment',NULL,'employee group',NULL,25,NULL,NULL,'2011-03-04 09:32:57',2,'2011-03-04 09:56:10',2,0,'Wiring Diagram for Each Power Supply (2). Installation starts from this step.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,2,'YMCA 160 Warning 1',1,1,'production','equipment',NULL,'employee group',NULL,26,NULL,NULL,'2011-03-04 09:37:53',2,'2011-03-04 09:47:51',2,0,'WARNINGS AND CAUTIONS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(31,2,'YMCA 160 Warning 2',1,1,'production','equipment',NULL,'employee group',NULL,27,NULL,NULL,'2011-03-04 09:54:38',2,NULL,NULL,0,'WARNINGS AND CAUTIONS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,2,'YMCA 160 Dissassembly 1',1,1,'production','equipment',NULL,'employee group',NULL,28,NULL,NULL,'2011-03-04 10:12:17',2,'2011-03-04 10:41:07',2,0,'INSTALLATION INSTRUCTIONS\r\n-- DISSASSEMBLY PROCEDURE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,2,'YMCA 160 Dissas 2',1,1,'production','equipment',NULL,'employee group',NULL,29,NULL,NULL,'2011-03-04 10:23:22',2,NULL,NULL,0,'DISSASSEMBLY PROCEDURE (CONINUED)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(34,2,'YMCA 160 Dissas3',1,1,'production','equipment',NULL,'employee group',NULL,30,NULL,NULL,'2011-03-04 10:31:07',2,'2011-03-04 10:33:48',2,0,'DISSASSEMBLY PROCEDURE (LAST)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(35,2,'YMCA 160 Install 1',1,1,'production','equipment',NULL,'employee group',NULL,31,NULL,NULL,'2011-03-04 10:40:41',2,NULL,NULL,0,'INSTALLATION INSTRUCTIONS\r\n-- ASSEMBLY PROCEDURE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(36,2,'YMCA 160 Install 2',1,1,'production','equipment',NULL,'employee group',NULL,32,NULL,NULL,'2011-03-04 10:47:24',2,NULL,NULL,0,'ASSEMBLY PROCEDURE (CONTINUED)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(37,12,'YMCA 160 deliver',1,1,'production','equipment',NULL,'employee group',NULL,NULL,NULL,NULL,'2011-03-04 10:48:35',2,NULL,NULL,0,'Final Deliver',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `step` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `step_group`
--

DROP TABLE IF EXISTS `step_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_group` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `step_group`
--

LOCK TABLES `step_group` WRITE;
/*!40000 ALTER TABLE `step_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `step_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `step_type`
--

DROP TABLE IF EXISTS `step_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `step_type`
--

LOCK TABLES `step_type` WRITE;
/*!40000 ALTER TABLE `step_type` DISABLE KEYS */;
INSERT INTO `step_type` VALUES (1,'condition',10,3,'2010-08-04 10:55:16',NULL,'Condition takes at least three parameters: x operator Y'),(2,'display message',10,1,'2010-08-04 10:55:16',NULL,'Dispaly message is the only required parameter.'),(3,'call api',10,1,'2010-08-04 10:55:16',NULL,'api name is the required parameter.'),(4,'check list',0,1,'2010-08-04 10:55:16',NULL,'At list one item is required.'),(5,'hold lot',0,0,'2010-08-04 10:55:16',NULL,'No parameter required and lot number is supplied when executed.'),(6,'hold equipment',0,0,'2010-08-04 10:55:16',NULL,'No parameter required and equiipment id is supplied when executed.'),(7,'email',10,3,'2010-08-04 10:55:16',NULL,'email address, subject, and content are required'),(8,'consume material',0,0,'2010-08-04 10:55:16',NULL,'recipe is supplied as a column value.'),(9,'reposition',0,0,'2010-08-04 10:55:16',NULL,'No parameter is needed.'),(10,'ship to warehouse',0,0,'2010-08-04 10:55:16',NULL,'No parameter is needed.'),(11,'scrap',0,0,'2010-08-04 10:55:16',NULL,'No parameter is needed.'),(12,'deliver to customer',0,0,'2011-01-11 11:10:43',NULL,'No parameter is needed.Receiving information carried in lot comment');
/*!40000 ALTER TABLE `step_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_roles`
--

DROP TABLE IF EXISTS `system_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_roles`
--

LOCK TABLES `system_roles` WRITE;
/*!40000 ALTER TABLE `system_roles` DISABLE KEYS */;
INSERT INTO `system_roles` VALUES (1,1,'Admin'),(2,1,'Manager'),(3,1,'QA'),(4,1,'Engineer'),(5,1,'tester');
/*!40000 ALTER TABLE `system_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uom`
--

DROP TABLE IF EXISTS `uom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uom` (
  `id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `alias` varchar(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uom`
--

LOCK TABLES `uom` WRITE;
/*!40000 ALTER TABLE `uom` DISABLE KEYS */;
INSERT INTO `uom` VALUES (1,'Unit','unit','unit of parts'),(2,'meter','m','Length for wires.'),(3,'cm','cm',NULL),(5,'mm','mm',NULL),(6,'liter','l',NULL),(7,'kg','kg',NULL),(8,'g','g',NULL),(9,'km','km',NULL),(10,'inch','\"',NULL),(11,'ounce','oz',NULL),(12,'feet','\'',NULL),(13,'yard','yard',NULL),(14,'squarefoot','sf',NULL),(15,'cubicfoot','cuf',NULL),(16,'volt','v',NULL),(17,'Kit',NULL,NULL),(18,'Roll',NULL,NULL);
/*!40000 ALTER TABLE `uom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uom_conversion`
--

DROP TABLE IF EXISTS `uom_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uom_conversion` (
  `from_id` smallint(3) unsigned NOT NULL,
  `to_id` smallint(3) unsigned NOT NULL,
  `method` enum('ratio','reduction','addtion') NOT NULL,
  `constant` decimal(16,4) unsigned NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`from_id`,`to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uom_conversion`
--

LOCK TABLES `uom_conversion` WRITE;
/*!40000 ALTER TABLE `uom_conversion` DISABLE KEYS */;
INSERT INTO `uom_conversion` VALUES (1,17,'ratio','1.0000',NULL),(2,3,'ratio','100.0000',NULL),(3,5,'ratio','10.0000','test'),(7,8,'ratio','1000.0000',NULL),(12,10,'ratio','12.0000',NULL);
/*!40000 ALTER TABLE `uom_conversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_in_roles`
--

DROP TABLE IF EXISTS `users_in_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_in_roles` (
  `userId` int(11) NOT NULL DEFAULT '0',
  `roleId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`userId`,`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_in_roles`
--

LOCK TABLES `users_in_roles` WRITE;
/*!40000 ALTER TABLE `users_in_roles` DISABLE KEYS */;
INSERT INTO `users_in_roles` VALUES (1,1),(2,1),(3,1),(7,1),(8,5),(9,1),(10,1);
/*!40000 ALTER TABLE `users_in_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `view_ingredient`
--

DROP TABLE IF EXISTS `view_ingredient`;
/*!50001 DROP VIEW IF EXISTS `view_ingredient`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_ingredient` (
  `recipe_id` int(11) unsigned,
  `source_type` varchar(8),
  `ingredient_id` int(11) unsigned,
  `name` varchar(255),
  `description` text,
  `quantity` decimal(16,4) unsigned,
  `uom_id` smallint(6) unsigned,
  `uom_name` varchar(20),
  `order` tinyint(4) unsigned,
  `mintime` int(11) unsigned,
  `maxtime` int(11) unsigned,
  `comment` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_lot_in_process`
--

DROP TABLE IF EXISTS `view_lot_in_process`;
/*!50001 DROP VIEW IF EXISTS `view_lot_in_process`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_lot_in_process` (
  `id` int(10) unsigned,
  `alias` varchar(20),
  `product_id` int(10) unsigned,
  `product` varchar(255),
  `priority` tinyint(2) unsigned,
  `priority_name` varchar(20),
  `dispatch_time` datetime,
  `process_id` int(10) unsigned,
  `process` varchar(255),
  `sub_process_id` int(10) unsigned,
  `sub_process` varchar(255),
  `position_id` int(5) unsigned,
  `sub_position_id` int(5) unsigned,
  `step_id` int(10) unsigned,
  `step` varchar(255),
  `lot_status` enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  `step_status` enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  `start_time` datetime,
  `end_time` datetime,
  `start_timecode` char(15),
  `actual_quantity` decimal(16,4) unsigned,
  `uomid` smallint(5) unsigned,
  `uom` varchar(20),
  `contact` int(10) unsigned,
  `contact_name` varchar(41),
  `equipment_id` int(10) unsigned,
  `equipment` varchar(255),
  `device_id` int(10) unsigned,
  `approver_id` int(10) unsigned,
  `comment` text,
  `result` text,
  `emp_usage` enum('employee group','employee'),
  `emp_id` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_process_step`
--

DROP TABLE IF EXISTS `view_process_step`;
/*!50001 DROP VIEW IF EXISTS `view_process_step`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_process_step` (
  `process_id` int(10) unsigned,
  `position_id` int(5) unsigned,
  `step_id` int(10) unsigned,
  `prev_step_pos` int(5) unsigned,
  `next_step_pos` int(5) unsigned,
  `false_step_pos` int(5) unsigned,
  `rework_limit` smallint(2) unsigned,
  `if_sub_process` tinyint(1) unsigned,
  `YN_sub_process` varchar(1),
  `prompt` varchar(255),
  `if_autostart` tinyint(1) unsigned,
  `YN_autostart` varchar(1),
  `need_approval` tinyint(1) unsigned,
  `YN_need_approval` varchar(1),
  `approve_emp_usage` enum('employee group','employee category','employee'),
  `approve_emp_id` int(10) unsigned,
  `approve_emp_name` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'ezmes'
--
/*!50003 DROP FUNCTION IF EXISTS `convert_quantity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `convert_quantity`(
   _quantity decimal(16,4) unsigned,
   _from_uomid smallint(3) unsigned,
   _to_uomid smallint(3) unsigned
) RETURNS decimal(16,4) unsigned
BEGIN
  
  DECLARE _to_quantity decimal(16,4) unsigned;
  
  IF _from_uomid = _to_uomid
  THEN
    RETURN _quantity;
  ELSE
    SELECT _quantity*constant
      INTO _to_quantity
      FROM uom_conversion
    WHERE from_id = _from_uomid
      AND method= 'ratio'
      AND to_id = _to_uomid;
  
    IF _to_quantity IS NULL
    THEN
      SELECT _quantity/constant
        INTO _to_quantity
        FROM uom_conversion
      WHERE from_id = _to_uomid
        AND method="ratio"
        AND to_id = _from_uomid
        AND constant > 0;
    END IF;
    
    return _to_quantity;
  END IF;
  
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_local_time` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 FUNCTION `get_local_time`(
   _utc_time datetime
) RETURNS datetime
BEGIN
  
  DECLARE _timezone char(6);
  DECLARE _daylightsaving_starttime datetime;
  DECLARE _daylightsaving_endtime datetime;
  DECLARE _local_time datetime;
  
  SELECT timezone,
         daylightsaving_starttime,
         daylightsaving_endtime
    INTO _timezone, _daylightsaving_starttime, _daylightsaving_endtime
  FROM company
  LIMIT 1;
  
  SET _local_time = convert_tz(_utc_time, '+00:00', _timezone);
  IF _local_time BETWEEN concat(year(_local_time), substring(_daylightsaving_starttime,5))
                      AND concat(year(_local_time), substring(_daylightsaving_endtime,5))
  THEN
    RETURN addtime(_local_time, '01:00');
  ELSE
    RETURN _local_time;
  END IF;

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_attribute_to_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `add_attribute_to_product`(
  IN _employee_id int(10) unsigned,
  IN _pd_id int(10) unsigned,
  IN _attr_name varchar(255),
  IN _attr_value  varchar(255),
  IN _attr_type enum('in', 'out', 'both'),
  IN _data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime'),
  IN _length int(4) unsigned,
  IN _decimal_length tinyint(1) unsigned,
  IN _key_attr tinyint(1),
  IN _optional tinyint(1),  
  IN _max_value varchar(255),
  IN _min_value varchar(255),
  IN _enum_values varchar(255),
  IN _description text,
  IN _comment text,
  OUT _attr_id int(10) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _pd_id IS NULL
  THEN
    SET _response='Product information is missing';   
   
  ELSEIF _attr_name IS NULL OR length(_attr_name)<1
  THEN
    SET _response = 'Attribute name is required.';
    
  ELSEIF _attr_type IS NULL
  THEN
    SET _response = 'Attribute type is required.'; 
    
  ELSEIF _data_type IS NULL
  THEN
    SET _response = 'Data type for the attribute is required.';
    
  ELSE
      SELECT name INTO ifexist
        FROM product
      WHERE id=_pd_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The product selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
         IF ifexist IS NULL
         THEN
           SET _response = 'The employee who is inserting this attribute does not exist in database.';
         ELSE
         
          SET ifexist=NULL;
          SELECT attr_name INTO ifexist
            FROM pd_attributes
            WHERE pd_id=_pd_id
              AND attr_name=_attr_name;
              
            IF ifexist IS NULL
            THEN
              SELECT ifnull(MAX(attr_id)+1,1) INTO _attr_id
                FROM pd_attributes
               WHERE pd_id = _pd_id;
               
               
              INSERT INTO pd_attributes
              (
                `pd_id`,
                `attr_id`,
                `attr_name`,
                `attr_value`,
                `attr_type`,
                `data_type`,
                `length`,
                `decimal_length`,
                `key_attr`,
                `optional` ,
                `max_value` ,
                `min_value` ,
                `enum_values` ,
                `description` ,
                `comment`
              )
              VALUES (
                _pd_id,
                _attr_id,
                _attr_name,
                _attr_value,
                _attr_type,
                _data_type,
                _length,
                _decimal_length,
                _key_attr,
                _optional,
                _max_value,
                _min_value,
                _enum_values,
                _description,
                _comment
              );
              
              INSERT INTO attribute_history
              (
                `event_time`,
                `employee_id`,
                `action`,
                `parent_type`,
                `parent_id`,
                `attr_id`,
                `attr_name`,
                `attr_value`,
                `attr_type`,
                `data_type`,
                `length`,
                `decimal_length`,
                `key_attr`,
                `optional`,  
                `max_value`,
                `min_value`,
                `enum_values`,
                `description`,
                `comment`              
              )
              SELECT _eventtime,
                     _employee_id,
                     'insert',
                     'product',
                     pd_id,
                     attr_id,
                     attr_name,
                     attr_value,
                     attr_type,
                     data_type,
                     `length`,
                     decimal_length,
                     key_attr,
                     optional,
                     max_value,
                     min_value,
                     enum_values,
                     description,
                     comment
                FROM pd_attributes
               WHERE pd_id = _pd_id
                 AND attr_id = _attr_id;
            
              UPDATE product
                 SET state_change_time = _eventtime,
                     state_changed_by = _employee_id
               WHERE id=_pd_id;
            ELSE
              SET _response = concat('An attribute with name ', _attr_name , ' for this product already exist in database.');
            END IF;
         END IF;
      END IF; 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_ingredient_to_recipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `add_ingredient_to_recipe`(
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source type is required.';
    
  ELSEIF _quantity IS NULL
  THEN
    SET _response = 'Quantity is required.'; 
    

    
  ELSE
      SELECT name INTO ifexist
        FROM recipe
      WHERE id =_recipe_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
         IF ifexist IS NULL
         THEN
           SET _response = 'The employee who is adding this ingredient does not exist in database.';
         ELSE
        
          SET ifexist=NULL;
          IF _source_type = 'product'
          THEN
            SELECT name,
                   uomid
             INTO ifexist, _uom_id
              FROM product
              WHERE id=_ingredient_id;
          ELSEIF _source_type = 'material'
          THEN
            SELECT name,
                   uom_id
              INTO ifexist, _uom_id
              FROM material
              WHERE id=_ingredient_id;
          ELSE
            SET _response = concat('Source type ' , _source_type , ' is not valid.');
          END IF;
          
          IF ifexist IS NULL 
          THEN
            IF _response IS NULL
            THEN
              SET _response = 'The ingredient you selected does not exist in database.';
            END IF;
          ELSE
              INSERT INTO ingredients
              (
                recipe_id,
                source_type,
                ingredient_id,
                quantity,
                uom_id,
                `order`,
                mintime,
                maxtime,
                comment
              )
              VALUES (
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment
              );

              INSERT INTO ingredients_history
              (
                event_time,
                employee_id,
                action,
                recipe_id,
                source_type,
                ingredient_id,
                quantity,
                uom_id,
                `order`,
                mintime,
                maxtime,
                comment              
              )
              VALUES (
                _eventtime,
                _employee_id,
                'insert',
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment             
              );
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_step_to_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `add_step_to_process`(
  IN _process_id int(10) unsigned,
  IN _position_id  int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _prev_step_pos  int(5) unsigned,
  IN _next_step_pos  int(5) unsigned,
  IN _false_step_pos  int(5) unsigned,
  IN _segment_id  int(5) unsigned,
  IN _rework_limit smallint(2) unsigned,
  IN _if_sub_process tinyint(1),
  IN _prompt varchar(255),
  IN _if_autostart tinyint(1) unsigned,
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _eventtime datetime;
  DECLARE _step_type varchar(20);
  
  
  SET _eventtime = now();
 

IF NOT EXISTS (SELECT * FROM step WHERE id=_step_id)
THEN
  SET _response="The step you selected doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
THEN
  SET _response="The workflow you are working on doesn't exist in database.";
ELSEIF EXISTS (SELECT position_id FROM process_step WHERE process_id = _process_id AND position_id = _position_id)
THEN
  SET _response= concat('The position ' , _position_id ,' is already used in the process. Please change the position and try again.');
ELSEIF _segment_id IS NOT NULL AND NOT EXISTS(SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id = _segment_id)
THEN
  SET _response = "The segment you chose does not exist in database";
ELSE
  
  SELECT t.name INTO _step_type
    FROM step s, step_type t
   WHERE s.id = _step_id
     AND t.id = s.step_type_id;
     
  IF _step_type = 'condition' AND _false_step_pos IS NULL 
  THEN
    SET _response="A step position on false result is required for conditional step.";
  ELSEIF _step_type != 'condition' AND _false_step_pos IS NOT NULL 
  THEN
    SET _response = "No step position on false result is needed. Please leave it blank.";
  ELSE
  
    IF _if_sub_process = 1
    THEN
      SET _if_autostart = 1;
    END IF;
    INSERT INTO process_step (
      process_id,
      position_id,
      step_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id)
    VALUES (
      _process_id,
      _position_id,
      _step_id,
      _prev_step_pos,
      _next_step_pos,
      _false_step_pos,
      _segment_id,
      _rework_limit,
      _if_sub_process,
      _prompt,
      _if_autostart,
      _need_approval,
      _approve_emp_usage,
      _approve_emp_id
    );
  
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id 
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'insert',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id  
    FROM process_step
    WHERE process_id=_process_id
      AND position_id = _position_id;
    
    UPDATE process
      SET state_change_time = _eventtime,
          state_changed_by = _employee_id
    WHERE id = _process_id;

   
  END IF;


END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `associate_product_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `associate_product_process`(
  IN _product_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _priority tinyint(2) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  IF _product_id IS NULL
  THEN
    SET _response = 'No product was selected. Please select a product.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'No process was selected. Please select a process.';
  ELSE
      SELECT name INTO ifexist 
      FROM product 
      WHERE id=_product_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The product you selected does not exist in database.';
      ELSE
        SET ifexist = NULL;
        SELECT name INTO ifexist
        FROM process
        WHERE id=_process_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The process you selected does not exist in database.';
        ELSE
          SET ifexist = NULL;
          SELECT 'RECORD EXIST' INTO ifexist
           FROM product_process
          WHERE product_id = _product_id
            AND process_id = _process_id;
          
          IF ifexist IS NULL
          THEN
            INSERT INTO product_process (
              product_id,
              process_id,
              priority,
              recorder,
              comment)
            VALUES (
              _product_id,
              _process_id,
              _priority,
              _recorder,
              _comment
            );
          ELSE
            UPDATE product_process
               SET priority = _priority,
                   recorder = _recorder,
                   comment = _comment
             WHERE product_id = _product_id
               AND process_id = _process_id
               ;
          END IF;
        END IF;
      END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `autoload_client` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `autoload_client`(
OUT _client_id int(10) unsigned,
IN _name varchar(40),
IN _type enum('supplier', 'customer', 'both'),
IN _internal_contact_id int(10) unsigned,
IN _company_phone varchar(20),
IN _address varchar(255),
IN _city varchar(20),
IN _state varchar(20),
IN _zip varchar(10),
IN _country varchar(20),
IN _address2 varchar(255),
IN _city2 varchar(20),
IN _state2 varchar(20),
IN _zip2 varchar(10),
IN _contact_person1 varchar(20),
IN _contact_person2 varchar(20),
IN _person1_workphone varchar(20),
IN _person1_cellphone varchar(20),
IN _person1_email varchar(40),
IN _person2_workphone varchar(20),
IN _person2_cellphone varchar(20),
IN _person2_email varchar(20),
IN _ifactive tinyint(1) unsigned,
IN _comment text,
OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Client name is required. Please input the client name.';
  ELSEIF _type IS NULL OR length(_type)<1
  THEN
    SET _response='Client type is required. Please input the client type.';  
  ELSEIF _internal_contact_id IS NULL 
  THEN
    SET _response = 'Internal contact person is required. Please select an employee as internal contact person.';
    
  ELSEIF _contact_person1 IS NULL OR length(_contact_person1)<1
  THEN
    SET _response='Contact person name from client company is required. Please fill in the name of the person.'; 
    
  ELSEIF _person1_email IS NULL OR length(_person1_email)<1
  THEN
    SET _response='Email address of the first contact person from client company is required. Please fill in the email address.';    
    
  ELSE
    SELECT id
      INTO _client_id
      FROM client
     WHERE name=_name;
     
    IF _client_id IS NULL
    THEN
      INSERT INTO client (
        name,
        type,
        internal_contact_id,
        company_phone,
        address,
        city,
        state,
        zip,
        country,
        address2,
        city2,
        state2,
        zip2,
        contact_person1,
        contact_person2,
        person1_workphone,
        person1_cellphone,
        person1_email,
        person2_workphone,
        person2_cellphone,
        person2_email,
        firstlistdate,
        ifactive,
        comment
      )
      VALUES (
        _name,
        _type,
        _internal_contact_id,
        _company_phone,
        _address,
        _city ,
        _state,
        _zip,
        _country,
        _address2,
        _city2,
        _state2,
        _zip2,
        _contact_person1,
        _contact_person2,
        _person1_workphone,
        _person1_cellphone,
        _person1_email,
        _person2_workphone,
        _person2_cellphone,
        _person2_email,
        now(),
        _ifactive,
        _comment
      );
      SET _client_id = last_insert_id();
    END IF;

  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `autoload_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `autoload_inventory`(
  IN _recorded_by int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _pd_or_mt_id int(10) unsigned,
  IN _supplier_id int(10) unsigned, -- if no supplier use 0
  IN _lot_id varchar(20),
  IN _serial_no varchar(20),
  IN _out_order_id varchar(20),
  IN _in_order_id varchar(20),
  IN _original_quantity decimal(16,4) unsigned,
  IN _uom_name varchar(20),
  IN _manufacture_date datetime,
  IN _expiration_date datetime,
  IN _arrive_date datetime,
  IN _contact_employee int(10) unsigned,
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE ifexist varchar(255);
  DECLARE wording varchar(20);
  DECLARE _uom_id smallint(3) unsigned;
  
  SELECT id INTO _uom_id
    FROM uom
   WHERE name = _uom_name;
   
  IF _source_type IS NULL OR length(_source_type )< 1
  THEN
    SET _response='Source type is required. Please provide an source type.';
  ELSEIF  _pd_or_mt_id IS NULL
  THEN 
    SET _response='No part number provided. Please supply a part number.';
  ELSEIF  _supplier_id IS NULL
  THEN 
    SET _response='Supplier is required. Please supply a supplier.';
  ELSEIF  _lot_id IS NULL
  THEN 
    SET _response='Supplier lot number is required. Please fill in the lot number.';
  ELSEIF  _original_quantity IS NULL OR _original_quantity = 0
  THEN 
    SET _response='Original Quanity is required and can not be zero. Please provide original quantity.';
  ELSEIF  _uom_name IS NULL
  THEN 
    SET _response='Unit of Measure is required. Please provide a unit of measure.';   
  ELSEIF  _manufacture_date IS NULL
  THEN 
    SET _response='Manufacture Date is required. Please provide a manufacture date.'; 
  ELSEIF  _arrive_date IS NULL
  THEN 
    SET _response='Arrive Date is required. Please provide an arrive date.';
  ELSEIF  _recorded_by IS NULL
  THEN 
    SET _response='Recorder information is missing.';   
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_recorded_by)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';  
  ELSEIF _contact_employee IS NOT NULL AND NOT EXISTS (SELECT * FROM employee WHERE id=_contact_employee)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';   
  ELSEIF _uom_name IS NULL 
  THEN
    SET _response = 'Unit of Measure is required. Please provide unit of measure used by the inventory.';
  ELSEIF _uom_id IS NULL
  THEN
    SET _response = "The unit of measure used doesn't exist in database. Please insert the UoM to database first.";
  ELSE
  

      
      IF _source_type = 'product' THEN

        SET _response = "This stored procedure currently doesn't handle self produced product.";
        
      ELSEIF _source_type = 'material' THEN
        IF NOT EXISTS (SELECT * FROM material WHERE id=_pd_or_mt_id)
        THEN
          SET _response = 'The material you selected is not in our material list. Please first record the material information.';
        ELSEIF _supplier_id IS NULL
        THEN
          SET _response = "Supplier information is missing. Please provide supplier information.";
        ELSEIF _supplier_id=0 
        THEN
          SELECT ifnull(supplier_id, 0) INTO _supplier_id
            FROM material_supplier s 
           WHERE s.material_id=_pd_or_mt_id
           ORDER BY s.preference
           LIMIT 1;
           
        END IF;
      ELSE
        SET _response = 'The source type you selected is invalid. Please select a valid source type.';
      END IF;
    
      IF _response IS NULL
      THEN
        IF _serial_no IS NULL AND EXISTS (SELECT * 
                                            FROM inventory 
                                          WHERE source_type = _source_type 
                                            AND pd_or_mt_id = _pd_or_mt_id
                                            AND supplier_id = _supplier_id
                                            AND lot_id = _lot_id
                                            )
        THEN
          SET _response = concat('The batch ', _lot_id , ' already exists in inventory.');
        ELSEIF EXISTS (SELECT * FROM inventory
                        WHERE source_type = _source_type 
                          AND pd_or_mt_id = _pd_or_mt_id
                          AND supplier_id = _supplier_id
                          AND lot_id = _lot_id
                          AND serial_no = _serial_no
                      )
        THEN
          SET _response = concat('The batch ', _lot_id , ' with serial number ', _serial_no, ' already exists in inventory.');
        END IF;
      END IF;
      
      IF _response IS NULL THEN

        INSERT INTO `inventory` (
          source_type,
          pd_or_mt_id,
          supplier_id,
          lot_id,
          serial_no,
          out_order_id,
          in_order_id,
          original_quantity,
          actual_quantity,
          uom_id,
          manufacture_date,
          expiration_date,
          arrive_date,
          recorded_by,
          contact_employee,
          comment 
        )
        values (
              _source_type,
              _pd_or_mt_id,
              _supplier_id,
              _lot_id,
              _serial_no,
              _out_order_id,
              _in_order_id,
              _original_quantity,
              _original_quantity,
              _uom_id,
              _manufacture_date,
              _expiration_date,
              _arrive_date,
              _recorded_by,
              _contact_employee,
              _comment  
            );
        SET _inventory_id = last_insert_id();

      END IF;
  END IF;
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `autoload_material` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `autoload_material`(
  IN _employee_id int(10) unsigned,
  IN _name varchar(255),
  IN _alias varchar(255),
  IN _mg_id int(10) unsigned,
  IN _material_form enum('solid','liquid','gas'),
  IN _status enum('inactive','production','frozen'),
  IN _lot_size decimal(16,4) unsigned,
  IN _uom_name varchar(20),
  IN _supplier_id int(10) unsigned,
  IN _preference smallint(3) unsigned,  
  IN _mpn varchar(255),
  IN _price decimal(10,2) unsigned,
  IN _lead_days int(5) unsigned,
  IN _description text,
  IN _comment text,
  OUT _material_id int(10) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  DECLARE _uom_id smallint(3) unsigned;
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Material name is required. Please give the material a name.';
    
  ELSEIF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.';
  ELSEIF _uom_name IS NULL
  THEN
    SET _response = 'Unit of Measure used for item is missing.';
  ELSE

    SELECT id
      INTO _uom_id
      FROM uom
     WHERE name=_uom_name;
    
    IF _uom_id IS NULL
    THEN
      SET _response = 'Unit of Measure used by the item does not exist in database.';
    ELSE
    
      SELECT id INTO _material_id 
      FROM material 
      WHERE name=_name
        AND mg_id <=> _mg_id;
      
      IF _material_id IS NULL
      THEN
        INSERT INTO material (
          name,
          mg_id,
          alias,
          uom_id,
          lot_size,
          material_form,
          status,
          enlist_time,
          enlisted_by,
          description,
          comment
        )
        VALUES (
          _name,
          _mg_id,
          _alias,
          _uom_id,
          _lot_size,
          _material_form,
          _status,
          now(),
          _employee_id,
          _description,
          _comment
        );
        SET _material_id = last_insert_id();
        SET _response = '';
      END IF;
      
      IF _supplier_id IS NOT NULL
      THEN
        IF NOT EXISTS (SELECT * FROM material_supplier WHERE material_id = _material_id AND supplier_id = _supplier_id)
        THEN
          INSERT INTO material_supplier
          (
            `material_id`,
            `supplier_id`,
            `preference`,
            `mpn`,
            `price`,
            `price_uom_id`,
            `lead_days`
          )
          VALUES(
            _material_id,
            _supplier_id,
            _preference,  
            _mpn,
            _price,
            _uom_id,
            _lead_days        
          );
        ELSE
          UPDATE material_supplier
            SET preference = ifnull(_preference, preference)
              , mpn = ifnull(_mpn, mpn)
              , price = ifnull(_price, price)
              , price_uom_id = _uom_id
          WHERE material_id = _material_id
            AND supplier_id = _supplier_id;
        END IF;
      END IF;
    END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `auto_start_lot_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `auto_start_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _start_quantity decimal(16,4) unsigned,
  IN _comment text,
  OUT _process_id int(10) unsigned,
  OUT _sub_process_id int(10) unsigned,
  OUT _position_id int(5) unsigned,
  OUT _sub_position_id int(5) unsigned,
  OUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result char(1);
  DECLARE _if_autostart tinyint(1) unsigned;  
 
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           substring(ifnull(result, 'T'), 1, 1),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);
    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _if_autostart > 0 AND _step_type = 'consume material' -- auto start only applies to "consume material" step type
    THEN
      IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
      THEN
        SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
      ELSEIF _step_status = 'dispatched'
      THEN
        SET _response = "The first step after dispatch can't be auto started.";
      ELSEIF _step_status != 'ended'
      THEN
        SET _response = "The batch didn't finish last step normally, thus can't start new step.";
      ELSEIF _response IS NULL
      THEN
  
        SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        SET _step_status = 'started';
         
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          status,
          start_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _start_timecode,
          _process_id_p,
          _sub_process_id_n,
          _position_id_n,
          _sub_position_id_n,
          _step_id_n,
          _operator_id,
          _step_status,
          _start_quantity,
          _uomid,
          _comment
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'in process';
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _start_quantity
                ,update_timecode = _start_timecode
                ,comment=_comment
           WHERE id=_lot_id;
        ELSE
          SET _response="Error when recording batch history.";
        END IF;  
  
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_approver` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `check_approver`(
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  OUT _response varchar(255)
)
BEGIN
      
  IF _need_approval > 0
  THEN
    IF NOT EXISTS (SELECT * FROM employee WHERE id = _approver_id AND password=_approver_password AND status='active')
    THEN
      SET _response = "Approver username or password is incorrect. Please correct.";
    ELSEIF _approve_emp_usage = 'employee group' 
        AND NOT EXISTS (SELECT * FROM employee WHERE id=_approver_id AND eg_id = _approve_emp_id)
    THEN
      SET _response = "Approver doesn't belong to the employee group required for approving this step.";
    ELSEIF _approve_emp_usage='employee' AND _approver_id != _approve_emp_id
    THEN
      SET _response = "Approver is not the person required for approving this step.";
    -- currently we are not taking care of 'employee category' case. x.d.
    END IF;
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_emp_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `check_emp_access`(
  IN _emp_id int(10) unsigned,
  IN _emp_usage enum('employee group', 'employee'),
  IN _allow_emp_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _if_allow tinyint(1) unsigned;
  SET _if_allow=0;
  IF _emp_id IS NULL
  THEN
    SET _response = "Please supply an employee id to be checked";  
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_emp_id) 
  THEN
    SET _response = "The employee selected doesn't exist in database.";
  ELSEIF _allow_emp_id IS NULL
  THEN
    SET _response = "There is no defined restriction for employee access.";
  ELSEIF _emp_usage="employee group" 
    AND EXISTS (SELECT * FROM employee WHERE id=_emp_id
                                         AND eg_id=_allow_emp_id)
  THEN
    SET _if_allow=1;
  ELSEIF _emp_usage="employee" AND _emp_id=_allow_emp_id
  THEN
    SET _if_allow=1;
          
  END IF;
  
  SELECT _if_allow;
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `consume_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `consume_inventory`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _inventory_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _comment text,
  IN _recipe_uomid smallint(3) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_consume_quantity decimal(16,4) unsigned;
  DECLARE _inv_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
 
  SET autocommit=0;

  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch indentifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSEIF NOT EXISTS (
    SELECT *
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _step_start_timecode
       AND process_id = _process_id
       AND sub_process_id <=> _sub_process_id
       AND position_id = _position_id
       AND sub_position_id <=> _sub_position_id
       AND step_id = _step_id
  )
  THEN
    SET _response = "The batch you selected is not at the step and position given.";
  ELSE
    SELECT uom_id, actual_quantity
      INTO _inventory_uomid, _inv_quantity
      FROM inventory
     WHERE id=_inventory_id;
    
    IF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
      SET _inv_consume_quantity=convert_quantity(_quantity, _recipe_uomid, _inventory_uomid);
      IF _inv_consume_quantity IS NULL
      THEN
        SET _response = "Can not calculate consumption because no UoM conversion provided to convert quantity into the UoM used in inventory.";
      ELSEIF _inv_consume_quantity > _inv_quantity
      THEN
        SET _response = "The inventory doesn't have enough to meet the quantity required.";
      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
          INSERT INTO inventory_consumption
          (lot_id,
           lot_alias,
           start_timecode,
           end_timecode,
           inventory_id,
           quantity_used,
           uom_id,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           operator_id,
           equipment_id,
           device_id,
           comment
           )
           VALUES(
           _lot_id,
           _lot_alias,
           _timecode,
           _timecode,
           _inventory_id,
           _quantity,
           _recipe_uomid,
           _process_id,
           _sub_process_id,
           _position_id,
           _sub_position_id,
           _step_id,
           _operator_id,
           _equipment_id,
           _device_id,
           _comment
           );
           
          UPDATE inventory
             SET actual_quantity = actual_quantity - _inv_consume_quantity
           WHERE id=_inventory_id;
           
        COMMIT;
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_equipment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_equipment`(
  IN _employee_id int(10) unsigned,
  IN _equipment_id int(10) unsigned
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','up','down','qual','checkout','checkin');
  DECLARE _newstate  enum('inactive','up','down','qual','checkout','checkin');
  
  IF _employee_id IS NOT NULL AND EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN

    IF _equipment_id IS NOT NULL AND EXISTS (SELECT * FROM equipment WHERE id = _equipment_id)
    THEN

        
      INSERT INTO equip_history (
      event_time,
      equip_id,
      old_state,
      new_state,
      employee,
      comment,
      new_record
      )
      SELECT now(),
            id,
            state,
            null,
            _employee_id,
            concat('equipment ', name, ' is deleted'),
            concat('<EQUIPMENT><EG_ID>',eg_id,
                    '</EG_ID><NAME>',name,
                    '</NAME><STATE>', state, 
                    '</STATE><LOCATION_ID>',location_id,
                    '</LOCATION_ID><CONTACT_EMPLOYEE>',contact_employee,
                    '</CONTACT_EMPLOYEE><MANUFACTURE_DATE>', manufacture_date,
                    '</MANUFACTURE_DATE><MANUFACTURER>', manufacturer,
                    '</MANUFACTURER><MANUFACTURER_PHONE>', manufacturer_phone,
                    '</MANUFACTURER_PHONE><ONLINE_DATE>', online_date,
                    '</ONLINE_DATE><DESCRIPTION>',description,
                    '</DESCRIPTION><COMMENT>', comment, 
                    '</COMMENT></EQUIPMENT>')
      FROM equipment
      WHERE id=_equipment_id;
      
      DELETE FROM equipment WHERE id = _equipment_id;

    END IF; 
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_material` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_material`(
  IN _material_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  IF _material_id IS NULL OR NOT EXISTS (SELECT * FROM material WHERE id=_material_id)
  THEN
    SET _response = "The material you provided doesn't exist.";
    
  ELSEIF EXISTS (SELECT i.ingredient_id
                   FROM ingredients i, recipe r, step s, process_step ps, process p
                  WHERE i.source_type = 'material'
                    AND i.ingredient_id = _material_id
                    AND r.id = i.recipe_id
                    AND s.recipe_id = r.id
                    AND ps.step_id = s.id
                    AND p.id = ps.process_id
                    AND p.state='production'
                    )
  THEN
    SELECT CONCAT('The material ', name, " can't be deleted, because it is in use by a production workflow.")
      INTO _response
      FROM material
     WHERE id = _material_id;
  ELSE
    DELETE FROM material_supplier
     WHERE material_id = _material_id;
    DELETE FROM material
     WHERE id = _material_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_order`(
  IN _order_id int(10) unsigned
)
BEGIN
    DELETE FROM order_state_history
     WHERE order_id = _order_id;
    DELETE FROM order_detail
     WHERE order_id = _order_id;
    DELETE FROM order_general
     WHERE id = _order_id;
     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_process`(
  IN _process_id int(10) unsigned,
  IN _employee_id int(10) unsigned
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  DECLARE _eventtime datetime;
  SET _eventtime = now();  


   SELECT NAME INTO ifexist 
   FROM process 
   WHERE id= _process_id;
   
   IF ifexist IS NOT NULL
   THEN
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      if_sub_process,
      need_approval,
      approve_emp_usage,
      approve_emp_id 
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'DELETE',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      if_sub_process,
      need_approval,
      approve_emp_usage,
      approve_emp_id  
    FROM process_step
    WHERE process_id=_process_id;

    
    DELETE FROM process_step
    WHERE process_id = _process_id;
  
    -- delete process_segment record
    DELETE FROM process_segment
    WHERE process_id = _process_id;
    
    SELECT state
     INTO _oldstate
     FROM process
   WHERE id=_process_id;  
   
   DELETE FROM product_process
    WHERE process_id = _process_id;
    
   DELETE FROM process
    WHERE id=_process_id;

     INSERT INTO config_history (
       event_time,
       source_table,
       source_id,
       old_state,
       new_state,
       employee,
       comment 
     )
     VALUES (_eventtime,
             'process',
             _process_id,
             _oldstate,
             'deleted',
             _employee_id,
             concat('process ' , ifexist , ' is deleted')
             );


   END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_recipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_recipe`(
  IN _recipe_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _event_time datetime;
  SET _event_time = now();
  
  IF _recipe_id IS NULL
  THEN
    SET _response='No recipe selected. Please select a recipe to delete.';
    
  ELSEIF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
  THEN
    SET _response = 'The selected recipe does not exist in database';
  ELSEIF _employee_id IS NULL
  THEN
    SET _response='Employee information that initiated deletion is missing .'; 
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN
    SET _response = 'The employee that initiated deletion does not have record in database.';
  ELSE
    START TRANSACTION;
      INSERT INTO ingredients_history
        (
          event_time,
          employee_id,
          action,
          recipe_id,
          source_type,
          ingredient_id,
          quantity,
          uom_id,
          `order`,
          mintime,
          maxtime,
          comment              
        )
      SELECT 
        _event_time,
        _employee_id,
        'delete',
        recipe_id,
        source_type,
        ingredient_id,
        quantity,
        uom_id,
        `order`,
        mintime,
        maxtime,
        'delete recipe'  
      FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM recipe
      WHERE id = _recipe_id;
     
    COMMIT;    
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_step_from_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_step_from_process`(
  IN _process_id int(10) unsigned,
  IN _employee_id int(10) unsigned,  
  IN _position_id  int(5) unsigned

)
BEGIN
  DECLARE ifexist int(5) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();

  SELECT position_id INTO ifexist
    FROM process_step
  WHERE process_id = _process_id
    AND position_id = _position_id;
    
  IF ifexist IS NOT NULL
  THEN
  
  INSERT INTO process_step_history (
    event_time,
    process_id,
    position_id,
    step_id,
    action,
    employee_id,
    prev_step_pos,
    next_step_pos,
    false_step_pos,
    segment_id,
    rework_limit,
    if_sub_process,
    prompt,
    if_autostart,
    need_approval,
    approve_emp_usage,
    approve_emp_id 
  )
  SELECT _eventtime,
    process_id,
    position_id,
    step_id,
    'DELETE',
    _employee_id,
    prev_step_pos,
    next_step_pos,
    false_step_pos,
    segment_id,
    rework_limit,
    if_sub_process,
    prompt,
    if_autostart,
    need_approval,
    approve_emp_usage,
    approve_emp_id  
  FROM process_step
  WHERE process_id=_process_id
    AND position_id = _position_id;
  
  DELETE FROM process_step
   WHERE process_id = _process_id
     AND position_id = _position_id;
     
  UPDATE process
    SET state_change_time = _eventtime,
        state_changed_by = _employee_id
  WHERE id = _process_id;  
  
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_uom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `delete_uom`(
  IN _uom_id smallint(3) unsigned
)
BEGIN


  
  IF _uom_id IS NOT NULL AND EXISTS (SELECT * FROM uom WHERE id = _uom_id)
  THEN
    START TRANSACTION;

      
      DELETE FROM uom_conversion
       WHERE from_id = _uom_id
          OR to_id = _uom_id;
      
      DELETE FROM uom
      WHERE id = _uom_id;
     
    COMMIT;    
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deliver_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `deliver_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _deliver_datetime datetime,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _delivery_address varchar(255),
  IN _recipient varchar(30),
  IN _recipient_contact varchar(255),
  IN _comment text,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  
  SET autocommit=0;
   
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);    
    IF _response IS NULL AND _step_type = "deliver to customer"
    THEN
      -- SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
      IF ( _process_id IS NULL 
         AND _sub_process_id IS NULL 
         AND _position_id IS NULL
         AND _sub_position_id IS NULL
         AND _step_id IS NULL) OR
         (_process_id<=>_process_id_p 
            AND _sub_process_id<=>_sub_process_id_n
            AND _position_id <=>_position_id_n
            AND _sub_position_id <=>_sub_position_id_n
            AND _step_id <=> _step_id_n)
      THEN  -- new step informaiton wasn't supplied
      
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSE
         SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF;
      
       -- check approver information
      IF _response IS NULL
      THEN
        IF _sub_process_id IS NULL
        THEN
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id
            AND step_id = _step_id
        ;
        ELSE
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _sub_process_id
            AND position_id = _sub_position_id
            AND step_id = _step_id
          ;
        END IF;
        
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
      END IF;
      
      IF _response IS NULL
      THEN
        SET _step_status = 'shipped';
        SET _timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;        
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          end_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          end_operator_id,
          status,
          start_quantity,
          end_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _timecode,
          _timecode,
          _process_id,
          _sub_process_id,
          _position_id,
          _sub_position_id,
          _step_id,
          _operator_id,
          _operator_id,
          _step_status,
          _quantity,
          _quantity,
          _uomid ,
          CONCAT('RECIPIENT:', IFNULL(_recipient, ''), '\n', 
          'RECIPIENT CONTACT:', IFNULL(_recipient_contact,''), '\n',
          'DELIVERY DATETIME:', IFNULL(_deliver_datetime,''), '\n',
          'DELIVERY ADDRESS:', IFNULL(_delivery_address,''), '\n', 
          'COMMENT:', IFNULL(_comment,''))
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'shipped';
          
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _quantity
                ,update_timecode = _timecode
                ,comment=_comment
           WHERE id=_lot_id;
           
           UPDATE order_detail o, lot_status l
              SET o.quantity_in_process = o.quantity_in_process - convert_quantity(_quantity, _uomid, o.uomid),
                  o.quantity_shipped = o.quantity_shipped + convert_quantity(_quantity, _uomid, o.uomid),
                  o.actual_deliver_date=IFNULL(_deliver_datetime, o.actual_deliver_date)
            WHERE l.id = _lot_id
              AND o.order_id = l.order_id
              AND o.source_type = 'product'
              AND o.source_id = l.product_id
              ;
             COMMIT;         
        ELSE
          SET _response="Error when recording step pass in batch history.";
          ROLLBACK;
        END IF;  
        
        
      END IF;
    END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `dispatch_multi_lots` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `dispatch_multi_lots`(
  IN _order_id int(10) unsigned, 
  IN _product_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _num_lots int(10) unsigned,
  IN _alias_prefix varchar(10), 
  IN _lot_contact int(10) unsigned,
  IN _lot_priority tinyint(2) unsigned,
  IN _comment text,
  IN _dispatcher int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(20);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
  DECLARE _new_id int(10) unsigned;
  DECLARE _total_quantity decimal(16,4) unsigned;
 
  SET autocommit=0;

  
  IF _order_id IS NULL
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id)
  THEN
    SET _response = "The order you selected doesn't exist in database.";    
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'Process is required. Please select a process to dispatch lots to';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
  THEN
    SET _response = "The process you selected doesn't exist in database.";
  ELSEIF _num_lots IS NULL or _num_lots < 1
  THEN
    SET _response = 'Number of lots to dispatch is incorrect. Please dispatch at least one lot.';
  ELSEIF _dispatcher IS NULL
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher)
  THEN
    SET _response = "Dispatcher information doesn't exist in our database.";
  ELSEIF _product_id IS NULL
  THEN
      SET _response = 'The order you selected does not exist in database.';
  ELSEIF NOT EXISTS
  (   SELECT *
        FROM product_process
      WHERE process_id = _process_id
        AND product_id = _product_id
   )  
  THEN
        SET _response = 'The process you selected can not be used to manufacture the ordered product.';
  ELSE
    IF _lot_size IS NULL
    THEN
      SELECT lot_size into _lot_size
        FROM product
       WHERE id = _product_id;
    ELSEIF _lot_size > (SELECT lot_size FROM product WHERE id = _product_id)
    THEN
      SET _response ="The lot size you selected is bigger than the maximum lot size limit for the product. Please adjust your lot size.";
    END IF;
        
    IF _lot_priority IS NULL
    THEN
      SELECT priority INTO _lot_priority
        FROM `order`
       WHERE id = _order_id;
    END IF;
        
    IF _lot_size IS NULL
    THEN
      SET _response = 'Lot size information can not be found. Please enter the size for a single lot.';
    ELSE
--       SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
--                             between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
--                             and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
--                         substring(addtime(timezone, '01:00'), 1, 6),
--                         timezone)  
--               FROM company c, employee e
--               WHERE e.id = _dispatcher AND c.id = e.company_id);       
      
      SET _dispatch_time = utc_timestamp();
      
      SET _alias_suffix = 0;
      SET _total_quantity = 0;
      
      IF _alias_prefix IS NULL
      THEN
        SET _alias_prefix = '';
      END IF;
      
      SELECT uomid INTO _uom_id
        FROM product
      WHERE id = _product_id;    
      
       SET _ratio = null;
      IF EXISTS (SELECT * 
                FROM order_detail
                WHERE order_id = _order_id
                  AND source_type = 'product'
                  AND source_id = _product_id
                  AND uomid = _uom_id
              )
      THEN
        SET _ratio = 1;
      ELSE
        SELECT constant INTO _ratio
          FROM uom_conversion u 
          JOIN order_detail o ON o.order_id = _order_id 
                                AND o.source_type = 'product' 
                                AND o.source_id = _product_id
        WHERE from_id = _uom_id
          AND to_id = o.uomid
          AND method = 'ratio';
        
        IF _ratio IS NULL
        THEN
          SELECT constant INTO _ratio
            FROM uom_conversion u 
            JOIN order_detail o ON o.order_id = _order_id 
                                  AND o.source_type = 'product' 
                                  AND o.source_id = _product_id
          WHERE to_id = _uom_id
            AND from_id = o.uomid
            AND method = 'ratio';  
        
          IF _ratio IS NULL OR _ratio = 0
          THEN
            SET _response = "There is no valid conversion between the unit of measure used in traveler and the unit of measure used in order. Please add conversion between the two UoMs.";
          ELSE
            SET _ratio = 1.00/_ratio;
          END IF;
        END IF;
      END IF;      
      IF _ratio IS NOT NULL AND NOT EXISTS (SELECT * FROM order_detail o
                    WHERE o.order_id = _order_id
                      AND o.source_type = 'product'
                      AND o.source_id = _product_id
                      AND o.quantity_requested >= (quantity_in_process + _lot_size*_ratio*_num_lots+quantity_made+quantity_shipped))
      THEN
        SET _response = "You are dispatching more product than requested. Please adjust lot size.";
      END IF;
      
      CREATE TEMPORARY TABLE IF NOT EXISTS multilots (lot_id int(10) unsigned, lot_alias varchar(20));
      
      START TRANSACTION;
      WLOOP: WHILE _num_lots >0 DO
        SET _num_lots = _num_lots - 1;
        
        -- IF _alias_suffix = 3 THEN
        IF _alias_suffix = 4294967295 THEN
          ROLLBACK;
          SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
          LEAVE WLOOP;
          
        END IF;
        
        SET _alias_suffix = _alias_suffix + 1;
        SET _alias = CONCAT(_alias_prefix, _alias_suffix);
        
        ALOOP: WHILE EXISTS (SELECT * FROM lot_status WHERE alias=_alias)
        DO
           -- IF _alias_suffix = 3 THEN 
          IF _alias_suffix = 4294967295 THEN
          
            ROLLBACK;
            SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
            LEAVE ALOOP;
          END IF;
        
          SET _alias_suffix = _alias_suffix + 1;
          SET _alias = CONCAT(_alias_prefix, _alias_suffix);    
          
        END WHILE;
        
        IF _response IS NULL OR length(_response) = 0
        THEN
          INSERT INTO lot_status(
            alias,
            order_id,
            product_id,
            process_id,
            status,
            start_quantity,
            actual_quantity,
            uomid,
            update_timecode,
            contact,
            priority,
            dispatcher,
            dispatch_time,
            comment
            )
            VALUES
            (
              _alias,
              _order_id,
              _product_id,
              _process_id,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _lot_contact,
              _lot_priority,
              _dispatcher,
              _dispatch_time,
              _comment  
            );
          SET _new_id = last_insert_id();
            
          IF _new_id IS NOT NULL
          THEN
            INSERT INTO lot_history (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
              comment
              )
            VALUES (
              _new_id,
              _alias,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _process_id,
              0,
              0,
              _dispatcher,
              _dispatcher,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              _comment
              );
  
            INSERT INTO multilots (lot_id, lot_alias)
            VALUES (_new_id, _alias);
            
            SET _total_quantity = _total_quantity + _lot_size;
          ELSE
            ROLLBACK;
            SET _response = "Error countered when dispatching lot.";
            LEAVE WLOOP;
          END IF;
        ELSE
          LEAVE WLOOP;
        END IF;
 
        
        
      END WHILE;
      
      IF _response IS NULL OR length(_response) = 0
      THEN
        UPDATE `order_detail`
           SET quantity_in_process = ifnull(quantity_in_process, 0) +  _total_quantity*_ratio
         WHERE order_id=_order_id;
        COMMIT;
      
      END IF;
      
      SELECT lot_id, lot_alias
        FROM multilots;
        
      DROP TABLE multilots;
      
    END IF;
   
   
  END IF;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `dispatch_single_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `dispatch_single_lot`(
  IN _order_id int(10) unsigned, 
  IN _product_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _alias_prefix varchar(10), 
  IN _lot_contact int(10) unsigned,
  IN _lot_priority tinyint(2) unsigned,
  IN _comment text,
  IN _dispatcher int(10) unsigned,
  OUT _lot_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
 
  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(20);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
 

 
  -- SET AUTOCOMMIT = 0;
  
  IF _order_id IS NULL
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id)
  THEN
    SET _response = "The order you selected doesn't exist in database.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'Process is required. Please select a process to dispatch lots to';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
  THEN
    SET _response = "The process you selected doesn't exist in database.";
  ELSEIF _dispatcher IS NULL
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher)
  THEN
    SET _response = "Dispatcher information doesn't exist in our database.";
  ELSEIF _product_id IS NULL
  THEN
      SET _response = 'The order you selected does not exist in database.';
  ELSEIF NOT EXISTS
  (   SELECT *
        FROM product_process
      WHERE process_id = _process_id
        AND product_id = _product_id
   )  
  THEN
        SET _response = 'The process you selected can not be used to manufacture the ordered product.';
  ELSE
    IF _lot_size IS NULL
    THEN
      SELECT lot_size into _lot_size
        FROM product
       WHERE id = _product_id;
    ELSEIF _lot_size > (SELECT lot_size FROM product WHERE id = _product_id)
    THEN
      SET _response ="The lot size you selected is bigger than the maximum lot size limit for the product. Please adjust your lot size.";
    END IF;
  
    
    IF _lot_priority IS NULL
    THEN
      SELECT priority INTO _lot_priority
        FROM `order_general`
       WHERE id = _order_id;
    END IF;
        
    IF _lot_size IS NULL
    THEN
      SET _response = 'Lot size information can not be found. Please enter the size for a single lot.';
    ELSE
          
--       SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
--                             between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
--                             and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
--                         substring(addtime(timezone, '01:00'), 1, 6),
--                         timezone)  
--               FROM company c, employee e
--               WHERE e.id = _dispatcher AND c.id = e.company_id); 
              
      SET _dispatch_time = utc_timestamp();
      
      SET _alias_suffix = 0;
      
        
      IF _alias_prefix IS NULL
      THEN
        SET _alias_prefix = '';
      END IF;

        
      SET _alias_suffix = _alias_suffix + 1;
      SET _alias = CONCAT(_alias_prefix, _alias_suffix);
      
      SELECT uomid INTO _uom_id
        FROM product
    WHERE id = _product_id;

    SET _ratio = null;
    IF EXISTS (SELECT * 
                  FROM order_detail
                  WHERE order_id = _order_id
                    AND source_type = 'product'
                    AND source_id = _product_id
                    AND uomid = _uom_id
                )
    THEN
      SET _ratio = 1;
    ELSE
      SELECT constant INTO _ratio
        FROM uom_conversion u 
        JOIN order_detail o ON o.order_id = _order_id 
          AND o.source_type = 'product' 
          AND o.source_id = _product_id
        WHERE from_id = _uom_id
          AND to_id = o.uomid
          AND method = 'ratio';
          
      IF _ratio IS NULL
      THEN
        SELECT constant INTO _ratio
          FROM uom_conversion u 
          JOIN order_detail o ON o.order_id = _order_id 
                                  AND o.source_type = 'product' 
                                  AND o.source_id = _product_id
         WHERE to_id = _uom_id
           AND from_id = o.uomid
           AND method = 'ratio';  
          
        IF _ratio IS NULL OR _ratio = 0
        THEN
          SET _response = "There is no valid conversion between the unit of measure used in traveler and the unit of measure used in order. Please add conversion between the two Uoms";
        ELSE  
          SET _ratio = 1.00/_ratio;
        END IF;
      END IF;
    END IF;

    IF _ratio IS NOT NULL AND NOT EXISTS (SELECT * FROM order_detail o
                    WHERE o.order_id = _order_id
                      AND o.source_type = 'product'
                      AND o.source_id = _product_id
                      AND o.quantity_requested >= (quantity_in_process + _lot_size*_ratio+quantity_made+quantity_shipped))
    THEN
      SET _response = "You are dispatching more product than requested. Please adjust lot size.";
    END IF;
    ALOOP: WHILE EXISTS (SELECT * FROM lot_status WHERE alias=_alias)
    DO
      IF _alias_suffix = 4294967295 THEN
        SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
         
        LEAVE ALOOP;
      END IF;
      

      SET _alias_suffix = _alias_suffix + 1;
      SET _alias = CONCAT(_alias_prefix, _alias_suffix);
         
    END WHILE ALOOP;
       
    IF _response IS NULL OR length(_response) = 0
    THEN
    SET _response = _alias;  
      START TRANSACTION;
      INSERT INTO lot_status(
          alias,
          order_id,
          product_id,
          process_id,
          status,
          start_quantity,
          actual_quantity,
          uomid,
          update_timecode,
          contact,
          priority,
          dispatcher,
          dispatch_time,
          comment
          )
      VALUES
          (
            _alias,
            _order_id,
            _product_id,
            _process_id,
            'dispatched',
            _lot_size,
            _lot_size,
            _uom_id,
            DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
            _lot_contact,
            _lot_priority,
            _dispatcher,
            _dispatch_time,
            _comment  
        );
      SET _lot_id = last_insert_id();
              
      IF _lot_id IS NOT NULL THEN
         
        INSERT INTO lot_history (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
              comment
              )
        VALUES (
              _lot_id,
              _alias,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _process_id,
              0,
              0,
              _dispatcher,
              _dispatcher,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              _comment
        );       
            

          
  
        UPDATE `order_detail`
           SET quantity_in_process = ifnull(quantity_in_process, 0) +  _lot_size*_ratio
         WHERE order_id=_order_id;
            
        COMMIT;
         
      ELSE
          -- COMMIT;
        ROLLBACK;
        SET _response = "Error encountered when dispatching.";
      END IF;
    END IF;
  END IF;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_lot_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `end_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _start_timecode char(15),
  IN _operator_id int(10) unsigned,
  IN _end_quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _result_comment text,  -- for long text result or comment
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _autostart_timecode char(15),  
  OUT _response varchar(255)
)
BEGIN
-- doesn't check employee access to the step. End form will check employee access though.
  DECLARE _process_id_p int(10) unsigned;
  DECLARE _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _result text;
  DECLARE _end_timecode char(15);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The batch you supplied does not exist in database";
    ELSE
      -- check position information
      SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid
        INTO _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p, _step_id_p, _uomid
        FROM lot_history
       WHERE lot_id = _lot_id
         AND start_timecode = _start_timecode
         AND status IN ('started', 'restarted') 
         AND end_timecode IS NULL
         ;
      
      IF _process_id_p IS NULL 
      THEN
        SET _response = "The batch is currently not in a workflow step.";
      ELSE
        IF _process_id IS NOT NULL AND _process_id != _process_id_p
        THEN
          SET _response = "The batch is in a different workflow than you supplied.";
        ELSEIF _position_id IS NOT NULL AND _position_id!= _position_id_p
        THEN
          SET _response = concat("The batch is at a different position " , _position_id_p , " than you supplied.");
        ELSEIF _step_id IS NOT NULL AND _step_id != _step_id_p
        THEN
          SET _response = "The batch is at a different step than you supplied.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id_p IS NULL
        THEN
          SET _response = "The batch is not in a sub workflow as you indicated.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id != _sub_process_id_p 
        THEN
          SET _response = "The batch is in a different sub workflow than you supplied.";
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id IS NULL
        THEN
          SET _response = concat("The batch is not in the position " , _sub_position_id , " in sub workflow as you indicated.");
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id!=_sub_position_id_p
        THEN
          SET _response = "The batch is at a different position in sub workflow than you indicated.";
        ELSE
          SET _process_id = _process_id_p;
          SET _position_id = _position_id_p;
          SET _step_id = _step_id_p;
          
          IF _sub_process_id_p IS NOT NULL
          THEN
            SET _sub_process_id = _sub_process_id_p;
          END IF;
          
          IF _sub_position_id_p IS NOT NULL
          THEN
            SET _sub_position_id = _sub_position_id_p;
          END IF;
          
          -- check approver information
          IF _sub_process_id IS NULL
          THEN
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
           ;
          ELSE
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _sub_process_id
               AND position_id = _sub_position_id
               AND step_id = _step_id
             ;
          END IF;
          
          CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
          
          IF _response IS NULL OR length(_response)=0
          THEN
            -- get step type
            SELECT st.name
              INTO _step_type
              FROM step s, step_type st
            WHERE s.id =_step_id
              AND st.id =s.step_type_id;
  
            SET _end_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            IF _step_type in ('consume material', 'condition', 'hold lot')
            THEN
              SET _step_status = 'ended';
              UPDATE lot_history
                SET end_timecode = _end_timecode
                  , end_operator_id = _operator_id
                  , status = _step_status
                  , end_quantity = _end_quantity
                  , uomid = _uomid
                  , approver_id = _approver_id
                  , result = _short_result
                  , comment = _result_comment
              WHERE lot_id = _lot_id
                AND start_timecode = _start_timecode
                AND status IN ('started', 'restarted')
                AND end_timecode IS NULL;
            
              IF row_count() > 0 THEN
                SET _lot_status = 'in transit';
                UPDATE lot_status
                  SET status = _lot_status
                      ,actual_quantity = _end_quantity
                      ,update_timecode = _end_timecode
                      ,comment = _result_comment
                WHERE id=_lot_id;
               
                SET _process_id_p = null;
                SET _sub_process_id_n = null;
                SET _position_id_n = null;
                SET _sub_position_id_n = null;
                SET _step_id_n = null;
                
                CALL `start_lot_step`(
                  _lot_id,
                  _lot_alias,
                  _operator_id,
                  1,
                  _end_quantity,
                  null,
                  null,
                  'Step started automatically',
                  _process_id_p,
                  _sub_process_id_n,
                  _position_id_n,
                  _sub_position_id_n,
                  _step_id_n,
                  _lot_status_n,
                  _step_status_n,
                  _autostart_timecode,
                  _response
                );
                IF _autostart_timecode IS NOT NULL
                THEN
                  SET _process_id = _process_id_p;
                  SET _sub_process_id = _sub_process_id_n;
                  SET _position_id = _position_id_n;
                  SET _sub_position_id = _sub_position_id_n;
                  SET _step_id = _step_id_n;
                  SET _lot_status = _lot_status_n;
                  SET _step_status = _step_status_n;
                END IF;

              ELSE
                SET _response = "Error encountered when update batch history information.";
              END IF;             
            END IF;

          END IF;
          
 
        END IF;
      END IF;
    END IF;
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_lot_info_for_start_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_lot_info_for_start_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  IN _process_id int(10) unsigned,
  IN _sub_process_id_p int(10) unsigned,
  IN _position_id_p int(5) unsigned,
  IN _sub_position_id_p int(5) unsigned,
  IN _step_id_p int(10) unsigned,
  IN _result char(1),
  OUT _sub_process_id_n int(10) unsigned,
  OUT _position_id_n int(5) unsigned,
  OUT _sub_position_id_n int(5) unsigned,
  OUT _step_id_n int(10) unsigned,
  OUT _step_type varchar(20),
  OUT _rework_limit smallint(2) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSE
 
    SET _result =substring(ifnull(_result, 'T'), 1, 1);
          
    IF _lot_status IN ('dispatched', 'in transit')
    THEN      
      IF _sub_process_id_p IS NOT NULL AND _response IS NULL THEN  
      -- the lot was in a sub process
        SELECT if(_result = "F" AND st.name='condition', ps.false_step_pos, ps.next_step_pos)
          INTO _sub_position_id_n        
          FROM process_step ps, step s, step_type st
        WHERE ps.process_id=_sub_process_id_p
          AND ps.position_id = _sub_position_id_p
          AND ps.step_id = s.id
          AND st.id = s.step_type_id;
  
        IF _sub_position_id_n IS NULL THEN  -- the lot just finished the sub process it was in
          
          SELECT if(_result="F" AND st.name='condition', ps0.false_step_pos,ps0.next_step_pos )
            INTO _position_id_n
            FROM process_step ps0, step s, step_type st
          WHERE ps0.process_id = _process_id
            AND ps0.position_id = _position_id_p
            AND ps0.step_id = s.id
            AND st.id = s.step_type_id;
              
          SELECT step_id,
                if_sub_process,
                rework_limit
            INTO _step_id_n, _if_sub_process, _rework_limit
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n;
              
          IF _if_sub_process = 1 THEN  
            -- next step is a process, collect information
            
            SET _sub_process_id_n = _step_id_n;
            
            SELECT step_id,
                   position_id,
                   rework_limit
              INTO _step_id_n, _sub_position_id_n, _rework_limit
              FROM process_step
            WHERE process_id = _sub_process_id_n
              AND position_id = (SELECT min(position_id) 
                                   FROM process_step 
                                  WHERE process_id = _sub_process_id_n);
              
          END IF;
        ELSE  -- next step is within the same sub process, collect information
          SET _position_id_n = position_id_p;
          SET _sub_process_id_n = _sub_process_id_p;
          
          SELECT step_id,
                 rework_limit
            INTO _step_id_n, _rework_limit
            FROM process_step
          WHERE process_id=_sub_process_id_n
            AND position_id = _sub_position_id_n;
        END IF;
          
      ELSE
        
        -- the lot was not in a sub process
        IF _position_id_p =0
        THEN
          SELECT min(position_id)
            INTO _position_id_n
            FROM process_step
          WHERE process_id=_process_id;
        ELSE    
          SELECT if(_result = "F" AND st.name = 'condition', ps.false_step_pos,ps.next_step_pos )
            INTO _position_id_n           
            FROM process_step ps, step s, step_type st
          WHERE ps.process_id=_process_id
            AND ps.position_id =_position_id_p
            AND ps.step_id = s.id
            AND st.id = s.step_type_id;   
        END IF;
        -- Select 'position'||ifnull(_position_id_p,_result) ;
        SELECT step_id,
              if_sub_process,
              rework_limit
          INTO _step_id_n, _if_sub_process, _rework_limit
          FROM process_step
        WHERE process_id = _process_id
          AND position_id = _position_id_n; 
            
        IF _if_sub_process = 1 THEN  
        -- next step is a process, collect information
          
          SET _sub_process_id_n = _step_id_n;
          
          SELECT step_id,
                 position_id,
                 rework_limit
            INTO _step_id_n, _sub_position_id_n, _rework_limit
            FROM process_step
          WHERE process_id = _sub_process_id_n
            AND position_id = (SELECT min(position_id)
                                 FROM process_step
                                WHERE process_id = _sub_process_id_n
                               )
          ;
            
        END IF;           
      END IF;
--       SELECT count(*) into _rework_count
--         FROM lot_history
--        WHERE lot_id = _lot_id
--          AND position_id = _position_id_n
--          AND sub_position_id <=>_sub_position_id_n
--          AND process_id = _process_id
--          AND sub_process_id <=> _sub_process_id_n
--          AND status in ('ended', 'started', 'finished');
          
         SELECT st.name INTO _step_type
         FROM step s, step_type st
         WHERE st.id = s.step_type_id;
         
--       SELECT eq_usage, eq_id
--         INTO _eq_usage,_eq_id
--         FROM step
--        WHERE id = _step_id_n;
--       
--       IF _eq_usage IS NOT NULL
--       THEN
--         IF _eq_usage = 'equipment group'
--         THEN
--           SELECT name INTO _eq_name
--             FROM equipment_group
--            WHERE id = _eq_id;
--          
--         ELSEIF _eq_usage = 'equipment'
--         THEN
--           SELECT name INTO _eq_name
--             FROM equipment
--            WHERE id=_eq_id;
--         END IF;
--       END IF;
    END IF;  

          
  END IF;

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_next_step_for_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_next_step_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  IN _process_id int(10) unsigned,
  IN _sub_process_id_p int(10) unsigned,
  IN _position_id_p int(5) unsigned,
  IN _sub_position_id_p int(5) unsigned,
  IN _step_id_p int(10) unsigned,
  IN _result varchar(255),
  OUT _sub_process_id_n int(10) unsigned,
  OUT _position_id_n int(5) unsigned,
  OUT _sub_position_id_n int(5) unsigned,
  OUT _step_id_n int(10) unsigned,
  OUT _step_type varchar(20),
  OUT _rework_limit smallint(2) unsigned,
  OUT _if_autostart tinyint(1) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _step_type_p varchar(20);
  DECLARE _sub_process_id_str VARCHAR(10);
  DECLARE _sub_position_id_str VARCHAR(10);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSE
 
    
          
    IF _lot_status IN ('dispatched', 'in transit')
    THEN      
      
      SELECT st.name
        INTO _step_type_p
        FROM step s, step_type st
       WHERE s.id=_step_id_p
         AND st.id=s.step_type_id;
      
 
      CASE
      WHEN _step_type_p='reposition' THEN
        -- _result has all next step information in the format: sub_process_id_n,position_id_n,sub_position_id_n,step_id_n
        SET _sub_process_id_str=substring_index(_result,',',1);
        SET _sub_process_id_n=if(length(_sub_process_id_str)>0, _sub_process_id_str, null);

        SET _step_id_n=substring_index(_result,',',-1);     
        SET _position_id_n=substring_index(right(_result,length(_result)-length(_sub_process_id_str)-1),',',1);
        
        SET _sub_position_id_str=substring_index(left(_result, length(_result)-length(_step_id_n)-1),',',-1);
        SET _sub_position_id_n=if(length(_sub_position_id_str)>0, _sub_position_id_str, null);
        
        IF _sub_process_id_n IS NOT NULL AND _sub_position_id_n IS NOT NULL
        THEN
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _sub_process_id_n
            AND position_id = _sub_position_id_n
            AND step_id=_step_id_n;    
        ELSE
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n
            AND step_id=_step_id_n; 
        END IF;
      ELSE
        SET _result =substring(ifnull(_result, 'T'), 1, 1);
        IF _sub_process_id_p IS NOT NULL AND _response IS NULL THEN  
        -- the lot was in a sub process
          SELECT if(_result = "F" AND st.name='condition', ps.false_step_pos, ps.next_step_pos)
            INTO _sub_position_id_n        
            FROM process_step ps, step s, step_type st
          WHERE ps.process_id=_sub_process_id_p
            AND ps.position_id = _sub_position_id_p
            AND ps.step_id = s.id
            AND st.id = s.step_type_id;
    
          IF _sub_position_id_n IS NULL THEN  -- the lot just finished the sub process it was in
            
            SELECT if(_result="F" AND st.name='condition', ps0.false_step_pos,ps0.next_step_pos )
              INTO _position_id_n
              FROM process_step ps0, step s, step_type st
            WHERE ps0.process_id = _process_id
              AND ps0.position_id = _position_id_p
              AND ps0.step_id = s.id
              AND st.id = s.step_type_id;
                
            SELECT step_id,
                  if_sub_process,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _if_sub_process, _rework_limit,_if_autostart
              FROM process_step
            WHERE process_id = _process_id
              AND position_id = _position_id_n;
                
            IF _if_sub_process = 1 THEN  
              -- next step is a process, collect information
              
              SET _sub_process_id_n = _step_id_n;
              
              SELECT step_id,
                    position_id,
                    rework_limit,
                    if_autostart
                INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
                FROM process_step
              WHERE process_id = _sub_process_id_n
                AND position_id = (SELECT min(position_id) 
                                    FROM process_step 
                                    WHERE process_id = _sub_process_id_n);
                
            END IF;
          ELSE  -- next step is within the same sub process, collect information
            SET _position_id_n = position_id_p;
            SET _sub_process_id_n = _sub_process_id_p;
            
            SELECT step_id,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _rework_limit, _if_autostart
              FROM process_step
            WHERE process_id=_sub_process_id_n
              AND position_id = _sub_position_id_n;
          END IF;
            
        ELSE
          
          -- the lot was not in a sub process
          IF _position_id_p =0
          THEN
            SELECT min(position_id)
              INTO _position_id_n
              FROM process_step
            WHERE process_id=_process_id;
          ELSE    
            SELECT if(_result = "F" AND st.name = 'condition', ps.false_step_pos,ps.next_step_pos )
              INTO _position_id_n           
              FROM process_step ps, step s, step_type st
            WHERE ps.process_id=_process_id
              AND ps.position_id =_position_id_p
              AND ps.step_id = s.id
              AND st.id = s.step_type_id;   
          END IF;
          -- Select 'position'||ifnull(_position_id_p,_result) ;
          SELECT step_id,
                if_sub_process,
                rework_limit,
                if_autostart
            INTO _step_id_n, _if_sub_process, _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n; 
              
          IF _if_sub_process = 1 THEN  
          -- next step is a process, collect information
            
            SET _sub_process_id_n = _step_id_n;
            
            SELECT step_id,
                  position_id,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
              FROM process_step
            WHERE process_id = _sub_process_id_n
              AND position_id = (SELECT min(position_id)
                                  FROM process_step
                                  WHERE process_id = _sub_process_id_n
                                )
            ;
              
          END IF;           
        END IF;
      END CASE;
          
     SELECT st.name INTO _step_type
     FROM step s, step_type st
     WHERE st.id = s.step_type_id
       AND s.id = _step_id_n;
         

    END IF;  

          
  END IF;

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_rework_count_for_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_rework_count_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  OUT _rework_count smallint(2) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "Please select a process.";
  ELSEIF _position_id IS NULL
  THEN
    SET _response = "Please supply a position.";
  ELSE
 

    SELECT count(*) into _rework_count
      FROM lot_history
     WHERE lot_id = _lot_id
       AND process_id = _process_id
       AND sub_process_id <=> _sub_process_id
       AND step_id = _step_id
       AND status in ('ended', 'started', 'finished')
       AND position_id = _position_id
       AND sub_position_id <=>_sub_position_id
;
          
  END IF;

 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_inventory`(
  IN _recorded_by int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _pd_or_mt_id int(10) unsigned,
  IN _supplier_id int(10) unsigned, -- currently not used, use 0
  IN _lot_id varchar(20),
  IN _serial_no varchar(20),
  IN _out_order_id varchar(20),
  IN _in_order_id varchar(20),
  IN _original_quantity decimal(16,4) unsigned,
  IN _actual_quantity decimal(16,4) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _manufacture_date datetime,
  IN _expiration_date datetime,
  IN _arrive_date datetime,

  IN _contact_employee int(10) unsigned,
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE ifexist varchar(255);
  DECLARE wording varchar(20);
  
  IF _source_type IS NULL OR length(_source_type )< 1
  THEN
    SET _response='Source type is required. Please select an source type.';
  ELSEIF  _pd_or_mt_id IS NULL
  THEN 
    SET _response='No resource selected. Please select a resource.';
  ELSEIF  _supplier_id IS NULL
  THEN 
    SET _response='Supplier is required. Please select a supplier.';
  ELSEIF  _lot_id IS NULL
  THEN 
    SET _response='Supplier lot number is required. Please fill in the lot number.';
  ELSEIF  _original_quantity IS NULL OR _original_quantity = 0
  THEN 
    SET _response='Original Quanity is required and can not be zero. Please fill in original quantity.';
  ELSEIF  _actual_quantity IS NULL
  THEN 
    SET _response='Actual Quanity is required. Please fill in actual quantity.';   
  ELSEIF  _uom_id IS NULL
  THEN 
    SET _response='Unit of Measure is required. Please select a unit of measure.';   
  ELSEIF  _manufacture_date IS NULL
  THEN 
    SET _response='Manufacture Date is required. Please fill in a manufacture date.'; 
  ELSEIF  _arrive_date IS NULL
  THEN 
    SET _response='Arrive Date is required. Please fill in an arrive date.';
  ELSEIF  _recorded_by IS NULL
  THEN 
    SET _response='Recorder information is missing.';   
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_recorded_by)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';  
  ELSEIF _contact_employee IS NOT NULL AND NOT EXISTS (SELECT * FROM employee WHERE id=_contact_employee)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';    
  ELSE
  

      
      IF _source_type = 'product' THEN
        IF NOT EXISTS (SELECT * FROM product WHERE id=_pd_or_mt_id)
        THEN 
          SET _response = 'The product you selected does not exist in database. Please first record the product information.';
        END IF;
        
      ELSEIF _source_type = 'material' THEN
        IF NOT EXISTS (SELECT * FROM material WHERE id=_pd_or_mt_id)
        THEN
          SET _response = 'The material you selected is not in our material list. Please first record the material information.';
        ELSE
          SELECT supplier_id into _supplier_id
            FROM material_supplier
           WHERE material_id=_pd_or_mt_id
           ORDER BY preference 
           LIMIT 1;
        END IF;
      ELSE
        SET _response = 'The source type you selected is invalid. Please select a valid source type.';
      END IF;
    
      IF _serial_no IS NULL AND EXISTS (SELECT * 
                                          FROM inventory 
                                         WHERE source_type = _source_type 
                                           AND pd_or_mt_id = _pd_or_mt_id
                                           AND supplier_id = _supplier_id
                                           AND lot_id = _lot_id
                                          )
      THEN
        SET _response = concat('The lot ', _lot_id , ' already exists in inventory.');
      ELSEIF EXISTS (SELECT * FROM inventory
                      WHERE source_type = _source_type 
                        AND pd_or_mt_id = _pd_or_mt_id
                        AND supplier_id = _supplier_id
                        AND lot_id = _lot_id
                        AND serial_no = _serial_no
                     )
      THEN
        SET _response = concat('The lot ', _lot_id , ' with serial number ', _serail_no, ' already exists in inventory.');
      END IF;
      
      IF _response IS NULL THEN

        INSERT INTO `inventory` (
          source_type,
          pd_or_mt_id,
          supplier_id,
          lot_id,
          serial_no,
          out_order_id,
          in_order_id,
          original_quantity,
          actual_quantity,
          uom_id,
          manufacture_date,
          expiration_date,
          arrive_date,
          recorded_by,
          contact_employee,
          comment 
        )
        values (
              _source_type,
              _pd_or_mt_id,
              _supplier_id,
              _lot_id,
              _serial_no,
              _out_order_id,
              _in_order_id,
              _original_quantity,
              _actual_quantity,
              _uom_id,
              _manufacture_date,
              _expiration_date,
              _arrive_date,
              _recorded_by,
              _contact_employee,
              _comment  
            );
        SET _inventory_id = last_insert_id();

      END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_order_general` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_order_general`(
  IN _order_type enum('inventory', 'customer', 'supplier'),
  IN _ponumber varchar(40),
  IN _client_id int(10) unsigned,
  IN _priority tinyint(2) unsigned,
  IN _state varchar(10),
  IN _state_date datetime,
  IN _net_total decimal(16,2) unsigned,
  IN _tax_percentage tinyint(2) unsigned,
  IN _tax_amount decimal(14,2) unsigned,
  IN _other_fees decimal(16,2) unsigned,
  IN _total_price decimal(16,2) unsigned,
  IN _expected_deliver_date datetime,
  IN _internal_contact int(10) unsigned,
  IN _external_contact varchar(255),
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _order_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  IF _order_type IS NULL OR length(_order_type )< 1
  THEN
    SET _response='Order type is required. Please select an order type.';
  ELSEIF  _state_date is NULL OR length(_state_date) < 1
  THEN 
    SET _response='Date when the state happened is required. Please fill the state date.';
  ELSEIF  _internal_contact is NULL OR length(_internal_contact) < 1
  THEN 
    SET _response='The internal contact is required. Please fill the contact info.';
  ELSEIF  _internal_contact is NULL OR length(_internal_contact) < 1
  THEN 
    SET _response='The internal contact is required. Please fill the contact info.';
  ELSEIF _state IS NULL OR _state NOT IN ('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid')
  THEN
    SET _response='The value for state is not valid. Please select one state from following: quoted, POed, scheduled, produced, shipped, delivered, invoiced, paid.';
  ELSE
  
    INSERT INTO `order_general` (
         order_type,
         ponumber,
         client_id,
         priority,
         state,
         net_total,
         tax_percentage,
         tax_amount,
         other_fees,
         total_price,
         expected_deliver_date,
         internal_contact,
         external_contact,
         comment)
    values (
          _order_type,
          _ponumber,
          _client_id,
          _priority,
          _state,
          _net_total,
          _tax_percentage,
          _tax_amount,
          _other_fees,
          _total_price,
          _expected_deliver_date,
          _internal_contact,
          _external_contact,
          _comment
         );
        SET _order_id = last_insert_id();
        IF _order_id IS NOT NULL
        THEN
          INSERT INTO order_state_history
          (order_id,
          state,
          state_date,
          recorder_id,
          comment
          )
          VALUES
          (
            _order_id,
            _state,
            _state_date,
            _recorder_id,
            _comment
          );
        END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_process`(
  IN _prg_id int(10) unsigned,
  IN _name varchar(255),
  IN _version  int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),
  IN _owner_id int(10) unsigned,
  IN _if_default_version tinyint(1),
  IN _employee_id int(10) unsigned,
  IN _usage enum('sub process only','main process only','both'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255),
  OUT _process_id int(10) unsigned
)
BEGIN
  DECLARE ifexist varchar(255);

  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Process name is required. Please give the process a name.';
    
  ELSEIF _owner_id IS NULL or _owner_id<0
  THEN
    SET _response = 'Process owner is required. Please give the process an owner.';    
   
  ELSEIF _usage IS NULL or length(_usage)<1
  THEN
    SET _response = 'Process usage is required.  Please select process usage.';
    
  ELSE

      SELECT NAME INTO ifexist 
      FROM process 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO process (
          prg_id, 
          name, 
          `version`, 
          state,
          owner_id,
          if_default_version,
          create_time, 
          created_by,  
          `usage`,
          description, 
          comment)
        VALUES (
          _prg_id,
          _name,
          _version,
          _state,
          _owner_id,
          _if_default_version,
          now(),
          _employee_id,
          _usage,
          _description,
          _comment
        );
        SET _process_id = last_insert_id();
        INSERT INTO config_history (
          event_time,
          source_table,
          source_id,
          old_state,
          new_state,
          employee,
          comment,
          new_record
        )
        SELECT create_time,
              'process',
              id,
              null,
              state,
              created_by,
              concat('process', name , 'is created'),
              concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
              '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
                '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
                '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><USAGE>', `usage`, 
                '</USAGE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PROCESS>')
        FROM process
        WHERE id=_process_id;
        SET _response = '';
      ELSE
        SET _response= concat('The process name ' , _name ,' is already used by another process. Please change the process name and try again.');
      END IF;
 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_uom_conversion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_uom_conversion`(
  IN _from_id smallint(3) unsigned,
  IN _to_id smallint(3) unsigned,
  IN _method enum('ratio', 'reduction', 'addtion'),
  IN _constant decimal(16,4) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN


  
  IF _from_id IS NULL
  THEN
    SET _response='From UoM is required. Please select a From UoM.';
    
  ELSEIF _to_id IS NULL
  THEN
    SET _response = 'To UoM is required. Please select a To UoM.';    
  ELSEIF _method IS NULL
  THEN
    SET _response = 'Converting Method is required. Please select a method.';
  ELSEIF _constant IS NULL 
  THEN
    SET _response = 'Conversion costant is required. Please provide a constant.';
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_from_id)
  THEN
    SET _response = 'The From Uom does not exist in database.';    
    
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_to_id)
  THEN
    SET _response = 'The To Uom does not exist in database.';  
  ELSEIF EXISTS (SELECT * FROM uom_conversion WHERE from_id = _from_id AND to_id=_to_id)
  THEN
    SET _response = 'The conversion between the selected UoMs already exists in database.';     
  ELSE

  INSERT INTO uom_conversion
  (from_id, to_id, method,constant, comment)
  VALUES (_from_id, _to_id, _method, _constant, _comment);
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `issue_feedback` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `issue_feedback`(
  IN _employee_id int(10) unsigned,
  INOUT _feedback_id int(10) unsigned,
  IN _subject varchar(255),
  IN _contact_info varchar(255),
  IN _note text,
  OUT _response varchar(255)
)
BEGIN

  
  IF _employee_id IS NULL OR NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN
    SET _response='The employee who is issuing this feedback does not exist in database.'; 
  ELSE
        
    IF _feedback_id IS NULL
    THEN
      INSERT INTO feedback 
      (
        `create_time`,
        `noter_id` ,
        `contact_info` ,
        `state` ,
        `subject` ,
        `note` 
      )
      VALUES (
        now(),
        _employee_id,
        _contact_info,
        'issued',
        _subject,
        _note
      );
      SET _feedback_id = last_insert_id();
    
    ELSE
      UPDATE feedback
         SET contact_info = _contact_info,
             last_noter_id = _employee_id,
             last_note_time = now(),
             subject=_subject,
             note=_note
       WHERE id = _feedback_id;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_client` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_client`(
INOUT _client_id int(10) unsigned,
IN _name varchar(40),
IN _type enum('supplier', 'customer', 'both'),
IN _internal_contact_id int(10) unsigned,
IN _company_phone varchar(20),
IN _address varchar(255),
IN _city varchar(20),
IN _state varchar(20),
IN _zip varchar(10),
IN _country varchar(20),
IN _address2 varchar(255),
IN _city2 varchar(20),
IN _state2 varchar(20),
IN _zip2 varchar(10),
IN _contact_person1 varchar(20),
IN _contact_person2 varchar(20),
IN _person1_workphone varchar(20),
IN _person1_cellphone varchar(20),
IN _person1_email varchar(40),
IN _person2_workphone varchar(20),
IN _person2_cellphone varchar(20),
IN _person2_email varchar(20),
IN _ifactive tinyint(1) unsigned,
IN _comment text,
OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);

  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Client name is required. Please input the client name.';
  ELSEIF _type IS NULL OR length(_type)<1
  THEN
    SET _response='Client type is required. Please input the client type.';  
  ELSEIF _internal_contact_id IS NULL 
  THEN
    SET _response = 'Internal contact person is required. Please select an employee as internal contact person.';
    
  ELSEIF _contact_person1 IS NULL OR length(_contact_person1)<1
  THEN
    SET _response='Contact person name from client company is required. Please fill in the name of the person.'; 
    
  ELSEIF _person1_email IS NULL OR length(_person1_email)<1
  THEN
    SET _response='Email address of the first contact person from client company is required. Please fill in the email address.';    
    
  ELSEIF _client_id IS NULL
  THEN
    
    IF EXISTS (SELECT * FROM client WHERE name=_name)
    THEN
      SET _response = concat('The client ', _name , 'already exists in database.');    
    ELSE
      INSERT INTO client (
        name,
        type,
        internal_contact_id,
        company_phone,
        address,
        city,
        state,
        zip,
        country,
        address2,
        city2,
        state2,
        zip2,
        contact_person1,
        contact_person2,
        person1_workphone,
        person1_cellphone,
        person1_email,
        person2_workphone,
        person2_cellphone,
        person2_email,
        firstlistdate,
        ifactive,
        comment
      )
      VALUES (
        _name,
        _type,
        _internal_contact_id,
        _company_phone,
        _address,
        _city ,
        _state,
        _zip,
        _country,
        _address2,
        _city2,
        _state2,
        _zip2,
        _contact_person1,
        _contact_person2,
        _person1_workphone,
        _person1_cellphone,
        _person1_email,
        _person2_workphone,
        _person2_cellphone,
        _person2_email,
        now(),
        _ifactive,
        _comment
      );
      SET _client_id = last_insert_id();
    END IF;

  ELSE
    
    IF EXISTS (SELECT * FROM client WHERE id!= _client_id AND name=_name)
    THEN
      SET _response = concat('The client ',_name , ' already exists in database.');    
    ELSE
      UPDATE client
        SET name = _name,
            type = _type,
              internal_contact_id = _internal_contact_id,
              company_phone = _company_phone,
              address = _address,
              city = _city,
              state = _state,
              zip = _zip,
              country = _country,
              address2 = _address2,
              city2 = _city2,
              state2 = _state2,
              zip2 = _zip2,
              contact_person1 = _contact_person1,
              contact_person2 = _contact_person2,
              person1_workphone = _person1_workphone,
              person1_cellphone = _person1_cellphone,
              person1_email = _person1_email,
              person2_workphone = _person2_workphone,
              person2_cellphone = _person2_cellphone,
              person2_email = _person2_email,
              updateddate = now(),
              ifactive = _ifactive,
              comment = _comment
      WHERE id = _client_id;

    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_client_document` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_client_document`(
  IN _operation char(6), -- 'insert' or 'update'
  IN _id int(10) unsigned,
  IN _client_id int(10) unsigned,
  IN _recorder_id int(10) unsigned,  
  IN _key_words varchar(255),
  IN _title varchar(255),
  IN _path varchar(255),
  IN _version varchar(10),
  IN _contact int(10) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  IF _title IS NULL or length(_title)<1
  THEN
    SET _response = 'Document title is missing. Please fill in the title.';
  ELSEIF _path IS NULL or length(_path)<1
  THEN
    SET _response = 'Document path is missing. Please fill in the path.';
  ELSEIF _recorder_id IS NULL or NOT EXISTS (SELECT * FROM employee WHERE id<=>_recorder_id)
  THEN
    SET _response = 'Sorry, you are not an active employee and can not record this document.';
  ELSEIF _contact IS NULL or NOT EXISTS (SELECT * FROM employee WHERE id<=>_contact)
  THEN
    SET _response = 'The contact person selected is not an active employee.';
  ELSE
    IF _operation = 'insert'
    THEN
      IF EXISTS (SELECT * FROM document WHERE source_table = 'client' AND source_id=_client_id AND title = _title)
      THEN
        SET _response = 'Sorry, the document with the same title already exists in our database. Please change the title and retry.';
      ELSE
        INSERT INTO document
        (
          source_table,
          source_id,
          key_words,
          title,
          path,
          `version`,
          recorder_id,
          contact_id,
          record_time,
          description,
          comment
      
        )
        VALUES (
          'client',
          _client_id,
          _key_words,
          _title,
          _path,
          _version,
          _recorder_id,
          _contact,
          now(),
          _description,
          _comment
          );
      END IF;
    ELSEIF _operation = 'update'
    THEN
      IF _id IS NULL 
      THEN
        SET _response = 'There is no record selected for update. Please select a record to update.';
      ELSEIF  EXISTS (SELECT * FROM document WHERE id!=_id AND source_table = 'client' AND source_id=_client_id AND title = _title)
      THEN
        SET _response = 'Sorry, the document with the same title already exists in our database. Please change the title and retry.';
      ELSE
        UPDATE document
           SET key_words = _key_words,
               title = _title,
               path = _path,
               `version` = _version,
               contact_id = _contact,
               updated_by = _recorder_id,
               update_time = now(),
               description = _description,
               comment = _comment
        WHERE id = _id;
      END IF;
    END IF;  
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_employee`(
  INOUT _id int(10) unsigned,
  IN _username varchar(20),
  IN _password varchar(20),
  IN _status enum('active','inactive','removed'),
  IN _or_id int(10) unsigned,
  IN _eg_id int(10) unsigned,
  IN _firstname varchar(20),
  IN _lastname varchar(20),
  IN _middlename varchar(20),
  IN _email varchar(45),
  IN _phone varchar(45),
  IN _role_id int(10) unsigned,
  IN _report_to int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  IF  _id IS NULL AND (_username is NULL OR length(_username) < 1)
  THEN 
    SET _response='User name is required. Please fill the username.';
  ELSEIF _id IS NULL AND ( _password is NULL OR length(_password) < 1)
  THEN 
    SET _response='Password is required. Please fill the password.';
  ELSEIF  _status is NULL OR length(_status) < 1
  THEN 
    SET _response='Status is required. Please fill the Status.';
  ELSEIF  _or_id is NULL OR length(_or_id) < 1
  THEN 
    SET _response='Organization is required. Please fill the Organization.';
  ELSEIF  _firstname is NULL OR length(_firstname) < 1
  THEN 
    SET _response='First Name is required. Please fill the first name.';
  ELSEIF  _lastname is NULL OR length(_lastname) < 1
  THEN 
    SET _response='Last name is required. Please fill the last name.';
  ELSEIF  _role_id IS NULL OR NOT EXISTS (SELECT * FROM system_roles WHERE id=_role_id)
  THEN 
    SET _response='Role is required. Please select a role.';   
  ELSEIF _id is NULL 
  THEN
    INSERT INTO `employee` (
         id, company_id, username, password,
         status, or_id, eg_id, firstname,
         lastname, middlename, email,
         phone, report_to, comment)
    values (
          _id, 1, _username, _password,
         _status, _or_id, _eg_id, _firstname,
         _lastname, _middlename, _email,
         _phone, _report_to, _comment
         );
    SET _id = last_insert_id();
    INSERT INTO users_in_roles (
      userId,
      roleId
    )
    values (_id, _role_id);
    
  ELSE
    UPDATE `employee` 
      SET 
      status = _status, 
      or_id = _or_id, 
      eg_id = _eg_id, 
      firstname = _firstname,
      lastname = _lastname, 
      middlename = _middlename, 
      email = _email,
      phone = _phone, 
      report_to = _report_to, 
      comment = _comment
    WHERE id = _id;
    
    UPDATE users_in_roles 
       SET roleId = _role_id
     WHERE userId = _id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_equipment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_equipment`(
  IN _employee_id int(10) unsigned,
  INOUT _equipment_id int(10) unsigned, 
  IN _eg_id int(10) unsigned,
  IN _location_id int(10) unsigned,
  IN _name varchar(255),
  IN _state enum('inactive','up','down','qual','checkout','checkin'),
  IN _contact_employee int(10) unsigned,
  IN _manufacture_date date,
  IN _manufacturer varchar(255),
  IN _manufacturer_phone varchar(50),
  IN _online_date date,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','up','down','qual','checkout','checkin');
  DECLARE _newstate  enum('inactive','up','down','qual','checkout','checkin');
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Equipment name is required. Please give the equipment a name.';
  ELSE
    IF _equipment_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM equipment 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO equipment (
        eg_id,
        name,
        state,
        location_id,
        create_time,
        created_by,
        contact_employee,
        manufacture_date,
        manufacturer,
        manufacturer_phone,
        online_date,
        description,
        comment)
        VALUES (
          _eg_id,
          _name,
          _state,
          _location_id,
          now(),
          _employee_id,
          _contact_employee,
          _manufacture_date,
          _manufacturer,
          _manufacturer_phone,
          _online_date,
          _description,
          _comment
        );
        SET _equipment_id = last_insert_id();
        
        INSERT INTO equip_history (
        event_time,
        equip_id,
        old_state,
        new_state,
        employee,
        comment,
        new_record
        )
        SELECT create_time,
              id,
              NULL,
              state,
              created_by,
              concat('equipment ', name, ' is created'),
              concat('<EQUIPMENT><EG_ID>',eg_id,
                      '</EG_ID><NAME>',name,
                      '</NAME><STATE>', state, 
                      '</STATE><LOCATION_ID>',location_id,
                      '</LOCATION_ID><CONTACT_EMPLOYEE>',contact_employee,
                      '</CONTACT_EMPLOYEE><MANUFACTURE_DATE>', manufacture_date,
                      '</MANUFACTURE_DATE><MANUFACTURER>', manufacturer,
                      '</MANUFACTURER><MANUFACTURER_PHONE>', manufacturer_phone,
                      '</MANUFACTURER_PHONE><ONLINE_DATE>', online_date,
                      '</ONLINE_DATE><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>', comment, 
                      '</COMMENT></EQUIPMENT>')
        FROM equipment
        WHERE id=_equipment_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another equipment. Please change the product name and try again.');
      END IF;
    ELSE
    SELECT NAME INTO ifexist 
      FROM equipment 
      WHERE name=_name
        AND id !=_equipment_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM equipment
      WHERE id=_equipment_id;
        
      UPDATE equipment
         SET eg_id = _eg_id,
             name = _name,
             state = _state,
             location_id = _location_id,
             state_change_time = now(),
             state_changed_by = _employee_id,
             contact_employee = _contact_employee,
             manufacture_date = _manufacture_date,
             manufacturer = _manufacturer,
             manufacturer_phone = _manufacturer_phone,
             online_date = _online_date,
             description = _description,
             comment =_comment
      WHERE id = _equipment_id;
      
      INSERT INTO equip_history (
        event_time,
        equip_id,
        old_state,
        new_state,
        employee,
        comment,
        new_record
          )
          SELECT state_change_time,
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('equipment ', name, ' updated'),
                concat('<EQUIPMENT><EG_ID>',eg_id,
                      '</EG_ID><NAME>',name,
                      '</NAME><STATE>', state, 
                      '</STATE><LOCATION_ID>',location_id,
                      '</LOCATION_ID><CONTACT_EMPLOYEE>',contact_employee,
                      '</CONTACT_EMPLOYEE><CREATE_TIME>',create_time,
                      '</CREATE_TIME><CREATED_BY>', created_by,
                      '</CREATED_BY><MANUFACTURE_DATE>', manufacture_date,
                      '</MANUFACTURE_DATE><MANUFACTURER>', manufacturer,
                      '</MANUFACTURER><MANUFACTURER_PHONE>', manufacturer_phone,
                      '</MANUFACTURER_PHONE><ONLINE_DATE>', online_date,
                      '</ONLINE_DATE><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>', comment, 
                      '</COMMENT></EQUIPMENT>')                
          FROM equipment
          WHERE id=_equipment_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another equipment. Please change the equipment name and try again.');
    END IF;
  END IF; 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_ingredient_in_recipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_ingredient_in_recipe`(
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _old_order tinyint(3) unsigned,
  IN _new_order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  -- DECLARE _uom_id smallint(3) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source type is required.';
    
  ELSEIF _quantity IS NULL
  THEN
    SET _response = 'Quantity is required.'; 
    

    
  ELSE
      
      IF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE  
         IF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
         THEN
           SET _response = 'The employee who is adding this ingredient does not exist in database.';
         ELSE
          
          IF NOT EXISTS 
          (SELECT *
             FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND `order`= _old_order
          ) 
          THEN
              SET _response = 'The ingredient you selected does not exist in database.';
          ELSEIF _new_order != _old_order AND EXISTS
           (SELECT *
              FROM ingredients
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND `order` = _new_order
           )
          THEN
            SET _response =concat( 'The ingredient already exists at order ', _new_order);
          ELSE
            UPDATE ingredients
               SET quantity = _quantity,
                   `order` = _new_order,
                   mintime = _mintime,
                   maxtime = _maxtime,
                   comment = _comment
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND ingredient_id = _ingredient_id
               AND `order` = _old_order;


            INSERT INTO ingredients_history
            (
              event_time,
              employee_id,
              action,
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment              
            )
            SELECT
              _eventtime,
              _employee_id,
              'modify',
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment             
            FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND ingredient_id = _ingredient_id
              AND `order` = _new_order;
              
            UPDATE recipe
               SET update_time = _eventtime,
                   updated_by = _employee_id
             WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_material` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_material`(
  INOUT _material_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  IN _name varchar(255),
  IN _alias varchar(255), -- currently take in supplier_id information. x.d. Feb 7, 2011
  IN _mg_id int(10) unsigned,
  IN _material_form enum('solid','liquid','gas'),
  IN _status enum('inactive','production','frozen'),
  IN _alert_quantity decimal(16,4) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Material name is required. Please give the material a name.';
    
  ELSEIF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.';  
  ELSEIF _material_id IS NULL
  THEN

    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id;
    
    IF ifexist IS NULL
    THEN
      INSERT INTO material (
        name,
        mg_id,
        uom_id,
        alert_quantity,
        lot_size,
        material_form,
        status,
        enlist_time,
        enlisted_by,
        description,
        comment
      )
      VALUES (
        _name,
        _mg_id,
        _uom_id,
        _alert_quantity,
        _lot_size,
        _material_form,
        _status,
        now(),
        _employee_id,
        _description,
        _comment
      );
      SET _material_id = last_insert_id();

    ELSE
      SET _response= concat('The material ' , _name , ' already exists in table.');
    END IF;
 ELSE
    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id
      AND id != _material_id;
      
    IF ifexist IS NULL
    THEN
      UPDATE material
         SET name = _name,
             mg_id = _mg_id,
             uom_id = _uom_id,
             alert_quantity = _alert_quantity,
             lot_size = _lot_size,
             material_form =_material_form,
             status = _status,
             update_time = now(),
             updated_by = _employee_id,
             description = _description,
             comment = _comment
       WHERE id = _material_id;
    ELSE
      SET _response = concat('The material name ' , _name , ' is already used by another material in table.');
    END IF;
 END IF;
 IF _response IS NULL AND _material_id IS NOT NULL AND _alias IS NOT NULL
 THEN
  IF NOT EXISTS (SELECT * FROM material_supplier WHERE material_id = _material_id AND supplier_id = _alias)
  THEN
    INSERT INTO material_supplier
    (material_id
    ,supplier_id
    )
    VALUES(_material_id, _alias);
  END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_material_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_material_group`(
  INOUT _group_id int(10) unsigned,
  IN _name varchar(255),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Name of the material group is required. Please give the material group a name.';
    
  ELSEIF _group_id IS NULL
  THEN

    IF EXISTS (SELECT * FROM material_group WHERE name=_name)
    THEN
      SET _response= concat('The material group ' , _name , ' already exists in database.');
    ELSE
    

      INSERT INTO material_group (
        name,
        description,
        comment
      )
      VALUES (
        _name,
        _description,
        _comment
      );
      SET _group_id = last_insert_id();
      SET _response = '';
    END IF;
 ELSE
    IF EXISTS (SELECT * FROM material_group WHERE id!=_group_id AND name=_name)
    THEN
      SET _response= concat('The name ' , _name , ' is already used by another material group in database.');
    ELSE
      UPDATE material_group
         SET name = _name,
             description = _description,
             comment = _comment
       WHERE id = _group_id;
    END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_order_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_order_detail`(
  IN _operation enum('insert', 'update'),
  IN _order_id int(10) unsigned,
  IN _order_type enum('inventory', 'customer', 'supplier'),
  IN _source_id int(10) unsigned,
  IN _quantity_requested decimal(16,4) unsigned,
  IN _unit_price decimal(10,2) unsigned,
  IN _quantity_made decimal(16,4) unsigned,
  IN _quantity_in_process decimal(16,4) unsigned,
  IN _quantity_shipped decimal(16,4) unsigned,
  IN _output_date datetime,
  IN _expected_deliver_date datetime,  
  IN _actual_deliver_date datetime,
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _source_type enum('product', 'material');
  DECLARE _uomid smallint(3) unsigned;
  
  IF _operation IS NULL OR length(_operation) < 1
  THEN
    SET _response = 'No operation is defined. Please define an operation.';
  ELSEIF _order_id IS NULL
  THEN
    SET _response = 'You must select an order for adding details. Please select an order.';
  ELSEIF _order_type IS NULL OR length(_order_type) <1
  THEN
    SET _response='Order type is required. Please select an order type.';
  ELSEIF  _source_id is NULL
  THEN 
    SET _response='No item selected for ordering. Please select an item.';
  ELSEIF  _quantity_requested is NULL OR _quantity_requested <= 0
  THEN 
    SET _response='Quantity requested is required. Please fill the quantity requested.';
   
  ELSE
  
    IF _order_type IN ('inventory', 'customer')
    THEN
      SET _source_type = 'product';
      SELECT uomid INTO _uomid
        FROM product
       WHERE id = _source_id;
       
    ELSE
      SET _source_type = 'material';
      SELECT uom_id INTO _uomid
        FROM material
       WHERE id = _source_id;
    END IF;
    
    IF _uomid IS NULL
    THEN
      SET _response = 'THE product or material selected does not exist in database.';
    ELSE
    
      IF _operation = 'insert'
      THEN
        INSERT INTO `order_detail` (
          order_id,
          source_type,
          source_id,
          quantity_requested,
          unit_price,
          quantity_made,
          quantity_in_process,
          quantity_shipped,
          uomid,
          output_date,
          expected_deliver_date,
          actual_deliver_date,
          recorder_id,
          record_time,
          comment   
    )
        values (
          _order_id,
          _source_type,
          _source_id,
          _quantity_requested,
          _unit_price,
          _quantity_made,
          _quantity_in_process,
          _quantity_shipped,
          _uomid,
          _output_date,
          _expected_deliver_date,
          _actual_deliver_date,
          _recorder_id,
          now(),
          _comment
            );
      ELSEIF _operation= 'update'
      THEN
        UPDATE order_detail
          SET quantity_requested = _quantity_requested,
              unit_price = _unit_price,
              quantity_made = _quantity_made,
              quantity_in_process = _quantity_in_process,
              quantity_shipped = _quantity_shipped,
              uomid = _uomid,
              output_date = _output_date,
              expected_deliver_date = _expected_deliver_date,
              actual_deliver_date = _actual_deliver_date,
              recorder_id = _recorder_id,
              record_time = now(),
              comment = _comment
        WHERE order_id = _order_id
          AND source_type = _source_type
          AND source_id = _source_id;
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_order_general` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_order_general`(
  IN _order_id int(10) unsigned,
  IN _ponumber varchar(40),
  IN _priority tinyint(2) unsigned,
  IN _state varchar(10), 
  IN _state_date datetime,
  IN _net_total decimal(16,2) unsigned,
  IN _tax_percentage tinyint(2) unsigned,
  IN _tax_amount decimal(14,2) unsigned,
  IN _other_fees decimal(16,2) unsigned,
  IN _total_price decimal(16,2) unsigned,
  IN _expected_deliver_date datetime,
  IN _internal_contact int(10) unsigned,
  IN _external_contact varchar(255),
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _old_state varchar(10);
  
  IF  _internal_contact is NULL OR length(_internal_contact) < 1
  THEN 
    SET _response='The internal contact is required. Please fill the contact info.';
  ELSE
    SELECT state INTO _old_state
      FROM order_general
     WHERE id = _order_id;
     
    IF _state IS NULL OR length(_state) < 1
    THEN
      SET _state = _old_state;
    ELSEIF _state=_old_state 
           AND _state_date IS NOT NULL 
           AND length(_state_date) > 0
           AND NOT EXISTS (SELECT * 
                         FROM order_state_history 
                        WHERE order_id = _order_id
                          AND state = _old_state
                          AND state_date = _state_date)
           OR _state != _old_state
    THEN
      IF _state IS NULL OR _state NOT IN ('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid')
      THEN
        SET _response='The value for state is not valid. Please select one state from following: quoted, POed, scheduled, produced, shipped, delivered, invoiced, paid.';
      ELSEIF _state_date IS NULL or length(_state_date) < 1
      THEN
        SET _response = 'The date when the state happened is required. Please fill in the state date.';
      ELSE
        INSERT INTO order_state_history
            (order_id,
            state,
            state_date,
            recorder_id,
            comment
            )
            VALUES
            (
              _order_id,
              _state,
              _state_date,
              _recorder_id,
              _comment
            );
      END IF;
    END IF;
    UPDATE `order_general`
       SET ponumber = _ponumber,
           priority = _priority,
           state = _state,
           net_total = _net_total,
           tax_percentage = _tax_percentage,
           tax_amount = _tax_amount,
           other_fees = _other_fees,
           total_price = _total_price,
           expected_deliver_date = _expected_deliver_date,
           internal_contact = _internal_contact,
           external_contact = _external_contact,
           comment = _comment
     WHERE id = _order_id;
     
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_process`(
  IN _process_id int(10) unsigned,
  IN _prg_id int(10) unsigned,
  IN _name varchar(255),
  IN _version  int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),
  IN _owner_id int(10) unsigned,
  IN _if_default_version tinyint(1),
  IN _employee_id int(10) unsigned,
  IN _usage enum('sub process only','main process only','both'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _process_id IS NULL
  THEN
    SET _response='Process id is required. Please suppy process id.';
    
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Process name is required. Please give the process a name.';
    
  ELSEIF _owner_id IS NULL or _owner_id<0
  THEN
    SET _response = 'Process owner is required. Please give the process an owner.';    
   
  ELSEIF _usage IS NULL or length(_usage)<1
  THEN
    SET _response = 'Process usage is required.  Please select process usage.';
    
  ELSE

      SELECT NAME INTO ifexist 
      FROM process 
      WHERE name=_name
        AND id!= _process_id;
      
      IF ifexist IS NULL
      THEN
       SELECT state
         INTO _oldstate
        FROM process
      WHERE id=_process_id;  
      
        UPDATE process
           SET prg_id = _prg_id,
               name = _name,
               `version` = _version,
               state = _state,
               owner_id = _owner_id,
               if_default_version = _if_default_version,
               `usage` = _usage,
               description = _description,
               comment = _comment,
               state_change_time = now(),
               state_changed_by = _employee_id
        WHERE  id = _process_id;

        INSERT INTO config_history (
          event_time,
          source_table,
          source_id,
          old_state,
          new_state,
          employee,
          comment,
          new_record
        )
        SELECT state_change_time,
              'process',
              id,
              _oldstate,
              state,
              state_changed_by,
              concat('process' , name , ' general information is updated'),
              concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
              '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
                '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
                '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><USAGE>', `usage`, 
                '</USAGE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PROCESS>')              
        FROM process
        WHERE id=_process_id;
        SET _response = '';
      ELSE
        SET _response= concat('The process name ' , _name ,' is already used by another process. Please change the process name and try again.');
      END IF;
 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_product`(
  INOUT _product_id int(10) unsigned,
  IN _created_by int(10)unsigned,
  IN _version int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),  
  IN _pg_id int(10) unsigned,
  IN _name varchar(255),
  IN _lot_size decimal(16,4) unsigned,
  IN _uomid smallint(3) unsigned,
  IN _lifespan int(10) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _newstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Product name is required. Please give the product a name.';
  ELSE
    IF _product_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM product 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO product (
          pg_id, 
          name, 
          `version`, 
          state,
          lot_size,
          uomid,
          lifespan,
          create_time, 
          created_by, 
          state_change_time, 
          state_changed_by, 
          description, 
          comment)
        VALUES (
          _pg_id,
          _name,
          _version,
          _state,
          _lot_size,
          _uomid,
          _lifespan,
          now(),
          _created_by,
          null,
          null,
          _description,
          _comment
        );
        SET _product_id = last_insert_id();
        
        INSERT INTO config_history (
          event_time,
          source_table,
          source_id,
          old_state,
          new_state,
          employee,
          comment,
          new_record
        )
        SELECT create_time,
              'product',
              id,
              NULL,
              state,
              created_by,
              concat('product ', name, ' is created'),
              concat('<PRODUCT><PG_ID>',pg_id, '</PG_ID><NAME>', name,'</NAME><STATE>',state,
                '</STATE><LOT_SIZE>', lot_size, '</LOT_SIZE><UOMID>', uomid,
                '</UOMID><LIFESPAN>',lifespan, '</LIFESPAN><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PRODUCT>')
        FROM product
        WHERE id=_product_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another product. Please change the product name and try again.');
      END IF;
    ELSE
    SELECT NAME INTO ifexist 
      FROM product 
      WHERE name=_name
        AND id !=_product_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM product
      WHERE id=_product_id;
        
      UPDATE product
        SET pg_id=_pg_id,
            name = _name,
            `version` = _version,
            state = _state,
            lot_size = _lot_size,
            uomid = _uomid,
            lifespan = _lifespan,
            state_change_time = now(), 
            state_changed_by = _created_by,
            description = _description, 
              comment = _comment
      WHERE id = _product_id;
      
      INSERT INTO config_history (
            event_time,
            source_table,
            source_id,
            old_state,
            new_state,
            employee,
            comment,
            new_record
          )
          SELECT state_change_time,
                'product',
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('product ', name, ' updated'),
                concat('<PRODUCT><PG_ID>',pg_id, '</PG_ID><NAME>', name,'</NAME><STATE>',state,
                  '</STATE><LOT_SIZE>', lot_size, '</LOT_SIZE><UOMID>', uomid,
                  '</UOMID><LIFESPAN>', lifespan, '</LIFESPAN><CREATE_TIME>',
                  create_time,'</CREATE_TIME><CREATED_BY>',created_by,
                  '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                  '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                  '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                  '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                  '</COMMENT></PRODUCT>')                
          FROM product
          WHERE id=_product_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another product. Please change the product name and try again.');
    END IF;
  END IF; 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_recipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_recipe`(
  IN _created_by int(10) unsigned,
  INOUT _recipe_id int(10) unsigned,
  IN _name varchar(20),
  IN _exec_method enum('ordered','random'),
  IN _contact_employee int(10) unsigned,
  IN _instruction text,
  IN _file_action enum('delete', 'nochange', 'replace'),
  IN _diagram_filename varchar(255),
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);

  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Recipe name is required. Please give the recipe a name.';
    
  ELSEIF _exec_method IS NULL OR length(_exec_method)<1
  THEN
    SET _response = 'Execution Method is required.';
  ELSEIF _contact_employee IS NULL
  THEN
    SET _response='Contact Employee information is missing.'; 
  ELSE
    SET ifexist=NULL;
    SELECT firstname INTO ifexist
      FROM employee
     WHERE id = _created_by;
        
    IF ifexist IS NULL
    THEN
      SET _response = 'The employee who is inserting this attribute does not exist in database.';
    ELSE
      SET ifexist=NULL;
      IF _recipe_id IS NULL
      THEN
        SELECT name INTO ifexist 
        FROM recipe 
        WHERE name=_name;
        
        IF ifexist IS NULL
        THEN
          INSERT INTO recipe (
            name,
            exec_method,
            contact_employee,
            instruction,
            diagram_filename,
            create_time,
            created_by,        
            comment)
          VALUES (
            _name,
            _exec_method,
            _contact_employee,
            _instruction,
            _diagram_filename,
            now(),
            _created_by,
            _comment
  
          );
          SET _recipe_id = last_insert_id();
  
          SET _response = '';
        ELSE
          SET _response= concat('The name ',_name,' is already used by another recipe. Please change the recipe name and try again.');
        END IF;
      ELSE
      SELECT name INTO ifexist 
        FROM recipe 
        WHERE name=_name
          AND id !=_recipe_id;
          
      IF ifexist is NULL
      THEN 
        IF  _file_action = 'nochange' THEN
          UPDATE recipe
            SET name=_name,
                exec_method = _exec_method,
                contact_employee = _contact_employee,
                instruction = _instruction,
                update_time = now(),
                updated_by = _created_by,
                comment = _comment
          WHERE id = _recipe_id;
        ELSE
          IF _file_action='replace' AND _diagram_filename IS NULL
          THEN
            SET _response = "No new file supplied for replacing current file in system. Please select a file.";
          ELSEIF _file_action = 'replace' AND length(_diagram_filename)=0
          THEN
            SET _response = "No new file supplied for replacing current file in system. Please select a file.";
          ELSE
            UPDATE recipe
              SET name=_name,
                  exec_method = _exec_method,
                  contact_employee = _contact_employee,
                  instruction = _instruction,
                  diagram_filename = if(_file_action='delete', null, _diagram_filename),
                  update_time = now(),
                  updated_by = _created_by,
                  comment = _comment
            WHERE id = _recipe_id;  
          END IF;
        END IF;
        SET _response='';
      ELSE
        SET _response= concat('The name ', _name,' is already used by another recipe. Please change the recipe name and try again.');
      END IF;
    END IF; 
   END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_segment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_segment`(
  IN _process_id int(10) unsigned,
  INOUT _segment_id int(5) unsigned, 
  IN _name varchar(255),
  IN _position smallint(2),
  IN _description text,
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Segment name is required. Please give the segment a name.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response='Workflow is required. Please select a workflow for the segment.';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
  THEN
    SET _response="The workflow you chose doesn't exist in database.";
  ELSE
    IF _segment_id IS NULL
    THEN

      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another segment. Please change the segment name and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND `position`=_position)
      THEN
        SET _response = 'There is already another segment for the same position, please make the position available before adding new segment to it.';
      ELSE
        INSERT INTO process_segment (process_id, segment_id, name, `position`, description)
        SELECT _process_id,
               ifnull(MAX(segment_id),0)+1,
               _name,
               _position,
               _description
          FROM process_segment
         WHERE process_id = _process_id;

      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id!=_segment_id AND name=_name)
      THEN
        SET _response= concat('The segment name ', _name,' is already used by another segment. Please change it and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND segment_id!=_segment_id AND `position`=_position) 
      THEN
        SET _response=concat('The position ', _position, ' is already occupied by another segment. Please make it available before using the position.');
      ELSE
          
        UPDATE process_segment
          SET name = _name,
              `position`=_position,
              description = _description
        WHERE process_id=_process_id
          AND segment_id=_segment_id;
      END IF;
    END IF; 
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_step`(
  INOUT _step_id int(10) unsigned, 
  IN _created_by int(10) unsigned,
  IN _version int(5) unsigned,
  IN _if_default_version tinyint(1) unsigned,
  IN _state enum('inactive','production','frozen','checkout','checkin','engineer'),
  IN _eq_usage enum('equipment group','equipment'),
  IN _emp_usage enum('employee group','employee'),
  IN _emp_id int(10) unsigned,  
  IN _name varchar(255),
  IN _step_type_id int(5) unsigned,   
  IN _eq_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _description text,
  IN _comment text,  
  IN _para1 text,
  IN _para2 text,
  IN _para3 text,
  IN _para4 text,
  IN _para5 text,
  IN _para6 text,
  IN _para7 text,
  IN _para8 text,
  IN _para9 text,
  IN _para10 text,  
  IN _para_count tinyint(3),
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _newstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _step_type_id IS NULL OR length(_step_type_id)<1
  THEN
    SET _response='Step type is required. Please give the step a type.';
  
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Step name is required. Please give the step a name.';
  ELSEIF `_version` IS NULL OR length(`_version`)<1
  THEN
    SET _response='Step version is required. Please give the step a version.';  
 
  ELSEIF _created_by IS NULL OR length(_created_by)<1
  THEN
    SET _response='Created by is required. Please select create person.';  
   
  ELSE
    IF _step_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM step 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO step (
          step_type_id,
          name,
          `version`,
          if_default_version,
          state,
          eq_usage,
          eq_id,
          emp_usage,
          emp_id,
          recipe_id,
          mintime,
          maxtime,
          create_time,
          created_by,
          para_count,
          description,
          comment,
          para1,
          para2,
          para3,
          para4,
          para5,
          para6,
          para7,
          para8,
          para9,
          para10
        )
        VALUES (
          _step_type_id,
          _name,
          _version,
          _if_default_version,
          _state,
          _eq_usage,
          _eq_id,
          _emp_usage,
          _emp_id,
          _recipe_id,
          _mintime,
          _maxtime,
          now(),
          _created_by,
          _para_count,
          _description,
          _comment,  
          _para1,
          _para2,
          _para3,
          _para4,
          _para5,
          _para6,
          _para7,
          _para8,
          _para9,
          _para10
        );
        SET _step_id = last_insert_id();
        
        INSERT INTO config_history (
          event_time,
          source_table,
          source_id,
          old_state,
          new_state,
          employee,
          comment,
          new_record
        )
        SELECT create_time,
              'step',
              id,
              NULL,
              state,
              created_by,
              concat('Step ', name, ' is created'),
              concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')
        FROM step
        WHERE id=_step_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another step. Please change the step name and try again.');
      END IF;
    ELSE
    SELECT name INTO ifexist 
      FROM step 
      WHERE name=_name
        AND id !=_step_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM step
      WHERE id=_step_id;
        
      UPDATE step
        SET step_type_id = _step_type_id,
            name = _name,
            `version` = _version,
            if_default_version = _if_default_version,
            state = _state,
            eq_usage = _eq_usage,
            eq_id = _eq_id,
            emp_usage = _emp_usage,
            emp_id = _emp_id,
            recipe_id = _recipe_id,
            mintime = _mintime,
            maxtime = _maxtime,
            state_change_time = now(),
            state_changed_by = _created_by,
            para_count = _para_count,
            description = _description,
            comment = _comment,  
            para1 = _para1,
            para2 = _para2,
            para3 = _para3,
            para4 = _para4,
            para5 = _para5,
            para6 = _para6,
            para7 = _para7,
            para8 = _para8,
            para9 = _para9,
            para10 = _para10
      WHERE id = _step_id;
      
      INSERT INTO config_history (
            event_time,
            source_table,
            source_id,
            old_state,
            new_state,
            employee,
            comment,
            new_record
          )
          SELECT state_change_time,
                'step',
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('step ', name, ' updated'),
                concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')                
          FROM step
          WHERE id=_step_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another step. Please change the step name and try again.');
    END IF;
  END IF; 
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_step_in_process` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_step_in_process`(
  IN _process_id int(10) unsigned,
  IN _position_id  int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _prev_step_pos  int(5) unsigned,
  IN _next_step_pos  int(5) unsigned,
  IN _false_step_pos  int(5) unsigned,
  IN _segment_id int(5) unsigned,
  IN _rework_limit smallint(2) unsigned,
  IN _if_sub_process tinyint(1),
  IN _prompt varchar(255),
  IN _if_autostart tinyint(1) unsigned,  
  IN _need_approval tinyint(1),
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _step_type varchar(20);
  DECLARE _eventtime datetime;
  SET _eventtime = now();

IF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
THEN
  SET _response = "The workflow you are working on doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT * FROM step WHERE id=_step_id)
THEN
  SET _response = "The step you selected doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT position_id  
                FROM process_step 
                WHERE process_id = _process_id
                  AND position_id = _position_id)
THEN
  SET _response= concat('The position ' , _position_id ,' doesn''t exist in this process.') ;
ELSEIF _segment_id IS NOT NULL AND NOT EXISTS(SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id = _segment_id)
THEN
  SET _response = "The segment you chose does not exist in database";
ELSE

  SELECT t.name INTO _step_type
    FROM step s, step_type t
   WHERE s.id = _step_id
     AND t.id = s.step_type_id;
     
  IF _step_type = 'condition' AND _false_step_pos IS NULL 
  THEN
    SET _response="A step position on false result is required for conditional step.";
  ELSEIF _step_type != 'condition' AND _false_step_pos IS NOT NULL 
  THEN
    SET _response = "No step position on false result is needed. Please leave it blank.";
  ELSE  
    IF _if_sub_process = 1
    THEN
      SET _if_autostart = 1;
    END IF; 
    
    UPDATE process_step
      SET step_id=_step_id,
          prev_step_pos = _prev_step_pos,
          next_step_pos = _next_step_pos,
          false_step_pos = _false_step_pos,
          segment_id = _segment_id,
          rework_limit = _rework_limit,
          if_sub_process = _if_sub_process,
          prompt = _prompt,
          if_autostart = _if_autostart,
          need_approval = _need_approval,
          approve_emp_usage = _approve_emp_usage,
          approve_emp_id = _approve_emp_id
      WHERE process_id= _process_id
        AND position_id = _position_id;
  
  
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id 
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'modify',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id  
    FROM process_step
    WHERE process_id=_process_id
      AND position_id = _position_id;
    
    UPDATE process
      SET state_change_time = _eventtime,
          state_changed_by = _employee_id
    WHERE id = _process_id;
  
    
  END IF;

END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `modify_uom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `modify_uom`(
  INOUT _uom_id smallint(3) unsigned, 
  IN _name varchar(20),
  IN _alias varchar(20),
  IN _description varchar(255),
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='UoM name is required. Please give the UoM a name.';
  ELSE
    IF _uom_id IS NULL
    THEN
      
      IF EXISTS (SELECT * FROM uom WHERE name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another unit of measure. Please change the UoM name and try again.');
      ELSE
        INSERT INTO uom (name,alias, description)
        VALUES (_name, _alias, _description);
        SET _uom_id = last_insert_id();
        SET _response = '';
      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM uom WHERE alias=_alias AND id != _uom_id)
      THEN
        SET _response= concat('The alias ', _alias,' is already used by another UoM. Please change it and try again.');
      ELSE
          
        UPDATE uom
          SET alias = _alias,
              description = _description
        WHERE id = _uom_id;
      END IF;
    END IF; 
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pass_lot_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `pass_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _comment text,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _autostart_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
 
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _start_timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;
     

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
    
      CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);
                                
      IF _response IS NULL
      THEN
  
        IF _process_id IS NULL 
          AND _sub_process_id IS NULL 
          AND _position_id IS NULL
          AND _sub_position_id IS NULL
          AND _step_id IS NULL
        THEN  -- new step informaiton wasn't supplied
        
          SET _process_id = _process_id_p;
          SET _sub_process_id = _sub_process_id_n;
          SET _position_id = _position_id_n;
          SET _sub_position_id = _sub_position_id_n;
          SET _step_id = _step_id_n;
        ELSEIF _process_id<=>_process_id_p 
              AND _sub_process_id<=>_sub_process_id_n
              AND _position_id <=>_position_id_n
              AND _sub_position_id <=>_sub_position_id_n
              AND _step_id <=> _step_id_n
        THEN -- new step information was supplied and checked
          SET _response='';
        ELSE
          SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
        END IF; 
        
        IF (_response IS NULL OR length(_response)=0)  
        THEN
 
           -- check approver information
          IF _sub_process_id IS NULL
          THEN
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
           ;
          ELSE
           SELECT need_approval, approve_emp_usage, approve_emp_id
             INTO _need_approval, _approve_emp_usage, _approve_emp_id
              FROM process_step
             WHERE process_id = _sub_process_id
               AND position_id = _sub_position_id
               AND step_id = _step_id
             ;
          END IF;
          
          CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);

          IF (_response IS NULL OR length(_response)=0)  
          THEN
          
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            
            SET _step_status = 'ended';
            
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
              equipment_id,
              device_id,
              result,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _operator_id,
              _step_status,
              _quantity,
              _quantity,
              _uomid ,
              _equipment_id,
              _device_id,
              _short_result,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'in transit';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _quantity
                    ,update_timecode = _start_timecode
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step pass in batch history.";
            END IF; 
            
            IF _response IS NULL OR length(_response)=0 THEN
              SET _process_id_p = null;
              SET _sub_process_id_n = null;
              SET _position_id_n = null;
              SET _sub_position_id_n = null;
              SET _step_id_n = null;
              
              CALL `start_lot_step`(
                _lot_id,
                _lot_alias,
                _operator_id,
                1,
                _quantity,
                null,
                null,
                'Step started automatically',
                _process_id_p,
                _sub_process_id_n,
                _position_id_n,
                _sub_position_id_n,
                _step_id_n,
                _lot_status_n,
                _step_status_n,
                _autostart_timecode,
                _response
              );
              IF _autostart_timecode IS NOT NULL
              THEN
                SET _process_id = _process_id_p;
                SET _sub_process_id = _sub_process_id_n;
                SET _position_id = _position_id_n;
                SET _sub_position_id = _sub_position_id_n;
                SET _step_id = _step_id_n;
                SET _lot_status = _lot_status_n;
                SET _step_status = _step_status_n;
              END IF;
            END IF;
          
          END IF;
        END IF;
  
  
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_ingredient_from_recipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `remove_ingredient_from_recipe`(
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type varchar(10),
  IN _order tinyint(3) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source Type is required.';
  ELSEIF _source_type !='product' AND _source_type!= 'material'
  THEN
    SET _response = 'Source Type can only have the value of "product" or "material". Please correct the value.';
    
  ELSE
      SELECT name INTO ifexist
        FROM recipe
      WHERE id =_recipe_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The employee who is adding this ingredient does not exist in database.';
        ELSE
        
        IF NOT EXISTS (SELECT * FROM ingredients
                        WHERE recipe_id = _recipe_id
                          AND source_type = _source_type
                          AND ingredient_id = _ingredient_id
                          AND `order` <=> _order)
        THEN
          IF _response IS NULL
          THEN
            SET _response = 'The ingredient you selected does not exist in database.';
          END IF;
        ELSE
          DELETE FROM ingredients
           WHERE recipe_id = _recipe_id
             AND source_type = _source_type
             AND ingredient_id = _ingredient_id
             AND `order` <=> _order;

          INSERT INTO ingredients_history
          (
            event_time,
            employee_id,
            action,
            recipe_id,
            source_type,
            ingredient_id,
            quantity,
            uom_id,
            `order`,
            mintime,
            maxtime,
            comment              
          )
          SELECT 
            _eventtime,
            _employee_id,
            'delete',
            recipe_id,
            source_type,
            ingredient_id,
            quantity,
            uom_id,
            `order`,
            mintime,
            maxtime,
            _comment 
           FROM ingredients
          WHERE recipe_id = _recipe_id
            AND source_type = _source_type
            AND ingredient_id = _ingredient_id
            AND `order` <=> _order
          ;
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_consumption_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_consumption_details`(
  IN _lot_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _source_type enum('product', 'material'),
  IN _source_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
-- If _step_start_timecode is supplied, the resultset only shows
-- the consumption for the step that started at the _step_start_timecode
-- otherwise, it shows the consumption of the whole workflow/process.

-- If _source_type is supplied, the resultset only shows the consumption of the specified source type,
-- otherwise, it shows consumption of all source type.

-- If _source_id is supplied, the resultset only shows the consumption of the particular source/ingredient,
-- otherwise, it will show the consumption of all sources.

-- _lot_id is required. The other three parameters can be used in combinations or all null.

  DECLARE _end_timecode char(15);

  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSE
     SELECT l.lot_id,
            l.lot_alias,
            str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' ) as step_start,
            str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' ) as step_end,
            l.process_id,
            l.sub_process_id,
            l.position_id,
            l.sub_position_id,
            l.step_id,
            s.name as step_name,
            str_to_date(ic.start_timecode, '%Y%m%d%H%i%s0' ) as consumption_start,
            str_to_date(ic.end_timecode, '%Y%m%d%H%i%s0' ) as consumption_end,
            ic.inventory_id,
            CASE WHEN i.source_type = 'product' THEN p.name ELSE m.name END AS part_name,
            i.lot_id as inv_lot_id,
            i.serial_no as inv_serial_no,
            ic.quantity_used,
            ic.uom_id,
            u.name as uom_name,
            ic.operator_id,
            CONCAT(e.firstname, ' ', e.lastname) AS operator,
            ic.comment
       FROM lot_history l
       INNER JOIN step s ON s.id = l.step_id 
       INNER JOIN step_type st ON st.id = s.step_type_id AND st.name = 'consume material'
       INNER JOIN inventory_consumption ic 
             ON ic.start_timecode >=l.start_timecode 
             AND (l.end_timecode IS NULL or ic.end_timecode <= l.end_timecode)
       INNER JOIN inventory i 
             ON i.id = ic.inventory_id 
             AND (_source_type IS NULL OR i.source_type = _source_type)
             AND (_source_id IS NULL OR i.pd_or_mt_id = _source_id)
       INNER JOIN uom u ON u.id = ic.uom_id
       LEFT JOIN employee e ON e.id = ic.operator_id
       LEFT JOIN product p ON i.source_type = 'product' AND p.id = i.pd_or_mt_id
       LEFT JOIN material m ON i.source_type = 'material' AND m.id = i.pd_or_mt_id
      WHERE l.lot_id =_lot_id 
        AND (_step_start_timecode IS NULL OR l.start_timecode = _step_start_timecode)
        ;

   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_consumption_for_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_consumption_for_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
-- the procedure uses _start_timecode,  to locate the consumption record if possible
-- otherwise, it will use the 
  DECLARE _end_timecode char(15);

  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "The batch has no workflow assigned.";
  ELSEIF _step_id IS NULL
  THEN
    SET _response = "The batch is not inside a step.";
  ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_consumption 
      (
        source_type varchar(20),
        ingredient_id int(10) unsigned,
        name varchar(255),
        `order` tinyint(3) unsigned,
        description text,
        required_quantity decimal(16,4),
        uom_id smallint(6) unsigned,
        uom_name varchar(20),
        mintime int(10) unsigned,
        maxtime int(10) unsigned,
        restriction varchar(255),
        comment text,
        used_quantity decimal(16,4)
      ) DEFAULT CHARSET=utf8;
    
    INSERT INTO temp_consumption
    SELECT v.source_type, 
           V.ingredient_id,
           v.name, 
           v.order,
           v.description, 
           v.quantity, 
           v.uom_id,
           v.uom_name, 
           v.mintime, 
           v.maxtime,
           CASE
             WHEN v.mintime>0 AND v.maxtime>0 
                 THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part, but no more than ", v.maxtime, " minutes.")
             WHEN v.mintime>0
              THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part.")
             WHEN v.maxtime>0
              THEN CONCAT("You have to add the part within ", v.maxtime, " minutes.")
             ELSE
               ''
           END,
           v.comment,
           null
      FROM step s JOIN view_ingredient v ON v.recipe_id = s.recipe_id
    WHERE s.id =_step_id;
    
    SELECT end_timecode
      INTO _end_timecode
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _start_timecode
       AND step_id = _step_id;
    

      
    UPDATE temp_consumption t LEFT JOIN 
      (SELECT i.source_type,
              i.pd_or_mt_id,
              sum(c.quantity_used) as total_used
         FROM inventory_consumption c INNER JOIN inventory i
           ON i.id = c.inventory_id
        WHERE c.lot_id = _lot_id
          AND c.start_timecode >= _start_timecode
          AND (_end_timecode IS NULL OR c.end_timecode<=_end_timecode)
          AND c.step_id = _step_id
        GROUP BY i.source_type, i.pd_or_mt_id) a
       ON a.source_type = t.source_type
          AND a.pd_or_mt_id = t.ingredient_id
     SET t.used_quantity = a.total_used;
    
    SELECT 
        source_type,
        ingredient_id,
        name,
        `order`,
        description,
        required_quantity,
        ifnull(used_quantity,0) as used_quantity,      
        uom_id,
        uom_name,
        mintime,
        maxtime,
        restriction,
        comment
      FROM temp_consumption
      ORDER BY `order`
      ;
    DROP TABLE temp_consumption;
  END IF;
 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_dispatch_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_dispatch_history`(
  IN _from_time datetime,
  IN _to_time datetime,
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
    
  IF _from_time IS NOT NULL AND _to_time IS NOT NULL AND _from_time < _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h2.status ='dispatched' , 
                 '', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
                                           
     WHERE h.start_timecode between 
               DATE_FORMAT(_from_time, '%Y%m%d%H%i%s0')
           AND DATE_FORMAT(_to_time, '%Y%m%d%H%i%s0')
       AND h.status = 'dispatched';
       
  ELSEIF _from_time = _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h2.status='dispatched' , 
                 ' ', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
                                           
     WHERE h.status = 'dispatched';
  ELSE   
      SET _response = "Both From Time and To Time need to be filled and From Time must be a datatime earlier than To Time.";
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_lot_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_lot_history`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  
 CREATE TEMPORARY TABLE IF NOT EXISTS lot_history_report
 (
    start_time datetime,
    end_time datetime,
    process_id int(10) unsigned,
    process_name varchar(255),
    sub_process_id int(10) unsigned,
    sub_process_name varchar(255),
    position_id int(5) unsigned,
    sub_position_id int(5) unsigned,
    step_id int(10) unsigned,
    step_name varchar(255),
    step_type varchar(20),
    start_operator_id int(10) unsigned,
    start_operator_name varchar(60),
    end_operator_id int(10) unsigned,
    end_operator_name varchar(60),
    status varchar(20),
    start_quantity decimal(16,4) unsigned,
    end_quantity decimal(16,4) unsigned,
    uomid smallint(3) unsigned,
    uom_name  varchar(20),
    equipment_id int(10) unsigned,
    equipment_name varchar(255),
    device_id int(10) unsigned,
    approver_id int(10) unsigned,
    approver_name varchar(60),
    result text,
    comment text
 );
 
 INSERT INTO lot_history_report
 SELECT get_local_time(str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' )),
        get_local_time(str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' )),
        l.process_id,
        p.name,
        sub_process_id,
        null,
        position_id,
        sub_position_id,
        l.step_id,
        s.name,
        st.name,
        l.start_operator_id,
        concat(e.firstname, ' ', e.lastname),
        l.end_operator_id,
        concat(e2.firstname, ' ', e2.lastname),
        l.status,
        l.start_quantity,
        l.end_quantity,
        l.uomid,
        u.name,
        l.equipment_id,
        null,
        l.device_id,
        l.approver_id,
        null,
        CASE 
          WHEN st.name='condition' AND l.result='true' THEN 'Pass'
          WHEN st.name='condition' AND l.result='false' THEN 'Fail'
          ELSE l.result
        END,
        l.comment
  FROM lot_history l
  LEFT JOIN process p ON p.id = l.process_id
  LEFT JOIN step s ON  s.id = l.step_id 
  LEFT JOIN step_type st ON st.id=s.step_type_id
  LEFT JOIN employee e ON e.id = l.start_operator_id
  LEFT JOIN employee e2 ON e2.id = l.end_operator_id
  LEFT JOIN uom u ON u.id = l.uomid
 WHERE l.lot_id <=> _lot_id
 ORDER BY start_timecode
;

 UPDATE lot_history_report
   SET result=CONCAT('Reposition to --> position ',
   substring_index(right(result,length(result)-length(substring_index(result, ',', 1))-1),',',1),
   ', Step ',
   (SELECT NAME FROM step WHERE id=substring_index(result, ',', -1)))
  WHERE step_type='reposition';
  
 UPDATE lot_history_report l, process p
    SET l.sub_process_name = p.name
  WHERE l.sub_process_id IS NOT NULL
    AND p.id = l.sub_process_id
 ;
 
 UPDATE lot_history_report l, equipment eq
    SET l.equipment_name = eq.name
  WHERE l.equipment_id IS NOT NULL
    AND eq.id = l.equipment_id
 ;
 
 UPDATE lot_history_report l, employee e
    SET l.approver_name = concat(e.firstname, ' ', e.lastname)
  WHERE l.approver_id IS NOT NULL
    AND e.id = l.approver_id
 ;
 
 SELECT 
    start_time,
    end_time,
    process_id,
    process_name,
    sub_process_id,
    sub_process_name,
    position_id,
    sub_position_id,
    step_id,
    step_name,
    start_operator_id,
    start_operator_name,
    end_operator_id,
    end_operator_name,
    status,
    start_quantity,
    end_quantity,
    uomid,
    uom_name,
    equipment_id,
    equipment_name,
    device_id,
    approver_id,
    approver_name,
    result,
    comment
  FROM lot_history_report;
  DROP TABLE lot_history_report;
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_lot_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_lot_status`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  

 SELECT l.product_id,
        p.name as product_name,
        l.order_id,
        o.ponumber,
        o.client_id,
        c.name as client_name,
        l.process_id,
        pr.name as process_name,
        l.status,
        l.start_quantity,
        l.actual_quantity,
        l.uomid,
        u.name as uom_name,
        l.contact,
        concat(e.firstname, ' ', e.lastname)as contact_name,
        l.priority,
        get_local_time(l.dispatch_time) as dispatch_time,
        get_local_time(l.output_time) as output_time,
        l.comment
  FROM lot_status l, product p , `order_general` o , client c, process pr, employee e, uom u
 WHERE l.id <=> _lot_id
   AND p.id = l.product_id
   AND o.id = l.order_id
   AND c.id = o.client_id
   AND pr.id = l.process_id
   AND e.id = l.contact
   AND u.id = l.uomid;
 
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_order_quantity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_order_quantity`(
  IN _order_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _order_id IS NOT NULL
  THEN

      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            p.id as product_id,
            p.name as product_name,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      JOIN product p ON od.source_type = 'product' AND od.source_id=p.id
      WHERE o.id = _order_id
        AND o.order_type in ('inventory', 'customer')
        AND od.source_type='product'; 
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_process_bom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_process_bom`(
  IN _process_id int(10) unsigned
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
    
  IF _process_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 
    (
      position_id int(10) unsigned,
      sub_position_id int(10) unsigned,
      step varchar(255),
      recipe varchar(255),
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      input_order tinyint(3) unsigned,
      alert_quantity decimal(16,4) unsigned,      
      unassigned_quantity_raw varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      unassigned_uom varchar(20),
      assigned_quantity_show varchar(31),
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    (
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uomid,
      uom,
      input_order   
    )
    SELECT position_id,
          null,
          s.name,
          r.name,
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id,
          u.name,
          if(i.order>0, i.order, null)
      FROM process_step p, step s, step_type t, recipe r, ingredients i, uom u
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id
      AND u.id = i.uom_id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    (
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uomid,
      uom,
      input_order   
    )    
    SELECT  p.position_id,
            p1.position_id,
            s.name,
            r.name,
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id,
            u.name,
            if(i.order>0, i.order, null)
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i,  uom u
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id
      AND u.id = i.uom_id;
      
    UPDATE process_bom pb, material m
       SET pb.ingredient_name = m.name,
           pb.alert_quantity = m.alert_quantity
     WHERE pb.source_type = 'material'
       AND pb.ingredient_id = m.id;
       
    UPDATE process_bom pb, product p
       SET pb.ingredient_name = p.name
     WHERE pb.source_type = 'product'
       AND pb.ingredient_id = p.id;
  
    UPDATE process_bom pb
       SET unassigned_quantity_raw=
       ifnull((SELECT concat(sum(inv.actual_quantity), ',', max(inv.uom_id))
              FROM inventory inv 
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND 
                (EXISTS (SELECT * 
                           FROM `order_general` o, order_state_history os
                          WHERE o.id = inv.in_order_id
                            AND o.order_type = 'inventory'
                            AND os.order_id = o.id
                            AND os.state='produced'
                            ) 
                 OR
                  (inv.in_order_id IS NULL))), 0),
            assigned_quantity_show=
        ifnull((SELECT concat(format(sum(inv.actual_quantity),1), ' ', max(u3.name))
              FROM inventory inv LEFT JOIN uom u3 ON u3.id = inv.uom_id
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND EXISTS (SELECT *
                            FROM `order_general` o
                           WHERE o.id = inv.in_order_id
                              AND o.order_type in( 'customer','inventory')
                              AND NOT EXISTS (SELECT *
                                                FROM order_state_history os
                                               WHERE os.order_id = o.id
                                                 AND os.state = 'produced'))),0);
                                                 
    UPDATE process_bom
       SET unassigned_quantity = CAST(LEFT(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')) AS DECIMAL),
           unassigned_uomid =SUBSTRING(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')+1)
     WHERE unassigned_quantity_raw != '0';  
     
     UPDATE process_bom
       SET unassigned_quantity = 0,
           unassigned_uomid =0
     WHERE unassigned_quantity_raw = '0';      
     
     UPDATE process_bom pb LEFT JOIN uom u ON unassigned_uomid = u.id
        SET unassigned_uom = u.name,
            ifalert=if(pb.unassigned_quantity=0 OR convert_quantity(pb.unassigned_quantity, pb.unassigned_uomid, pb.uomid) < pb.alert_quantity, 1, 0)
      ;    
     
    SELECT 
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uom,
      input_order,
      alert_quantity,      
      unassigned_quantity,
      unassigned_uom,
      assigned_quantity_show,
      ifalert    
      FROM process_bom
     ORDER BY position_id, sub_position_id, input_order;

    DROP TABLE process_bom;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_process_bom_total` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_process_bom_total`(
  IN _process_id int(10) unsigned
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

    
  IF _process_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    SELECT 
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id
      FROM process_step p, step s, step_type t, recipe r, ingredients i
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    SELECT  
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id;
 

      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_total 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      alert_quantity decimal(16,4) unsigned,
      description text
    ) DEFAULT CHARSET=utf8; 
    
     INSERT INTO process_bom_total 
     (source_type,
     ingredient_id,
     quantity,
     uomid,
     uom)
    SELECT source_type,
           ingredient_id,
           sum(quantity),
           pb.uomid,
           u.name
           
      FROM process_bom pb, uom u
     WHERE u.id = pb.uomid
     GROUP BY source_type, ingredient_id, ingredient_name, pb.uomid;
     
    DROP TABLE process_bom;
    
    UPDATE process_bom_total pb, material m
       SET pb.ingredient_name = m.name,
           pb.alert_quantity = m.alert_quantity,
           pb.description = m.description
     WHERE pb.source_type = 'material'
       AND pb.ingredient_id = m.id;
       
    UPDATE process_bom_total pb, product p
       SET pb.ingredient_name = p.name,
           pb.description = p.description
     WHERE pb.source_type = 'product'
       AND pb.ingredient_id = p.id;
    
      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_temp 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      unassigned_quantity_raw varchar(31),
      assigned_quantity_show varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;  
    
    INSERT INTO process_bom_temp
    (source_type, ingredient_id, unassigned_quantity_raw, assigned_quantity_show, ifalert)
    SELECT source_type,
           ingredient_id,
           ifnull((SELECT concat(sum(inv.actual_quantity), ',', max(inv.uom_id))
              FROM inventory inv 
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND 
                (EXISTS (SELECT * 
                           FROM `order_general` o, order_state_history os
                          WHERE o.id = inv.in_order_id
                            AND o.order_type = 'inventory'
                            AND os.order_id = o.id
                            AND os.state='produced'
                            ) 
                 OR
                  (inv.in_order_id IS NULL))), 0)  ,
           ifnull((SELECT concat(format(sum(inv.actual_quantity),1), ' ', max(u3.name))
              FROM inventory inv LEFT JOIN uom u3 ON u3.id = inv.uom_id
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND EXISTS (SELECT *
                            FROM `order_general` o
                           WHERE o.id = inv.in_order_id
                              AND o.order_type in( 'customer','inventory')
                              AND NOT EXISTS (SELECT *
                                                FROM order_state_history os
                                               WHERE os.order_id = o.id
                                                 AND os.state = 'produced'))),0),
             0
     
      FROM process_bom_total pb ;
      
    UPDATE process_bom_temp
       SET unassigned_quantity = CAST(LEFT(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')) AS DECIMAL),
           unassigned_uomid =SUBSTRING(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')+1)
     WHERE unassigned_quantity_raw != '0';
 
     UPDATE process_bom_temp
       SET unassigned_quantity = 0,
           unassigned_uomid =0
     WHERE unassigned_quantity_raw = '0';
    
    -- unassigned inventory is empty or below alert level will raise the ifalert flag
    UPDATE process_bom_temp pt, process_bom_total pb
      SET pt.ifalert =if(pt.unassigned_quantity=0 OR convert_quantity(pt.unassigned_quantity, pt.unassigned_uomid, pb.uomid)<pb.alert_quantity, 1, 0)
     WHERE pb.source_type = pt.source_type
       AND pb.ingredient_id = pt.ingredient_id;
   
    SELECT pt.source_type,
           pt.ingredient_id,
           pt.ingredient_name
           ,pt.quantity
           ,pt.uomid
           ,pt.uom
           ,pt.alert_quantity
           ,pt.description
           ,pb.unassigned_quantity
           ,pb.unassigned_uomid
           ,u.name AS unassigned_uom
           ,pb.assigned_quantity_show
           ,pb.ifalert
           FROM process_bom_total pt 
           JOIN process_bom_temp pb ON pt.source_type = pb.source_type AND pt.ingredient_id = pb.ingredient_id
           LEFT JOIN uom u ON u.id = pb.unassigned_uomid;
    
    DROP TABLE process_bom_total;
    DROP TABLE process_bom_temp;
  END IF;
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_process_cycletime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_process_cycletime`(
  IN _process_id int(10) unsigned,
  IN _product_id int(10) unsigned
)
BEGIN


    
  IF _process_id IS NOT NULL AND _product_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_cycletime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      step_id int(10) unsigned,
      step varchar(255),
      step_type varchar(20),
      description varchar(255),
      min_time int(10) unsigned,
      max_time int(10) unsigned,
      average_time int(10) unsigned,
      average_yield tinyint(2) unsigned,
      prev_step_pos varchar(5),
      next_step_pos varchar(5),
      false_step_pos varchar(5),
      rework_limit smallint(2) unsigned 
    );

    -- collect step information for steps/non-subprocess in the flow
    INSERT INTO process_cycletime
    SELECT p.position_id,
          null,
          p.step_id,
          s.name,
          t.name,
          if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
          s.mintime,
          s.maxtime,
          null,
          null,
          p.prev_step_pos,
          p.next_step_pos,
          p.false_step_pos,
          p.rework_limit
      FROM process_step p, step s, step_type t
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      ;
    
    -- collect step information for steps in sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_cycletime
    SELECT  p.position_id,
            concat('s', p1.position_id),
            p1.step_id,
            s.name,
            t.name,
            if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
            s.mintime,
            s.maxtime,
            null,
            null,
            concat('s',p1.prev_step_pos),
            concat('s',p1.next_step_pos),
            concat('s',p1.false_step_pos),
            p1.rework_limit

      FROM process_step p, process_step p1, step s, step_type t
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      ;
      CREATE TEMPORARY TABLE IF NOT EXISTS process_actualtime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      through_count int(5) unsigned,
      total_time int(10) unsigned,
      average_yield tinyint(2) unsigned
    );    
    
    INSERT INTO process_actualtime
    SELECT position_id,
           sub_position_id,
           sum(if(h.status in ('error', 'stopped'), 0, 1)),
           sum(timestampdiff(minute, str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' ), str_to_date(h.end_timecode, '%Y%m%d%H%i%s0') )),
           avg(100 * h.end_quantity/h.start_quantity)
      FROM lot_status l, lot_history h 
     WHERE l.product_id = _product_id
       AND l.process_id = _process_id
       AND h.lot_id = l.id
       AND h.status not in ('dispatched', 'started', 'restarted')
       AND h.start_quantity != 0
     GROUP BY position_id, sub_position_id;
    
    UPDATE process_cycletime pc, process_actualtime pa
       SET pc.average_time =  pa.total_time/pa.through_count
          ,pc.average_yield = pa.average_yield
     WHERE pc.position_id = pa.position_id
       AND pc.sub_position_id <=> pc.sub_position_id;
       
    SELECT position_id,
           sub_position_id,
           step_id,
           step,
           step_type,
           description,
           min_time,
           max_time,
           average_time,
           average_yield,
           prev_step_pos,
           next_step_pos,
           false_step_pos,
           rework_limit
      FROM process_cycletime
   ORDER BY position_id, sub_position_id
  ;

    DROP TABLE process_cycletime;
    DROP TABLE process_actualtime;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_product`(
  IN _product_id int(10) unsigned,
  IN _order_id int(10) unsigned,
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
  IF _product_id IS NULL
  THEN
    SET _response = "Product is required. Please select a product.";
  ELSEIF _order_id IS NULL OR length(_order_id) = 0
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h.status='dispatched', 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
                              AND h.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h2
                                           WHERE h2.lot_id=h.lot_id)
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
                                           
     WHERE l.product_id = _product_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  
       
  ELSE
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
                 AND h.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h2
                                           WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id                                         
     WHERE l.product_id = _product_id
       AND l.order_id = _order_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_product_quantity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `report_product_quantity`(
  IN _product_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _product_id IS NOT NULL
  THEN

  
    
    
    SELECT name INTO _pname
      FROM product
      WHERE id = _product_id;
    
    IF _pname IS NOT NULL
    THEN

      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      WHERE o.order_type in ('inventory', 'customer')
        AND od.source_type='product'
        AND od.source_id =_product_id ;
    END IF;
  
  END IF;

  

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `return_inventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `return_inventory`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _consumption_start_timecode char(15),
  IN _inventory_id int(10) unsigned,
  IN _quantity_returned decimal(16,4) unsigned,
  IN _comment text, 
  IN _recipe_uomid smallint(3) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_return_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
  DECLARE _quantity_before decimal(16,4) unsigned;
  
  SET autocommit=0;

  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch indentifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSEIF NOT EXISTS (
    SELECT *
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _step_start_timecode
  )
  THEN
    SET _response = "The batch you selected hasn't reach the step given.";
  ELSE
    SELECT quantity_used
      INTO _quantity_before
      FROM inventory_consumption
     WHERE lot_id = _lot_id
       AND start_timecode = _consumption_start_timecode
       AND inventory_id = _inventory_id;
       
    SELECT uom_id
      INTO _inventory_uomid
      FROM inventory
     WHERE id=_inventory_id;
    
    IF _quantity_before < _quantity_returned
    THEN
      SET _response = CONCAT("The quantity used ", _quantity_before, " is less than quantity to return. Please refresh form and reenter return quantity.");
    ELSEIF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
      SET _inv_return_quantity=convert_quantity(_quantity_returned, _recipe_uomid, _inventory_uomid);
      IF _inv_return_quantity IS NULL
      THEN
        SET _response = "Can not calculate inventory return because no UoM conversion provided to convert returned quantity into the UoM used in inventory.";

      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
        INSERT INTO `consumption_return` (
          `lot_id` ,
          `lot_alias` ,
          `return_timecode` ,
          `inventory_id` ,
          `quantity_before` ,
          `quantity_returned` ,
          `uom_id`  , 
          `operator_id`,
          `step_start_timecode` ,
          `consumption_start_timecode` ,
          `process_id` ,
          `step_id` ,
          `comment` )
           VALUES(
           _lot_id,
           _lot_alias,
           _timecode,
           _inventory_id,
           _quantity_before,
           _quantity_returned,
           _recipe_uomid,
           _operator_id,
           _step_start_timecode,
           _consumption_start_timecode,
           _process_id,
           _step_id,
           _comment
           );
          
          IF (_quantity_before = _quantity_returned)
          THEN
            DELETE FROM inventory_consumption
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;            
          ELSE
            UPDATE inventory_consumption
              SET quantity_used = quantity_used - _quantity_returned
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;   
          END IF;
          
          UPDATE inventory
             SET actual_quantity = actual_quantity + _inv_return_quantity
           WHERE id=_inventory_id;
           
        COMMIT;
      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `scrap_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `scrap_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _comment text,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  
  SET autocommit=0;
   
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);    
    IF _response IS NULL AND _step_type = "scrap"
    THEN
      -- SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
      IF ( _process_id IS NULL 
         AND _sub_process_id IS NULL 
         AND _position_id IS NULL
         AND _sub_position_id IS NULL
         AND _step_id IS NULL) OR
         (_process_id<=>_process_id_p 
            AND _sub_process_id<=>_sub_process_id_n
            AND _position_id <=>_position_id_n
            AND _sub_position_id <=>_sub_position_id_n
            AND _step_id <=> _step_id_n)
      THEN  -- new step informaiton wasn't supplied
      
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSE
         SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF;
      
       -- check approver information
      IF _response IS NULL
      THEN
        IF _sub_process_id IS NULL
        THEN
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id
            AND step_id = _step_id
        ;
        ELSE
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _sub_process_id
            AND position_id = _sub_position_id
            AND step_id = _step_id
          ;
        END IF;
        
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
      END IF;
      
      IF _response IS NULL
      THEN
        SET _step_status = 'scrapped';
        SET _timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;        
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          end_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          end_operator_id,
          status,
          start_quantity,
          end_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _timecode,
          _timecode,
          _process_id,
          _sub_process_id,
          _position_id,
          _sub_position_id,
          _step_id,
          _operator_id,
          _operator_id,
          _step_status,
          _quantity,
          _quantity,
          _uomid ,
          _comment
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'scrapped';
          
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _quantity
                ,update_timecode = _timecode
                ,comment=_comment
           WHERE id=_lot_id;
           
           UPDATE order_detail o, lot_status l
              SET o.quantity_in_process = o.quantity_in_process - convert_quantity(_quantity, _uomid, o.uomid)
            WHERE l.id = _lot_id
              AND o.order_id = l.order_id
              AND o.source_type = 'product'
              AND o.source_id = l.product_id
              ;
             COMMIT;         
        ELSE
          SET _response="Error when recording scrap action in batch history.";
          ROLLBACK;
        END IF;  
        
        
      END IF;
    END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_step_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `select_step_details`(
  IN _step_id int(10) unsigned
)
BEGIN
  SELECT s.name AS step_name,
         s.step_type_id,
         st.name as step_type_name,
         s.version,
         s.state,
         s.eq_usage,
         s.eq_id,
         IF (s.eq_usage='equipment',
             (SELECT eq.name FROM equipment eq WHERE eq.id =s.eq_id ),
             (SELECT eqg.name FROM equipment_group eqg WHERE eqg.id = s.eq_id)) AS eq_name,
         s.emp_usage,
         s.emp_id,
         IF (s.emp_usage = 'employee',
             (SELECT concat(e2.firstname, ' ', e2.lastname) FROM employee e2 WHERE e2.id = s.emp_id),
             (SELECT eg2.name FROM employee_group eg2 WHERE eg2.id = s.emp_id)) AS emp_name,
         s.recipe_id,
         s.mintime,
         s.maxtime,
         s.description,
         s.comment AS step_comment,
         s.para1,
         s.para2,
         s.para3,
         s.para4,
         s.para5,
         s.para6,
         s.para7,
         s.para8,
         s.para9,
         s.para10,
         r.name as recipe_name,
         r.exec_method,
         r.contact_employee,
         (SELECT concat(e3.firstname, ' ', e3.lastname) FROM employee e3 WHERE e3.id = r.contact_employee) AS contact_employee_name,
         r.instruction,
         r.diagram_filename,
         r.comment AS recipe_comment
    FROM step s 
         LEFT JOIN recipe r ON r.id = s.recipe_id
         LEFT JOIN step_type st ON st.id = s.step_type_id
   WHERE s.id = _step_id
  ;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sel_consumption_for_cur_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `sel_consumption_for_cur_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _start_timecode char(15);
  DECLARE _end_timecode char(15);

  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "The batch has no workflow assigned.";
  ELSEIF _step_id IS NULL
  THEN
    SET _response = "The batch is not inside a step.";
  ELSE
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_consumption 
      (
        source_type varchar(20),
        ingredient_id int(10) unsigned,
        name varchar(255),
        description text,
        required_quantity decimal(16,4),
        uom_id smallint(6) unsigned,
        uom_name varchar(20),
        mintime int(10) unsigned,
        maxtime int(10) unsigned,
        restriction varchar(255),
        comment text,
        used_quantity decimal(16,4)
      ) DEFAULT CHARSET=utf8;
    
    INSERT INTO temp_consumption
    SELECT v.source_type, 
           V.ingredient_id,
           v.name, 
           v.description, 
           v.quantity, 
           v.uom_id,
           v.uom_name, 
           v.mintime, 
           v.maxtime,
           CASE
             WHEN v.mintime>0 AND v.maxtime>0 
                 THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part, but no more than ", v.maxtime, " minutes.")
             WHEN v.mintime>0
              THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part.")
             WHEN v.maxtime>0
              THEN CONCAT("You have to add the part within ", v.maxtime, " minutes.")
             ELSE
               ''
           END,
           v.comment,
           null
      FROM step s LEFT JOIN view_ingredient v ON v.recipe_id = s.recipe_id
    WHERE s.id =_step_id;
    
    DROP TABLE temp_consumption;
  END IF;
  

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ship_lot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ship_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _ship_timecode char(15),
  IN _shipper_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _contact_id int(10) unsigned, 
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _ship_time datetime;
  DECLARE _process_id int(10) unsigned;
  DECLARE _sub_process_id int(10) unsigned;
  DECLARE _position_id int(5) unsigned;
  DECLARE _sub_position_id int(5) unsigned;
  DECLARE _step_id int(10) unsigned;  
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Lot identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The lot you supplied does not exist in database";
    ELSE
      SET _ship_time = str_to_date(_ship_timecode, '%Y%m%d%H%i%s0' );
      
      START TRANSACTION;
      
      INSERT INTO inventory (
        source_type,
        pd_or_mt_id,
        supplier_id,
        lot_id,
        in_order_id,
        original_quantity,
        actual_quantity,
        uom_id,
        manufacture_date,
        expiration_date,
        arrive_date,
        recorded_by,
        contact_employee,
        comment
        )
      SELECT 'manufactured',
             l.product_id,
             0,
             l.id,
             l.order_id,
             _quantity,
             _quantity,
             l.uomid,
             _ship_time,
             if(p.lifespan > 0, date_add(_ship_time, INTERVAL p.lifespan DAY), NULL),
             _ship_time,
             _shipper_id,
             _contact_id,
             _comment
        FROM lot_status l, product p
       WHERE l.id=_lot_id
         AND p.id = l.product_id;
         
      IF row_count() > 0 THEN
        SET _inventory_id = last_insert_id();
        
        UPDATE `order` o, lot_status l
           SET quantity_made = quantity_made + _quantity,
               quantity_in_process = if(quantity_in_process < _quantity, 0, quantity_in_process - _quantity)
         WHERE l.id = _lot_id
           AND l.order_id = o.id;
        
        IF row_count() >= 0 THEN
        -- update lot history
          CALL end_lot_step(
            _lot_id,
            _lot_alias,
            _ship_timecode,
            _shipper_id,
            _quantity,
            null,
            null,
            _process_id,
            _sub_process_id,
            _position_id,
            _sub_position_id,
            _step_id,
            _response);
            
          IF _response IS NULL THEN
            COMMIT;
          ELSE
            ROLLBACK;
          END IF;
        ELSE
          ROLLBACK;
        END IF;
      ELSE
        ROLLBACK;
        SET _response = concat('Database error encountered when shipping lot ', _lot_id , ' to warehouse');
      END IF;
      
    END IF;
    
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_lot_step` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'PIPES_AS_CONCAT,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `start_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _check_autostart tinyint(1) unsigned,
  IN _start_quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _comment text,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
  -- doesn't check if operator has access to the step, because for autostart, even the operator
  -- only has access to previous step, this step can still be automaically started when previouse step
  -- is ended by the operator.
  -- start form will check employee access though.
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _result varchar(255);
  DECLARE _step_type varchar(20);
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  
 
  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch identifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);
    
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSEIF _response IS NULL
    THEN
      -- start step under two cases: 1. started by start form (_check_autostart = 0)
      -- 2. auto started after another step ends and called by stored procedure (_check_autostart=1)
      -- 3. hold lot step type always autostart, regardless whether it is configured this way
      IF _check_autostart = 0 OR 
        (_check_autostart > 0 
           AND (_if_autostart > 0 OR _step_type='hold lot')
           AND _lot_status = 'in transit' 
           AND _step_status = 'ended'
        )
      THEN

  
        IF _process_id IS NULL 
          AND _sub_process_id IS NULL 
          AND _position_id IS NULL
          AND _sub_position_id IS NULL
          AND _step_id IS NULL
        THEN  -- new step informaiton wasn't supplied
        
          SET _process_id = _process_id_p;
          SET _sub_process_id = _sub_process_id_n;
          SET _position_id = _position_id_n;
          SET _sub_position_id = _sub_position_id_n;
          SET _step_id = _step_id_n;
        ELSEIF _process_id<=>_process_id_p 
              AND _sub_process_id<=>_sub_process_id_n
              AND _position_id <=>_position_id_n
              AND _sub_position_id <=>_sub_position_id_n
              AND _step_id <=> _step_id_n
        THEN -- new step information was supplied and checked
          SET _response='';
        ELSE
          SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
        END IF;        
         
        IF (_response IS NULL OR length(_response)=0)  
        THEN
          CASE 
          WHEN _step_type in ('consume material', 'condition')
          THEN
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'in process';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF; 
            
         WHEN _step_type='hold lot'
          THEN            
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            IF (_check_autostart > 0)
            THEN
              SET _comment=CONCAT('Batch ', _lot_alias, ' has been held due to the result from previous step.');
            END IF;
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'hold';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF;             

         -- END IF;
         END CASE;
        END IF;


      END IF;
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_ingredient`
--

/*!50001 DROP TABLE IF EXISTS `view_ingredient`*/;
/*!50001 DROP VIEW IF EXISTS `view_ingredient`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_ingredient` AS select `i`.`recipe_id` AS `recipe_id`,`i`.`source_type` AS `source_type`,`i`.`ingredient_id` AS `ingredient_id`,`p`.`name` AS `name`,`p`.`description` AS `description`,`i`.`quantity` AS `quantity`,`i`.`uom_id` AS `uom_id`,`u`.`name` AS `uom_name`,`i`.`order` AS `order`,`i`.`mintime` AS `mintime`,`i`.`maxtime` AS `maxtime`,`i`.`comment` AS `comment` from ((`ingredients` `i` left join `product` `p` on((`p`.`id` = `i`.`ingredient_id`))) left join `uom` `u` on((`u`.`id` = `i`.`uom_id`))) where (`i`.`source_type` = 'product') union select `i1`.`recipe_id` AS `recipe_id`,`i1`.`source_type` AS `source_type`,`i1`.`ingredient_id` AS `ingredient_id`,`m`.`name` AS `name`,`m`.`description` AS `description`,`i1`.`quantity` AS `quantity`,`i1`.`uom_id` AS `uom_id`,`u1`.`name` AS `uom_name`,`i1`.`order` AS `order`,`i1`.`mintime` AS `mintime`,`i1`.`maxtime` AS `maxtime`,`i1`.`comment` AS `comment` from ((`ingredients` `i1` left join `material` `m` on((`m`.`id` = `i1`.`ingredient_id`))) left join `uom` `u1` on((`u1`.`id` = `i1`.`uom_id`))) where (`i1`.`source_type` = 'material') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_lot_in_process`
--

/*!50001 DROP TABLE IF EXISTS `view_lot_in_process`*/;
/*!50001 DROP VIEW IF EXISTS `view_lot_in_process`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_lot_in_process` AS select `s`.`id` AS `id`,`s`.`alias` AS `alias`,`s`.`product_id` AS `product_id`,`pr`.`name` AS `product`,`s`.`priority` AS `priority`,`p`.`name` AS `priority_name`,`get_local_time`(`s`.`dispatch_time`) AS `dispatch_time`,`s`.`process_id` AS `process_id`,`pc`.`name` AS `process`,`h`.`sub_process_id` AS `sub_process_id`,ifnull(NULL,(select `pcs`.`name` AS `name` from `process` `pcs` where (`pcs`.`id` = `h`.`sub_process_id`))) AS `sub_process`,`h`.`position_id` AS `position_id`,`h`.`sub_position_id` AS `sub_position_id`,`h`.`step_id` AS `step_id`,`st`.`name` AS `step`,`s`.`status` AS `lot_status`,`h`.`status` AS `step_status`,`get_local_time`(str_to_date(`h`.`start_timecode`,'%Y%m%d%H%i%s0')) AS `start_time`,`get_local_time`(str_to_date(`h`.`end_timecode`,'%Y%m%d%H%i%s0')) AS `end_time`,`h`.`start_timecode` AS `start_timecode`,`s`.`actual_quantity` AS `actual_quantity`,`s`.`uomid` AS `uomid`,`u`.`name` AS `uom`,`s`.`contact` AS `contact`,concat(`e`.`firstname`,' ',`e`.`lastname`) AS `contact_name`,`h`.`equipment_id` AS `equipment_id`,`eq`.`name` AS `equipment`,`h`.`device_id` AS `device_id`,`h`.`approver_id` AS `approver_id`,`s`.`comment` AS `comment`,`h`.`result` AS `result`,`st`.`emp_usage` AS `emp_usage`,`st`.`emp_id` AS `emp_id` from (((((((((`lot_status` `s` join `lot_history` `h` on(((`h`.`lot_id` = `s`.`id`) and (`h`.`process_id` = `s`.`process_id`) and (`h`.`start_timecode` = (select max(`h1`.`start_timecode`) AS `max(h1.start_timecode)` from `lot_history` `h1` where (`h1`.`lot_id` = `h`.`lot_id`))) and (isnull(`h`.`end_timecode`) or ((not(exists(select 1 AS `Not_used` from `lot_history` `h2` where ((`h2`.`lot_id` = `h`.`lot_id`) and (`h2`.`start_timecode` = `h`.`start_timecode`) and isnull(`h2`.`end_timecode`))))) and (`h`.`end_timecode` = (select max(`h3`.`end_timecode`) AS `max(h3.end_timecode)` from `lot_history` `h3` where (`h3`.`lot_id` = `h`.`lot_id`)))))))) left join `product` `pr` on((`pr`.`id` = `s`.`product_id`))) left join `process` `pc` on((`pc`.`id` = `s`.`process_id`))) left join `step` `st` on((`st`.`id` = `h`.`step_id`))) left join `uom` `u` on((`u`.`id` = `s`.`uomid`))) left join `priority` `p` on((`p`.`id` = `s`.`priority`))) left join `employee` `e` on((`e`.`id` = `s`.`contact`))) left join `equipment` `eq` on((`eq`.`id` = `h`.`equipment_id`))) left join `employee` `ea` on((`ea`.`id` = `h`.`approver_id`))) where (`s`.`status` not in ('shipped','scrapped')) order by `s`.`product_id`,`s`.`priority`,`s`.`dispatch_time` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_process_step`
--

/*!50001 DROP TABLE IF EXISTS `view_process_step`*/;
/*!50001 DROP VIEW IF EXISTS `view_process_step`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_process_step` AS select `ps`.`process_id` AS `process_id`,`ps`.`position_id` AS `position_id`,`ps`.`step_id` AS `step_id`,`ps`.`prev_step_pos` AS `prev_step_pos`,`ps`.`next_step_pos` AS `next_step_pos`,`ps`.`false_step_pos` AS `false_step_pos`,`ps`.`rework_limit` AS `rework_limit`,`ps`.`if_sub_process` AS `if_sub_process`,if(`ps`.`if_sub_process`,'Y','N') AS `YN_sub_process`,`ps`.`prompt` AS `prompt`,`ps`.`if_autostart` AS `if_autostart`,if(`ps`.`if_autostart`,'Y','N') AS `YN_autostart`,`ps`.`need_approval` AS `need_approval`,if(`ps`.`need_approval`,'Y','N') AS `YN_need_approval`,`ps`.`approve_emp_usage` AS `approve_emp_usage`,`ps`.`approve_emp_id` AS `approve_emp_id`,if((`ps`.`approve_emp_usage` = 'employee'),(select concat(`e`.`firstname`,' ',`e`.`lastname`) AS `concat(e.firstname, ' ', e.lastname)` from `employee` `e` where (`e`.`id` = `ps`.`approve_emp_id`)),(select `eg`.`name` AS `name` from `employee_group` `eg` where (`eg`.`id` = `ps`.`approve_emp_id`))) AS `approve_emp_name` from `process_step` `ps` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-14 11:50:09
