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