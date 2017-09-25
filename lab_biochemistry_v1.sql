SELECT 
    o1.person_id,
    DATE(o1.obs_datetime),
    GROUP_CONCAT(IF(o1.concept_id = 1216
                AND o2.concept_id = 1683
                AND o2.value_coded = 1
                AND o1.voided = 0
                AND o2.voided = 0,
            o1.value_numeric,
            NULL)),
    GROUP_CONCAT(IF(o1.concept_id = 1217
                AND o2.concept_id = 1695
                AND o2.value_coded = 1
                AND o1.voided = 0
                AND o2.voided = 0,
            o1.value_numeric,
            NULL))
FROM
    obs o1
        JOIN
    obs o2 ON o2.person_id = o1.person_id
        AND o1.obs_group_id = o2.obs_group_id
        AND o1.obs_datetime = o2.obs_datetime
GROUP BY o1.obs_datetime
