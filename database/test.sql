SELECT i.ingredient_id 
                   FROM ingredients i, recipe r, step s, process_step ps, process p
                  WHERE i.source_type = 'material'
                    AND i.ingredient_id = 1
                    AND r.id = i.recipe_id
                    AND s.recipe_id = r.id
                    AND ps.step_id = s.id
                    AND p.id = ps.process_id
                    AND p.state='production'
SELECT m.name,
                             (select s.supplier_id FROM material_supplier s WHERE s.material_id = m.id ORDER BY s.preference limit 1) AS alias,
                             m.mg_id,
                             m.material_form,
                             m.status,
                             CAST(m.lot_size AS unsigned integer) AS lot_size,
                             CAST(m.alert_quantity AS unsigned integer) AS alert_quantity,
                             m.uom_id,
                             m.description,
                             m.comment 
                        FROM material m
                       WHERE m.id = 1
 call autoload_inventory (
  2,
   'material',
  6,
  4, -- if no supplier use 0
  '00-08519',
  '2011-2-10',
  null,
  null,
  '30.00',
  'unit',
  '2011-2-10',
  null,
  '2011-2-20',
  null,
  null,
 @_inventory_id,
 @_response
);
select @_inventory_id, substring(@_response, 1, 200);

 set @dc_def_id=null;
 call `modify_dc_def_main`(
  @dc_def_id,
  1,
  'production', 
  'test',
  2,
  'product',
  'test',
  'test',
  @response
);

    SELECT *

      FROM view_lot_in_process
     WHERE id=27

    SELECT position_id,
           sub_position_id,
           h.status,
           h.start_timecode,
           h.end_timecode,
           -- sum(if(h.status in ('error', 'stopped'), 0, 1)),
           -- sum(timestampdiff(minute, str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' ), str_to_date(h.end_timecode, '%Y%m%d%H%i%s0') )),
           avg(100 * h.end_quantity/h.start_quantity)
      FROM lot_status l, lot_history h 
     WHERE l.product_id = 1
       AND l.process_id = 1
       AND h.lot_id = l.id
       AND h.status not in ('dispatched', 'started', 'restarted')
       AND h.start_quantity != 0
     GROUP BY position_id, sub_position_id;

SELECT i.id as ingredient_id,
       0.00 as required_quantity,
       0.00 as used_quantity,
       (select u.name FROM uom u, ingredients g WHERE g.source_type = 'material' AND g.ingredient_id=3 AND u.id = g.uom_id) as uom_name,
       '' as comment
  FROM  inventory i
   limit 1
select * from employee
select @dc_def_id, @response;
SHOW columns FROM uom_conversion LIKE 'method'
call `insert_dc_def_attr`(
  1,
  1,
  'anotherTemp12',
  'unsigned integer', 
  3,
  null,
  1,
  null,
  100,
  0,
  null,
  'test',
  'test',
  @response
);
select substring(@response,1,30);
call  `inactivate_dc_def_main`(
  1,
  1,
  @response
);
select substring(@response,1,30);
 call `modify_dc_def_attr`(
  1,
  1,
 5, 
  'anotherTemp5',
  'varchar',
 5,
  null,
  2,
  null,
  null,
  null,
  null,
  'test',
  'test',
  @response);
  select substring(@response, 1, 300);
  
  call `drop_dc_def_attr`(
  1,
  1,
  'anotherTemp10',
  10, 
  @response);
  select substring(@response, 1, 300);

  SELECT * FROM dc_def_attr WHERE def_id = 1 AND attr_id = 5;
  select * from attribute_history where attr_id = 5;
  select * from dc_def_main where id = 1;
  select event_time, source_table, source_id, substring(comment, 1, 250) from config_history where source_id = 1;

SELECT table_name
FROM information_schema.tables
WHERE table_name = 'dc_1_1';

show tables like 'dc_1_1'
if exists (SELECT *
FROM information_schema.tables
WHERE table_name = 'dc_1_1') then
select 'yes';
else
select 'no';
end if;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dc_1_2' AND COLUMN_NAME = 'attr_4'

CALL create_data_table(
  'ezmes',
  1
)\


 SELECT g.id, 
  g.order_type, 
  g.ponumber, 
  g.client_id,
  c.name as ClientName,
  g.priority,
  p.Name as PriName,
  d.source_id, 
  p.name as ProductName,
  d.quantity_requested, 
  d.quantity_made, 
  d.quantity_in_process, 
  d.quantity_shipped, 
  d.uomid,
  u.Name as uom,
  (SELECT max(state_date) FROM order_state_history h WHERE h.order_id = g.id) AS order_date,
  d.output_date, 
  d.expected_deliver_date, 
  d.actual_deliver_date, 
  g.internal_contact,
  CONCAT(e.firstname,' ',e.lastname) as internal_contact_name,
  g.external_contact, 
  d.comment 
  FROM order_general g
  INNER JOIN order_detail d ON d.order_id = g.id AND d.source_type = 'product'
  INNER JOIN product p ON d.source_type = 'product' AND d.source_id = p.id
  LEFT JOIN client c ON g.client_id = c.id 
  LEFT JOIN priority ON g.priority = p.id 
  LEFT JOIN uom u ON d.uomid = u.id 
  LEFT JOIN employee e ON g.internal_contact = e.id
  WHERE g.order_type in ('inventory', 'customer');
  
   SELECT  (SELECT PP.process_id 
           FROM product_process pp 
           WHERE PP.product_id = p.id) as process_id, 
            p.lot_size,
            1 as num_lots,
            p.name as alias_prefix,
            o.internal_contact as lot_contact,
            o.priority as lot_priority,
          substr(o.comment,0,0) as comment
  FROM `order_general` o, order_detail d, product p 
 WHERE o.id= ? and d.order_id = o.id
   AND d.source_type = 'product'
   AND d.source_id = p.id
   
      SELECT  (SELECT PP.process_id 
           FROM product_process pp 
           WHERE PP.product_id = p.id) as process_id, 
            p.lot_size,
            1 as num_lots,
            p.name as alias_prefix,
            o.internal_contact as lot_contact,
            o.priority as lot_priority,
          substr(o.comment,0,0) as comment
  FROM `order_general` o, order_detail d, product p 
 WHERE o.id= 4 and d.order_id = o.id
   AND d.source_type = 'product'
   AND d.source_id = 1
   AND p.id = d.source_id
   
   SELECT id, name 
   FROM process p, product_process pp 
   WHERE pp.product_id=1 
      and p.id=pp.process_id 
      order by pp.priority desc
   
  SELECT (SELECT PP.process_id 
           FROM product_process pp 
           WHERE PP.product_id = p.id ORDER BY pp.priority limit 1) as process_id, 
            p.lot_size,
            1 as num_lots,
            p.name as alias_prefix,
            o.internal_contact as lot_contact,
            o.priority as lot_priority,
          substr(o.comment,0,0) as comment
  FROM `order_general` o, order_detail d, product p 
 WHERE o.id= 4 and d.order_id = o.id
   AND d.source_type = 'product'
   AND d.source_id = 1
   AND p.id = d.source_id
   
   SELECT  p.name as ProductName,
            (SELECT PP.process_id 
           FROM product_process pp 
           WHERE PP.product_id = p.id ORDER BY pp.priority desc LIMIT 1) as process_id, 
            p.lot_size,
            u.name as uom,
            1 as num_lots,
            p.name as alias_prefix,
            o.internal_contact as lot_contact,
            o.priority as lot_priority,
          substr(o.comment,0,0) as comment
  FROM `order_general` o
  INNER JOIN order_detail d ON d.order_id = o.id
  INNER JOIN product p ON d.source_type = 'product' AND d.source_id=1 AND p.id = d.source_id
  LEFT JOIN uom u ON p.uomid =u.id
 WHERE o.id= 4 
 SELECT * FROM lot_status WHERE alias='test0000000001'
 call `dispatch_multi_lots`(
  4, 
  1,
  1,
  1,
  2,
  'test', 
  1,
  3,
  'test',
  1,
  @response
);
 select substring(@response, 1, 300);
 select @lot_id;
 
 UNLOCK  lot_status
 
         INSERT INTO lot_status(
          alias,
          order_id,
          product_id,
          process_id,
          status,
          start_quantity,
          actual_quantity,
          uomid,
          update_timecode,
          contact,
          priority,
          dispatcher,
          dispatch_time,
          comme
          )
          VALUES
          (
            'test0000000001',
            4,
            1,
            1,
            'dispatched',
            1,
            1,
            1,
            DATE_FORMAT(now(), '%Y%m%d%H%i%s0'),
            1,
            3,
            1,
            now(),
            ''  
        )
 commit
 
 show columns from employee like 'status'
 
     SELECT lot_id
      FROM lot_history
     WHERE start_timecode between 
               DATE_FORMAT('2010-11-08 02:00', '%Y%m%d%H%i%s0')
           AND DATE_FORMAT('2010-11-10 02:00', '%Y%m%d%H%i%s0')
       AND status = 'dispatched'
       
    call   report_dispatch_history ('2010-11-08', '2010-11-10', @response)
 
 SELECT id,
        alias,
        product_id,
        product,
        process_id,
        pc.name as process,
        h.sub_process_id,
        ifnull(null, (SELECT pcs.name FROM process pcs WHERE pcs.id = h.sub_process_id)) AS sub_process,
        h.position_id,
        h.sub_position_id,
        h.step_id,
        st.name AS step,
        h.status,
        str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' ) AS start_time,
        str_to_date(h.end_timecode, '%Y%m%d%H%i%s0' ) AS end_time,
        h.end_timecode,
        s.actual_quantity,
        s.uomid,
        u.name AS uom,
        s.contact,
        s.priority,
        p.name as priority_name,
        s.comment
   FROM lot_status s 
        INNER JOIN lot_history h ON h.lot_id = s.id
                                 AND h.process_id = s.process_id
                                 AND h.start_timecode = (SELECT max(h1.start_timecode)
                                                           FROM lot_history h1
                                                          WHERE h1.lot_id = h.lot_id)
        LEFT JOIN product pr ON pr.id = s.product_id
        LEFT JOIN process pc ON pc.id = s.process_id
        LEFT JOIN step st ON st.id = h.step_id
        LEFT JOIN uom u ON u.id = s.uomid
        LEFT JOIN priority p ON p.id = s.priority
  WHERE s.status NOT IN ('shipped', 'scrapped')
         
SELECT id,
        alias,
        product_id,
        product,
        priority,
        priority_name,
        dispatch_time,
        process_id,
        process,
        sub_process_id,
        sub_process,
        position_id,
        sub_position_id,
        step_id,
        step,
        lot_status,
        step_status,
        start_time,
        end_time,
        actual_quantity,
        uomid,
        uom,
        contact_name,
        equipment_id,
        comment,
        result
   FROM view_lot_in_process
   
           SELECT step_id,
              if_sub_process,
              rework_limit
          INTO @_step_id_n, @_if_sub_process, @_rework_limit
          FROM process_step
        WHERE process_id = 1
          AND position_id = 1; 
          
   
   SELECT min(position_id)
            
            FROM process_step
          WHERE process_id=1;
          
   call get_next_step_for_lot(1,'solarlight0000000001','dispatched',1,null,0,null,'',@_sub_process_id_n,@_position_id_n,@_sub_position_id_n,@_step_id_n,@_step_type,@_rework_limit,@_response)
   call get_next_step_for_lot(2,'RACN-ASL-60000000001','dispatched',1,null,0,null,'',@_sub_process_id_n,@_position_id_n,@_sub_position_id_n,@_step_id_n,@_step_type,@_rework_limit,@_response)
   insert into lot_status
   (id, alias,order_id, product_id, process_id, status, start_quantity, actual_quantity, uomid, update_timecode, contact,
   priority, dispatcher, dispatch_time, output_time, comment)
   select lot_id,
          lot_alias,
          1,
          1,
          1,
          'dispatched',
          start_quantity, 
          end_quantity,
          uomid,
          end_timecode,
          3,
          2,
          3,
          str_to_date(start_timecode, '%Y%m%d%H%i%s0' ),
          null,
          'restored'
     from lot_history h
   
     
      SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as state,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           l.dispatch_time,
           -- l.dispatcher,
           CONCAT (e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT (e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           IF(h2.status in ('dispatched', 'shipped') , 
                 h2.status, 
                 CONCAT (h2.status, ' at step ', IFNULL(s.name, ''))) as curstatus
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
           LEFT JOIN step s ON s.id = h2.step_id
                                           
     WHERE    h.status = 'dispatched'
     
     SELECT '','All Orders'
     UNION
     SELECT od.order_id,
           og.ponumber
       FROM order_detail od, order_general og
      WHERE source_type = 'product'
        AND source_id = @product_id
        AND og.id = od.order_id;
        
     select date_format(utc_timestamp(),'%Y%m%d%H%i%s0')
     
     UPDATE lot_status
             SET status = 'in transit'
                ,actual_quantity = 1
                ,update_timecode = date_format(utc_timestamp(),'%Y%m%d%H%i%s0')
                ,comment='test'
           WHERE id=8;
           
   select substring(comment, 1, 8)
     from lot_status
    where id=10

    SELECT *
      FROM view_lot_in_process
      order by 
      limit 10
     WHERE id=11;
     
    set @process_id = 1;
    set @sub_process_id=null;
    set @position_id=1;
    set @sub_position_id=null;
    set @step_id=1;
    call pass_lot_step (
   11,
  'solarlight0000000011',
  2,
  1,
  null,
  null,
  null,
  'test pass stored procedure',
  @process_id,
  @sub_process_id,
  @position_id,
  @sub_position_id,
  @step_id,
  @lot_status,
  @step_status,
  @response
    );
    select substring(@lot_status, 1, 10), substring(@step_status, 1, 10), substring(@response, 1, 300);
    
    select substring(comment, 1, 300)
    from lot_status
    where id=12
       CALL get_next_step_for_lot(
   11,
  'solarlight0000000011',
                                'dispatched', 
                                1,
                                null,
                                0,
                                null,
                                null,
                                @sub_process_id_n,
                                @position_id_n,
                                @sub_position_id_n,
                                @step_id_n,
                                @step_type,
                                @rework_limit,
                                @response);
select @sub_process_id_n, @position_id_n, @sub_position_id_n, @step_id_n, @step_type, @rework_limit, @response;

SELECT `get_local_time`(UTC_TIMESTAMP())
select * from view_lot_in_process

call report_product_in_process(1, null, @response);

select addtime(utc_timestamp(), '-01:00')

SELECT id,
     --  ?,
       actual_quantity,
       g.uom_id
  FROM  ingredients g, inventory i
 WHERE g.source_type = 'material'
   AND g.ingredient_id = 4
   AND i.source_type = g.source_type
   AND i.pd_or_mt_id = g.ingredient_id
   limit 1
 SELECT concat(i.lot_id, '(', i.serial_no, '), ', i.actual_quantity, ' ', u.name) as description , i.id FROM inventory i, uom u WHERE i.source_type ='material' AND i.pd_or_mt_id = 4 AND u.id = i.uom_id  
   
 SELECT concat(i.lot_id, '(', i.serial_no, '), ', i.actual_quantity, ' ', u.name), i.id
   FROM inventory i, uom u
  WHERE i.source_type = 'material'
    AND i.pd_or_mt_id = 4
    AND u.id = i.uom_id 
 ---------------------------------------  
 SELECT CONCAT('AT ', date_format(str_to_date(c.start_timecode, '%Y%m%d%H%i%s0' ), '%m/%d/%Y %I:%i%p'),
        ' consumed ',
        CAST(c.quantity_used AS CHAR),
        ' ', u.name,
        ' from inventory ', CAST(i.lot_id AS CHAR),
        '(', i.serial_no, ')') AS txtvalue,
       -- select
        CONCAT (c.start_timecode,',', c.quantity_used, ',', i.uom_id,',', c.inventory_id) AS datavalue
   FROM inventory_consumption c, inventory i, uom u
  WHERE c.lot_id = 10
    AND c.start_timecode > '201012042111200'
    AND i.id = c.inventory_id
    AND i.source_type = 'material'
    AND i.pd_or_mt_id = 4
    AND u.id = c.uom_id
    
 CALL `report_consumption_details`(
  10,
  '201012042111200',
  'material',
  null,
  @response 
)
       select '', 'all steps'
union

       select l.step_id
       FROM lot_history l
       INNER JOIN step s ON s.id = l.step_id 
       INNER JOIN step_type st ON st.id = s.step_type_id AND st.name = 'consume material'
       where lot_id = 10
       -- order by position_id, sub_position_id
       union
       select null , null, null, 'all steps'
       order by position_id, sub_position_id
DROP FUNCTION IF EXISTS `convert_quantity`;
DROP FUNCTION IF EXISTS `convert_quantity`;
   select convert_quantity(100, 3, 1)
    SELECT alias,
              get_local_time(dispatch_time) as dispatch_time
         FROM lot_status
        WHERE get_local_time(dispatch_time) >=get_local_time(addtime(utc_timestamp(), '-10:00'))
        
        call report_dispatch_history('2010-12-01','2010-12-07', @response) 

             DELETE FROM inventory_consumption
            WHERE lot_id = 10
              AND start_timecode = '201012201952260'
              AND inventory_id = 6;       
        
        call report_consumption_for_step(
        SELECT source_type, name, description, quantity, uom_name, mintime, maxtime, `order` FROM view_ingredient WHERE recipe_id=2 ORDER BY `order`
 
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h2.status ='dispatched' , 
                 '', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
                                           
     WHERE h.start_timecode between 
               DATE_FORMAT('2010-11-02 15:15', '%Y%m%d%H%i%s0')
           AND DATE_FORMAT('2011-01-02 15:15', '%Y%m%d%H%i%s0')
       AND h.status = 'dispatched';
       
SELECT * FROM employee WHERE id = 2 AND password='test' AND status='active'

set @_process_id = 1;
set @_sub_process_id = null;
set @_position_id = 10;
set @_sub_position_id = null;
set @_step_id=11;
select if(@_process_id!=@_sub_position_id, "no", "yes");

call deliver_lot(17,"solarlight0000000029",
2,1,'2011-1-11 10:50',2,'test','3 Chrsitine Ln','Susan Dong','8607998321','test',
@_process_id,@_sub_process_id,@_position_id,@_sub_position_id,@_step_id,@_lot_status,@_step_status,@_response       
select substring(1, 300, @response); 

call `report_process_cycletime`(
1, 1
)
select substring(comment, 1, 50)
  from lot_status
  where id=50
    SELECT alias,
            lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
        substring(ifnull(result, 'T'),1,50),
           uomid

      FROM view_lot_in_process
     WHERE id=53;
set @process_id=null;
set @sub_process_id=null;
set @position_id=null;
set @sub_position_id=null;
set @step_id=null;
call `start_lot_step`(
  50,
  'YMCA-0000000003',
  2,
  1,
  1,
  null,
  null,
  'Step started automatically',
  @process_id,
@sub_process_id,
@position_id,
@sub_position_id,
@step_id,
@lot_status,
@step_status,
@start_timecode,
@response
)  ;
select   @process_id,
@sub_process_id,
@position_id,
@sub_position_id,
@step_id,
@lot_status,
@step_status,
@start_timecode,
substring(@response, 1, 500);
call `get_next_step_for_lot`(
  52,
  'YMCA-0000000005',
 'in transit',
  3,
  null,
  26,
  null,
  21,
  ',27,,22',
  @_sub_process_id_n,
  @_position_id_n,
  @_sub_position_id_n,
  @_step_id_n,
  @_step_type,
  @_rework_limit,
  @_if_autostart,
  @_response
)  ;  
select @_sub_process_id_n, @_position_id_n, @_sub_position_id_n, @_step_id_n, substring(@_step_type,1, 20), @_rework_limit, @_if_autostart;
      SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid
        
        FROM lot_history
       WHERE lot_id = 50
         AND start_timecode = '201103151656470'
         AND status IN ('started', 'restarted') 
          AND end_timecode IS NULL
          
            SELECT st.name
         
              FROM step s, step_type st
            WHERE s.id =19
              AND st.id =s.step_type_id; 
              select *
               WHERE lot_id = 50
                AND start_timecode =  '201103151656470'
                AND status IN ('started', 'restarted')
                AND end_timecode IS NULL;             
set @process_id=3;
set @position_id=25;
set @step_id=20;
call end_lot_step(
54,
'YMCA-0000000006',
'201103151929450',
2,
1,
2,
'test',
null,
'test unhold',
@process_id,
@sub_process_id,
@position_id,
@sub_position_id,
@step_id,
@lot_status,
@step_status,
@autostart_timecode,
@response);
select @process_id, @position_id, @step_id, substring(@lot_status, 1, 20), substring(@step_status, 1, 20), @autostart_timecode, substring(@response, 1, 200);

      -- check position information
      SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid
        
        FROM lot_history
       WHERE lot_id = 54
         AND start_timecode = '201103151929450'
         AND status IN ('started', 'restarted') 
         AND end_timecode IS NULL
             SELECT st.name
           
              FROM step s, step_type st
            WHERE s.id =20
              AND st.id =s.step_type_id;
 select substring(p.name, 1, 10) as alias_prefix
    from process p where p.id=3
    
    SELECT null as sub_process_id, 
          p.position_id,
          null as sub_position_id,
          p.step_id,
          s.name,
          s.description
      FROM process_step p, step s
    WHERE process_id = 3
      AND if_sub_process = 0
      AND s.id = p.step_id
     union
    

    SELECT  p1.process_id,
            p.position_id,
            p1.position_id,
            p1.step_id,
            s.name,
            s.description
      FROM process_step p, process_step p1, step s
    WHERE p.process_id = 3
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
    ORDER BY 2,3
    
    select * from inventory where lot_id='scr-001'
    
              SELECT supplier_id 
            FROM material_supplier
           WHERE material_id=1
           ORDER BY preference 
  select ps.position_id, s.name as step, ps.prev_step_pos, ps.next_step_pos, ps.false_step_pos, sg.name as segment, ps.rework_limit,  if(ps.if_sub_process, 'Y', 'N') as if_sub_process, ps.prompt, if(ps.if_autostart, 'Y', 'N') as if_autostart,  if(ps.need_approval, 'Y', 'N') as need_approval, concat(e1.firstname, ' ', e1.lastname) as approved_by 
from process_step ps join step s on ps.step_id=s.id left join employee e1 on ps.approve_emp_id=e1.id LEFT JOIN process_segment sg ON ps.process_id=sg.process_id AND ps.segment_id=sg.segment_id where ps.process_id = 1 and ps.if_sub_process=0
union
select ps.position_id, s.name as step, ps.prev_step_pos, ps.next_step_pos, ps.false_step_pos,sg.name as segment, ps.rework_limit, if(ps.if_sub_process, 'Y', 'N') as if_sub_process, ps.prompt, if(ps.if_autostart, 'Y', 'N') as if_autostart, if(ps.need_approval, 'Y', 'N') as need_approval, concat(e1.firstname, ' ', e1.lastname) as approved_by 
from process_step ps join process s on ps.step_id=s.id left join employee e1 on ps.approve_emp_id=e1.id LEFT JOIN process_segment sg ON ps.process_id=sg.process_id AND ps.segment_id=sg.segment_id where ps.process_id = 1 and ps.if_sub_process=1
order by position_id
        SELECT process_id,
               length(name)
     
          FROM process_segment
         WHERE process_id = 1

set @_segment_id=null;
call modify_segment(1, @_segment_id, 'Assembly', 1, 'Assembly Steps', @response);
select @_segment_id, @response;

select substring(description, 1, 200) from material where id=11

SELECT o.id, concat(ifnull(o.ponumber, ''), c.name) FROM order_general o left join client c on o.client_id=c.id where order_type in ('inventory', 'customer')


      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            p.id as product_id,
            p.name as product_name,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      JOIN product p ON od.source_type = 'product' AND od.source_id=p.id
      WHERE o.id = 1
        AND o.order_type in ('inventory', 'customer')
        AND od.source_type='product';