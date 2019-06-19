/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : get_local_time.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    6/18/2019: Xueyan Dong: hardcode to select company 2 for local time					
*/
DELIMITER $  
DROP FUNCTION IF EXISTS `get_local_time`$
CREATE FUNCTION `get_local_time`(
   _utc_time datetime
)
RETURNS datetime
BEGIN
  
  DECLARE _timezone char(6);
  DECLARE _daylightsaving_starttime datetime;
  DECLARE _daylightsaving_endtime datetime;
  DECLARE _local_time datetime;
  
  SELECT timezone,
         daylightsaving_starttime,
         daylightsaving_endtime
    INTO _timezone, _daylightsaving_starttime, _daylightsaving_endtime
  FROM company
  WHERE id=2;
  
  SET _local_time = convert_tz(_utc_time, '+00:00', _timezone);
  IF _local_time BETWEEN concat(year(_local_time), substring(_daylightsaving_starttime,5))
                      AND concat(year(_local_time), substring(_daylightsaving_endtime,5))
  THEN
    RETURN addtime(_local_time, '01:00');
  ELSE
    RETURN _local_time;
  END IF;

 END$