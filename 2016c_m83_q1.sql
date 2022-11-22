--openU-20277
--@Evyatar-E
--Exam 2016c_m83
--Question 1


--Section a
SELECT tno
FROM fish NATURAL JOIN tank --NATURAL JOIN species
WHERE tcolor = 'blue' AND sno IN(
                                SELECT sno
                                FROM fish NATURAL JOIN tank --NATURAL JOIN species
                                WHERE tcolor = 'green');


--Section b
SELECT sno, sname AVG(tank.tvolume)
FROM (species AS s) NATURAL JOIN fish NATURAL JOIN tank
WHERE
EXISTS( SELECT
        FROM  ((fish AS f1) join (fish AS f2) USING(sno))
        WHERE f1.sno=s.sno AND f1.tno <> f2.tno)
AND
NOT EXISTS(SELECT fname
          FROM fish NATURAL JOIN tank
          WHERE fish.sno = s.sno AND tank.tvolume>200,000)
GROUP BY sno, sname;