SELECT 
    *
FROM
    (SELECT DISTINCT
        (pi.identifier) AS 'EMR ID'
    FROM
        patient_identifier pi
    JOIN obs ON pi.patient_id = obs.person_id
    ORDER BY person_id) EMR_ID,
    (SELECT 
        person_id, DATE(obs_datetime), value_coded
    FROM
        obs
    WHERE
        (concept_id = 1093 AND value_coded = 248)
            OR (concept_id = 1093 AND value_coded = 1825)
            OR (concept_id = 1093 AND value_coded = 1826)
            OR (concept_id = 1093 AND value_coded = 1095)
            OR (concept_id = 1093 AND value_coded = 1096)
            OR (concept_id = 1093 AND value_coded = 1097)
            OR (concept_id = 1093 AND value_coded = 1092)
    ORDER BY person_id) SMEAR,
    (SELECT 
        DATE(obs_datetime), value_coded
    FROM
        obs
    WHERE
			(concept_id = 1138 AND value_coded = 1134)
            OR (concept_id = 1138 AND value_coded = 1135)
            OR (concept_id = 1138 AND value_coded = 1136)
            OR (concept_id = 1138 AND value_coded = 1137)
            OR (concept_id = 1138 AND value_coded = 246)
    ORDER BY person_id) CULTURE;
