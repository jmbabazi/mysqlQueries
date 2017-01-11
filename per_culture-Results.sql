DROP TEMPORARY TABLE treatmentStartDate;
CREATE TEMPORARY TABLE IF NOT EXISTS treatmentStartDate (encounter_id int(11), person_id int(11), dates datetime );
insert into treatmentStartDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(obs_datetime)
from
obs where concept_id=1210 order by person_id ASC;

DROP TEMPORARY TABLE sampleCollectionDate;
CREATE TEMPORARY TABLE IF NOT EXISTS sampleCollectionDate (encounter_id int(11), person_id int(11), dates datetime );
insert into sampleCollectionDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(obs_datetime)
from
obs where concept_id=1187 order by person_id ASC;

-- select * from sampleCollectionDate;


DROP TEMPORARY TABLE smearDate;
CREATE TEMPORARY TABLE IF NOT EXISTS smearDate (encounter_id int(11), person_id int(11), dates datetime );
insert into smearDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(obs_datetime)
from
obs where concept_id=1090 order by person_id ASC;

-- select * from smearDate;

DROP temporary table cultureDate;
CREATE TEMPORARY TABLE IF NOT EXISTS cultureDate (encounter_id int(11), person_id int(11), dates datetime);
insert into cultureDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(value_datetime)
from
obs where concept_id=1126 order by person_id ASC;

-- select * from cultures;

SELECT 
    pi.identifier,
    DATE(ti.dates) AS 'Treatment start date',
    DATE(sc.dates) AS 'Sample Collection Date',
    DATE(sm.dates) AS 'Date of smear',
    DATE(c.dates) AS 'Culture Innoculation Date',
    DATEDIFF(sm.dates, ti.dates) AS 'Interval in day(s)',
    DATEDIFF(NOW(), ti.dates) AS 'Days on Treatment'
FROM
    smearDate sm
        INNER JOIN
    patient_identifier pi ON pi.patient_id = sm.person_id
        INNER JOIN
    treatmentStartDate ti ON ti.person_id = pi.patient_id
        INNER JOIN
    sampleCollectionDate sc ON sm.encounter_id = sc.encounter_id
        LEFT JOIN
    cultureDate c ON sm.encounter_id = c.encounter_id
ORDER BY pi.identifier;
/* 85, 95
  185 195
  275 280 */

DROP temporary table Results;
CREATE TEMPORARY TABLE IF NOT EXISTS Results (pi_indentifier varchar(250), ti_dates date, sc_dates date, sm_dates date, c_dates date, dateDiff int(11));
INSERT INTO Results (pi_indentifier, ti_dates, sc_dates, sm_dates, c_dates, dateDiff)
select pi.identifier, DATE(ti.dates) AS 'Treatment start date', DATE(sc.dates) AS 'Sample Collection Date', DATE(sm.dates) AS 'Date of smear',
DATE(c.dates) AS 'Culture Innoculation Date', DATEDIFF(sm.dates, ti.dates) AS 'Interval in day(s)'
from smearDate sm inner join patient_identifier pi on pi.patient_id=sm.person_id inner join treatmentStartDate ti on ti.person_id=pi.patient_id 
inner join sampleCollectionDate sc on sm.encounter_id=sc.encounter_id
left join cultureDate c on sm.encounter_id=c.encounter_id order by pi.identifier;

SELECT 
    *
FROM
    Results;

SELECT 
    *
FROM
    Results
WHERE
    dateDiff BETWEEN 85 AND 95;
SELECT 
    *
FROM
    Results
WHERE
    dateDiff BETWEEN 175 AND 185;
SELECT 
    *
FROM
    Results
WHERE
    dateDiff BETWEEN 265 AND 275;
SELECT 
    *
FROM
    Results
WHERE
    dateDiff BETWEEN 355 AND 365;
