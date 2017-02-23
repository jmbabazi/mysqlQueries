/*EMR ID, person_id, Date (MAX), Result*/
SELECT 
    pi.identifier AS 'EMR ID',
    o.person_id,
    MAX(DATE(o.value_datetime)) AS 'Date',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            concept_id = o1.value_coded
                AND cn.voided = 0
                AND cn.locale = 'en'
                AND cn.concept_name_type = 'SHORT') AS 'Result'
FROM
    obs o
        JOIN
    patient_identifier pi ON pi.patient_id = o.person_id
        AND concept_id = 1090
        AND o.voided = 0
        JOIN
    obs o1 ON o.person_id = o1.person_id
        AND o1.concept_id = 1093
GROUP BY pi.identifier;
