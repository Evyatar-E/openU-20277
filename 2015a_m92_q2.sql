--openU-20277
--@Evyatar-E
--Exam 2015a_m92
--Question 2



--Section a
SELECT tdate, COUNT(hip, cip)
FROM access
WHERE (access.tdate BETWEEN current_date-30 AND current_date) AND access.hip = "earth.example.net"
GROUP BY tdate


--Section b
SELECT * INTO ow
FROM (directory AS d) 
WHERE d.isroot = false AND NOT IN ( SELECT directory.*
                                    FROM directory NATURAL JOIN file);

SELECT directory.* INTO oc
FROM (ow JOIN parent on(directory.dname = parent.pdname AND directory.phip = parent.chip)) JOIN directory on(directory.dname = parent.cdname AND directory.hip = parent.chip);

SELECT oc.dname, oc.hip
FROM oc NATURAL JOIN file
GROUP BY oc.dname, oc.hip
HAVING 3<=COUNT(filename)

--JOIN parent on(directory.dname = parent.cdname AND directory.hip = parent.chip)
--{כל הספריות} \ {10,124,3}
SELECT dname
FROM directory as d ,file as f
WHERE d.isroot = false AND f.filename = false AND


--Section c
CREATE OR REPLACE FUNCTION ALTabc() RETURNS TRIGGER AS $$
BEGIN


IF(EXISTS(  SELECT *
            FROM access
            WHERE tdate IN(date_part("month", current_date)) AND new.hip=access.hip
)) THEN /*noth*/
ELSE


INSERT INTO generalinfo (SELECT date_part("month", current_date),date_part("year", current_date),new.hip, count(cip)
FROM access
WHERE tdate IN date_part("month", current_date) AND new.hip=access.hip
GROUP BY hip);
DELETE FROM access where new.hip=access.hip;


--INSERT INTO generalinfo VALUEs(date_part("month", current_date),date_part("year", current_date),,)
END IF;
RETURN new;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER ALTgit
    BEFORE INSERT ON access
    FOR EACH ROW
    --WHEN (date_part("day", current_date) = 1)
EXECUTE PROCEDURE ALTabc();




-- ALTERNATIVE Section c (loop, SINGEL HIP)
CREATE OR REPLACE FUNCTION LPabc() RETURNS TRIGGER AS $$
BEGIN


IF(EXISTS(  SELECT *
            FROM access
            WHERE tdate IN(date_part("month", current_date)) AND new.hip=access.hip
)) THEN /*noth*/
ELSE

FOR cc IN (
    SELECT count(cip)
    FROM access
    WHERE tdate IN date_part("month", current_date) AND new.hip=access.hip
    GROUP BY hip)
LOOP
INSERT INTO generalinfo
VALUES (date_part("month", current_date),date_part("year", current_date),new.hip,cc);
END LOOP;

DELETE FROM access where new.hip=access.hip;

--INSERT INTO generalinfo VALUEs(date_part("month", current_date),date_part("year", current_date),,)
END IF;
RETURN new;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER LPgit
    BEFORE INSERT ON access
    FOR EACH ROW
    --WHEN (date_part("day", current_date) = 1)
EXECUTE PROCEDURE LPabc();
