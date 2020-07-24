-- Use the join_example_db. Select all the records from both the users and roles tables.
use join_example_db;
select *
from users;

select * from roles;

-- Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.

-- 4 results, excludes users without a role and roles without a user
SELECT users.name as user_name, roles.name as role_name
FROM users
JOIN roles ON users.role_id = roles.id;

-- 6 results, includes users without a role, but not roles without a user
SELECT users.name AS user_name, roles.name AS role_name
FROM users
LEFT JOIN roles ON users.role_id = roles.id;

-- 5 results, includes roles without a user, but not users without a role
SELECT users.name AS user_name, roles.name AS role_name
FROM users
RIGHT JOIN roles ON users.role_id = roles.id;

/* -- Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query. */
SELECT roles.name, count(users.`name`)
from roles
left join users on users.role_id = roles.id
group by roles.name;


-- 1 Use the employees database.

use `employees`;

/*2. Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.
  Department Name    | Department Manager
 --------------------+--------------------
  Customer Service   | Yuchang Weedman
  Development        | Leon DasSarma
  Finance            | Isamu Legleitner
  Human Resources    | Karsten Sigstam
  Marketing          | Vishwani Minakawa
  Production         | Oscar Ghazalie
  Quality Management | Dung Pesch
  Research           | Hilary Kambil
  Sales              | Hauke Zhang */

SELECT d.dept_name, CONCAT(e.first_name, ' ', e.last_name) AS Department_Manager
FROM employees as e
JOIN dept_manager as dm
  ON dm.emp_no = e.emp_no and dm.to_date > CURDATE()
JOIN departments AS d
  ON d.dept_no = dm.dept_no
  order by d.dept_name;
  
/*3 Find the name of all departments currently managed by women.
Department Name | Manager Name
----------------+-----------------
Development     | Leon DasSarma
Finance         | Isamu Legleitner
Human Resources | Karsetn Sigstam
Research        | Hilary Kambil */
SELECT d.dept_name, CONCAT(e.first_name, ' ', e.last_name) AS Department_Manager
FROM employees as e
JOIN dept_manager as dm
  ON dm.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = dm.dept_no
where dm.to_date > CURDATE()
and e.gender = 'F'
order by d.dept_name;


/*4 Find the current titles of employees currently working in the Customer Service department.
Title              | Count
-------------------+------
Assistant Engineer |    68
Engineer           |   627
Manager            |     1
Senior Engineer    |  1790
Senior Staff       | 11268
Staff              |  3574
Technique Leader   |   241 */
SELECT t.title, count(t.emp_no)
FROM employees as e
join dept_emp as de on e.emp_no = de.emp_no
join titles as t on e.emp_no = t.emp_no
where de.to_date > curdate()
and t.to_date > curdate()
and de.dept_no = 'd009'
group by t.title
order by t.title;

/*5 Find the current salary of all current managers.
Department Name    | Name              | Salary
-------------------+-------------------+-------
Customer Service   | Yuchang Weedman   |  58745
Development        | Leon DasSarma     |  74510
Finance            | Isamu Legleitner  |  83457
Human Resources    | Karsten Sigstam   |  65400
Marketing          | Vishwani Minakawa | 106491
Production         | Oscar Ghazalie    |  56654
Quality Management | Dung Pesch        |  72876
Research           | Hilary Kambil     |  79393
Sales              | Hauke Zhang       | 101987 */
SELECT d.dept_name, CONCAT(e.first_name, ' ', e.last_name) AS Name, s.salary
FROM employees as e
JOIN dept_manager as dm ON dm.emp_no = e.emp_no and dm.to_date > CURDATE()
JOIN departments AS d ON d.dept_no = dm.dept_no
join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
order by d.dept_name;


