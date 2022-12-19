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

## :briefcase: Prerequisites <a name="prerequisites></a>

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

## Queries <a name="queries"></a>




First we need determined the number of retiring employees per job title. The employees.csv file holds over 300,000 records with employee number (emp_no), birth date, name, gender and hire date. 

Finding the number of employees eligible to retire was as simple as querying emp_no by birth_date range between 1952 and 1955:

```
--Retirement eligibility

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
```

The above query did not take into consideration the to_date, which is the date that indicates whether an employee is still currently working at Pewlett Hackard. So the next query includes the line of code:

```
WHERE de.to_date = ('9999-01-01');
```

Setting the to_date to January 1, 9999, ensures that the query returns only retirement eligible employees who are still on the payroll. This results in narrowing down the list of employees to 33,118.

[image]

Finally, 

## :chart_with_upwards_trend: Results and Discussion <a name="results"></a>

![retiring_titles_piechart image](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/retiring_titles_piechart.png)

![mentorship_titles_piechart image](https://github.com/EBolinVA/Pewlett-Hackard-Analysis/blob/main/mentorship_titles_piechart.png)

## Recommendations <a name="recommendations"></a>