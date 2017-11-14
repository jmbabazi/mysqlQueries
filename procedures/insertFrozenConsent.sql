DROP PROCEDURE IF EXISTS  insertFrozenConsent;

CREATE PROCEDURE insertFrozenConsent(emr_id VARCHAR(255), value_coded INT(11))

BEGIN

        DECLARE _concept_id INT;
        DECLARE _parent_concept_id INT;
        DECLARE _person_id INT;
        DECLARE _encounter_id INT;
        DECLARE _obs_group_id INT;
        DECLARE _value_numeric INT;
        DECLARE _obs_datetime DATETIME;

SET _concept_id=2923; -- TI, Consent for freezing isolates signed 
SET _parent_concept_id=367; -- TI, New treatment eligibility

SET _person_id = (SELECT patient_id from patient_identifier where identifier=emr_id);
SET _obs_datetime = (SELECT obs_datetime from obs where concept_id=_parent_concept_id and voided=0 and person_id=(select patient_id from patient_identifier where identifier=emr_id));

SET _encounter_id = (select DISTINCT(o1.encounter_id) from obs o1 where o1.obs_group_id=(select obs_id from obs o2 where o2.concept_id=_parent_concept_id and o2.voided=0 and o2.obs_datetime=_obs_datetime and person_id=(select patient_id from patient_identifier where identifier=emr_id)));

SET _obs_group_id = (select DISTINCT(o3.obs_group_id) from obs o3 where o3.obs_group_id=(select o4.obs_id from obs o4 where o4.concept_id=_parent_concept_id and o4.voided=0 and o4.obs_datetime=_obs_datetime and person_id=(select patient_id from patient_identifier where identifier=emr_id)));

INSERT INTO obs (
        obs_id,
        person_id,
        concept_id,
        encounter_id,
        obs_datetime,
        location_id,
        obs_group_id,
        value_coded,
        creator,
        date_created,
        uuid
        )
Values
        (
        NULL,
        _person_id,
        _concept_id,
        _encounter_id,
        _obs_datetime,
        3,
        _obs_group_id,
        value_coded,
        1,
        NOW(),
        UUID()
);


END;
