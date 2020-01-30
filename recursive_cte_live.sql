WITH RECURSIVE extended_admission (patient_id, admission_date, discharge_date) AS (
    SELECT patient_id, admission_date, discharge_date FROM admission
    WHERE (discharge_date IS NOT NULL AND discharge_date > '2019-12-31') OR discharge_date IS NULL
    UNION ALL
    SELECT
        a1.patient_id AS patient_id,
        a2.admission_date AS admission_date,
        a1.discharge_date AS discharge_date
    FROM extended_admission AS a1
    INNER JOIN admission a2 ON a1.patient_id = a2.patient_id AND a2.discharge_date = a1.admission_date
), filtered_admission (patient_id, admission_date, discharge_date) AS (
    SELECT patient_id, MIN(admission_date) AS admission_date, discharge_date
    FROM extended_admission GROUP BY patient_id, discharge_date
),
filtered_admission_2 (patient_id, admission_date, discharge_date) AS (
    SELECT patient_id, admission_date, MAX(discharge_date) AS discharge_date
    FROM filtered_admission GROUP BY patient_id, admission_date
)
SELECT * FROM filtered_admission_2
WHERE DATE_PART('day', discharge_date::timestamp - admission_date::timestamp) > 30 AND discharge_date IS NOT NULL
ORDER BY patient_id, admission_date;