CREATE DEFINER=`root`@`localhost` PROCEDURE `get_approvers`(
	IN _process_id int(10) unsigned,
    IN _position_id int(10) unsigned
    )
BEGIN
	DECLARE _approver_usage enum('user', 'user_group', 'organization');
    
    SELECT approver_usage
    INTO _approver_usage
    FROM process_step
    WHERE process_id = _process_id AND position_id = _position_id;
    
    IF _approver_usage = 'user'
    THEN
		SELECT id, firstname + ' ' + lastname
        FROM employee;
	ELSEIF _approver_usage = 'user_group'
    THEN
		SELECT id, name
        FROM employee_group;
	ELSE
		SELECT id, name
        FROM organization;
	END IF;
END