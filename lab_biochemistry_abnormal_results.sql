SELECT 
    o1.concept_id, o1.value_numeric, o2.value_coded
FROM
    obs o1
        JOIN
    obs o2 ON o2.person_id = o1.person_id
WHERE
    o1.concept_id = 1216
        AND o2.concept_id = 1683
        AND o2.value_coded = 2
        AND o1.voided = 0
        AND o2.voided = 0;
