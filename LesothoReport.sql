SELECT concept_name_type FROM concept_name;
SELECT concept_id FROM concept_name WHERE name LIKE "1 = XDR (resistance to a fluoroquinolone and at least one injectable)";
SELECT COUNT(persion_id) FROM obs WHERE value_coded=328;  -- XDR (resistance to a fluoroquinolone and at least one injectable) --
SELECT COUNT(person_id) FROM obs WHERE value_coded=329;   -- Pre-XDR - fluoroquinolone (resistance to a fluoroquinolone, but susceptible to second-line injectables) --
SELECT COUNT(person_id) FROM obs WHERE value_coded=330;   -- 3 = Pre-XDR - injectable (resistance to at least one second-line injectable, but susceptible to a fluoroquinolone) --
SELECT COUNT(person_id) FROM obs WHERE value_coded=331;   -- 4 = Other patterns of resistance that are not XDR or pre-XDR (two or more Group 4 drugs) --
SELECT COUNT(person_id) FROM obs WHERE value_coded=332;   -- 5 = Contact with a patient infected with a strain with one of the above resistance patterns --
SELECT COUNT(*) FROM obs WHERE value_coded=333;           -- 6 = Unable to tolerate MDR drugs necessary for construction of the regimen --
SELECT COUNT(person_id) FROM obs WHERE value_coded=334;   -- 7 = Patients who have FAILED an MDR regimen --
SELECT value_coded FROM obs WHERE concept_id=338;       -- 338 is ti_patients_const_four_drug_regimen_not_possible --  paper Patients for whom the construction of a regimen with four
                                                          -- likely effective second-line drugs is not possible (check all that apply): -- 4
SELECT person_id, value_coded FROM obs WHERE concept_id=338 ORDER BY person_id;
SELECT 
    patient_identifier.identifier, obs.value_coded
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
        AND concept_id = 338
ORDER BY patient_identifier.identifier;

-- Joining 3 tables --
-- 1 row of identifier, 1 row of result. This duplicates identifiers --
SELECT 
    patient_identifier.identifier, concept_name.name
FROM
    concept_name
        JOIN
    obs ON concept_name.concept_id = obs.value_coded
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
        AND obs.concept_id = 338
        AND concept_name.concept_name_type = 'FULLY_SPECIFIED'
ORDER BY patient_identifier.identifier;

-- Using Group Concat --
-- Lesotho Report --
SELECT 
    patient_identifier.identifier AS 'EMR ID',
    GROUP_CONCAT(IF(obs.concept_id = 338,
            (SELECT 
                    name
                FROM
                    concept_name
                WHERE
                    concept_name.concept_id = obs.value_coded
                        AND concept_name_type = 'SHORT'
                        AND locale = 'en'
                        AND concept_name.voided = 0
                        AND obs.voided = 0),
            NULL)) AS 'Patients for whom the construction of a regimen with four likely effective second-line drugs is not possible (check all that apply)'
FROM
    obs
        JOIN
    patient_identifier ON patient_identifier.patient_id = obs.person_id
GROUP BY patient_identifier.identifier
ORDER BY patient_identifier.identifier;
