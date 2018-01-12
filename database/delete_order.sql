-- an order may never should be deleted. This is a temporary function. 
-- In the future, we may need to be more sophisticated, 
--   like closing an order and move the records to an archive table, instead of deleting.  -- X.D. 

DROP PROCEDURE IF EXISTS `delete_order`;
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
     
END;
