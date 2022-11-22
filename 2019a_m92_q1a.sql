--openU-20277
--@Evyatar-E
--Exam 2019a_m92
--Question 1, Section a

SELECT /*d.*/candidate
FROM donate AS d
WHERE d.type='oil industry'
AND d.donor NOT IN(
    SELECT donor
    FROM donate AS d2
    WHERE d2.party = 'big dwarfs'
);