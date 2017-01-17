-- Treatment Start Date
#############################
DROP TEMPORARY TABLE treatmentStartDate;
CREATE TEMPORARY TABLE IF NOT EXISTS treatmentStartDate (encounter_id int(11), person_id int(11), dates datetime );
INSERT INTO treatmentStartDate (encounter_id, person_id, dates)
SELECT 
    encounter_id, person_id, DATE(obs_datetime)
FROM
    obs
WHERE
    concept_id = 1210
ORDER BY person_id ASC;
-- select * from treatmentStartDate;

-- Sample Collection Date
##################################
DROP TABLE IF EXISTS sampleCollectionDate1;
CREATE TEMPORARY TABLE sampleCollectionDate1 (dates DATE, concept_id INT(11), encounter_id INT(11), person_id INT(11), obs_group_id INT(11));
INSERT INTO sampleCollectionDate1 (dates, concept_id, encounter_id, person_id, obs_group_id)
SELECT DISTINCT
    DATE(obs_datetime),
    concept_id,
    encounter_id,
    person_id,
    obs_group_id
FROM
    obs
WHERE
     concept_id = 1093
        AND form_namespace_and_path IS NULL
        OR value_coded = 248
        OR value_coded = 1825
        OR value_coded = 1826
        OR value_coded = 1095
        OR value_coded = 1096
        OR value_coded = 1097
        OR value_coded = 1092
ORDER BY person_id, obs_datetime ASC;

-- Final sample collection date table
DROP TABLE IF EXISTS sampleCollectionDate;
CREATE TEMPORARY TABLE sampleCollectionDate (dates DATE, concept_id INT(11), encounter_id INT(11), person_id INT(11), obs_group_id INT(11));
INSERT INTO sampleCollectionDate (dates, concept_id, encounter_id, person_id, obs_group_id)
SELECT 
    dates, concept_id, encounter_id, person_id, obs_group_id
FROM
    sampleCollectionDate1
WHERE
    concept_id = 1093;
-- SELECT * from sampleCollectionDate;

-- Culture Date
####################################
DROP TEMPORARY TABLE cultureDate;
CREATE TEMPORARY TABLE IF NOT EXISTS cultureDate (encounter_id int(11), person_id int(11), dates datetime);
INSERT INTO cultureDate (encounter_id, person_id, dates)
SELECT 
    encounter_id, person_id, DATE(value_datetime)
FROM
    obs
WHERE
    concept_id = 1126
ORDER BY person_id ASC;
-- select * from cultureDate;

-- Results
#######################
DROP TEMPORARY table Results;
CREATE TEMPORARY TABLE IF NOT EXISTS Results (pi_indentifier varchar(250), ti_dates date, sc_dates date, c_dates date, dateDiff int(11));
INSERT INTO Results (pi_indentifier, ti_dates, sc_dates, c_dates, dateDiff)
SELECT 
    pi.identifier,
    DATE(ti.dates) AS 'Treatment start date',
    DATE(sc.dates) AS 'Sample Collection Date',
    DATE(c.dates) AS 'Culture Innoculation Date',
    DATEDIFF(NOW(), sc.dates) AS 'Interval in day(s)'
FROM
    sampleCollectionDate sc
        INNER JOIN
    patient_identifier pi ON pi.patient_id = sc.person_id
        INNER JOIN
    treatmentStartDate ti ON ti.person_id = pi.patient_id
        LEFT JOIN
    cultureDate c ON sc.encounter_id = c.encounter_id
ORDER BY pi.identifier , sc.dates ASC;

-- SELECT * from Results where c_dates IS NULL order by pi_indentifier, sc_dates ASC;
-- SELECT * from Results where c_dates IS NULL and dateDiff>=90 order by pi_indentifier, sc_dates ASC;
