SELECT 
    CONCAT_WS(' = ',
            'Number of patients on treatment',
            COUNT(obs_datetime)) AS Totals
FROM
    obs
WHERE
    concept_id = 1210 AND voided = 0 
UNION SELECT 
    CONCAT_WS(' = ',
            'Number of patients on BDQ',
            COUNT(mycount))
FROM
    (SELECT 
        MIN(scheduled_date) mycount
    FROM
        orders
    WHERE
        concept_id = 1251 AND voided = 0
    GROUP BY patient_id) temp_orders 
UNION SELECT 
    CONCAT_WS(' = ',
            'Number of patients on DLM',
            COUNT(mycount1))
FROM
    (SELECT 
        MIN(scheduled_date) mycount1
    FROM
        orders
    WHERE
        concept_id = 1252 AND voided = 0
    GROUP BY patient_id) temp_orders1 
UNION SELECT 
    CONCAT_WS(' = ',
            'Number of patients on DLM and BDQ',
            COUNT(mycount2))
FROM
    (SELECT 
        MIN(scheduled_date) mycount2
    FROM
        orders
    WHERE
        (concept_id = 1252 AND voided = 0)
            AND (concept_id = 1251 AND voided = 0)
    GROUP BY patient_id) temp_orders2;
