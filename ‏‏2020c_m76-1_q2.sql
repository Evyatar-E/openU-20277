--openU-20277
--@Evyatar-E
--Exam 2020c_m76
--Question 2


WITH manuplane(mname, avgage) as
(
    SELECT manufacture, AVG(current_date- pilot.byear)
    FROM aircraft NATURAL JOIN flies NATURAL JOIN pilot
    WHERE ayear<2010
    GROUP BY manufacture
)
SELECT mname
FROM manuplane
GROUP BY manufacturer 
HAVING avgage<=MIN(avgage);