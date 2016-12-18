-- Returns ID for patients who are XDR, Pre-XDR - fluoroquinolone and Pre-XDR - Injectable --
SELECT 
    GROUP_CONCAT(IF(obs.value_coded = 328,
            (SELECT 
                    patient_identifier.identifier
                FROM
                    patient_identifier
                WHERE
                    patient_identifier.patient_id = obs.person_id
                        AND obs.value_coded = 328 and obs.voided=0),
            NULL)) AS 'XDR (resistance to a fluoroquinolone and at least one injectable)',
    GROUP_CONCAT(IF(obs.value_coded = 329,
            (SELECT 
                    patient_identifier.identifier
                FROM
                    patient_identifier
                WHERE
                    patient_identifier.patient_id = obs.person_id
                        AND obs.value_coded = 329 and obs.voided=0),
            NULL)) AS 'Pre-XDR - fluoroquinolone (resistance to a fluoroquinolone, but susceptible to second-line injectables)',
    GROUP_CONCAT(IF(obs.value_coded = 330,
            (SELECT 
                    patient_identifier.identifier
                FROM
                    patient_identifier
                WHERE
                    patient_identifier.patient_id = obs.person_id
                        AND obs.value_coded = 330 and obs.voided=0),
            NULL)) AS 'Pre-XDR - injectable (resistance to at least one second-line injectable, but susceptible to a fluoroquinolone'
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
