CREATE DATABASE sample_code;

USE sample_code;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2)
);

ALTER TABLE employees
ADD Gender VARCHAR(10),
age INT;

SELECT * FROM employees;

ALTER TABLE employees
DROP COLUMN email; 


INSERT INTO employees(employee_id,first_name,last_name,salary,Gender,age)
VALUES
(101,'Ajay','Kumar',50000,'Male',35);


INSERT INTO employees(employee_id,first_name,last_name,salary,Gender,age)
VALUES
(104,'Vijay','Kumar',30000,'Male',25),
(107,'Anu','Vijaya',75000,'Female',50),
(108,'Tara','Vaishu',45000,'Female',24),
(123,'Zyan','Kishan',45000,'Male',28),
(154,'Venkat','Ragava',50000,'Male',35),
(143,'Manisha','Arjun',60000,'Female',42),
(178,'John','Smith',77000,'Male',55)
;

-- SELECT AND PEMDAS(PARANTHESIS, EXPONENT, MULTIPLICATION, DIVISION, ADDITION, SUBTRACTION
SELECT first_name,age,age+10 
FROM employees;

--DISTINCT

SELECT DISTINCT gender FROM employees;

-- WHERE CLAUSE

SELECT * FROM employees WHERE gender='Female';

-- LOGICAL OPERATION

SELECT * FROM employees WHERE gender='Female' AND age!=50 ;
SELECT * FROM employees WHERE gender='Female' OR age=50 ;

-- TABLE DEPARTMENTS
CREATE TABLE departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);


ALTER TABLE departments
ADD place VARCHAR(20)
;

SELECT * FROM departments;

ALTER TABLE employees
ADD DepartmentID INT;

-- FOREIGN KEY AS EMPLOYEE ID
ALTER TABLE employees
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (DepartmentID) REFERENCES departments(DepartmentID);


INSERT INTO departments (DepartmentID, DepartmentName)
VALUES 
(1, 'HR'),
(2, 'IT Support'),
(3, 'Finance'),
(4, 'Marketing'),
(5,'Product');

ALTER TABLE departments
DROP COLUMN place; 


-- UPDATE
UPDATE employees 
SET DepartmentID = 1 
WHERE salary > 60000;

UPDATE employees 
SET DepartmentID = 2 
WHERE salary = 50000;

UPDATE employees 
SET DepartmentID = 3 
WHERE first_name = 'Manisha';


UPDATE employees 
SET DepartmentID = 5 
WHERE salary = 30000;

UPDATE employees 
SET DepartmentID = 4 
WHERE age<30 AND age !=25;

-- performance_reviews table
CREATE TABLE performance_reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,     -- Auto-increments (1, 2, 3...)
    EmployeeID INT NOT NULL,
    ReviewDate DATE NOT NULL,                   -- Date of evaluation
    Rating INT CHECK (Rating BETWEEN 1 AND 5), -- Restricts rating scale from 1 to 5
    Notes VARCHAR(MAX),                  -- Unlimited text for feedback
);
-- foreign key as employee id
ALTER TABLE performance_reviews
ADD CONSTRAINT FK_Reviews_Employees 
        FOREIGN KEY (EmployeeID) REFERENCES employees(employee_id)
;

SELECT * FROM performance_reviews;

--insert 

INSERT INTO performance_reviews (EmployeeID, ReviewDate, Rating, Notes)
VALUES 
(101, '2026-07-17', 4, 'Excellent'),
(107, '2026-07-17', 5, 'Star Performer'),
(104, '2026-07-17', 2, 'Needs to improve');

INSERT INTO performance_reviews (EmployeeID, ReviewDate, Rating, Notes)
VALUES 
(154, '2026-07-18', 3, 'Good, Keep Trying'),
(108, '2026-07-18', 1, 'Better Luck next Time'),
(178, '2026-07-18', 4, 'Excellent');

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM performance_reviews;

-- inner join
SELECT *
FROM employees
INNER JOIN performance_reviews
ON employees.employee_id= performance_reviews.EmployeeID;

SELECT employee_id,first_name,last_name,Notes 
FROM employees
INNER JOIN performance_reviews
ON employees.employee_id= performance_reviews.EmployeeID;


-- outer join

SELECT *
FROM employees
LEFT JOIN performance_reviews -- OR LEFT OUTER JOIN
ON employees.employee_id= performance_reviews.EmployeeID;

SELECT *
FROM employees
RIGHT JOIN performance_reviews -- OR RIGHT OUTER JOIN
ON employees.employee_id= performance_reviews.EmployeeID;

-- SELF JOIN

SELECT *
FROM performance_reviews pr1
JOIN performance_reviews pr2
    ON pr1.ReviewID +1 = pr2.ReviewID ;


-- join multiple tables together
SELECT *
FROM employees
INNER JOIN performance_reviews
    ON employees.employee_id= performance_reviews.EmployeeID
INNER JOIN departments 
    ON performance_reviews.ReviewID = departments.DepartmentID; -- ReviewID and DepartmentID are not same but they have different values
    

