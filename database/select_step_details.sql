DROP PROCEDURE IF EXISTS `select_step_details`;
CREATE PROCEDURE `select_step_details`(
  IN _step_id int(10) unsigned
)
BEGIN
  SELECT s.name AS step_name,
         s.step_type_id,
         st.name as step_type_name,
         s.version,
         s.state,
         s.eq_usage,
         s.eq_id,
         IF (s.eq_usage='equipment',
             (SELECT eq.name FROM equipment eq WHERE eq.id =s.eq_id ),
             (SELECT eqg.name FROM equipment_group eqg WHERE eqg.id = s.eq_id)) AS eq_name,
         s.emp_usage,
         s.emp_id,
         IF (s.emp_usage = 'employee',
             (SELECT concat(e2.firstname, ' ', e2.lastname) FROM employee e2 WHERE e2.id = s.emp_id),
             (SELECT eg2.name FROM employee_group eg2 WHERE eg2.id = s.emp_id)) AS emp_name,
         s.recipe_id,
         s.mintime,
         s.maxtime,
         s.description,
         s.comment AS step_comment,
         s.para1,
         s.para2,
         s.para3,
         s.para4,
         s.para5,
         s.para6,
         s.para7,
         s.para8,
         s.para9,
         s.para10,
         r.name as recipe_name,
         r.exec_method,
         r.contact_employee,
         (SELECT concat(e3.firstname, ' ', e3.lastname) FROM employee e3 WHERE e3.id = r.contact_employee) AS contact_employee_name,
         r.instruction,
         r.diagram_filename,
         r.comment AS recipe_comment
    FROM step s 
         LEFT JOIN recipe r ON r.id = s.recipe_id
         LEFT JOIN step_type st ON st.id = s.step_type_id
   WHERE s.id = _step_id
  ;
END; 