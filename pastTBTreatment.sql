SELECT
    identifier,
    GROUP_CONCAT(IF(concept_id = (SELECT
                    concept_id
                FROM
                    concept_name cn
                WHERE
                    cn.name LIKE '%TUBERCULOSIS DRUG TREATMENT START DATE%'
                        AND cn.concept_name_type = 'FULLY_SPECIFIED'
                        AND cn.locale = 'en'
                        AND voided = 0)
                AND o.voided = 0,
            DATE(o.obs_datetime),
            NULL)) AS 'Treatment start date',
    GROUP_CONCAT(IF(concept_id = (SELECT
                    concept_id
                FROM
                    concept_name cn
                WHERE
                    cn.name LIKE '%Has the patient ever been treated for TB in the past?%'
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0)
                AND o.voided = 0,
            (SELECT
                    name
                FROM
                    concept_name cn
                WHERE
                    cn.concept_id = value_coded
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0),
            NULL)) AS 'Has the patient ever been treated for TB in the past?',
    GROUP_CONCAT(IF(concept_id = (SELECT
                    concept_id
                FROM
                    concept_name cn
                WHERE
                    cn.name LIKE '%How many drug-susceptible TB treatments%'
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0)
                AND o.voided = 0,
            (SELECT
                    name
                FROM
                    concept_name cn
                WHERE
                    cn.concept_id = value_coded
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0),
            NULL)) AS 'How many drug-susceptible TB treatments',
    GROUP_CONCAT(IF(concept_id = (SELECT
                    concept_id
                FROM
                    concept_name cn
                WHERE
                    cn.name LIKE '%How many drug-resistant TB treatments%'
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0)
                AND o.voided = 0,
            (SELECT
                    name
                FROM
                    concept_name cn
                WHERE
      cn.concept_id = value_coded
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0),
            NULL)) AS 'How many drug-resistant TB treatments',
    GROUP_CONCAT(IF(concept_id = (SELECT
                    concept_id
                FROM
                    concept_name cn
                WHERE
                    cn.name LIKE '%Past TB Drug regimen%'
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0)
                AND o.voided = 0,
            (SELECT
                    name
                FROM
                    concept_name cn
                WHERE
                    cn.concept_id = value_coded
                        AND cn.concept_name_type = 'SHORT'
                        AND cn.locale = 'en'
                        AND voided = 0),
            NULL)) AS 'Past TB Drug regimen'
FROM
    obs o
        JOIN
    patient_identifier pi ON pi.patient_id = person_id
        AND pi.voided = 0 and o.obs_datetime BETWEEN '#startDate#' AND '#endDate#'
GROUP BY person_id;
