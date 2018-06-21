/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_client_document.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_client_document`$
CREATE PROCEDURE `modify_client_document`(
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
  


END$
