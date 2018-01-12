DROP PROCEDURE IF EXISTS `modify_recipe`;
CREATE PROCEDURE `modify_recipe`(
  IN _created_by int(10) unsigned,
  INOUT _recipe_id int(10) unsigned,
  IN _name varchar(20),
  IN _exec_method enum ('ordered', 'random'),
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
    SET _response = 'Execution Method is required. It must be either "ordered" or "random"';
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
END;
