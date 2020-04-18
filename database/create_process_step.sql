/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table holds the relationship between process and its contained steps or sub processes.
*                             If if_sub_process=1, the step_id correspond to a process_id that constitutes the sub process at the position
*                             Recursive process only limit to 1 level deep in this software
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/09/2018: xdong: added new column product_made to mark whether a final step produces the product desired	
*    04/15/2020: xdong: added new column: step_options for holding reposition option list		
*                       added new column approver_usage for determine whether approver is a user group, organization or particular user
*                       dropped column approve_emp_usage column, for it is replaced with above approver_usage
*/
DELIMITER $ 
DROP TABLE IF EXISTS `process_step`$
CREATE TABLE `process_step` (
  `process_id` int(10) unsigned NOT NULL,  -- id of the workflow/process
  `position_id` int(5) unsigned NOT NULL,  -- position of the step, starting from 1, unique within a process
  `step_id` int(10) unsigned NOT NULL,   -- id of the step or sub process at the position
  `prev_step_pos` int(5) unsigned DEFAULT NULL,  -- previous step position id
  `next_step_pos` int(5) unsigned DEFAULT NULL, -- next step position id
  `false_step_pos` int(5) unsigned DEFAULT NULL,  -- for condition step, if failed condition, the step/position id to go
  `step_options` varchar(255) DEFAULT NULL, -- currently, for providing a list of allowed reposition positions for reposition step type
                                            -- for example, if a reposition step only allow user to reposition to one of the following positions:
                                            -- 1, 3, 5, then this field will be filled as "1,3,5"  (comma separated list). If a reposition step
                                            -- has no this field filled, then all the positions in the current workflow except the resposition step
                                            -- itself will be show as possible choices for reposition.
  `segment_id` int(5) unsigned DEFAULT NULL,  -- process can be dividied into segments. The segment that the position/step belong to.
  `rework_limit` smallint(2) unsigned NOT NULL DEFAULT '0', -- the max number of times that the position/step can be revisited by a batch. 0 means no limit
  `if_sub_process` tinyint(1) unsigned NOT NULL DEFAULT '0', -- if the step points to a sub process. If 1, step_id corresponds to an id in process table. 
                                                             -- otherwise, it correpsonds to an id in step table
  `prompt` varchar(255) DEFAULT NULL,  -- prompt for user when batch comes to the step/position
  `if_autostart` tinyint(1) unsigned NOT NULL default '1', -- whether to automatically start this step after previous step finished
  `need_approval` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether need another employee or employee group or employ category to approve when ending the step
  `approve_emp_usage` enum('user group', 'organization','user') DEFAULT NULL, -- if need_approval = 1, this field determine whether a particular employee
                                                                                          -- or a particular employee category or a partcular employee group can
                                                                                          -- approve the execution of the step
  `approver_usage` enum('user group', 'organization','user') DEFAULT NULL, -- if need_approval = 1, this field determine whether a particular user
                                                                                          -- or a particular organization (this is big) or a partcular user group can
                                                                                          -- approve the execution of the step
  `approve_emp_id` int(10) unsigned DEFAULT NULL, -- approved employee or group or category id
  `product_made` tinyint(1) unsigned NOT NULL DEFAULT 0,  -- it will only be 1 if completion of the step produce the final product ordered
                                                          -- however, even at the step, the product is made, the process may not finish,
                                                          -- there can still be more steps after product made as post processing, such as ship or warranty etc
  PRIMARY KEY (`process_id`,`position_id`,`step_id`)
) ENGINE=InnoDB$