SELECT 
    TA.identifier,
    DATE(TI.obs_datetime) AS 'Treatment start date',
    DATE(Bact.obs_datetime) AS 'AFB Smear date',
    DATEDIFF(DATE(Bact.obs_datetime),
            DATE(TI.obs_datetime)) AS 'Interval in day(s)',
    TIMESTAMPDIFF(MONTH,
        DATE(TI.obs_datetime),
        DATE(Bact.obs_datetime)) AS 'Interval in Month(s)'
FROM
    (SELECT DISTINCT
        (identifier), patient_id
    FROM
        patient_identifier pi
    INNER JOIN obs o ON pi.patient_id = o.person_id) AS TA
        INNER JOIN
    (SELECT 
        person_id, obs_datetime
    FROM
        obs
    WHERE
        concept_id = 1210) AS TI
        INNER JOIN
    (SELECT 
        person_id, obs_datetime
    FROM
        obs
    WHERE
        concept_id = 1090) AS Bact

        ON TI.person_id = Bact.person_id
        AND TA.patient_id = TI.person_id 
        
ORDER BY TI.person_id , Bact.obs_datetime ASC;
