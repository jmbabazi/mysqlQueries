DROP PROCEDURE IF EXISTS  insert_audio_numeric_data;

CREATE PROCEDURE insert_audio_numeric_data(assesmentDate DATE, emr_id VARCHAR(255), value_numeric INT(11))

BEGIN

        DECLARE _concept_id INT;
        DECLARE _parent_concept_id INT;
        DECLARE _person_id INT;
        DECLARE _encounter_id INT;
        DECLARE _obs_group_id INT;

SET _concept_id=1263;
SET _parent_concept_id=1651;
-- SET @assesmentDate := CONCAT('%',assessmentDate,'%');

-- SET assessmentDate=assessmentDate; -- obs_datetime
-- SET emr_id=emr_id;

SET _person_id = (SELECT patient_id from patient_identifier where identifier=emr_id);

SET _encounter_id = (select DISTINCT(o1.encounter_id) from obs o1 where o1.obs_group_id=(select obs_id from obs o2 where o2.concept_id=_parent_concept_id and o2.voided=0 and DATE(o2.obs_datetime)=assesmentDate and person_id=(select patient_id from patient_identifier where identifier=emr_id)));

SET _obs_group_id = (select DISTINCT(o3.obs_group_id) from obs o3 where o3.obs_group_id=(select o4.obs_id from obs o4 where o4.concept_id=_parent_concept_id and o4.voided=0 and DATE(o4.obs_datetime)=assesmentDate and person_id=(select patient_id from patient_identifier where identifier=emr_id)));

-- SET @form_namespace_and_path = (select DISTINCT(form_namespace_and_path) from obs o5 where o5.obs_group_id=(select o6.obs_id from obs o6 where o6.concept_id=@parent_concept_id and o6.voided=0 and DATE(o6.obs_datetime)=assesmentDate and person_id=(select patient_id from patient_identifier where identifier=emr_id)));
-- select patient_id INTO _person_id from patient_identifier where identifier=emr_id;

INSERT INTO obs (
        obs_id,
        person_id,
        concept_id,
        encounter_id,
        obs_datetime,
        location_id,
        obs_group_id,
        value_numeric,
        creator,
        date_created,
        uuid -- , 
-- form_namespace_and_path)
        )
Values
        (
        NULL,
        _person_id,
        _concept_id,
        _encounter_id,
        assesmentdate,
-- (select obs_datetime from obs o3 where o3.obs_datetime like @assesmentDate and concept_id=@parent_concept_id and person_id=(select patient_id from patient_identifier where identifier=emr_id)), 
        3,
        _obs_group_id,
        value_numeric,
        1,
        NOW(),
        UUID() -- ,
-- @form_namespace_and_path
);

END;