/* 6 Find the number of employees in each department.
+---------+--------------------+---------------+
| dept_no | dept_name          | num_employees |
+---------+--------------------+---------------+
| d001    | Marketing          | 14842         |
| d002    | Finance            | 12437         |
| d003    | Human Resources    | 12898         |
| d004    | Production         | 53304         |
| d005    | Development        | 61386         |
| d006    | Quality Management | 14546         |
| d007    | Sales              | 37701         |
| d008    | Research           | 15441         |
| d009    | Customer Service   | 17569         |
+---------+--------------------+---------------+ */
select departments.dept_no, departments.dept_name, count(de.`emp_no`)
from departments
join dept_emp as de on departments.dept_no = de.`dept_no` and de.`to_date` > curdate()
group by de.dept_no;

/*7  Which department has the highest average salary?
+-----------+----------------+
| dept_name | average_salary |
+-----------+----------------+
| Sales     | 88852.9695     |
+-----------+----------------+ */
select departments.dept_name, avg(s.`salary`) as average_salary
from departments
join dept_emp as de on departments.dept_no = de.`dept_no` and de.`to_date` > curdate()
join salaries as s on s.`emp_no` = de.`emp_no` and s.`to_date` > curdate()
group by departments.dept_name
order by average_salary desc
limit 1;

/*8 Who is the highest paid employee in the Marketing department?
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Akemi      | Warwick   |
+------------+-----------+ */
SELECT e.first_name, e.`last_name`
FROM employees as e
JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE() and de.`dept_no` = 'd001'
join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
order by s.salary desc
limit 1;

/*9 Which current department manager has the highest salary?
+------------+-----------+--------+-----------+
| first_name | last_name | salary | dept_name |
+------------+-----------+--------+-----------+
| Vishwani   | Minakawa  | 106491 | Marketing |
+------------+-----------+--------+-----------+ */
SELECT e.first_name, e.last_name, s.salary, d.dept_name 
FROM employees as e
JOIN dept_manager as dm ON dm.emp_no = e.emp_no and dm.to_date > CURDATE()
JOIN departments AS d ON d.dept_no = dm.dept_no
join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
order by s.salary desc
limit 1;

/* 10 Bonus Find the names of all current employees, their department name, and their current manager's name.
240,124 Rows
Employee Name | Department Name  |  Manager Name
--------------|------------------|-----------------
 Huan Lortz   | Customer Service | Yuchang Weedman

 ..... */
select CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', d.dept_name as 'Department Name', cm.man_name as 'Manager Name'
FROM employees as e
JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE() 
join departments as d on d.dept_no = de.dept_no
join dept_manager as dm on d.dept_no = dm.dept_no and dm.to_date > curdate() 
join (
	select CONCAT(e.first_name, ' ', e.last_name) AS man_name, dm.dept_no
	from employees as e
	join dept_manager as dm on dm.emp_no = e.`emp_no` and dm.to_date > curdate()
		) as cm on cm.dept_no = de.dept_no
order by d.dept_name;

/* 11. Bonus Find the highest paid employee in each department. */
SELECT marketing. 
FROM employees as e
JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
JOIN departments AS d ON d.dept_no = de.dept_no
join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd001'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as marketing on d.`dept_name` = marketing.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd002'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as finance on d.`dept_name` = finance.dept_name;
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd003'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as HR on d.`dept_name` = HR.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd004'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as production on d.`dept_name` = production.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd005'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as development on d.`dept_name` = development.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd006'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as quality on d.`dept_name` = quality.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd007'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as sales on d.`dept_name` = sales.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd008'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as research on d.`dept_name` = research.dept_name
join (SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd009'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1) as cust_serv on d.`dept_name` = cust_serv.dept_name
order by s.salary desc;

SELECT e.first_name, e.last_name, s.salary, d.dept_name
FROM employees as e
JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd001'
join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
order by s.salary desc
limit 1;

SELECT e.first_name, e.last_name, s.salary, d.dept_name
		FROM employees as e
		JOIN dept_emp as de ON de.emp_no = e.emp_no and de.to_date > CURDATE()
		JOIN departments AS d ON d.dept_no = de.dept_no and d.dept_no = 'd009'
		join salaries as s on e.emp_no = s.emp_no and s.to_date > CURDATE()
		order by s.salary desc
		limit 1;
