--openU-20277
--@Evyatar-E
--Exam 2020c_m76_3

--#2020c_m76_3_q1+2

--Question 1
SELECT manufacturer
FROM aircraft          AS a
    NATURAL JOIN flies AS f
    NATURAL JOIN pilot AS p
WHERE pilot.salary >17800
    AND NOT EXISTS (
        SELECT * 
        FROM aircraft
            NATURAL JOIN flies
        WHERE aircraft.manufacturer = a.manufacturer
            AND flies.since > 2016
    );

--Question 2
SELECT pid
FROM flies
    NATURAL JOIN pilot
WHERE pilot.salary>30000
GROUP BY pid
HAVING COUNT(ano) >= ALL(
    SELECT COUNT(ano)
    FROM flies
        NATURAL JOIN pilot
    WHERE pilot.salary>30000
    GROUP BY pid
);