# Pewlett-Hackard-Analysis


## :book: Table of Contents
1. [About the Project](#about)
2. [Prerequisites](#prerequisites)
3. [Dataset](#dataset)
4. [Queries](#queries)
5. [Results and Discussion](#results)
6. [Recommendations](#recommendations)

## :memo: About the Project <a name="about"></a>
This project uses SQL to query employee data for Pewlett Hackard. They anticipate a changing workforce and want to forecast retirements and employment needs. Many job openings are imminent due to baby boomers in the workforce retiring. Our data analysis goal is to forecast the departments and positions that will need filling, and also find the group of junior employees who can be mentored into new roles. 

Working with an original data set of 6 .csv files holding employee, department, manager, title, and salary information, the first task is to create an entity relationship diagram (ERD) to understand the schema of the database we are building. 

![image of ERD](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

The next task is to join and create new tables in a relational database with more targeted information about those employees currently eligible for retirement. Using the query tool in pgAdmin4 platform enables quick results and clean data.

[schema.sql file](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/schema.sql): Creating tables to load the original data for our database using PostgreSQL in pgAdmin4.

## :briefcase: Prerequisites <a name="prerequisites"></a>

The following open source packages are used in this project:
- QuickDBD
- ![image](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
- pgAdmin 4 

## :floppy_disk: Dataset <a name="dataset"></a>

The dataset includes human resources information obtained from Pewlett Hackard and consists of six original .csv files:
- employees
- departments
- dept_manager
- dept_employee
- salaries
- titles

## :question: Queries <a name="queries"></a>
- How many are  eligible to retire?

First we need determined the number of retiring employees per job title. The employees.csv file holds over 300,000 records with employee number (emp_no), birth date, name, gender and hire date. 

```
--Retirement eligibility

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');
```

The above query did not take into consideration the to_date, which is the date that indicates whether an employee is still currently working at Pewlett Hackard. The 'to_date' column is found in the original dept_emp.csv file. The next query includes the line of code:

```
WHERE de.to_date = ('9999-01-01');
```

Setting the to_date to January 1, 9999, ensures that the query returns only retirement eligible employees who are still on the payroll. This results in narrowing down the list of retirement eligible employees to 72,458.

- How many employees are eligible for mentorship?

```
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
```

## :warning: Results and Discussion <a name="results"></a>
* 240,124 Pewlett Hackard current employees 
* 72,458 employees eligible to retire; 33,118 have at least 30 years of service
* 1,549 employees eligible for mentorship
* 30% reduction of workforce imminent due to retirement

![image of barchart showing numbers of employees eligible to retire next to numbers of current employees eligible for mentorship](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/retiring_vs_mentorship_barchart.png)



## :ocean: Summary and Recommendations <a name="recommendations"></a>
The impending "silver tsunami" requires some planning to fill upcoming vacant positions. There are two main questions this analysis set out to address: the number of retiring employees and the number of those ready for mentorships.

### * How many employees are currently eligible to retire?

- 72,458 employees are currently eligible to retire:
![image of query and results for retirement eligible employees]()

- It is unknown the date of this data pull for Pewlett Hackard. The analysis is done 4Q2022. 

- The titles.csv file contains records for 240,124 unique current employees.

- Join titles, dept_emp, and employees file to obtain current employees eligible to retire by birthdate between 1952 and 1955.


### * How many employees are currently eligible for mentorship?
- Employees eligible for mentorship are born in 1965. Expand the pool of employees in mentorship to fill senior leadership: 
    - widen the range of employees by including more birth years
        - Note: there are no employees in the database with a birth_date more recent than 1965-12-31
        - A query of current employees NOT born between 1962-1965 (retirement age) is done with the following code and results in 183,265 employee records:
        ```
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
        ```

        ![image of query for birthdates](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/Birthdates_after_1965.png)

    - choose mentorship by years of service