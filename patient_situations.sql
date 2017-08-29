/* 
This query returns results for situation 3 patients.
Fields returned
EMR ID, Treatment start date, Situation 3 and Current month of treatment
/*

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
    patient_identifier pi ON o.value_coded = 2267 AND o.voided = 0
        AND pi.patient_id = o.person_id
        JOIN
    obs o1 ON o1.person_id = o.person_id
        AND o1.concept_id = 1210
        AND o1.voided = 0
ORDER BY pi.identifier ASC;
