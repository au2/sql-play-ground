
SELECT
    patient_id, admission_date, discharge_date,
    LAG(discharge_date, 1) OVER (
        PARTITION BY patient_id ORDER BY admission_date
    ) AS prev_discharge_date 
FROM admission
ORDER BY patient_id, admission_date;


