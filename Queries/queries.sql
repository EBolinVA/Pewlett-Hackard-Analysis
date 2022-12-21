--Creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no), 
	UNIQUE (dept_name)
);

CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL, 
	from_dte DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no	VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM titles;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Retirement eligibility

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
-- INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

--Create new table for retiring employees
SELECT emp_no, first_name, last_name
--INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
--INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
--INTO current_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--


-- Retirement eligible employees in Sales Department
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
-- INTO sales_info
FROM retirement_info As ri
LEFT JOIN dept_emp As de
ON ri.emp_no = de.emp_no
LEFT JOIN departments As d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

-- Create a table with retirement eligible employees in Sales and Development
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
--INTO combined_sales_dev_info
FROM retirement_info As ri
LEFT JOIN dept_emp As de
ON ri.emp_no = de.emp_no
LEFT JOIN departments As d
ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
--INTO retirement_titles
FROM employees As e
INNER JOIN titles As t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no, t.title DESC;

--Steps 8-15 in Deliverable 1. Get most recent titles
-- for current employees eligible to retire.
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title

--INTO unique_titles
FROM retirement_titles As rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.title DESC;

-- retrieve the number of employees by their most recent
-- job title who are about to retire.
SELECT COUNT(ut.title) As title_count,
	ut.title
--INTO retiring_titles
FROM unique_titles As ut
GROUP BY ut.title
ORDER BY title_count DESC;

--Deliverable 2
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
--INTO mentorship_eligibility
FROM employees As e
LEFT JOIN dept_emp As de
ON e.emp_no = de.emp_no
LEFT JOIN titles As t
ON e.emp_no = t.emp_no
GROUP BY e.emp_no, de.from_date, de.to_date, e.birth_date, t.title
HAVING (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT to_date
FROM retirement_titles
ORDER BY to_date ASC;

-- retrieve the number of current employees 
-- eligible for mentorship
--by their most recent job title.
SELECT COUNT(me.title) As title_count,
	me.title
--INTO mentorship_titles
FROM mentorship_eligibility As me
GROUP BY me.title
ORDER BY title_count DESC;

-- Get total number of current employees still actively employed
SELECT DISTINCT ON (emp_no) emp_no,
	to_date
FROM titles
WHERE (to_date='9999-01-01')
ORDER BY emp_no, to_date DESC;

-- 12-20-22 Re-do Lesson 7.3.5 to get emp_info file
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
--INTO emp_info
FROM employees As e
INNER JOIN salaries As s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp As de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

--ADD hire_date to unique_titles to see if that narrows it down more
SELECT ut.emp_no, e.hire_date
FROM unique_titles As ut
INNER JOIN employees As e
ON (ut.emp_no = e.emp_no)
WHERE (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY ut.emp_no, e.hire_date DESC;

-- Deliverable 3, expand mentorship numbers by expanding birth years
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
--INTO mentorship_eligibility
FROM employees As e
LEFT JOIN dept_emp As de
ON e.emp_no = de.emp_no
LEFT JOIN titles As t
ON e.emp_no = t.emp_no
GROUP BY e.emp_no, de.from_date, de.to_date, e.birth_date, t.title
HAVING (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1965-01-01' AND '1975-12-31')
ORDER BY e.emp_no;

--just birthdates after 1965, resulting in no records
SELECT e.emp_no,
	e.birth_date
FROM employees As e
GROUP BY e.emp_no
HAVING (e.birth_date > '1965-12-31')
;

-- Deliverable 3, expand mentorship numbers by considering length of service
-- by combining employees emp_no and hire_date with dept_emp.emp_no and to_date
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	e.hire_date,
	de.from_date,
	de.to_date, 
	t.title
--INTO mentorship_eligibility
FROM employees As e
LEFT JOIN dept_emp As de
ON e.emp_no = de.emp_no
INNER JOIN titles As t
ON e.emp_no = t.emp_no
GROUP BY e.emp_no, e.hire_date, de.from_date, de.to_date, e.birth_date, t.title
HAVING (de.to_date = '9999-01-01') AND (e.birth_date NOT BETWEEN '1962-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

