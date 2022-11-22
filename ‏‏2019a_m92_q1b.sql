--openU-20277
--@Evyatar-E
--Exam 2019a_m92
--Question 1, Section b

WITH u(donor, sa) AS 
    (
        SELECT donor, SUM(amount) AS sa
        FROM donate AS d1 join donate AS d2 using(donor, party)
        WHERE d1.candidate <> d2.candidate
        GROUP BY donor
        HAVING MIN(amount) >=1000
    )
SELECT donor
FROM u
GROUP BY donor
HAVING sa >= ALL(SELECT sa FROM u);