
WITH admission_prev (patient_id, admission_date, discharge_date, prev_discharge_date) AS (
    SELECT patient_id, admission_date, discharge_date, LAG(discharge_date, 1) OVER (PARTITION BY patient_id ORDER BY admission_date) AS prev_discharge_date 
    FROM admission WHERE discharge_date > '12-01-2019'
), admission_cont (patient_id, admission_date, discharge_date, continuation) AS (
    SELECT patient_id, admission_date, discharge_date,
    CASE WHEN prev_discharge_date IS NOT NULL AND prev_discharge_date = admission_date
    THEN 0 ELSE 1 END AS continuation
    FROM admission_prev
), admission_group (patient_id, admission_date, discharge_date, group_id) AS (
    SELECT patient_id, admission_date, discharge_date,
    SUM(continuation) OVER (ORDER BY patient_id, admission_date) AS group_id
    FROM admission_cont
), admission_selected (patient_id, admission_date, discharge_date) AS (
    SELECT patient_id,
    FIRST_VALUE(admission_date) OVER (PARTITION BY patient_id, group_id ORDER BY admission_date) AS admission_date,
    discharge_date
    FROM admission_group
), admission_ranked (patient_id, admission_date, discharge_date, patient_row) AS (
    SELECT patient_id, admission_date, discharge_date,
    ROW_NUMBER() OVER (PARTITION BY patient_id, admission_date ORDER BY
        CASE WHEN discharge_date IS NULL THEN 1 ELSE 2 END, discharge_date DESC 
    ) AS patient_row
    FROM admission_selected
)
SELECT patient_id, admission_date, discharge_date FROM admission_ranked
WHERE DATE_PART('day', discharge_date::timestamp - admission_date::timestamp) > 30
    AND patient_row = 1 AND discharge_date IS NOT NULL AND discharge_date > '2019-12-31'
ORDER BY patient_id, admission_date;






