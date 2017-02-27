DROP PROCEDURE IF EXISTS smearResults;
CREATE procedure  smearResults()

BEGIN
        DECLARE maxDate DATE;
        DECLARE secondMaxDate DATE;
        DECLARE maxDateValue INT;
        DECLARE secondMaxDateValue INT;
        DECLARE _id INT;
        DECLARE _id1 INT;

        SELECT MAX(value_datetime) into maxDate from obs where concept_id=1090 and voided=0 group by person_id;
        SELECT MAX(value_datetime) into secondMaxDate from obs where concept_id=1090 and voided=0 and secondMaxDate < maxDate group by person_id;
        SELECT value_coded into maxDateValue from obs where concept_id=1093 and voided=0 and obs_datetime=(select obs_datetime from obs where value_datetime=maxDate) group by person_id;
        SELECT value_coded into secondMaxDateValue from obs where concept_id=1093 and voided=0 and obs_datetime=(select obs_datetime from obs where value_datetime=secondMaxDate) group by person_id;

        SELECT DISTINCT person_id into _id from obs where concept_id=1090 and value_datetime=maxDate;
        SELECT DISTINCT person_id into _id1 from obs where concept_id=1090 and value_datetime=secondMaxDate;



CREATE TEMPORARY TABLE IF NOT EXISTS smearResults (person_id INT(11), Dates VARCHAR(255), value INT(11), person_id1 INT(11), secondDate VARCHAR(255), secondValue INT(11));

INSERT INTO smearResults (person_id, Dates, value, person_id1, secondDate, secondValue) values (_id, maxDate, maxDateValue, _id1, secondMaxDate, secondMaxDateValue);

SELECT * from smearResults where _id=id1 order by _id ASC;

DROP TABLE smearResults;

END;
