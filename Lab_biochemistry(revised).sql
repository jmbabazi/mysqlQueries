SELECT 
    o1.encounter_id AS 'Encounter ID',
    o1.person_id AS 'ID',
    o1.obs_id AS 'Parent Obs ID',
    o2.obs_id AS 'Child Obs ID',
    o2.obs_group_id AS 'Child Obs group ID',
    DATE(o2.obs_datetime) AS 'Date of Sample collection',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o6.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Type of Assesment',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o3.concept_id
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Lab test',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o4.concept_id
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Lab test with units',
    o5.value_numeric AS 'Value'
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
        AND o2.obs_id = o3.obs_group_id
        AND o3.obs_id = o4.obs_group_id
        AND o4.obs_id = o5.obs_group_id
        AND o1.voided = 0
        AND o2.voided = 0
        AND o3.voided = 0
        AND o4.voided = 0
        AND o5.voided = 0
        AND o5.value_numeric IS NOT NULL
        JOIN
    obs o6 ON o1.obs_id = o6.obs_group_id
        AND o6.concept_id = 809
        AND o6.voided = 0
        AND o6.value_coded IS NOT NULL
ORDER BY o1.person_id;
