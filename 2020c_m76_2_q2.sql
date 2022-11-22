--openU-20277
--@Evyatar-E
--Exam 2020c_m76_2
--Question 2

WITH amig(ano, cpid) AS(
    SELECT a.ano, COUNT(flies.pid)
    FROM aircraft AS a
        NATURAL JOIN flies
    WHERE manufacturer ='מיג'
        AND ayear > 2010
    GROUP BY amig.ano
)
SELECT ano
FROM amig
WHERE cpid>=all( SELECT cpid FROM amig);


--  Another,  with "into"
SELECT a.ano, COUNT(flies.pid)AS cpid INTO QWE
FROM aircraft AS a
    NATURAL JOIN flies
WHERE manufacturer ='מיג'
    AND ayear > 2010
GROUP BY amig.ano;

SELECT ano
FROM amig
WHERE cpid>=all( SELECT cpid FROM amig);