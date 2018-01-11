SELECT 
    identifier
FROM
    patient_identifier
WHERE
    patient_id NOT IN (SELECT 
            person_id
        FROM
            obs
        WHERE
            concept_id = 1210 AND voided = 0);
