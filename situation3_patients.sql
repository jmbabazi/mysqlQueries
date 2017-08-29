SELECT 
    pi.identifier AS 'EMR ID',
    DATE(o1.obs_datetime) AS 'Treatment start date',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en') AS 'Patient situation',
    TIMESTAMPDIFF(MONTH,
        o1.obs_datetime,
        NOW()) AS 'Current month of treatment'
FROM
    obs o
        JOIN
    patient_identifier pi ON o.value_coded = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%Situation 3%'
                AND concept_name_type = 'SHORT'
                AND voided = 0
                AND locale = 'en')
        AND o.voided = 0
        AND pi.patient_id = o.person_id
        JOIN
    obs o1 ON o1.person_id = o.person_id
        AND o1.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TUBERCULOSIS DRUG TREATMENT START DATE%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND voided = 0
                AND locale = 'en')
        AND o1.voided = 0
ORDER BY pi.identifier ASC;
