--openU-20277
--@Evyatar-E
--Exam 2020c_m76
--Question 1

SELECT aircraft.manufacturer, aircraft.ano  
FROM aircraft AS a NATURAL JOIN flies
WHERE since/*since is *a* year and not date*/< 2010 AND NOT EXISTS(
    SELECT pilot.pid
    FROM pilot NATURAL JOIN flies
    WHERE flies.ano = a.ano AND pilot.salary>20,000
);