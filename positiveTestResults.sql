SELECT 
    person_id,
    o.concept_id,
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
    value_coded,
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND locale = 'en'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS Answer
FROM
    obs o
WHERE
    value_coded = (SELECT 
            concept_id
        FROM
            concept_name cn
        WHERE
            cn.name = 'Positive'
                AND cn.concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND cn.locale = 'en'
                AND cn.voided = 0)
        AND voided = 0;
