--
use employees;

-- 709 rows
SELECT * from employees
where first_name in ('Irena', 'Vidya', 'Maya');

-- 7330 rows
SELECT * from employees
where last_name like ('E%');

-- 135214 rows
select * from employees
where hire_date like ('199%');

-- 842 rows
select * from employees
where birth_date like ('%-12-25');

-- 1873 rows
SELECT * from employees
where last_name like ('%q%');


-- 709 rows use OR
SELECT * from employees
where first_name = 'Irena' or first_name = 'Vidya' or first_name = 'Maya';


-- 441 rows use or
SELECT * from employees
where (first_name = 'Irena' or first_name = 'Vidya' or first_name = 'Maya')
and gender = 'M';

-- 30723 rows
SELECT * from employees
where last_name like ('E%') or last_name like ('%e');

-- 899 rows
SELECT * from employees
where last_name like ('E%') and last_name like ('%e');

-- 362 rows
select * from employees
where hire_date like ('199%') and birth_date like ('%-12-25');

-- 547 rows
SELECT * from employees
where last_name like ('%q%') and last_name not like ('%qu%');
