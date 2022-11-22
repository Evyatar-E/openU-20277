--openU-20277
--@Evyatar-E
--Exam 2015c_m82
--Question 2

--Section a
SELECT b.bno,
    b.bname,
    COUNT(sr.rno)
FROM building AS b 
    JOIN room AS r ON(b.bno = r.bno)
WHERE r.maxstud = 1
GROUP BY b.bno, b.bname
HAVING COUNT(r.rno)>=10    
);


--Section b
WITH q(qsname, qc) AS(
    SELECT s.sname,
        COUNT(lent.iname, lent.sno)
    FROM (student AS s JOIN
        building AS b USING (bno)) 
        JOIN lent USING(sno)
    WHERE b.bname='המכללה'
        AND sno NOT IN (SELECT tsno FROM lent)
    GROUP BY s.sname
)
SELECT q.qname, q.qc
FROM q
WHERE q.qc >= ALL(SELECT COUNT(iname)
    FROM lent
    GROUP BY sno);


--Section c
CREATE OR REPLACE FUNCTION nf() RETURNS TRIGGER AS $$
--DECLARE
BEGIN
IF
    (
    (SELECT count(*) FROM lent AS l WHERE l.tsno = new.tsno)
    -
    (SELECT count(*) FROM lent AS l WHERE l.sno = new.tsno)
    )<=10
THEN
    RETURN new;
ELSE
    RAISE NOTICE'ERROR 0x:0001, nf(): This student cannot
    borrow more items until he lends more items to others';
    RETURN null;
END IF;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER n
    BEFORE INSERT ON lent
FOR EACH ROW
EXECUTE PROCEDURE nf();