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

select * from sampleCollectionDate;

DROP TEMPORARY TABLE smearDate;
CREATE TEMPORARY TABLE IF NOT EXISTS smearDate (encounter_id int(11), person_id int(11), dates datetime );
insert into smearDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(obs_datetime)
from
obs where concept_id=1090 order by person_id ASC;

select * from smearDate;

DROP temporary table cultureDate;
CREATE TEMPORARY TABLE IF NOT EXISTS cultureDate (encounter_id int(11), person_id int(11), dates datetime);
insert into cultureDate (encounter_id, person_id, dates)
select 
encounter_id, person_id, DATE(value_datetime)
from
obs where concept_id=1126 order by person_id ASC;
select * from cultures;

select pi.identifier, DATE(ti.dates) AS 'Treatment start date', DATE(sc.dates) AS 'Sample Collection Date', DATE(sm.dates) AS 'Date of smear',
DATE(c.dates) AS 'Culture Innoculation Date', DATEDIFF(sm.dates, ti.dates) AS 'Interval in day(s)'
from smearDate sm inner join patient_identifier pi on pi.patient_id=sm.person_id inner join treatmentStartDate ti on ti.person_id=pi.patient_id 
inner join sampleCollectionDate sc on sm.encounter_id=sc.encounter_id
left join cultureDate c on sm.encounter_id=c.encounter_id order by pi.identifier;
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

Select * from Results;

select * from Results where dateDiff BETWEEN 85 and 95;
select * from Results where dateDiff BETWEEN 185 and 195;
select * from Results where dateDiff BETWEEN 275 and 280;
select * from Results where dateDiff BETWEEN 365 and 375;
