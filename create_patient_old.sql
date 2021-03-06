-- DDL generated by Postico 1.4.2
-- Not all database features are supported. Do not use for backup.

-- Table Definition ----------------------------------------------

CREATE TABLE patient_old (
    id SERIAL PRIMARY KEY,
    ssn text,
    last_name text,
    first_name text,
    dob date
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX patient_old_pkey ON patient_old(id int4_ops);
