/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : view_lot_in_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    11/29/2018: Junlu Luo: Added order_line_num and finish columns to output	
*    12/02/2018: Xueyan Dong: Added order_id column to output	
*    12/04/2018: Xueyan Dong: Added quantity_status to output	
*    01/29/2019: Xueyan Dong: Added value1 to output
*/
DELIMITER $ 
DROP VIEW IF EXISTS `view_lot_in_process`$
CREATE ALGORITHM = MERGE VIEW `view_lot_in_process` AS
 SELECT s.id,
        s.alias,
        s.product_id,
        pr.name as product,
        s.priority,
        p.name as priority_name,
        get_local_time(s.dispatch_time) as dispatch_time,
        s.process_id,
        pc.name as process,       
        h.sub_process_id,
        ifnull(null, (SELECT pcs.name FROM process pcs WHERE pcs.id = h.sub_process_id)) AS sub_process,
        h.position_id,
        h.sub_position_id,
        h.step_id,
        st.name AS step,
        s.status AS lot_status,
        h.status AS step_status,
        get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) AS start_time,
        get_local_time(str_to_date(h.end_timecode, '%Y%m%d%H%i%s0' )) AS end_time,
        h.start_timecode,
        s.actual_quantity,
        s.uomid,
        u.name AS uom,
        s.contact,
        CONCAT(e.firstname, ' ', e.lastname) AS contact_name,
        h.equipment_id,
        eq.name as equipment,
        h.device_id,
        h.approver_id,
        s.comment,
        h.result,
        st.emp_usage,
        st.emp_id,
		h.location_id,
		og.ponumber,
		s.order_line_num,
		pr.description as finish,
    s.order_id,
    s.quantity_status,
    s.value1
   FROM lot_status s 
	JOIN order_general as og ON s.order_id = og.id
        INNER JOIN lot_history h ON h.lot_id = s.id
                                 AND h.process_id = s.process_id
                                 AND h.start_timecode = (SELECT max(h1.start_timecode)
                                                           FROM lot_history h1
                                                          WHERE h1.lot_id = h.lot_id
                                                         )
                                 AND (h.end_timecode IS NULL OR 
                                         (
                                         NOT EXISTS (SELECT * FROM lot_history h2
                                                      WHERE h2.lot_id = h.lot_id
                                                        AND h2.start_timecode = h.start_timecode
                                                        AND h2.end_timecode IS NULL)
                                          AND h.end_timecode = (SELECT max(h3.end_timecode)
                                                                  FROM lot_history h3
                                                                 WHERE h3.lot_id = h.lot_id)))
        LEFT JOIN product pr ON pr.id = s.product_id
        LEFT JOIN process pc ON pc.id = s.process_id
        LEFT JOIN step st ON st.id = h.step_id
        LEFT JOIN uom u ON u.id = s.uomid
        LEFT JOIN priority p ON p.id = s.priority
        LEFT JOIN employee e ON e.id = s.contact
        LEFT JOIN equipment eq ON eq.id = h.equipment_id
        LEFT JOIN employee ea ON ea.id = h.approver_id
  WHERE s.status NOT IN ('shipped', 'scrapped')
  /* and h.lot_id not in 
        (Select lot_id from process_step ps, lot_history lh
			where lh.position_id = ps.position_id 
				and lh.step_id = ps.step_id 
                and lh.process_id = ps.process_id
                and ps.next_step_pos is null
                and lh.status = 'ended') */
  ORDER BY s.product_id, s.priority, s.dispatch_time
     $
