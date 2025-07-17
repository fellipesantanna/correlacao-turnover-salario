CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    job_category VARCHAR(50),
    salary NUMERIC(10,2),
    join_date DATE,
    exit_date DATE,
    attrition BOOLEAN,
    exit_reason VARCHAR(30)
);
