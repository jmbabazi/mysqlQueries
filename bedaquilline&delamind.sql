#BDQ #removed o.date_stopped IS NULL
SELECT 
    pi.identifier AS 'EMR ID',
    DATE(MIN(scheduled_date)) AS 'DATE'
FROM
    orders o
        JOIN
    patient_identifier pi ON pi.patient_id = o.patient_id
        AND o.concept_id = 1251
        AND o.voided = 0
GROUP BY o.patient_id
ORDER BY pi.identifier ASC;


#DLM #removed o.date_stopped IS NULL
SELECT 
    pi.identifier AS 'EMR ID',
    DATE(MIN(scheduled_date)) AS 'DATE'
FROM
    orders o
        JOIN
    patient_identifier pi ON pi.patient_id = o.patient_id
        AND o.concept_id = 1252
        AND o.voided = 0
GROUP BY o.patient_id
ORDER BY pi.identifier ASC;


#Both BDQ and DLM #removed o.date_stopped IS NULL and o1.date_stopped IS NULL
SELECT 
    pi.identifier AS 'EMR ID',
    DATE(MIN(o.scheduled_date)) AS 'BDQ start date',
    DATE(MIN(o1.scheduled_date)) AS 'DLM start date'
FROM
    orders o
        JOIN
    patient_identifier pi ON pi.patient_id = o.patient_id
        JOIN
    orders o1 ON o.patient_id = o1.patient_id
        AND o.concept_id = 1251
        AND o1.concept_id = 1252
        AND o.voided = 0
GROUP BY o.patient_id
ORDER BY pi.identifier ASC;
