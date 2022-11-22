--openU-20277
--@Evyatar-E
--Exam 2016a_m83
--Question 2, Section a

SELECT parent.id, parent.name, COUNT(child.id)
FROM parent JOIN child  ON parent.id = child.pid
GROUP BY parent.id, parent.name
HAVING COUNT(child.id)>=3 
    AND parent.id NOT IN(
        SELECT parent.id
        FROM ((parent JOIN mincome USING(id)) JOIN (child NATURAL JOIN agecat) ON parent.id = child.pid)
        WHERE mincome.month="january" AND mincome.total <= agecat.exempt
        );