SELECT 
    pi.identifier,
    DATE(person_id.obs_datetime),
    k.value_numeric AS Potassium,
    bun.value_numeric AS Urea,
    cr.value_numeric AS Creatinine,
    glu.value_numeric AS Glucose,
    glu_fast.value_numeric AS 'Glucose fasting',
    hba1c.value_numeric AS HbA1c,
    tsh.value_numeric AS TSH,
    serum.value_numeric AS Serum,
    ast.value_numeric AS AST,
    alt.value_numeric AS ALT,
    total_bil.value_numeric AS 'Total Bilirubin',
    mg.value_numeric AS Magnesium,
    ionized_cal.value_numeric AS 'Inozed Calcium',
    lip.value_numeric AS Lipase
FROM
    (SELECT DISTINCT
        (person_id), obs_datetime
    FROM
        obs
    WHERE
        concept_id IN (1216 , 1217, 1643, 1644, 1220, 1221, 1198, 1250, 1222, 1223, 1249, 822, 1641, 828)
            AND voided = 0) person_id
        JOIN
    patient_identifier pi ON pi.patient_id = person_id.person_id
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1216
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1683 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) k ON person_id.person_id = k.person_id
        AND person_id.obs_datetime = k.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1217
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1695 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) bun ON person_id.person_id = bun.person_id
        AND person_id.obs_datetime = bun.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1643
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1701 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) cr ON person_id.person_id = cr.person_id
        AND person_id.obs_datetime = cr.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1644
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1705 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) glu ON person_id.person_id = glu.person_id
        AND person_id.obs_datetime = glu.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1220
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1707 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) glu_fast ON person_id.person_id = glu_fast.person_id
        AND person_id.obs_datetime = glu_fast.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1198
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1711 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) hba1c ON person_id.person_id = hba1c.person_id
        AND person_id.obs_datetime = hba1c.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1221
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1713 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) tsh ON person_id.person_id = tsh.person_id
        AND person_id.obs_datetime = tsh.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1250
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1725 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) serum ON person_id.person_id = serum.person_id
        AND person_id.obs_datetime = serum.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1222
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1717 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) ast ON person_id.person_id = ast.person_id
        AND person_id.obs_datetime = ast.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1223
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1719 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) alt ON person_id.person_id = alt.person_id
        AND person_id.obs_datetime = alt.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1249
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1721 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) total_bil ON person_id.person_id = total_bil.person_id
        AND person_id.obs_datetime = total_bil.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 822
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1687 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) mg ON person_id.person_id = mg.person_id
        AND person_id.obs_datetime = mg.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 1641
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1693 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) ionized_cal ON person_id.person_id = ionized_cal.person_id
        AND person_id.obs_datetime = ionized_cal.obs_datetime
        LEFT JOIN
    (SELECT 
        person_id, obs_datetime, value_numeric
    FROM
        obs
    WHERE
        concept_id = 828
            AND obs_group_id IN (SELECT 
                obs_group_id
            FROM
                obs
            WHERE
                concept_id = 1715 AND value_coded = 1
                    AND voided = 0)
            AND voided = 0) lip ON person_id.person_id = lip.person_id
        AND person_id.obs_datetime = lip.obs_datetime
WHERE
    (k.value_numeric IS NOT NULL
        OR bun.value_numeric IS NOT NULL
        OR cr.value_numeric IS NOT NULL
        OR glu.value_numeric IS NOT NULL
        OR glu_fast.value_numeric IS NOT NULL
        OR hba1c.value_numeric IS NOT NULL
        OR tsh.value_numeric IS NOT NULL
        OR serum.value_numeric IS NOT NULL
        OR ast.value_numeric IS NOT NULL
        OR alt.value_numeric IS NOT NULL
        OR total_bil.value_numeric IS NOT NULL
        OR mg.value_numeric IS NOT NULL
        OR ionized_cal.value_numeric IS NOT NULL
        OR lip.value_numeric IS NOT NULL)
ORDER BY pi.identifier , person_id.obs_datetime;
