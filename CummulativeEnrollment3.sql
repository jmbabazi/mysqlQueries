DROP PROCEDURE IF EXISTS cumulative_enrollment2;

-- Number of patients that started Bdq in a treatment for the first time that month.
CREATE  PROCEDURE cumulative_enrollment2 ()
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_containing_regimen (dates VARCHAR(255), count INT(11));
INSERT INTO bdq_containing_regimen (dates, count)
        SELECT  DATE_FORMAT(mycount, '%Y/%M'), Count(mycount) FROM (SELECT Min(scheduled_date) mycount FROM orders o WHERE o.concept_id = 1251 AND o.voided=0
        GROUP BY o.patient_id) AS temp_orders GROUP BY DATE_FORMAT(mycount, '%Y%m');

-- Number of patients that started Dlm in a treatment for the first time that month.
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_containing_regimen (dates VARCHAR(255), count INT(11));
INSERT INTO dlm_containing_regimen (dates, count)
        SELECT  DATE_FORMAT(mycount, '%Y/%M'), Count(mycount) FROM (SELECT Min(scheduled_date) mycount FROM orders o WHERE o.concept_id=1252 AND o.voided=0
        GROUP BY o.patient_id) AS temp_orders GROUP BY DATE_FORMAT(mycount, '%Y%m');

-- Number of unique patients that enrolled in endTB that month (started either Bdq or Dlm, or Both).
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_value (dates VARCHAR(255), count INT(11));
INSERT INTO cumulative_value (dates, count)
        SELECT  DATE_FORMAT(mycount, '%Y/%M'), Count(mycount) FROM (SELECT Min(scheduled_date) mycount FROM orders o WHERE o.concept_id = 1251 AND o.voided=0
        OR o.concept_id=1252 AND o.voided=0 GROUP BY o.patient_id) AS temp_orders GROUP BY DATE_FORMAT(mycount, '%Y%m');

-- Patients on BDQ only date_format=date
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_date (bdqdates date, bdq_patient_id INT(11));
INSERT INTO bdq_date (bdqdates, bdq_patient_id)
        SELECT
        Min(scheduled_date) bdqDate, (patient_id) bdq_patient_id
    FROM
        orders
    WHERE
        concept_id = 1251 AND voided = 0
    GROUP BY patient_id;

-- Patients on DLM only date_format=date
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_date (dlmdates date, dlm_patient_id INT(11));
INSERT INTO dlm_date (dlmdates, dlm_patient_id)
SELECT
        Min(scheduled_date) dlmDate, (patient_id) dlm_patient_id
    FROM
        orders
    WHERE
        concept_id = 1252 AND voided = 0
    GROUP BY patient_id;

-- Patients on both BDQ and DLM basing on dlm table
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_n_dlm (dates date, patient_id INT(11));
INSERT INTO bdq_n_dlm
SELECT
    dlmdates AS 'Year and Month',
    dlm_patient_id AS 'Patients taking both BDQ and DLM'
FROM
    dlm_date where dlm_patient_id in (select bdq_patient_id from bdq_date);

-- Patients on both BDQ and DLM basing on bdq table
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_n_bdq (dates date, patient_id INT(11));
INSERT INTO dlm_n_bdq
SELECT
    bdqdates AS 'Year and Month',
    bdq_patient_id AS 'Patients taking both BDQ and DLM'
FROM
    bdq_date where bdq_patient_id in (select dlm_patient_id from dlm_date);

-- Patients on both BDQ and DLM joint table
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_bdq (dates date, patient_id INT(11));
INSERT INTO dlm_bdq
        SELECT * FROM dlm_n_bdq UNION ALL (SELECT * from bdq_n_dlm);

-- Patients on both BDQ and DLM with max start date.
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_bdq_c_max_date (dates VARCHAR(255), patient_id INT(11));
INSERT INTO dlm_bdq_c_max_date (dates, patient_id)
        SELECT DATE_FORMAT(MAX(dates), '%Y/%M'), patient_id FROM dlm_bdq GROUP BY patient_id;

-- Both bdq and  dlm count
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_dlm_count (dates VARCHAR(255), bdcounts INT(11));
 INSERT INTO bdq_dlm_count (dates, bdcounts)
        SELECT BothCount, Count(BothCount) FROM (SELECT (dates) BothCount FROM dlm_bdq_c_max_date GROUP BY patient_id) AS bdq_dlm_c GROUP BY BothCount order by STR_TO_DATE(BothCount, '%Y/%M');

-- Cumulative count table for concamittant drugs.
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_conc_count (dates VARCHAR(255), count INT(11), cumu_count INT(11));
INSERT INTO cumulative_conc_count (dates, count, cumu_count)
select bdc.dates,
       IFNULL(bdc.bdcounts, 0),
       IFNULL(@conc_count:=@conc_count+bdc.bdcounts, 0)
from bdq_dlm_count bdc join (SELECT @conc_count:=0 AS concdummy) concdummy;

-- Cumulative number of unique patients that enrolled in endTB since start.
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_count (dates VARCHAR(255), count INT(11));
INSERT INTO cumulative_count (dates, count)
SELECT
    dates,
    @runningTotal:=@runningTotal + count
FROM
    cumulative_value
        JOIN
    (SELECT @runningTotal:=0 AS dummy) dummy;
/* 
 DROP TEMPORARY TABLE bdq_containing_regimen;
 DROP TEMPORARY TABLE dlm_containing_regimen;
 DROP TEMPORARY TABLE cumulative_value; 
 DROP TEMPORARY TABLE dlm_n_bdq;
 DROP TEMPORARY TABLE bdq_n_dlm;
 DROP TEMPORARY TABLE bdq_date;
 DROP TEMPORARY TABLE dlm_date;
 DROP TEMPORARY TABLE dlm_bdq;
 DROP TEMPORARY TABLE dlm_bdq_c_max_date;
 DROP TEMPORARY TABLE bdq_dlm_count;
 DROP TEMPORARY TABLE cumulative_count;
 DROP TEMPORARY TABLE cumulative_conc_count;
*/
END;
