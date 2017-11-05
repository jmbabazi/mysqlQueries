SELECT 
    pi.identifier,
    DATE(person_id.obs_datetime),
    h.value_numeric AS 	Hemoglobin,
    hct.value_numeric AS 'Hematocrit (%)',
    pc.value_numeric AS 'Platelets count',
    rbc.value_numeric AS 'RBC Count (x10^12/L)',
    wbc.value_numeric AS 'WBC Count (x10^9/L)',
    n.value_numeric AS 'Neutrophils (%)',
    anc.value_numeric AS 'Absolute Neutrophil Count (cells/mm3)'
FROM
    (SELECT DISTINCT
        (person_id), obs_datetime
    FROM
        obs
    WHERE
        concept_id IN (1621 , 1248, 1212, 1213, 1214, 548, 1681)
            AND voided = 0) person_id
        JOIN
    patient_identifier pi ON pi.patient_id = person_id.person_id
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1621
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1657 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) h ON person_id.person_id = h.person_id
        AND person_id.obs_datetime = h.obs_datetime
        LEFT JOIN
    (SELECT
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1248
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1664 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) hct ON person_id.person_id = hct.person_id
        AND person_id.obs_datetime = hct.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1212
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1666 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) pc ON person_id.person_id = pc.person_id
        AND person_id.obs_datetime = pc.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1213
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1670 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) rbc ON person_id.person_id = rbc.person_id
        AND person_id.obs_datetime = rbc.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1214
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1672 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) wbc ON person_id.person_id = wbc.person_id
        AND person_id.obs_datetime = wbc.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 548
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1678 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) n ON person_id.person_id = n.person_id
        AND person_id.obs_datetime = n.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1681
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1680 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) anc ON person_id.person_id = anc.person_id
        AND person_id.obs_datetime = anc.obs_datetime
WHERE
        (h.value_numeric IS NOT NULL
        OR hct.value_numeric IS NOT NULL
        OR pc.value_numeric IS NOT NULL
        OR rbc.value_numeric IS NOT NULL
        OR wbc.value_numeric IS NOT NULL
        OR n.value_numeric IS NOT NULL
        OR anc.value_numeric IS NOT NULL)
ORDER BY pi.identifier , person_id.obs_datetime;
