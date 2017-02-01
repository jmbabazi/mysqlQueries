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
            'Number of patients on treatment on BDQ',
            COUNT(date_activated))
FROM
    orders
WHERE
    concept_id = 1251 AND voided = 0 
UNION SELECT 
    CONCAT_WS(' = ',
            'Number of patients on treatment on DLM',
            COUNT(date_activated))
FROM
    orders
WHERE
    concept_id = 1252 AND voided = 0;
