SELECT 
    pi.identifier,
    DATE(o3.obs_datetime) AS 'Treatment start date / Дата начала лечения',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = obs.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'ru'
                AND voided = 0) AS 'Consent for New drug explained and signed? / Информированное согласие на прием новых препаратов',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = o1.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'ru'
                AND voided = 0) AS 'Consent for the endTB Observational study explained and signed? / Информированное согласие на endTB исследование',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = o2.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'ru'
                AND voided = 0) AS 'Consent for freezing isolates explained and signed?'
FROM
    patient_identifier pi
        LEFT JOIN
    obs ON pi.patient_id = obs.person_id
        AND pi.voided = 0
        AND obs.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TI, Has the Treatment with New Drugs Consent Form been explained and signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND voided = 0
                AND locale = 'en')
        AND obs.voided = 0
        LEFT JOIN
    obs o1 ON pi.patient_id = o1.person_id
        AND o1.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TI, Has the endTB Observational Study Consent Form been explained and signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND voided = 0
                AND locale = 'en')
        AND o1.voided = 0
        LEFT JOIN
    obs o2 ON pi.patient_id = o2.person_id
        AND o2.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%T.I, Consent for freezing isolates signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND voided = 0
                AND locale = 'en')
        AND o2.voided = 0
        JOIN
    obs o3 ON pi.patient_id = o3.person_id
        AND o3.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TUBERCULOSIS DRUG TREATMENT START DATE%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND voided = 0
                AND locale = 'en')
        AND o3.voided = 0
        AND o3.obs_datetime BETWEEN '#startDate#' AND '#endDate#'
ORDER BY pi.identifier;
