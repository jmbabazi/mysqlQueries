/* including cummulative total */
SELECT 
    DATE_FORMAT(mycount, '%Y/%M') AS Date,
    COUNT(mycount) AS 'Patients enrolled' #,
    # @running_sum:=IF(@running_sum=COUNT(mycount),1, @running_sum)+COUNT(mycount) AS 'Cummulative enrollment'
FROM
    (SELECT 
        MIN(date_activated) mycount
    FROM
        orders
    WHERE
        concept_id = 1251 OR concept_id = 1252
    GROUP BY patient_id) temp_orders
        JOIN
    (SELECT @running_sum:=0 AS dummy) dummy
GROUP BY MONTH(temp_orders.mycount)
ORDER BY DATE_FORMAT(mycount, '%Y/%m') ASC;

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

/* Count patients who are/were either on BDQ or DLM */
SELECT 
    COUNT(mycount)
FROM
    (SELECT 
        MIN(date_activated) mycount
    FROM
        orders
    WHERE
        concept_id = 1251 or concept_id=1252
    GROUP BY patient_id) tempOrdersTable;
    
    
