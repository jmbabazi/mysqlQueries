DROP PROCEDURE IF EXISTS cumulative_enrollment1;
CREATE  PROCEDURE cumulative_enrollment1 ()
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_value (Dates VARCHAR(255), count INT(11));
insert into cumulative_value (Dates, count)
        SELECT  DATE_FORMAT(mycount, '%Y/%M'), count(mycount) FROM (SELECT MIN(scheduled_date) mycount FROM orders o WHERE o.concept_id = 1251 and o.voided=0
        OR o.concept_id=1252 and o.voided=0 GROUP BY o.patient_id) as temp_orders GROUP BY DATE_FORMAT(mycount, '%Y%m');

CREATE TEMPORARY TABLE IF NOT EXISTS bdq_value (BDQdates VARCHAR(255), bdqcount INT(11));
insert into bdq_value (BDQdates, bdqCount)
        SELECT  DATE_FORMAT(bdqCount, '%Y/%M'), count(bdqCount) FROM (SELECT MIN(scheduled_date) bdqCount FROM orders o1 WHERE o1.concept_id = 1251 and o1.voided=0
        GROUP BY o1.patient_id) as bdq_orders GROUP BY DATE_FORMAT(bdqCount, '%Y%m');

CREATE TEMPORARY TABLE IF NOT EXISTS dlm_value (DLMdates VARCHAR(255), dlmCount INT(11));
insert into dlm_value (DLMdates, dlmCount)
        SELECT  DATE_FORMAT(dlmCount, '%Y/%M'), count(dlmCount) FROM (SELECT MIN(scheduled_date) dlmCount FROM orders o2 WHERE o2.concept_id = 1252 and o2.voided=0
        GROUP BY o2.patient_id) as dlm_orders GROUP BY DATE_FORMAT(dlmCount, '%Y%m');

SELECT 
    Dates AS 'Year and Month',
    bdqCount AS 'BDQ enrollment by month',
    dlmCount AS 'DLM enrollment by month',
    count AS 'Patients enrolled in a month',
    @bdqrunningTotal:=@bdqrunningTotal + bdqCount AS 'BDQ Cumulative enrollment',
    @dlmrunningTotal:=@dlmrunningTotal + dlmCount AS 'DLM Cumulative enrollment',
    @runningTotal:=@runningTotal + count AS 'Cumulative enrollment'
FROM
    cumulative_value
        JOIN
    bdq_value ON Dates = BDQDates
        JOIN
    dlm_value ON Dates = DLMdates
        JOIN
    (SELECT @runningTotal:=0 AS dummy) dummy
        JOIN
    (SELECT @bdqrunningTotal = 0 AS bdqdummy) bdqdummy
        JOIN
    (SELECT @dlmrunningTotal = 0 AS dlmdummy) dlmdummy;


DROP TEMPORARY TABLE cumulative_value;
DROP TEMPORARY TABLE bdq_value;
DROP TEMPORARY TABLE dlm_value;


END;
