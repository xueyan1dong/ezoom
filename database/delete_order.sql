/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : delete_order.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose

-- an order may never should be deleted. This is a temporary function. 
-- In the future, we may need to be more sophisticated, 
--   like closing an order and move the records to an archive table, instead of deleting.  -- X.D. 

DROP PROCEDURE IF EXISTS `delete_order`$
CREATE PROCEDURE `delete_order`(
  IN _order_id int(10) unsigned
)
BEGIN
    DELETE FROM order_state_history
     WHERE order_id = _order_id;
    DELETE FROM order_detail
     WHERE order_id = _order_id;
    DELETE FROM order_general
     WHERE id = _order_id;
     
END$
