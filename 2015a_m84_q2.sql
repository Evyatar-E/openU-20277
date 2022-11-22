--openU-20277
--@Evyatar-E
--Exam 2015a_m84
--Question 2


--Section a
SELECT car.license,
     lcenter.name,
     MAX(tdate)
FROM car
     /*↓*/
     natural JOIN test
     natural JOIN lcenter --car doesnt necessary
     --WHERE test.tdate< (current_date-365)
GROUP BY car.license,
     lcenter.name
HAVING MAX(tdate) < (CURRENT_DATE -365);
--1/1/1970


--Section b
SELECT did, issuedate
FROM car AS c NATURAL JOIN owns
WHERE purchasedate <= ALL (
          SELECT purchasedate
          FROM owns
          WHERE c.license = owns.license)
     AND owns.did IN(
          SELECT owns.did
          FROM owns
          WHERE c.license = owns.license
               AND purchasedate >= ALL(
                    SELECT purchasedate
                    FROM owns
                    WHERE c.license = owns.license
               )
     );


--Section c
CREATE OR REPLACE FUNCTION p36f() RETURNS TRIGGER AS $$
DECLARE
     dpoints record;
BEGIN

     (SELECT d.nofpoints
     FROM driver    AS d
     WHERE d.did=new.did) INTO dpoints;

     IF 36 < SOME(dpoints)
     THEN RAISE NOTICE 'ERROR 0x0001, p36f():
      This driver has more than 36 points,
       thus he cannot purchase this car.';
          RETURN null;
     ELSE RETURN new;
     END IF;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER p36
     BEFORE INSERT ON owns
     FOR EACH ROW
EXECUTE PROCEDURE p36f();