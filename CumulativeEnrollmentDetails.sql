DROP PROCEDURE IF EXISTS cumulative_detailed_enrollment; 

-- EITHER BDQ or DLM
CREATE  PROCEDURE cumulative_detailed_enrollment () 
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_value (dates VARCHAR(255), count INT(11)); 
INSERT INTO cumulative_value (dates, count) 
        SELECT  DATE_FORMAT(mycount, '%Y/%M'), Count(mycount) FROM (SELECT Min(scheduled_date) mycount FROM orders o WHERE o.concept_id = 1251 AND o.voided=0
        OR o.concept_id=1252 AND o.voided=0 GROUP BY o.patient_id) AS temp_orders GROUP BY DATE_FORMAT(mycount, '%Y%m');
/*
-- BDQ 
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_value (bdqdates VARCHAR(255), bdqcount INT(11)); 
INSERT INTO bdq_value (bdqdates, bdqcount) 
        SELECT  DATE_FORMAT(bdqcount, '%Y/%M'), Count(bdqcount) FROM (SELECT Min(scheduled_date) bdqCount FROM orders o1 WHERE o1.concept_id = 1251 AND o1.voided=0
        GROUP BY o1.patient_id) AS bdq_orders GROUP BY DATE_FORMAT(bdqcount, '%Y%m'); 

-- DLM  
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_value (dlmdates VARCHAR(255), dlmcount INT(11)); 
NSERT INTO dlm_value (dlmdates, dlmcount) 
        SELECT  DATE_FORMAT(dlmcount, '%Y/%M'), Count(dlmcount) FROM (SELECT Min(scheduled_date) dlmCount FROM orders o2 WHERE o2.concept_id = 1252 AND o2.voided=0
        GROUP BY o2.patient_id) AS dlm_orders GROUP BY DATE_FORMAT(dlmcount, '%Y%m'); 
*/
-- BDQ patient IDs 
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_id (bdqdates VARCHAR(255), bdq_patient_id INT(11)); 
INSERT INTO bdq_id (bdqdates, bdq_patient_id) 
        SELECT 
    DATE_FORMAT(bdqdate, '%Y/%M'), bdq_patient_id 
FROM 
    (SELECT 
        Min(scheduled_date) bdqDate, (patient_id) bdq_patient_id 
    FROM 
        orders 
    WHERE 
        concept_id = 1251 AND voided = 0 
    GROUP BY patient_id) AS bdq_ids; 

-- DLM patient IDs 
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_id (dlmdates VARCHAR(255), dlm_patient_id INT(11)); 
INSERT INTO dlm_id (dlmdates, dlm_patient_id) 
        SELECT 
    DATE_FORMAT(dlmdate, '%Y/%M'), dlm_patient_id 
FROM 
    (SELECT 
        Min(scheduled_date) dlmDate, (patient_id) dlm_patient_id 
    FROM 
        orders 
    WHERE 
        concept_id = 1252 AND voided = 0 
    GROUP BY patient_id) AS dlm_ids; 

-- Patients on BDQ only
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_only (bdqdates VARCHAR(255), bdq_patient_id INT(11));
INSERT INTO bdq_only
SELECT
    bdqdates AS 'Year and Month',
    bdq_patient_id AS 'Patients taking BDQ only'
FROM
    bdq_id where bdq_patient_id not in (select dlm_patient_id from dlm_id); 

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


-- Patients on DLM only
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_only (dlmdates VARCHAR(255), dlm_patient_id INT(11));
INSERT INTO dlm_only
SELECT
    dlmdates AS 'Year and Month',
    dlm_patient_id AS 'Patients taking BDQ only'
FROM
    dlm_id where dlm_patient_id not in (select bdq_patient_id from bdq_id);

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

-- Patients on both BDQ and DLM with min start date.
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_bdq_c_min_date (dates VARCHAR(255), patient_id INT(11)); 
INSERT INTO dlm_bdq_c_min_date (dates, patient_id)
	SELECT DATE_FORMAT(MIN(dates), '%Y/%M'), patient_id FROM dlm_bdq GROUP BY patient_id;

-- BDQ (only) Count
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_count (bdqdates VARCHAR(255), bdqcount INT(11));
INSERT INTO bdq_count (bdqdates, bdqcount)
        SELECT  bdqCount, Count(bdqCount) FROM (SELECT (bdqdates) bdqCount FROM bdq_only GROUP BY bdq_patient_id) AS bdq_c GROUP BY bdqCount;

