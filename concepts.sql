SELECT 
    concept_id,
    GROUP_CONCAT(IF(concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en'
                AND voided = 0
                AND voided = 0,
            (SELECT name),
            NULL)) AS 'Full Name',
    GROUP_CONCAT(IF(concept_name_type = 'SHORT'
                AND locale = 'en'
                AND voided = 0,
            (SELECT name),
            NULL)) AS 'Short Name',
    GROUP_CONCAT(IF(concept_name_type = 'SHORT'
                AND locale = 'es'
                AND voided = 0,
            (SELECT name),
            NULL)) AS ' Translated Short Name'
FROM
    concept_name
GROUP BY concept_id;
