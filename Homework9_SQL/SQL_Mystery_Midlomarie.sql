-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/8KX98h
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- SQL HOMEWORK
-- A Mystery in Two Parts
-- Midlomarie

-- Departments table has the primary key that maps dept no and names together
-- Use the import/export function to read in the departments csv file from Resources
CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        dept_no)
	);
SELECT * from departments;

-- Managers_dept table maps managers (many) to (one) department
-- Use the import/export function to read in the dept_manager csv file from Resources
CREATE TABLE manager_dept (
	dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
	);
SELECT * from manager_dept;

-- Employee_dept table maps employees (many) to (one) department
-- Use the import/export function to read in the dept_emp csv file from Resources
CREATE TABLE employee_dept (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);
SELECT * from employee_dept WHERE dept_no = 'd001';

-- Employees table contains specific for each employee, emp_no is a Primary Key
-- Use the import/export function to read in the employees csv file from Resources
CREATE TABLE employees (
	 emp_no INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        emp_no
     )
);
SELECT * from employees WHERE emp_no < 10011;

-- Salaries table contains specific for each employee, emp_no is a Foreign Key
-- Use the import/export function to read in the salaries csv file from Resources
CREATE TABLE "salaries" (
	emp_no INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL 
);
SELECT * from salaries WHERE emp_no < 10011;

-- Titles table contains job title for each employee, emp_no is a Foreign Key
-- Use the import/export function to read in the titles csv file from Resources
CREATE TABLE "titles" (
	emp_no INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);
SELECT * from titles WHERE emp_no < 10011;

-- Complete connections between tables by linking the dept numbers and employee numbers
-- between specific tables using "FOREIGN KEYS"

ALTER TABLE manager_dept ADD CONSTRAINT "fk_manager_dept_dept_no" FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE manager_dept ADD CONSTRAINT "fk_manager_dept_emp_no" FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employee_dept ADD CONSTRAINT "fk_employee_dept_emp_no" FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employee_dept ADD CONSTRAINT "fk_employee_dept_dept_no" FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

-- Now that the tables are created and data imported, complete the queries required for
-- the analysis

-- 1. List the following details of each employee: emp_no, last name, first name, gender, and salary

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no
ORDER BY emp_no
LIMIT 10;
;

-- 2. List employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' and '1987-01-01';

-- 3. List the manager of each department with the following: dept_no, dept_name, manager's emp_no
--    last name, first name, and start and end employment dates
-- In this case, need to use the departments, manager_dept, employees tables to get all of the columns needed

SELECT departments.dept_no, departments.dept_name, manager_dept.emp_no,
	   employees.last_name, employees.first_name,
	    manager_dept.from_date, manager_dept.to_date
FROM departments
JOIN manager_dept
ON departments.dept_no = manager_dept.dept_no
JOIN employees
ON manager_dept.emp_no = employees.emp_no;

-- 4. List the department of each employee with emp_no
--    last name, first name, and department no
-- In this case, need to use the departments, employee_dept, employees tables to get all of the columns needed
SELECT employee_dept.emp_no,
	   employees.last_name, employees.first_name,departments.dept_name
FROM employee_dept
JOIN employees
ON employee_dept.emp_no = employees.emp_no
JOIN departments
ON employee_dept.dept_no = departments.dept_no;

-- 5. List the employees whose first name is "Hercules" and last names begin with "B"
-- In this case, need to use the employees table to get all of the columns needed
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- 6. List all employees in the Sales dept, inc. emp_no, last name, first name, and dept name
SELECT employee_dept.emp_no,
	   employees.last_name, employees.first_name,departments.dept_name
FROM employee_dept
JOIN employees
ON employee_dept.emp_no = employees.emp_no
JOIN departments
ON employee_dept.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';


-- 7. List all employees in the Sales dept, inc. emp_no, last name, first name, and dept name
SELECT employee_dept.emp_no,
	   employees.last_name, employees.first_name,departments.dept_name
FROM employee_dept
JOIN employees
ON employee_dept.emp_no = employees.emp_no
JOIN departments
ON employee_dept.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales'
OR departments.dept_name = 'Development';

-- 8.  In descending order, list the frequency count of employee last names

SELECT last_name,
COUNT (last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY 
COUNT (last_name) DESC;

-- 9. What's up with employee number 499942?

SELECT * FROM employees WHERE emp_no = 499942;