-- EMR REVIEW QUERY --
SELECT 
    GROUP_CONCAT(DISTINCT patient_identifier.identifier) AS 'EMR ID',
    (SELECT DISTINCT
            CAST(obs_datetime AS DATE)
        FROM
            obs
        WHERE
            obs.concept_id = 1210 AND obs.voided = 0
                AND obs.person_id = patient_identifier.patient_id) AS 'Treatment start date',
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
            NULL)) AS 'Indications for New Drugs (Treatment initiation from)',
    GROUP_CONCAT(IF(obs.concept_id = 339,
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
            NULL)) AS 'Indication for new drugs: high risk of unfavourable outcome',
    GROUP_CONCAT(IF(obs.concept_id = 1583,
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
            NULL)) AS 'Baseline, Has the patient ever been treated for TB in the past?',
    GROUP_CONCAT(IF(obs.concept_id = 274,
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
            NULL)) AS 'Past TB treatment(previously treated for DSTB)',
    GROUP_CONCAT(IF(obs.concept_id = 276,
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
            NULL)) AS 'Past TB treatment(previously treated for DRTB)',
    (SELECT 
            MAX(CAST(obs.value_datetime AS DATE))
        FROM
            obs
        WHERE
            obs.concept_id = 714
                AND obs.person_id = patient_identifier.patient_id
                AND obs.voided = 0) AS 'Start Date of the most recent TB treatment',
    GROUP_CONCAT(IF(obs.concept_id = 326,
            (SELECT DISTINCT
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Case Definition(WHO registration group or previously treated group)',
    GROUP_CONCAT(IF(obs.concept_id = 1208,
            (SELECT DISTINCT
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Previously treated group'
FROM
    obs
        RIGHT JOIN
    patient_identifier ON obs.person_id = patient_identifier.patient_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
 
 -- END OF EMR REVIEW QUERY --
