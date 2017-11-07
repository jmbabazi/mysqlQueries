SELECT
    identifier AS 'EMR ID',
    DATE(obs_datetime) AS 'Date of ECG',
    value_numeric AS 'QTcF interval (ms)'
FROM
    obs
        JOIN
    patient_identifier pi ON pi.patient_id = obs.person_id
        AND obs.concept_id = (SELECT
            concept_id
        FROM
            concept
        WHERE
            uuid = '17b179c7-ca16-4c93-a00d-12f2721b17bf')
        AND obs.voided = 0
        AND pi.voided = 0 AND value_numeric > 450 AND obs_datetime BETWEEN '#startDate#' AND '#endDate#'
ORDER BY identifier , obs_datetime;
