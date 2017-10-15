SELECT 
    pi.identifier AS 'EMR ID',
    DATE (tr.obs_datetime) AS 'Treatment start date',
    ROUND(DATEDIFF(NOW(), tr.obs_datetime)/30,1) AS Month,
    DATE(o.obs_datetime) 'Date of EKG',
    ROUND(DATEDIFF(o.obs_datetime, tr.obs_datetime)/30,1) AS 'Month of EKG assesment',
    GROUP_CONCAT(DISTINCT IF(orders.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_set
                WHERE
                    concept_set = (SELECT 
                            concept_id
                        FROM
                            concept_name
                        WHERE
                            name LIKE '%All TB Drugs%'
                                AND concept_name_type = 'FULLY_SPECIFIED'
                                AND voided = 0
                                AND locale = 'en')
                        AND orders.voided = 0
                        AND orders.auto_expire_date IS NULL
                        AND orders.date_stopped IS NULL), 
                        (SELECT 
                    name
                FROM
                    concept_name cn
                WHERE
                    cn.concept_id = orders.concept_id
                        AND locale = 'en'
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND voided = 0),
            NULL)) AS 'TB drugs (Active regimen)',
            GROUP_CONCAT(DISTINCT IF(orders.concept_id IN (SELECT 
                    concept_id
                FROM
                    concept_set
                WHERE
                    concept_set = (SELECT 
                            concept_id
                        FROM
                            concept_name
                        WHERE
                            name LIKE '%All TB Drugs%'
                                AND concept_name_type = 'FULLY_SPECIFIED'
                                AND voided = 0
                                AND locale = 'en')
                        AND orders.voided = 0
                        AND orders.auto_expire_date IS NOT NULL
                        OR orders.date_stopped IS NOT NULL), 
                        (SELECT 
                    name
                FROM
                    concept_name cn
                WHERE
                    cn.concept_id = orders.concept_id
                        AND locale = 'en'
                        AND concept_name_type = 'FULLY_SPECIFIED'
                        AND voided = 0),
            NULL)) AS 'Stopped TB drugs',
    o2.value_numeric AS 'Heart rate',
    o.value_numeric AS 'QT Interval',
    o1.value_numeric AS 'QTcF Interval'
FROM
    obs o
        JOIN
    obs o1 ON o.person_id = o1.person_id
        AND o.obs_group_id = o1.obs_group_id
        AND o.concept_id = 674
        AND o.value_numeric > 450
        AND o.voided = 0
        AND o1.concept_id = 517
        AND o1.voided = 0
        JOIN obs o2 ON
        o2.person_id=o1.person_id
        AND o2.obs_group_id = o.obs_group_id
        AND o2.concept_id = 672
        AND o2.voided =0
        JOIN obs tr on o.person_id = tr.person_id 
        AND tr.concept_id = 1210
        AND tr.voided = 0
        JOIN
    orders ON orders.patient_id = o.person_id and orders.voided=0
        JOIN
    patient_identifier pi ON pi.patient_id = o.person_id
    Group by o.obs_datetime
ORDER BY pi.identifier , o.obs_datetime;
