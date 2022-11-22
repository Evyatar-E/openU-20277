--openU-20277
--@Evyatar-E
--Exam 2016a_m83
--Question 2, Section c

CREATE OR REPLACE FUNCTION acf() RETURNS TRIGGER AS $$
DECLARE
    this_ctg record
BEGIN

    SELECT minage, maxage
    FROM agecat
    WHERE agecat.category = NEW.category
    INTO this_ctg;

    IF(this_ctg.minage<=NEW.age AND NEW.age<=this_ctg.maxage)
    THEN
        RETURN NEW;
    ELSE
        RAISE NOTICE 'ERROR_acf: This category of study is not suitable for this child because he does not meet the age requirements';
        RETURN NULL;
    END IF;
end;
$$ language plpgsql;

CREATE TRIGGER ac
    BEFORE INSERT OR UPDATE ON child
    FOR EACH ROW
    WHEN (OLD.category <> NEW.category)
EXECUTE PROCEDUER acf();