-- unions
SELECT DepartmentID, DepartmentName FROM departments
UNION
SELECT employee_id,first_name FROM employees
;


-- string functions

-- LEN (length)
SELECT first_name, LEN(first_name) AS char_len -- LENGTH IS FOR MySQL and for SSMS it is LEN
FROM employees
ORDER BY char_len ASC;

SELECT first_name, LEN(first_name) AS char_len -- LENGTH IS FOR MySQL and for SSMS it is LEN
FROM employees
ORDER BY char_len DESC;

-- UPPER
SELECT first_name, UPPER(first_name) AS char_upper -- LENGTH IS FOR MySQL and for SSMS it is LEN
FROM employees;

--LOWER 
SELECT first_name, LOWER(first_name) AS char_lower -- LENGTH IS FOR MySQL and for SSMS it is LEN
FROM employees;

--TRIMS(LEFT , RIGTH TRIMS)
SELECT first_name,
LTRIM(first_name, 2) AS LEFT_TRIM,
RTRIM(first_name, 2) AS REFT_TRIM,
SUBSTRING(first_name, 2 ,4)
FROM employees;

-- REPLACE
SELECT first_name,
REPLACE(first_name, 'a' ,'e')
FROM employees;

-- LOCATE(MySQL) and CHARINDEX(SSMS)
SELECT first_name,
CHARINDEX('An',first_name)
FROM employees;

-- CONCAT
SELECT first_name,last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employees;

-- case statements (benefits : can add multiple when clause)

SELECT * FROM employees;
SELECT first_name,
last_name, 
age,
CASE
    WHEN age <=30 THEN 'YOUNG'
    WHEN age BETWEEN 31 AND 60 THEN 'OLD'
END AS age_category
FROM employees;

SELECT first_name,
last_name, 
salary,
CASE
    WHEN salary<50000 THEN salary+(salary*0.05)
    WHEN salary BETWEEN 50000 AND 60000 THEN salary+(salary*0.07)
    WHEN salary>60000 THEN salary+(salary*0.09)
END AS pay_increase,
CASE
    WHEN DepartmentID=3 THEN salary+(salary*0.1)
END AS bonus

FROM employees;


-- SUBQUERIES

-- 1)USING WHERE CLAUSE
SELECT * FROM employees
WHERE employee_id IN
                  (SELECT employee_id FROM employees WHERE DepartmentID=1)
;

-- SELECT
SELECT first_name, salary,
(SELECT AVG(salary)  
FROM employees)
FROM employees
;


-- Aggregate fns
SELECT AVG(max_age) AS agg_table
FROM
(SELECT Gender,
AVG(age) AS avg_age,
MIN(age) AS min_age,
MAX(age) AS max_age
FROM employees
GROUP BY gender) AS agg_table
;

-- windows fns
SELECT * FROM employees;

SELECT Gender , AVG(salary) OVER(PARTITION BY gender)
FROM employees
JOIN performance_reviews
ON employees.employee_id = performance_reviews.EmployeeID;

SELECT first_name,Gender , salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY employee_id)AS rolling_total -- consecutive additions
FROM employees
JOIN performance_reviews
ON employees.employee_id = performance_reviews.EmployeeID;

SELECT first_name,Gender , salary,
ROW_NUMBER() OVER(ORDER BY salary)
FROM employees
JOIN performance_reviews
ON employees.employee_id = performance_reviews.EmployeeID;



SELECT first_name,Gender , salary,
ROW_NUMBER() OVER(PARTITION BY Gender 
ORDER BY salary)
FROM employees
JOIN performance_reviews
ON employees.employee_id = performance_reviews.EmployeeID;



SELECT first_name,Gender , salary,
ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY salary) AS row_num,
RANK() OVER(PARTITION BY Gender ORDER BY salary) AS rank_num
FROM employees
JOIN performance_reviews
ON employees.employee_id = performance_reviews.EmployeeID;

-- Temp tables in ssms-- CREATE TEMPORARY TABLE IN MySQL-- #table_name in SSMS--

SELECT * 
INTO #temp_table
FROM
employees WHERE salary>60000;

SELECT * FROM #temp_table;

--CTE's --
WITH cte_eg AS
(
SELECT * 
FROM employees)
SELECT AVG(salary) FROM cte_eg;


--STORED PROCEDURES---
CREATE PROCEDURE GetHighEarners
AS  -- Tells SQL Server the definition starts here
BEGIN  -- Opens the code block
    SELECT employee_id, first_name, salary 
    FROM employees 
    WHERE salary > 60000 
    ORDER BY salary DESC;
END;  -- Closes the code block

EXEC GetHighEarners;

CREATE TABLE SAMPLE_T(
SAM_NO INT IDENTITY(1,1) PRIMARY KEY,
sam_nam VARCHAR(50));

INSERT INTO SAMPLE_T(sam_nam
) VALUES
('A'),('B'),('C');

SELECT * FROM SAMPLE_T;

DELETE FROM SAMPLE_T WHERE SAM_NO=3;
TRUNCATE TABLE SAMPLE_T;
DROP TABLE SAMPLE_T;


--- TRIGGERS AND EVENTS---





