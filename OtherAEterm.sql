SELECT 
    pi.identifier AS 'EMR ID',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.concept_id
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS Field,
    o.value_text AS 'Other AE term'
FROM
    obs o
        JOIN
    patient_identifier pi ON pi.patient_id = o.person_id
        AND o.concept_id = 1436
        AND o.voided = 0
GROUP BY o.person_id
ORDER BY pi.identifier;
