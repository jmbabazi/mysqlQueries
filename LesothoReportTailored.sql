SELECT 
    patient_identifier.identifier, obs.value_coded
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
        AND concept_id = 338
ORDER BY patient_identifier.identifier;

-- Joining 3 tables --
-- 1 row of identifier, 1 row of result. This duplicates identifiers --
SELECT 
    patient_identifier.identifier, concept_name.name
FROM
    concept_name
        JOIN
    obs ON concept_name.concept_id = obs.value_coded
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
        AND obs.concept_id = 338
        AND concept_name.concept_name_type = 'FULLY_SPECIFIED'
ORDER BY patient_identifier.identifier;

-- Using Group Concat --
-- Lesotho Report --
SELECT 
    patient_identifier.identifier AS 'EMR ID',
    GROUP_CONCAT(IF(obs.concept_id = 338,
            (SELECT 
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'SHORT'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Patients for whom the construction of a regimen with four likely effective second-line drugs is not possible (check all that apply)'
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
