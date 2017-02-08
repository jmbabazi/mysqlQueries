DROP PROCEDURE IF EXISTS cumulative_enrollment;
CREATE PROCEDURE cumulative_enrollment ()
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS cumulative_value (Dates VARCHAR(255), count INT(11));
insert into cumulative_value (Dates, count)
        SELECT
            DATE_FORMAT(mycount, '%Y/%M') AS 'Date',
            COUNT(mycount) AS 'Patients enrolled'
        FROM
            (SELECT
                MIN(date_activated) mycount
            FROM
                orders
            WHERE
                concept_id = 1251 OR concept_id = 1252
            GROUP BY patient_id) as temp_orders
        GROUP BY MONTH(temp_orders.mycount)
        ORDER BY DATE_FORMAT(mycount, '%Y/%m');

SELECT
    Dates AS 'Year and Month', count AS 'Patients enrolled in a month', @runningTotal:=@runningTotal + count AS 'Cumulative enrollment'
FROM
    cumulative_value
        JOIN
    (SELECT @runningTotal:=0 AS dummy) dummy;

DROP TEMPORARY TABLE cumulative_value;

END
