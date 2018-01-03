SELECT 
    pi.identifier as 'EMR ID',
    DATE(o.obs_datetime) AS 'Date',
    DATE(o1.obs_datetime) AS 'Date of culture innoculation',
     (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Isolate frozen?',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o1.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Culture results'
FROM
    obs o
        JOIN
    obs o1 ON o.person_id = o1.person_id
        AND o.concept_id = 2900
        AND o1.concept_id = 1138
        AND o.voided = 0
        AND o1.voided = 0
        AND o1.obs_datetime = o.obs_datetime
        JOIN patient_identifier pi on pi.patient_id=o.person_id;
