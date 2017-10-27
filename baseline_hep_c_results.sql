SELECT 
    person_id,
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.concept_id
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS question,
    concept_id,
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.value_coded
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS answer,
    value_coded
FROM
    obs o
WHERE
    concept_id = (SELECT 
            concept_id
        FROM
            concept_name cn
        WHERE
            name LIKE '%Baseline, Hepatitis C%'
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND cn.locale = 'en'
                AND cn.voided = 0)
        AND voided = 0;
