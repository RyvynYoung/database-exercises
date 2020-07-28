use employees;

--1. Write a query that returns all employees (emp_no), their department number, their start date, their end date,
-- and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.
select *, to_date > now() as is_current_employee
from dept_emp;
-- did not read question correctly


--2. Write a query that returns all employee names, and a new column 'alpha_group' that returns 
-- 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.
select first_name, last_name, 
	case 
	when substr(last_name, 1, 1) in ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h') then 'A-H'
	when substr(last_name, 1, 1) in ('i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q') then 'I-Q'
	when substr(last_name, 1, 1) in ('r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z') then 'R-Z'
	else 'idk'
	end as alpha_group
from employees;

--3. How many employees were born in each decade?
select count(birth_date), 
	case when substr(birth_date, 3, 1) = 5 then '50s'
	when substr(birth_date, 3, 1) = 6 then '60s'
	else 'other'
	end as decade
from employees
group by decade;

-- BONUS
-- What is the average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
-- +-------------------+-----------------+
-- | dept_group        | avg_salary      |
-- +-------------------+-----------------+
-- | Customer Service  |                 |
-- | Finance & HR      |                 |
-- | Sales & Marketing |                 |
-- | Prod & QM         |                 |
-- | R&D               |                 |
-- +-------------------+-----------------+

-- step 1 find average salary by dept using CURRENT average
select d.dept_name, avg(s.salary)  
from salaries as s
join dept_emp as de on de.emp_no = s.emp_no and de.to_date > now()
join departments as d using(dept_no)
where s.to_date > now()
group by d.dept_name;

