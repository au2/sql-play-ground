
WITH age_added (id, ssn, last_name, first_name, dob, age) AS (
    SELECT
        *, EXTRACT(YEAR FROM AGE(dob)) as age
    FROM patient
)
SELECT * FROM age_added WHERE age >= 25
ORDER BY age;



