# Pewlett-Hackard-Analysis

## Overview
This project uses SQL to query employee data for Pewlett Hackard. They anticipate a changing workforce and want to forecast retirements and employment needs. Many job openings are imminent due to baby boomers in the workforce retiring. Our data analysis goal is to forecast the departments and positions that will need filling, and also find the group of junior employees who can be mentored into new roles. 

Working with an original data set of 6 .csv files holding employee, department, manager, title, and salary information, the first task is to create an entity relationship diagram (ERD) to understand the schema of the database we are building. 

![image of ERD](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

The next task is to join and create new tables in a relational database with more targeted information about those employees currently eligible for retirement. Using the query tool in pgAdmin4 platform enables quick results and clean data.

[schema.sql file](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/schema.sql): Creating tables to load the original data for our database using PostgreSQL in pgAdmin4.


## Results

First we determined the number of retiring employees per job title. The employees.csv file holds over 300,000 records with employee number (emp_no), birth date, name, gender and hire date. 

Finding the number of employees eligible to retire was as simple as querying emp_no by birth_date range between 1952 and 1955:

```
--Retirement eligibility

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
```


