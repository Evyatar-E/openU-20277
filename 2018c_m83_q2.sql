--openU-20277
--@Evyatar-E
--Exam 2015a_m84
--Question 2


--Section a
SELECT host.vname
FROM (host NATURAL JOIN enemy) JOIN hero USING (hname)
WHERE hero.power = 'fly'
GROUP BY vname
HAVING COUNT(cname) < ANY(
        SELECT COUNT(cname)
        FROM host
        GROUP BY vname)
);
-- villian hero enemy host

--Section b
SELECT hname
FROM city NATURAL JOIN hero NATURAL JOIN enemy
    NATURAL JOIN (  SELECT vname
                    FROM host NATURAL JOIN city
                    WHERE city.population>50,000)
WHERE city.population>1,000,000;


--Section c
CREATE OR REPLACE FUNCTION scf() RETURNS TRIGGER AS $$
DECLARE 
vcs record;
hc record;
BEGIN

(SELECT host.cname
FROM new.vname NATURAL JOIN host) INTO vcs;
(SELECT  hero.cname
FROM new.hname NATURAL JOIN hero) INTO hs ;

IF
(hs IN (vcs))
THEN
RETURN new;
ELSE
RAISE NOTICE 'scf(): The hero and the villain do not share a common city and therefore can not be enemies'
RETURN null;
END IF;
/*
אותה עיר>-  מחזיר את 
new
אחרת שולח הודעה שולח לטריגר 
null
        */

END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER samecity
        BEFORE INSERT ON enemy
FOR EACH ROW
EXECUTE PROCEDURE scf();