SELECT 
    o1.encounter_id,
    o1.person_id,
    o1.obs_id,
    o2.obs_id,
    o2.obs_group_id,
    DATE(o2.obs_datetime),
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o3.concept_id
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'),
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o4.concept_id
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'),
    o5.value_numeric
FROM
    obs o1
        JOIN
    obs o2
        JOIN
    obs o3
        JOIN
    obs o4
        JOIN
    obs o5 ON o1.obs_id = o2.obs_group_id
        AND o1.concept_id = 1650
        AND o2.concept_id = 593
        AND o2.obs_id = o3.obs_group_id
        AND o3.obs_id = o4.obs_group_id
        AND o4.obs_id = o5.obs_group_id
        AND o1.voided = 0
        AND o2.voided = 0
        AND o3.voided = 0
        AND o4.voided = 0
        AND o5.voided = 0
        AND o5.value_numeric IS NOT NULL
ORDER BY o1.person_id;
