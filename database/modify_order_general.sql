/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_order_general`$
CREATE PROCEDURE `modify_order_general`(
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
END$
