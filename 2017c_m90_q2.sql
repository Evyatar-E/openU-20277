--openU-20277
--@Evyatar-E
--Exam 2017c_m90
--Question 2

--Section a
SELECT a.acid, a.type, reserve.ahour
FROM  activity      AS a
    NATURAL JOIN reserve
    NATURAL JOIN presents
    JOIN item USING (iid)  
WHERE a.adate = current_date
    AND item.type = 'רישום';

--Section b
WITH notnushex(exid) AS (
    SELECT exhibition.exid
    FROM exhibition    AS ex 
    WHERE 'Paul Nush' NOT IN(
        SELECT item.artist
        FROM presents
            JOIN item USING (iid) 
        WHERE ex.exid = present.exid
    )
)SELECT e.exid, e.topic
FROM notnushex 
    NATURAL JOIN exhibition AS e
    JOIN presents USING(iid)
GROUP BY e.exid, e.topic
HAVING COUNT(iid) >= ALL(
    SELECT COUNT(iid)
    FROM notnushex 
        JOIN presents USING(iid)
    GROUP BY notnushex.exid
);

--Section c
CREATE OR REPLACE FUNCTION mf() RETURNS TRIGGER AS $$
DECLARE
     near RECORD;
BEGIN

    (SELECT * 
    FROM reserve AS r
    WHERE r.acid IN (SELECT acid FROM activity) --?
        r.adate = new.adate
        AND ((r.ahour-new.ahour)<60 AND (r.ahour-new.ahour) > -60)) INTO near;

    IF(new.acid IN (SELECT acid FROM activity) --?
        AND NOT EXISTS(near))
    THEN
        RETURN new;
    ELSE
        RAISE NOTICE 'ERROR 0x0001, mf(): This activity which you try to insert to the reserve is too close to another activity';
        RETURN null;
    END IF;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER m
     BEFORE INSERT ON reserve
     FOR EACH ROW
EXECUTE PROCEDURE mf();