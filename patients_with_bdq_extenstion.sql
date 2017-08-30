SELECT 
    concept_id,
    patient_id,
    date_activated,
    scheduled_date,
    auto_expire_date,
    date_stopped,
    DATEDIFF(NOW(), scheduled_date)
    -- COUNT(patient_id)
FROM
    orders
WHERE
    concept_id = 1251
        AND date_stopped IS NULL
        AND auto_expire_date IS NULL
        AND voided = 0
        AND DATEDIFF(NOW(), scheduled_date) > 181
ORDER BY patient_id;
