/* List patients and date they started taking BDQ, including patients with no active bdq drug*/
SELECT 
    pi.identifier, MIN(o.date_activated)
FROM
    patient_identifier pi
        LEFT JOIN
    orders o ON pi.patient_id = o.patient_id
        AND o.concept_id = 1251
GROUP BY o.patient_id
ORDER BY pi.identifier ASC;

/* Count patients who are on BDQ */
SELECT 
    COUNT(mycount)
FROM
    (SELECT 
        MIN(date_activated) mycount
    FROM
        orders
    WHERE
        concept_id = 1251
    GROUP BY patient_id) tempOrdersTable;
    
 /* List patients and their BDQ start date*/
 SELECT 
    patient_id, MIN(date_activated)
FROM
    orders
WHERE
    concept_id = 1251
GROUP BY patient_id;
    
    
