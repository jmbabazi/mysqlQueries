SELECT 
    pi.identifier AS 'EMR ID',
    gender AS 'Gender',
    FLOOR(DATEDIFF(NOW(), p.birthdate) / 365) AS 'Age',
    DATE(o1.obs_datetime) AS 'Sample collection date',
    cn1.name AS 'Type of visit',
    cn.name AS 'Pregnancy test',
    o1.voided,
    o1.voided,
    DATE(o1.date_created) AS 'Date form was created',
    DATE(o1.date_voided) AS 'Date from was deleted'
FROM
    obs o1
        JOIN
    patient_identifier pi ON concept_id = 1617
        AND pi.patient_id = o1.person_id
        JOIN
    person p ON p.person_id = o1.person_id
        JOIN
    obs o ON o1.obs_id = o.obs_group_id
        AND o.concept_id = 568
        JOIN
    obs o2 ON o1.obs_id = o2.obs_group_id
        AND o2.concept_id = 809
        JOIN
    concept_name cn ON o.value_coded = cn.concept_id
        AND cn.locale = 'en'
        AND cn.concept_name_type = 'SHORT'
        AND cn.voided = 0
        JOIN
    concept_name cn1 ON o2.value_coded = cn1.concept_id
        AND cn1.locale = 'en'
        AND cn1.concept_name_type = 'SHORT'
        AND cn1.voided = 0
ORDER BY pi.identifier ASC;
