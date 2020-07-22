-- 1 Create a new file named group_by_exercises.sql
use employees;

-- 2 In your script, use DISTINCT to find the unique titles in the titles table. Your results should look like:
/* Senior Engineer
Staff
Engineer
Senior Staff
Assistant Engineer
Technique Leader
Manager */
select distinct title from titles;

-- 3 Find your query for employees whose last names start and end with 'E'. Update the query find just the unique last names that start and end with 'E' using GROUP BY. The results should be:
/* Eldridge
Erbe
Erde
Erie
Etalle */
SELECT distinct(last_name)
from employees
where last_name like ('E%') and last_name like ('%e');

-- 4 Update your previous query to now find unique combinations of first and last name where the last name starts and ends with 'E'. You should get 846 rows.
SELECT distinct concat(first_name, " ", last_name) as full_name from employees
where last_name like ('E%') and last_name like ('%e');

-- 5 Find the unique last names with a 'q' but not 'qu'. Your results should be:
/* Chleq
Lindqvist
Qiwen */
select distinct last_name
from employees
where last_name like '%q%' and last_name not like '%qu%';

-- 6 Add a COUNT() to your results and use ORDER BY to make it easier to find employees whose unusual name is shared with others.
select last_name, count(emp_no) as number_emp_with_last_name
from employees
where last_name like '%q%' and last_name not like '%qu%'
group by last_name
order by number_emp_with_last_name desc;

-- 7 Update your query for 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names. Your results should be:
/* 441 M
268 F */
SELECT gender, count(emp_no) as number 
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
group by gender
order by number desc;

-- 8 Recall the query the generated usernames for the employees from the last lesson. Are there any duplicate usernames?
select lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_", substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as username
from employees
order by username; -- total rows 300024

select distinct lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_", substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as username
from employees
order by username; -- total rows 285872

-- Bonus: how many duplicate usernames are there? 14152 duplicates? by subtracting total rows from distinct rows
-- Alternative query produces list with only those with occuracnces > 1 and shows 13251 duplicates, But not sure why subtraction wouldn't produce same answer.

-- This will list total number of occurances for each user name, but can't figure out how to just get usernames with an occurance greater than 1 
select lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_", substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as username, count(lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_", substr(birth_date, 6, 2), substr(birth_date, 3, 2)))) as total_with_id
from employees
group by lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_", substr(birth_date, 6, 2), substr(birth_date, 3, 2)))
order by total_with_id desc, username asc;


-- alternative, this lists only usernames with a count higher than 1, so the correct number of duplicates is 13251
SELECT username, username_count 
FROM (
        SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)), "_", SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2)) AS username, COUNT(*) as username_count
        FROM employees
        GROUP BY username
        ORDER BY username_count DESC
) as question
WHERE username_count > 1;