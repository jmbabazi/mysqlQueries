/*
1. emr id 
2. treatment start date
3. situation
4. date_created
5.  date_changed
6. consnt_drugs
7. consent_study
8. frozen_isolate_consent 
*/

SELECT 
    identifier AS 'EMR ID',
    DATE(pi.date_created) AS 'Date EMR ID created',
    DATE(pi.date_changed) AS 'Date EMR ID changed',
    DATE(o.obs_datetime) AS 'Treatment start date',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = s.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'en'
                AND voided = 0) AS 'Situation',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = sc.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'en'
                AND voided = 0) AS 'Treatment with ND consent explained and signed',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = co.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'en'
                AND voided = 0) AS 'endTB Observational study consent explained and signed',
    (SELECT 
            name
        FROM
            concept_name
        WHERE
            concept_id = cf.value_coded
                AND concept_name_type = 'SHORT'
                AND locale = 'en'
                AND voided = 0) AS 'Freezing isolates consent signed'
FROM
    patient_identifier pi
        LEFT JOIN
    obs o ON pi.patient_id = o.person_id
        AND pi.voided = 0
        AND o.voided = 0
        AND concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TUBERCULOSIS DRUG TREATMENT START DATE%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en')
        LEFT JOIN
    obs s ON s.person_id = pi.patient_id
        AND s.voided = 0
        AND s.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TI, What is the situation of the patient?%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en')
        LEFT JOIN
    obs sc ON sc.person_id = pi.patient_id
        AND sc.voided = 0
        AND sc.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TI, Has the Treatment with New Drugs Consent Form been explained and signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en')
        LEFT JOIN
    obs co ON co.person_id = pi.patient_id
        AND co.voided = 0
        AND co.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%TI, Has the endTB Observational Study Consent Form been explained and signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en')
        LEFT JOIN
    obs cf ON cf.person_id = pi.patient_id
        AND cf.voided = 0
        AND cf.concept_id = (SELECT 
            concept_id
        FROM
            concept_name
        WHERE
            name LIKE '%T.I, Consent for freezing isolates signed%'
                AND concept_name_type = 'FULLY_SPECIFIED'
                AND locale = 'en') order by pi.identifier;
