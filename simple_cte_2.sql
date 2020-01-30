
WITH age_added AS (
    SELECT
        *, EXTRACT(YEAR FROM AGE(dob)) as age
    FROM patient
), old_age_ones AS (
    SELECT * FROM age_added WHERE age > 25
), dummy AS (
    DELETE FROM patient WHERE id in (SELECT id FROM old_age_ones)
), new_ids AS (
    INSERT INTO patient_old (ssn, first_name, last_name, dob)
    SELECT ssn, first_name, last_name, dob FROM old_age_ones
    RETURNING id
)
SELECT * FROM new_ids;





