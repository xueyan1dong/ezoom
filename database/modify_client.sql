/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_client.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_client`$
CREATE PROCEDURE `modify_client`(
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
END$



