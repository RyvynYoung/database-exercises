use employees;
select database();
show tables;
describe employees;
# 6 all tables except departments have an int column
# 7 all tables except salaries have a string type column
# 8 all tables except departments and employees_with_departments have a date type column
describe departments;
select * from employees;
select * from departments;
# 9 - I don't know, I don't see a replationship between these tables
show create table dept_manager;
