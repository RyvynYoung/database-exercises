/* Create a file named subqueries_exercises.sql and craft queries to return the results for the following criteria: */
use employees;

/* 1) Find all the employees with the same hire date as employee 101010 using a sub-query.
69 Rows */
select *
from employees
where hire_date in (
	select hire_date from employees where emp_no = 101010);

/* 2) Find all the titles held by all employees with the first name Aamod.
314 total titles, 6 unique titles */
select title
from titles
where emp_no in (
	select emp_no from employees where first_name = 'Aamod');
	
select title
from titles
where emp_no in (
	select emp_no from employees where first_name = 'Aamod')
group by title;
	

/* 3) How many people in the employees table are no longer working for the company? */
select count(emp_no) as number_of_emp_not_working_for_company
from employees
where emp_no not in (
	select emp_no from dept_emp where dept_emp.to_date > now());

/* 4) Find all the current department managers that are female.
+------------+------------+
| first_name | last_name  |
+------------+------------+
| Isamu      | Legleitner |
| Karsten    | Sigstam    |
| Leon       | DasSarma   |
| Hilary     | Kambil     |
+------------+------------+ */
select first_name, last_name
from employees
where emp_no in (select emp_no from dept_manager where to_date > now())
and gender = 'F';

/* 5) Find all the employees that currently have a higher than average salary.
154543 rows in total. Here is what the first 5 rows will look like:
+------------+-----------+--------+
| first_name | last_name | salary |
+------------+-----------+--------+
| Georgi     | Facello   | 88958  |
| Bezalel    | Simmel    | 72527  |
| Chirstian  | Koblick   | 74057  |
| Kyoichi    | Maliniak  | 94692  |
| Tzvetan    | Zielinski | 88070  |
+------------+-----------+--------+ */

select first_name, last_name, salary
from salaries
join employees on employees.emp_no = salaries.emp_no
where salary > (select avg(salary) from salaries) and to_date > now();
	

/* 6) How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
78 salaries */

select count(salary)
from salaries
where salary between ((select max(salary) from salaries) - (select stddev(salary) from salaries)) and (select max(salary) from salaries)
and to_date > now();

-- percentage = 
select ((select count(salary)
from salaries
where salary between ((select max(salary) from salaries) - (select stddev(salary) from salaries)) and (select max(salary) from salaries)
and to_date > now()) / (select count(salary) from salaries where to_date > now())
			) as percent_of_salaries_within_1_std_dev_of_max_salary;

/* BONUS
1) Find all the department names that currently have female managers.
+-----------------+
| dept_name       |
+-----------------+
| Development     |
| Finance         |
| Human Resources |
| Research        |
+-----------------+ */
select d.dept_name
from employees as e
join dept_manager as dm on e.emp_no = dm.emp_no
join departments as d on d.dept_no = dm.dept_no
where e.emp_no in (select emp_no from dept_manager where to_date > now())
and gender = 'F'
order by d.dept_name;


/* 2) Find the first and last name of the employee with the highest salary.
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Tokuyasu   | Pesch     |
+------------+-----------+ */

select first_name, last_name
from employees
where emp_no in (
	select emp_no from salaries where salary = 
		(select max(salary) from salaries where to_date > now())
			);

/* 3) Find the department name that the employee with the highest salary works in.
+-----------+
| dept_name |
+-----------+
| Sales     |
+-----------+ */
select dept_name
from departments
join dept_emp on dept_emp.dept_no = departments.dept_no and dept_emp.to_date > now()
join salaries on salaries.emp_no = dept_emp.emp_no and salaries.to_date > now()
where salaries.emp_no in (
	select salaries.emp_no from salaries where salary = 
		(select max(salary) from salaries where to_date > now())
			);
