
SELECT
    *, EXTRACT(YEAR FROM AGE(dob)) as age
FROM patient 
WHERE
    EXTRACT(YEAR FROM AGE(dob)) > 25
ORDER BY age;

