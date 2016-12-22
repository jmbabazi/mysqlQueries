SELECT 
    patient_identifier.identifier,
    MAX(CASE obs.value_coded
        WHEN 328 THEN 'YES'
    END) AS 'XDR (resistance to a fluoroquinolone and at least one injectable)',
    MAX(CASE obs.value_coded
        WHEN 329 THEN 'YES'
    END) AS 'Pre-XDR - fluoroquinolone (resistance to a fluoroquinolone, but susceptible to second-line injectables)',
    MAX(CASE obs.value_coded
        WHEN 330 THEN 'YES'
    END) AS 'Pre-XDR - injectable (resistance to at least one second-line injectable, but susceptible to a fluoroquinolone)',
    MAX(CASE obs.value_coded
        WHEN 331 THEN 'YES'
    END) AS 'Other patterns of resistance that are not XDR or pre-XDR (two or more Group 4 drugs)',
    MAX(CASE obs.value_coded
        WHEN 332 THEN 'YES'
    END) AS 'Contact with a patient infected with a strain with one of the above resistance patterns',
    MAX(CASE obs.value_coded
        WHEN 333 THEN 'YES'
    END) AS 'Unable to tolerate MDR drugs necessary for construction of the regimen',
    MAX(CASE obs.value_coded
        WHEN 334 THEN 'YES'
    END) AS 'Patients who have FAILED an MDR regimen'
FROM
    patient_identifier
        JOIN
    obs ON patient_identifier.patient_id = obs.person_id
        AND obs.voided = 0
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
