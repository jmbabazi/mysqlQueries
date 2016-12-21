SELECT 
    patient_identifier.identifier AS 'EMR ID',
    GROUP_CONCAT(IF(obs.concept_id = 740,
            (SELECT DISTINCT
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'SHORT'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Existing neuropathy ',
    GROUP_CONCAT(IF(obs.concept_id = 745,
            (SELECT DISTINCT
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'SHORT'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Grading'
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