-- DLM (only) Count
CREATE TEMPORARY TABLE IF NOT EXISTS dlm_count (dlmdates VARCHAR(255), dlmcount INT(11));
INSERT INTO dlm_count (dlmdates, dlmcount)
        SELECT  dlmCount, Count(dlmCount) FROM (SELECT (dlmdates) dlmCount FROM dlm_only GROUP BY dlm_patient_id) AS dlm_c GROUP BY dlmCount;

-- Both bdq and  dlm count
CREATE TEMPORARY TABLE IF NOT EXISTS bdq_dlm_count (dates VARCHAR(255), bdcounts INT(11));
 INSERT INTO bdq_dlm_count (dates, bdcounts)
        SELECT BothCount, Count(BothCount) FROM (SELECT (dates) BothCount FROM dlm_bdq_c_min_date GROUP BY patient_id) AS bdq_dlm_c GROUP BY BothCount;

-- OUTPUT RESULT1
CREATE TEMPORARY TABLE IF NOT EXISTS results1 (dates VARCHAR(255), bdq_monthly_enrollment INT(11), dlm_monthly_enrollment INT(11), conc_monthly_enrollment INT(11), totalMonthlyCount INT(11));
INSERT INTO results1
SELECT  
     c.Dates AS 'Year/Month', 
     IFNULL(bdqcount, 0) AS 'New patients enrolled on Bdq/month', 
     IFNULL(dlmcount, 0) AS 'New patients enrolled on Dlm/month', 
     IFNULL(bdcounts, 0) AS 'New patients enrolled on concomitant use/month',
     IFNULL(count, 0) AS 'New total patients/month'
     -- @bdqrunningTotal:=@bdqrunningTotal + bdqcount AS 'BDQ Cumulative enrollment', 
    -- @dlmrunningTotal:=@dlmrunningTotal + dlmcount AS 'DLM Cumulative enrollment', 
     -- @runningTotal:=@runningTotal + count AS 'Cumulative enrollment' 
  FROM 
      cumulative_value c
   LEFT JOIN 
          bdq_count  ON c.Dates=bdqdates 
   LEFT JOIN 
          dlm_count  ON c.Dates=dlmdates
    LEFT  JOIN
          bdq_dlm_count bd ON c.Dates=bd.dates
   order by str_to_date(c.Dates, '%Y/%M') ;


-- OUTPUT RESULTS2 with cumulative enrollment for bdq_monthly_enrollment
CREATE TEMPORARY TABLE IF NOT EXISTS results2 (dates VARCHAR(255), bdq_monthly_enrollment INT(11), dlm_monthly_enrollment INT(11), conc_monthly_enrollment INT(11), totalMonthlyCount INT(11), bdqtotalMonthlyCount INT(11));
INSERT INTO results2 (dates, bdq_monthly_enrollment, dlm_monthly_enrollment, conc_monthly_enrollment, totalMonthlyCount, bdqtotalMonthlyCount) 
SELECT 
    dates, 
    bdq_monthly_enrollment,
    dlm_monthly_enrollment,
    conc_monthly_enrollment,
    totalMonthlyCount,
    @bdqrunningTotal:=@bdqrunningTotal + bdq_monthly_enrollment AS 'BDQ Cumulative enrollment'
FROM
    results1
        JOIN
    (SELECT @bdqrunningTotal:=0 AS bdqdummy) bdqdummy;

-- OUTPUT RESULTS3 with cumulative enrollment for dlm_monthly_enrollment
CREATE TEMPORARY TABLE IF NOT EXISTS results3 (dates VARCHAR(255), bdq_monthly_enrollment INT(11), dlm_monthly_enrollment INT(11), conc_monthly_enrollment INT(11), totalMonthlyCount INT(11), bdqtotalMonthlyCount INT(11), dlmtotalMonthlyCount INT(11));
INSERT INTO results3 (dates, bdq_monthly_enrollment, dlm_monthly_enrollment, conc_monthly_enrollment, totalMonthlyCount, bdqtotalMonthlyCount, dlmtotalMonthlyCount)  
SELECT
    dates,
    bdq_monthly_enrollment,
    dlm_monthly_enrollment,
    conc_monthly_enrollment,
    totalMonthlyCount,
    bdqtotalMonthlyCount,
    @dlmrunningTotal:=@dlmrunningTotal + dlm_monthly_enrollment
FROM
    results2
        JOIN
    (SELECT @dlmrunningTotal:=0 AS dlmdummy) dlmdummy;

