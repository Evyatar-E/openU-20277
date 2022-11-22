--openU-20277
--@Evyatar-E
--Exam 2019a_m86
--Question 2

--Section a
SELECT manufacturer, COUNT(id) AS c INTO cmanu
FROM airplane JOIN type USING(model)
WHERE seats>500
GROUP BY manufacturer;

SELECT manufacturer
FROM cmanu
WHERE c >= ALL( SELECT c
                FROM cmanu);


--Section b
(   (SELECT code name
    FROM port)
EXCEPT
    (SELECT code
    FROM type NATURAL JOIN canland NATURAL JOIN port
    WHERE manufacturer = 'mambo')
) INTO notmumbo;

SELECT code, name, max(f.dtime)
FROM (  notmumbo JOIN flight AS f ON(code = f.dcode))
        JOIN schedule AS s USING(fno)
WHERE s.sdate = current_date    -- =date_part("day",current_date)
GROUP BY code, name;


--Section c
CREATE OR REPLACE FUNCTION af() RETURNS TRIGGER AS $$
DECLARE

cs RECORD;
b RECORD;

BEGIN
--new.fno ->שדות התעופה, new.id->דגם המטוס 

(SELECT CODE
FROM (new JOIN airplane USING(id)) NATURAL JOIN type NATURAL JOIN canland) INTO cs;

(SELECT *
FROM new NATURAL JOIN flight
WHERE dcode IN (cs) AND acode IN (cs)) INTO b;

IF
    EXISTS(b)
THEN
    RETURN new;
ELSE
    RAISE NOTICE 'af(): The aircraft is unable to take off and / or land according to the planned route';
    RETURN null;
END IF;
END;
$$LANGUAGE PLPGSQL;

CREATE TRIGGER a 
        BEFORE INSERT ON schedule
        FOR EACH ROW
    EXECUTE PROCEDURE af();