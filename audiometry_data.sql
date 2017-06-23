SELECT 
    o.person_id,
    pi.identifier AS 'EMR ID',
    DATE(o.obs_datetime) AS 'Date of audiometry assesment',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o8.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Type of assesment',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Left ear at 1000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o1.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Left ear at 2000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o2.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Left ear at 4000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o3.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Left ear at 8000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o4.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Right ear at 1000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o5.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Right ear at 2000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o6.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Right ear at 4000Hz-Coded_old',
    (SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = o7.value_coded
                AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en'
                AND cn.voided = 0) AS 'Right ear at 8000Hz-Coded_old'
FROM
    obs o
        JOIN
    patient_identifier pi ON o.person_id = pi.patient_id
        JOIN
    obs o1 ON o.person_id = o1.person_id
        AND o.encounter_id = o1.encounter_id
        AND o.obs_datetime = o1.obs_datetime
        AND o.concept_id = 2903
        AND o.voided = 0
        AND o1.concept_id = 2904
        AND o1.voided = 0
        JOIN
    obs o2 ON o.person_id = o2.person_id
        AND o.encounter_id = o2.encounter_id
        AND o.obs_datetime = o2.obs_datetime
        AND o2.concept_id = 2905
        AND o2.voided = 0
        JOIN
    obs o3 ON o.person_id = o3.person_id
        AND o.encounter_id = o3.encounter_id
        AND o.obs_datetime = o3.obs_datetime
        AND o3.concept_id = 2907
        AND o3.voided = 0
        JOIN
    obs o4 ON o.person_id = o4.person_id
        AND o.encounter_id = o4.encounter_id
        AND o.obs_datetime = o4.obs_datetime
        AND o4.concept_id = 2910
        AND o4.voided = 0
        JOIN
    obs o5 ON o.person_id = o5.person_id
        AND o.encounter_id = o5.encounter_id
        AND o.obs_datetime = o5.obs_datetime
        AND o5.concept_id = 2911
        AND o5.voided = 0
        JOIN
    obs o6 ON o.person_id = o6.person_id
        AND o.encounter_id = o6.encounter_id
        AND o.obs_datetime = o6.obs_datetime
        AND o6.concept_id = 2912
        AND o6.voided = 0
        JOIN
    obs o7 ON o.person_id = o7.person_id
        AND o.encounter_id = o7.encounter_id
        AND o.obs_datetime = o7.obs_datetime
        AND o7.concept_id = 2914
        AND o7.voided = 0
        JOIN
    obs o8 ON o.person_id = o8.person_id
        AND o.encounter_id = o8.encounter_id
        AND o.obs_datetime = o8.obs_datetime
        AND o8.concept_id = 851
        AND o8.voided = 0;
