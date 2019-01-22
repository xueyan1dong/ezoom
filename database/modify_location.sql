/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_location.sql
*    Created By             : Peiyu Ge
*    Date Created           : 12/21/2018
*    Platform Dependencies  : MySql
*    Description            : Insert or update location into the location table
*    example	            : 
*    Log                    : 1/21/2019 fixed the error: can not insert or update when all adjacent locations are null when there exists a different named location with all null ajdacent locations
*/
DELIMITER $

DROP PROCEDURE IF EXISTS `modify_location`$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_location`(
  INOUT _location_id int(10) unsigned,
  IN _name varchar(255),
  IN _parent_loc_id int(11) unsigned,
  IN _adjacent_loc_id1 int(5) unsigned,
  IN _adjacent_loc_id2 int(5) unsigned,
  IN _adjacent_loc_id3 int(5) unsigned,
  IN _adjacent_loc_id4 int(5) unsigned,
  IN _contact_employee int(10) unsigned,
  IN _description varchar(255),
  IN _comment text,
  OUT _response varchar(255))
BEGIN
	DECLARE created_time datetime;
    DECLARE ifexist varchar(255);
    DECLARE ifoccupied varchar(255);
    If _name is Null Or Length(Trim(_name)) = 0 Then
		Set _response = "Location name is missing.";
	Elseif _contact_employee is Null Then
		Set _response = "Contact Employee is missing.";
	Elseif _adjacent_loc_id1 = _adjacent_loc_id2 or _adjacent_loc_id1 = _adjacent_loc_id3 or _adjacent_loc_id1 = _adjacent_loc_id4 or _adjacent_loc_id2 = _adjacent_loc_id3 or _adjacent_loc_id2 = _adjacent_loc_id4 or _adjacent_loc_id3 = _adjacent_loc_id4 Then
		Set _response = "Adjacent locations should be different from each other.";
	Elseif _location_id is Null Then -- new location to be inserted
		-- check if already exists location with the same name and same parent location
        Select name into ifexist
        from location
        where name = _name and if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id);
        
        If ifexist is Null Then -- 
        -- check if the location has been occupied: if adjacent four ids are all null or any one of them is null, then we assume the location's physical location is not defined yet
		-- thus ifoccupied is null(can be put in any place); later, when we have more knowledge about adjacent locations and what are valid combination of four adjacent locations
		-- we need to add check adjacent location combinations are valid.
			If (_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is not null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is not null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is not null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is not null) Then
				Set ifexist = null;
			Else
				Select name into ifoccupied
				From location
				where if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
				and if(_adjacent_loc_id1 is null, adjacent_loc_id1 is null, adjacent_loc_id1 = _adjacent_loc_id1)
				and if(_adjacent_loc_id2 is null, adjacent_loc_id2 is null, adjacent_loc_id2 = _adjacent_loc_id2)
				and if(_adjacent_loc_id3 is null, adjacent_loc_id3 is null, adjacent_loc_id3 = _adjacent_loc_id3)
				and if(_adjacent_loc_id4 is null, adjacent_loc_id4 is null, adjacent_loc_id4 = _adjacent_loc_id4)
				and name != _name;
            End if;
			
			If ifoccupied is Null Then -- insert new location
				INSERT INTO location (
					name,
					parent_loc_id,
					create_time,
					update_time,
					contact_employee,
					adjacent_loc_id1,
					adjacent_loc_id2,
					adjacent_loc_id3,
					adjacent_loc_id4,
					description,
					comment
				  )
				  VALUES (
					_name,
					_parent_loc_id,
					Now(),
					Null,
					_contact_employee,
					_adjacent_loc_id1,
					_adjacent_loc_id2,
					_adjacent_loc_id3,
					_adjacent_loc_id4,
					_description,
					_comment
				  );
				  SET _location_id = last_insert_id();
			Else
				Set _response = Concat("The location you are about to insert into is occupied by ", ifoccupied, " .");
			End If;
		Else
			Set _response = Concat("The location name \"", ifexist, "\" alread exists.");
		End If;
	Elseif _location_id is not Null Then -- update location
		Select name into ifexist
        from location
        where name = _name
        and if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
        and id != _location_id; -- For a same parent location, exists a same named location
        
        If ifexist is Null Then
		
			If (_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is not null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is not null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is not null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is not null) Then
				Set ifoccupied = null;
			Else
				Select name into ifoccupied
				from location
				where if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
				and if(_adjacent_loc_id1 is null, adjacent_loc_id1 is null, adjacent_loc_id1 = _adjacent_loc_id1)
				and if(_adjacent_loc_id2 is null, adjacent_loc_id2 is null, adjacent_loc_id2 = _adjacent_loc_id2)
				and if(_adjacent_loc_id3 is null, adjacent_loc_id3 is null, adjacent_loc_id3 = _adjacent_loc_id3)
				and if(_adjacent_loc_id4 is null, adjacent_loc_id4 is null, adjacent_loc_id4 = _adjacent_loc_id4)
				and id != _location_id; -- check if exists another id that has the same adjacent locations
			End if;
            
            If ifoccupied is Null Then
				Select create_time into created_time
                from location
                where id = _location_id;
                
				Update location
					Set name = _name,
						parent_loc_id = _parent_loc_id,
                        contact_employee = _contact_employee,
                        create_time = created_time,
                        update_time = Now(),
                        adjacent_loc_id1 = _adjacent_loc_id1,
						adjacent_loc_id2 = _adjacent_loc_id2,
						adjacent_loc_id3 = _adjacent_loc_id3,
						adjacent_loc_id4 = _adjacent_loc_id4,
                        description = _description,
                        comment = _comment
					where id = _location_id;
			Else
				Set _response = Concat("The updated location is occupied by ", ifoccupied, " .");
			End if;
		Else
			Set _response = Concat("The updated location name \"", ifexist, "\" alread exists.");           
        End if;
        
	End if;
    
END$