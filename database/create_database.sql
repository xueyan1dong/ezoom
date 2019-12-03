-- run this script with command mysql -u<username> -p<password> < create_database.sql

-- create database , if need different database name, change the name in below 3 lines.
DROP DATABASE if EXISTS ezMES;
CREATE DATABASE ezMES;
USE ezMES;

-- create tables
source create_company.sql;
source create_client.sql;
source create_attribute_history.sql;
source create_config_history.sql;

source create_organization.sql;
source create_employee_group.sql;
source create_employee.sql;

source create_location.sql;
source create_equipment_group.sql;
source create_equipment.sql;
source create_eq_attributes.sql;
source create_equip_history.sql;

source create_uom.sql;
source create_uom_conversion.sql;

source create_recipe.sql;
source create_ingredients.sql;
source create_ingredients_history.sql;

source create_inventory.sql;
source create_inventory_consumption.sql;

source create_material_group.sql;
source create_material.sql;
source create_material_supplier.sql;
source create_order_general.sql;
source create_order_detail.sql;
source create_order_state_history.sql;

source create_organization.sql;
source create_root_org_type.sql;

source create_product_group.sql;
source create_product.sql;
source create_pd_attributes.sql;

source create_step_type.sql;
source create_step.sql;

source create_process_group.sql;
source create_process.sql;
source create_process_segment.sql;
source create_process_step.sql;
source create_process_step_history.sql;

source create_product_process.sql;

source create_lot_status.sql;
source create_lot_history.sql;

source create_priority.sql;

source create_document.sql;

source create_feedback.sql;

source create_consumption_return.sql;

-- create views
source view_process_step.sql;
source view_ingredient.sql;
source view_lot_in_process.sql;

-- load initial data
 source load_init_data.sql;

-- install stored procedures

delimiter $

source insert_inventory.sql$
source autoload_inventory.sql$
source modify_material_group.sql$
source modify_material.sql$
source delete_material.sql$
source autoload_material.sql$
source insert_order_general.sql$
source modify_order_general.sql$
source modify_order_detail.sql$
source delete_order.sql$

source modify_client.sql$
source autoload_client.sql$
source modify_equipment.sql$
source delete_equipment.sql$

source modify_employee.sql$

source delete_uom.sql$
source modify_uom.sql$
source insert_uom_conversion.sql$

source modify_product.sql$
source add_attribute_to_product.sql$

source modify_recipe.sql$
source add_ingredient_to_recipe.sql$
source remove_ingredient_from_recipe.sql$
source modify_ingredient_in_recipe.sql$
source delete_recipe.sql$

source insert_process.sql$
source modify_process.sql$
source delete_process.sql$
source modify_segment.sql$
source modify_step.sql$
source add_step_to_process.sql$
source modify_step_in_process.sql$
source delete_step_from_process.sql$

source modify_client_document.sql$

source associate_product_process.sql$

source consume_inventory.sql$
source return_inventory.sql$

source report_process_bom.sql$
source report_process_bom_total.sql$
source report_process_cycletime.sql$
source report_product_quantity.sql$
source report_lot_status.sql$
source report_lot_history.sql$
source report_dispatch history.sql$
source report_product_in_process.sql$
source report_consumption_for_step.sql$
source report_consumption_details.sql$
source report_order_quantity.sql$

source issue_feedback.sql$

source select_step_details.sql$

source get_next_step_for_lot.sql$
source get_rework_count_for_lot.sql$
source check_emp_access.sql$
source check_approver.sql$

source pass_lot_step.sql$
source dispatch_multi_lots.sql$
source dispatch_single_lot.sql$
source start_lot_step.sql$
source ship_lot.sql$
source end_lot_step.sql$
source deliver_lot.sql$
source scrap_lot.sql$

-- functions
source get_local_time.sql$
source convert_quantity.sql$