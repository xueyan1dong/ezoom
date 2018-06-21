/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : view_ingredient.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP VIEW IF EXISTS `view_ingredient`$
CREATE ALGORITHM = MERGE VIEW `view_ingredient` AS
SELECT i.recipe_id,
        -- CONCAT('self-manufactured ', i.source_type) AS source_type,
        i.source_type,
        i.ingredient_id,
        p.name,
        p.description,
        i.quantity, 
        i.uom_id,
        u.name as uom_name, 
        i.`order`,
        i.mintime,
        i.maxtime,
        i.comment
   FROM ingredients i 
   LEFT JOIN product p ON p.id = i.ingredient_id
   LEFT JOIN uom u ON u.id = i.uom_id
  WHERE i.source_type = 'product'
  UNION 
 SELECT i1.recipe_id,
        -- CONCAT('supplied ' , i1.source_type) AS source_type,
        i1.source_type,
        i1.ingredient_id,
         m.name,
         m.description,
        i1.quantity, 
        i1.uom_id,
        u1.name as uom_name, 
        i1.`order`,
        i1.mintime,
        i1.maxtime,
        i1.comment
   FROM ingredients i1
   LEFT JOIN material m ON m.id = i1.ingredient_id
   LEFT JOIN uom u1 ON u1.id = i1.uom_id
  WHERE i1.source_type = 'material'
     $
