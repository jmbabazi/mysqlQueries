SELECT * FROM 
(
SELECT
    person_id, DATE(obs_datetime), value_coded
FROM
    obs
WHERE
    (concept_id = 1093 AND value_coded = 248)
        OR (concept_id = 1093 AND value_coded = 1825)
        OR (concept_id = 1093 AND value_coded = 1826)
        OR (concept_id = 1093 AND value_coded = 1095)
        OR (concept_id = 1093 AND value_coded = 1096)
        OR (concept_id = 1093 AND value_coded = 1097)
        OR (concept_id = 1093 AND value_coded = 1092) order by person_id) SMEAR,
(
SELECT
	DATE(obs_datetime), value_coded
FROM
    obs
WHERE
    (concept_id = 1093 AND value_coded = 248)
        OR (concept_id = 1138 AND value_coded = 1134)
        OR (concept_id = 1138 AND value_coded = 1135)
        OR (concept_id = 1138 AND value_coded = 1136)
        OR (concept_id = 1138 AND value_coded = 1137)
        OR (concept_id = 1138 AND value_coded = 246) order by person_id) CULTURE;
