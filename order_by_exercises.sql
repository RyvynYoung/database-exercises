-- 1
use employees;

-- 2
SELECT * from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name;

-- 3
SELECT * from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name, last_name;

-- 4
SELECT * from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name, first_name;


-- 5
SELECT * from employees
where last_name like ('E%') order by emp_no;
-- 5
SELECT * from employees
where last_name like ('E%') or last_name like ('%e') order by emp_no;

-- 6
SELECT * from employees
where last_name like ('E%') order by emp_no DESC;
-- 6
SELECT * from employees
where last_name like ('E%') or last_name like ('%e') order by emp_no DESC;

-- 7
select * from employees
where hire_date like ('199%') and birth_date like ('%-12-25')
order by birth_date, hire_date desc;

