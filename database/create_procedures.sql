
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