-- OUTPUT RESULTS3 with cumulative enrollment for conc_monthly_enrollment
CREATE TEMPORARY TABLE IF NOT EXISTS results4 (dates VARCHAR(255), bdq_monthly_enrollment INT(11), dlm_monthly_enrollment INT(11), conc_monthly_enrollment INT(11), totalMonthlyCount INT(11), bdqtotalMonthlyCount INT(11), dlmtotalMonthlyCount INT(11), conctotalMonthlyCount INT(11));
INSERT INTO results4 (dates, bdq_monthly_enrollment, dlm_monthly_enrollment, conc_monthly_enrollment, totalMonthlyCount, bdqtotalMonthlyCount, dlmtotalMonthlyCount, conctotalMonthlyCount)
SELECT
    dates,
    bdq_monthly_enrollment,
    dlm_monthly_enrollment,
    conc_monthly_enrollment,
    totalMonthlyCount,
    bdqtotalMonthlyCount,
    dlmtotalMonthlyCount,
    @concrunningTotal:=@concrunningTotal + conc_monthly_enrollment
FROM
    results3
        JOIN
    (SELECT @concrunningTotal:=0 AS concdummy) concdummy;

-- OUTPUT RESULTS4 with cumulative enrollment for conc_monthly_enrollment ** FINAL TABLE **
CREATE TEMPORARY TABLE IF NOT EXISTS finalResults (dates VARCHAR(255), bdq_monthly_enrollment INT(11), dlm_monthly_enrollment INT(11), conc_monthly_enrollment INT(11), totalMonthlyCount INT(11), bdqtotalMonthlyCount INT(11), dlmtotalMonthlyCount INT(11), conctotalMonthlyCount INT(11), totalCumulativeMonthlyCount INT(11));
INSERT INTO finalResults (dates, bdq_monthly_enrollment, dlm_monthly_enrollment, conc_monthly_enrollment, totalMonthlyCount, bdqtotalMonthlyCount, dlmtotalMonthlyCount, conctotalMonthlyCount, totalCumulativeMonthlyCount)
SELECT
    dates,
    bdq_monthly_enrollment,
    dlm_monthly_enrollment,
    conc_monthly_enrollment,
    totalMonthlyCount,
    bdqtotalMonthlyCount,
    dlmtotalMonthlyCount,
    conctotalMonthlyCount,
    @runningTotal:=@runningTotal + totalMonthlyCount
FROM
    results4
        JOIN
    (SELECT @runningTotal:=0 AS dummy) dummy;

-- FINAL QUERY
SELECT 
    dates AS 'Year/Month',
    bdq_monthly_enrollment AS 'New patients enrolled on Bdq/month',
    dlm_monthly_enrollment AS 'New patients enrolled on Dlm/month',
    conc_monthly_enrollment AS 'New patients enrolled on concomitant use/month',
    totalMonthlyCount AS 'New total patients/month',
    bdqtotalMonthlyCount AS 'Cumulative patients on Bdq',
    dlmtotalMonthlyCount AS 'Cumulative patients on Dlm',
    conctotalMonthlyCount AS 'Cumulative patients on concomitant use',
    totalCumulativeMonthlyCount AS 'Cumulative patient enrollment'
FROM
  finalResults;

-- After get your results, drop the tables. This is for refreshing and allowing new entered data to be included and counted in these queries 
 DROP TEMPORARY TABLE IF EXISTS cumulative_value; 
 DROP TEMPORARY TABLE IF EXISTS bdq_value; 
 DROP TEMPORARY TABLE IF EXISTS dlm_value; 
 DROP TEMPORARY TABLE IF EXISTS bdq_id; 
 DROP TEMPORARY TABLE IF EXISTS dlm_id; 
 DROP TEMPORARY TABLE IF EXISTS bdq_only;
 DROP TEMPOrARY TABLE IF EXISTS dlm_only;
 DROP TEMPORARY TABLE IF EXISTS bdq_n_dlm;
 DROP TEMPORARY TABLE IF EXISTS bdq_count;
 DROP TEMPORARY TABLE IF EXISTS dlm_count;
 DROP TEMPORARY TABLE IF EXISTS bdq_dlm_count;
 DROP TEMPORARY TABLE IF EXISTS bdq_dlm_count;
 DROP TEMPORARY TABLE IF EXISTS bdq_date; 
 DROP TEMPORARY TABLE IF EXISTS dlm_date;
 DROP TEMPORARY TABLE IF EXISTS dlm_n_bdq;
 DROP TEMPORARY TABLE IF EXISTS bdq_n_dlm;
 DROP TEMPORARY TABLE IF EXISTS dlm_bdq;
 DROP TEMPORARY TABLE IF EXISTS dlm_bdq_c_min_date;
 DROP TEMPORARY TABLE IF EXISTS results1;
 DROP TEMPORARY TABLE IF EXISTS results2;
 DROP TEMPORARY TABLE IF EXISTS results3;
 DROP TEMPORARY TABLE IF EXISTS results4;
 DROP TEMPORARY TABLE IF EXISTS finalResults;

END;

