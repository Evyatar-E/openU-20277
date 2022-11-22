--openU-20277
--@Evyatar-E
--Exam 2019a_m92
--Question 1, Section c

CREATE OR REPLACE FUNCTION hf() RETURNS TRIGGER AS $$
DECLARE
sumd RECORD;
BEGIN

(SELECT (SUM(amount)+new.amount)
FROM donate
WHERE new.donor = donate.donor AND new.candidate = donate.candidate AND date_part("year", ddate) = date_part("year", current_date)
GROUP BY donor, candidate
) INTO sumd;

IF sumd <=20,000
THEN RETURN new;
ELSE
RAISE NOTICE 'ERROR hf(): donor cant donate to this candidate anymore';
RETURN null;
END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER h
    BEFORE INSERT ON donate
    FOR EACH ROW
EXECUTE PROCEDURE hf();