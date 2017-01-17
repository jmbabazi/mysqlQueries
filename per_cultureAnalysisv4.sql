create table culture (id_bacteriology_concept_set int(11), regnum VARCHAR(255), d_cult VARCHAR(255), id_cult VARCHAR(255));
create table bacteriology (id_bacteriology_concept_set int(11), regnum VARCHAR(255), d_coll date, id_sample_bk VARCHAR(255));
create table smear (id_bacteriology_concept_set int(11), regnum VARCHAR(255), d_smear date, id_smear VARCHAR(255));
create table treatmentRegistration (id_emr VARCHAR(255), regnum VARCHAR(255), d_reg date);

CULUTURE
##################
LOAD DATA LOCAL INFILE '/vagrant/cultures.csv'
IGNORE INTO TABLE culture
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'-- '\r\n'  or '\n' or ),
    IGNORE 1 LINES
(id_bacteriology_concept_set, regnum, @var1, id_cult)
SET d_cult = STR_TO_DATE(@var1,'%d/%b/%Y');

Bacteriology concept (sample collection date)
#######################
LOAD DATA LOCAL INFILE '/vagrant/bacteriology.csv'
IGNORE INTO TABLE bacteriology
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'-- '\r\n'  or '\n' or ),
    IGNORE 1 LINES
(id_bacteriology_concept_set, regnum, @var1, id_sample_bk)
SET d_coll = STR_TO_DATE(@var1,'%d/%b/%Y');

Smear
######################################
LOAD DATA LOCAL INFILE '/vagrant/smear.csv'
IGNORE INTO TABLE smear
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'-- '\r\n'  or '\n' or ),
    IGNORE 1 LINES
(id_bacteriology_concept_set, regnum, @var1, id_smear)
SET d_smear = STR_TO_DATE(@var1,'%d/%b/%Y');

Treatment Start Date
######################################
LOAD DATA LOCAL INFILE '/vagrant/treatmentRegistration.csv'
IGNORE INTO TABLE treatmentRegistration
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'-- '\r\n'  or '\n' or ),
    IGNORE 1 LINES
(id_emr, regnum, @var1)
SET d_reg = STR_TO_DATE(@var1,'%d/%b/%Y');

DROP temporary table Results;
CREATE TEMPORARY TABLE IF NOT EXISTS Results (id_emr VARCHAR(255), regnum VARCHAR(255), d_coll date, d_smear date, d_cult date, id_sample_bk VARCHAR(255), datediff int(11));
INSERT INTO Results (id_emr, regnum, d_coll, d_smear, d_cult, id_sample_bk , datediff)
SELECT 
    id_emr AS 'EMR ID',
    sc.regnum,
    d_coll AS 'Sample collection date',
    d_smear AS 'Smear date',
    d_cult AS 'Culture innoculation date',
    id_sample_bk AS 'Sample ID',
    DATEDIFF(Now(), d_coll)
FROM
    bacteriology sc
        INNER JOIN
    smear sm ON sc.id_bacteriology_concept_set = sm.id_bacteriology_concept_set
        AND sc.regnum = sm.regnum
        LEFT JOIN
    culture c ON c.id_bacteriology_concept_set = sm.id_bacteriology_concept_set
        AND c.regnum = sm.regnum
        JOIN
    treatmentRegistration tr ON tr.regnum = sm.regnum
ORDER BY sc.regnum , d_coll ASC;

