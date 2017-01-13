-- EMR patient ID
-- Patient Dlm start date  
-- Treatment start date
-- Number of days on treatment

SELECT 
    GROUP_CONCAT(DISTINCT patient_identifier.identifier) AS 'EMR ID',
    (SELECT DISTINCT
            CAST(obs_datetime AS DATE)
        FROM
            obs
        WHERE
            obs.concept_id = 1210 AND obs.voided = 0
                AND obs.person_id = patient_identifier.patient_id) AS 'Treatment start date',
    (SELECT DISTINCT
            MIN(CAST(date_activated AS DATE))
        FROM
            orders
        WHERE
            orders.concept_id = 1252
                AND orders.voided = 0
                AND orders.patient_id = patient_identifier.patient_id) AS 'Dlm start date',
    (SELECT 
            DATEDIFF(NOW(), CAST(obs_datetime AS DATE))
        FROM
            obs
        WHERE
            obs.concept_id = 1210 AND obs.voided = 0
                AND obs.person_id = patient_identifier.patient_id) AS 'Number of days on treatment '
FROM
    obs
        JOIN
    patient_identifier ON obs.person_id = patient_identifier.patient_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
