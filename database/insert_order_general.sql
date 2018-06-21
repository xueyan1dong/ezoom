/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : insert_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `insert_order_general`$
CREATE PROCEDURE `insert_order_general`(
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
END$
