-- 1. Using the example from the lesson, re-create the employees_with_departments table.
use darden_1030;

CREATE TEMPORARY TABLE employees_with_departments AS
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no, d.dept_name
FROM employees.employees as e
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no)
LIMIT 100;

-- a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
alter table employees_with_departments add full_name VARCHAR(31);

-- b. Update the table so that full name column contains the correct data
UPDATE employees_with_departments
SET full_name = CONCAT(first_name, " ", last_name);

-- c. Remove the first_name and last_name columns from the table.
ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

-- d. What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE employees_with_departments AS
SELECT e.emp_no, concat(e.first_name, ' ', e.last_name), de.dept_no, d.dept_name
FROM employees.employees as e
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no)
LIMIT 100;


-- 2.Create a temporary table based on the payment table from the sakila database.
CREATE TEMPORARY TABLE payment_sakila AS
select * from sakila.payment;

-- Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. 
-- For example, 1.99 should become 199.
select * from payment_sakila;
alter table payment_sakila add amountcent int(10);
update payment_sakila set amountcent = amount * 100;
alter table payment_sakila drop column amount;
alter table payment_sakila change amountcent amount int(10);
select * from payment_sakila;

-- Find out how the average pay in each department compares to the overall average pay. 
-- In order to make the comparison easier, you should use the Z-score for salaries. 
-- In terms of salary, what is the best department to work for? The worst?
-- +--------------------+-----------------+
-- | dept_name          | salary_z_score  | 
-- +--------------------+-----------------+
-- | Customer Service   | -0.273079       | 
-- | Development        | -0.251549       | 
-- | Finance            |  0.378261       | 
-- | Human Resources    | -0.467379       | 
-- | Marketing          |  0.464854       | 
-- | Production         | -0.24084        | 
-- | Quality Management | -0.379563       | 
-- | Research           | -0.236791       | 
-- | Sales              |  0.972891       | 
-- +--------------------+-----------------+
use employees;
SELECT d.dept_name, s.salary
FROM employees.salaries as s
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no);


use darden_1030;
CREATE TEMPORARY TABLE salaries_and_dept AS
SELECT d.dept_name, s.salary
FROM employees.salaries as s
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no);

CREATE TEMPORARY TABLE avg_sal_by_dept AS
select dept_name, avg(salary) as dep_avg
from salaries_and_dept group by dept_name; 

select avg(salary) as avg_sal
from salaries_and_dept; -- 63805.4005

select * from avg_sal_by_dept;

alter table avg_sal_by_dept add salary_z_score float;

-- z score calculation
-- z score = (dept_avg - avg_sal) / stddev
select stddev(salary) as std_dev
from salaries_and_dept2; -- 16900.847231800373

CREATE TEMPORARY TABLE salaries_and_dept2 AS
SELECT d.dept_name, s.salary
FROM employees.salaries as s
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no);

update avg_sal_by_dept
set salary_z_score = ((dep_avg - (select avg(salary) as avg_sal
from salaries_and_dept)) / (select stddev(salary) as std_dev
from salaries_and_dept2));

select dept_name, salary_z_score
from avg_sal_by_dept; 