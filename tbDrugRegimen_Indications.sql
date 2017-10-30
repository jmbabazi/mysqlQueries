SELECT 
    o.patient_id,
    MIN(DATE(o.scheduled_date)) AS Bdq_start_date,
    o.concept_id,
    MIN(DATE(o1.scheduled_date)) AS Dlm_start_date,
    o1.concept_id,
	(SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = obs.value_coded AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en' and cn.voided = 0) AS 'Patient indications_4',
	(SELECT 
            name
        FROM
            concept_name cn
        WHERE
            cn.concept_id = obs1.value_coded AND cn.concept_name_type = 'SHORT'
                AND cn.locale = 'en' and cn.voided = 0) AS 'Patient indications_not_possible',
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1252
                AND voided = 0) AS DLM,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1225
                AND voided = 0) AS H,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 237
                AND voided = 0) AS Z,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1226
                AND voided = 0) AS R,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1221
                AND voided = 0) AS E,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 227
                AND voided = 0) AS K,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 242
                AND voided = 0) AS S,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 215
                AND voided = 0) AS Am,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 219
                AND voided = 0) AS Cm,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 228
                AND voided = 0) AS Lfx,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 231
                AND voided = 0) AS Mfx,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 236
                AND voided = 0) AS Pto,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 223
                AND voided = 0) AS Eto,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 220
                AND voided = 0) AS Cs,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 244
                AND voided = 0) AS Trd,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 235
                AND voided = 0) AS PAS,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1227
                AND voided = 0) AS 'PAS-Na',
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 218
                AND voided = 0) AS Cfz,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1228
                AND voided = 0) AS 'Imp/Cln',
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 216
                AND voided = 0) AS 'Amx/Clv',
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 230
                AND voided = 0) AS Mpm,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 1258
                AND voided = 0) AS Clr,
    (SELECT 
            concept_id
        FROM
            orders
        WHERE
            MIN(o.scheduled_date) = scheduled_date
                AND o.patient_id = patient_id
                AND o.encounter_id = encounter_id
                AND concept_id = 229
                AND voided = 0) AS Lzd
FROM
    orders o
        JOIN
    orders o1 ON o.concept_id = 1251 AND o.voided = 0
        AND o.patient_id = o1.patient_id
        AND o1.voided = 0
        OR o1.concept_id = 1252
	JOIN obs on obs.person_id = o.patient_id and obs.voided = 0 and obs.concept_id = 338
    join obs obs1 on obs1.person_id = o.patient_id and obs1.voided = 0 and obs1.concept_id = 339
GROUP BY o.patient_id;
