-- Deliverable 1
--Create Retirement_Titles table
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees As e
INNER JOIN titles As t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no, t.title DESC;

-- Use Dictinct with Orderby to remove duplicate rows
--Steps 8-15 in Deliverable 1. Get most recent titles
-- for current employees eligible to retire.
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title

INTO unique_titles
FROM retirement_titles As rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.title DESC;

-- retrieve the number of employees by their most recent
-- job title who are about to retire.
SELECT COUNT(ut.title) As title_count,
	ut.title
INTO retiring_titles
FROM unique_titles As ut
GROUP BY ut.title
ORDER BY title_count DESC;

--Deliverable 2
--create a table of employees eligible for mentorship
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees As e
LEFT JOIN dept_emp As de
ON e.emp_no = de.emp_no
LEFT JOIN titles As t
ON e.emp_no = t.emp_no
GROUP BY e.emp_no, de.from_date, de.to_date, e.birth_date, t.title
HAVING (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;


