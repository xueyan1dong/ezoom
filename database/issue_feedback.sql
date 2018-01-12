DROP PROCEDURE IF EXISTS `issue_feedback`;
CREATE PROCEDURE `issue_feedback`(
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
END;
