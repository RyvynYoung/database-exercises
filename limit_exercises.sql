use employees;
;
-- MySQL provides a way to return only unique results from our queries with the keyword DISTINCT. For example, to find all the unique titles within the company, we could run the following query:
-- SELECT DISTINCT title FROM titles;
-- List the first 10 distinct last name sorted in descending order. Your result should look like this:
SELECT distinct `last_name` FROM employees order by `last_name` desc limit 10;

-- Find your query for employees born on Christmas and hired in the 90s from order_by_exercises.sql. Update it to find just the first 5 employees. Their names should be:
select * from employees
where hire_date like ('199%') and birth_date like ('%-12-25')
order by birth_date, hire_date desc limit 5;

-- Try to think of your results as batches, sets, or pages. The first five results are your first page. The five after that would be your second page, etc. Update the query to find the tenth page of results. The employee names should be:
select * from employees
where hire_date like ('199%') and birth_date like ('%-12-25')
order by birth_date, hire_date desc limit 5 offset 45;

-- LIMIT and OFFSET can be used to create multiple pages of data. What is the relationship between OFFSET (number of results to skip), LIMIT (number of results per page), and the page number?
-- limit is consistent for each page = l, pg number counts ascending starting with 1, set p = 1 to start, offset = (l*p)-l 
-- pg 1 limit 5 offset 0
-- pg 2 limit 5 offset 5
-- pg 3 limit 5 offset 10
-- pg 4 limit 5 offset 15
-- pg 5 limit 5 offset 20
-- pg 6 limit 5 offset 25
-- pg 7 limit 5 offset 30
-- pg 8 limit 5 offset 35
-- pg 9 limit 5 offset 40
-- pg10 limit 5 offset 45
