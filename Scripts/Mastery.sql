USE practicedb;
go

-- Changed FROM PRACTICE.dbo to practice schema for better organization and to avoid confusion with other databases

CREATE SCHEMA PRACTICE;
GO
ALTER SCHEMA PRACTICE TRANSFER dbo.calendar_data;
ALTER SCHEMA PRACTICE TRANSFER dbo.doctors;
ALTER SCHEMA PRACTICE TRANSFER dbo.patients;
ALTER SCHEMA PRACTICE TRANSFER dbo.test_shop;
ALTER SCHEMA PRACTICE TRANSFER dbo.vw_Doctor_Patient;

SELECT DB_NAME();
SELECT USER_NAME(),SUSER_NAME();
SELECT IS_MEMBER('db_owner');
ALTER USER dbo
WITH DEFAULT_SCHEMA = PRACTICE; -- To change the default schema of the user to practice but for dbo it won't change

SELECT default_schema_name
FROM sys.database_principals
WHERE name = USER_NAME();

-- Where Condition

SELECT * 
FROM PRACTICE.test_shop
WHERE size  = 'L';

-- Order By
SELECT 
	Age, 
	Purchase_Amount_USD, 
	size	
FROM PRACTICE.test_shop
WHERE size  = 'S'
ORDER BY age ASC, Purchase_Amount_USD DESC;

-- Group By

SELECT 
	Category,
	COUNT(*) AS Total_Purchases,
	AVG(Purchase_Amount_USD) AS Average_Spend 
FROM PRACTICE.test_shop
GROUP BY Category;

-- Multi Group by = Unique values of grouped columns

SELECT 
	Gender,
	Item_purchased,
	COUNT(*) AS Total_Purchases
FROM PRACTICE.test_shop
GROUP BY Gender, Item_purchased
ORDER BY Item_Purchased ASC, Gender DESC

-- Having Clause

SELECT 
	Gender,
	Item_purchased,
	COUNT(*) AS Total_Purchases
FROM PRACTICE.test_shop
GROUP BY Gender, Item_purchased
HAVING Item_Purchased = 'Shoes'
ORDER BY Item_Purchased ASC, Gender DESC;

-- Distinct

SELECT
	DISTINCT Shipping_Type
FROM PRACTICE.test_shop;

-- Top

SELECT TOP 5*
FROM PRACTICE.test_shop

-- Static Values = We can add columns in the select statement with static values

SELECT
	DISTINCT Shipping_Type,
	'Unique' AS Type_of_ship
FROM PRACTICE.test_shop;

-- Filtering Data

-- Comparison Operators: =, <>, >, <, >=, <=
-- for not equals to we can use <> or !=

SELECT * 
FROM PRACTICE.test_shop
WHERE Item_Purchased = 'Blouse';

SELECT * 
FROM PRACTICE.test_shop
WHERE Category != 'Clothing';

SELECT * 
FROM PRACTICE.test_shop
WHERE Age > 60;

SELECT * 
FROM PRACTICE.test_shop
where Review_Rating <= 2.5;

--- Logical Operators: AND, OR, NOT

SELECT	
	age, 
	gender, 
	Item_Purchased, 
	Location 
FROM PRACTICE.test_shop
WHERE Item_Purchased = 'Sneakers' AND Age > 50
ORDER BY gender DESC,age DESC;

SELECT
	age, 
	gender, 
	Item_Purchased, 
	Location
FROM PRACTICE.test_shop
WHERE Item_Purchased = 'Blouse' or Gender = 'Female'
ORDER BY gender DESC,age DESC;

SELECT 
	gender, 
	age, 
	Subscription_Status 
FROM PRACTICE.test_shop
WHERE NOT Subscription_Status = 'Yes'
ORDER BY gender DESC, age ASC;

-- RANGE Operators: BETWEEN

SELECT 
	Season, 
	Subscription_Status 
FROM PRACTICE.test_shop
WHERE Review_Rating BETWEEN 3.0 AND 4.5;

-- MEMBERSHIP Operators: IN, NOT IN

SELECT * 
FROM PRACTICE.test_shop
WHERE Location IN ('Virginia', 'Oklahoma', 'Texas');

SELECT * 
FROM PRACTICE.test_shop
WHERE Shipping_Type NOT IN ('Next Day Air', '2-Day Shipping');

-- Search Pattern Operators: LIKE

SELECT * 
FROM PRACTICE.test_shop
WHERE Color LIKE 'b%';

SELECT * 
FROM PRACTICE.test_shop
WHERE Color LIKE '%y';

SELECT * 
FROM PRACTICE.test_shop
WHERE Color LIKE 'b%e';

SELECT * 
FROM PRACTICE.test_shop
WHERE Color LIKE 'B__e';

-- To Drop a table
DROP TABLE Customers;

SELECT * 
FROM PRACTICE.test_shop
WHERE Item_Purchased LIKE '%s%';

SELECT * FROM PRACTICE.patients;
SELECT * FROM PRACTICE.doctors;
SELECT * FROM PRACTICE.calendar_data;

-- COLUMNS DROPPED
ALTER TABLE doctors
DROP COLUMN svg_img, png_img;

--JOINS

SELECT * FROM PRACTICE.patients;
SELECT * FROM PRACTICE.doctors;

SELECT
	a.Patient_ID, 
	b.doctor_id, 
	b.doctor 
FROM PRACTICE.patients AS a
FULL JOIN PRACTICE.doctors AS b
ON a.Doctor_ID = b.Doctor_ID
ORDER BY b.doctor_id ASC;

SELECT
	a.Patient_ID, 
	b.doctor_id, 
	b.doctor 
FROM PRACTICE.patients AS a
INNER JOIN PRACTICE.doctors AS b
ON a.Doctor_ID = b.Doctor_ID
ORDER BY b.doctor_id ASC;

-- Age retrived FROM PRACTICE.DOB and IN_DATE and depatment FROM PRACTICE.doctors table using inner join

SELECT
	Patient_ID,
	p.Doctor_ID,
	DOB, 
	IN_DATE,
	DATEDIFF(YEAR, DOB, In_Date) AS AGE_AT_ADMISSION,
	d.department
FROM PRACTICE.patients AS p
inner JOIN PRACTICE.doctors AS d
ON p.Doctor_ID = d.doctor_id
ORDER BY AGE_AT_ADMISSION;

-- UNION GIVES DISTINCT VALUES SO TOTAL 35 VALUES ONLY

SELECT DOCTOR_ID FROM PRACTICE.patients

SELECT DOCTOR_ID FROM PRACTICE.patients
UNION
SELECT doctor_id FROM PRACTICE.doctors


-- UNION ALL GIVES ALL VALUES INCLUDING DUPLICATES SO TOTAL 4207+35 = 4241

SELECT DOCTOR_ID FROM PRACTICE.patients
SELECT doctor_id FROM PRACTICE.doctors

SELECT DOCTOR_ID FROM PRACTICE.patients
UNION ALL
SELECT doctor_id FROM PRACTICE.doctors

--EXCEPT GIVES DISTINCT VALUES IN FIRST SELECT STATEMENT WHICH ARE NOT IN SECOND SELECT STATEMENT

SELECT DOCTOR_ID FROM PRACTICE.patients

SELECT DOCTOR_ID FROM PRACTICE.patients
EXCEPT
SELECT doctor_id FROM PRACTICE.doctors

-- INTERSECT GIVES DISTINCT VALUES WHICH ARE COMMON IN BOTH SELECT STATEMENTS

SELECT DOCTOR_ID FROM PRACTICE.patients
INTERSECT
SELECT doctor_id FROM PRACTICE.doctors

-- SQL FUNCTIONS

--SINGLE ROW FUNCTIONS

--String Functions

-- MANUPULATING STRINGS

SELECT 
	doctor, 
	department, 
	CONCAT(doctor, ' - ', department) AS Doctor_Dept
FROM PRACTICE.doctors;

SELECT 
	doctor, 
	department,
	UPPER(doctor) AS CAPITAL_DOCTOR_NAME,
	LOWER(department) AS small_department_name
FROM PRACTICE.doctors;

SELECT 
	doctor,
	LEN(doctor) AS Doctor_Name_Length,
	LEN(TRIM(doctor)) AS Doctor_Name_Length_Without_Spaces,
	LEN(DOCTOR) - LEN(TRIM(DOCTOR)) AS FLAG
FROM PRACTICE.doctors;

SELECT '21-02-2026' AS DATE,
REPLACE('21-02-2026', '-', '/') AS new_date;

-- CALCULATION

SELECT 
	Referred_by,
	LEN(Referred_by) AS patient_length
FROM PRACTICE.patients;

-- STRING EXTRACTION FUNTIONS

SELECT 
	doctor,
	LEFT(doctor, 3) AS Doctor_Name_First_3_Characters,
	RIGHT(doctor, 3) AS Doctor_Name_Last_3_Characters
FROM PRACTICE.doctors;

SELECT 
	doctor,
	SUBSTRING(doctor, 4, len(doctor)) AS Doctor_Name
FROM PRACTICE.doctors;

-- NUMERIC FUNCTIONS

SELECT
	ROUND(Review_Rating, 2) AS Rounded_Review_Rating,
	CEILING(Review_Rating) AS Ceiling_Review_Rating,
	FLOOR(Review_Rating) AS Floor_Review_Rating
FROM PRACTICE.test_shop;

-- DATE FUNCTIONS

-- PART EXTRACTION


SELECT
	In_Date,
	YEAR(In_Date) AS Admission_Year,
	MONTH(In_Date) AS Admission_Month,
	DAY(In_Date) AS Admission_Day,
	GETDATE() AS NOW -- gives current date and time
FROM PRACTICE.patients;

SELECT
	In_Date,
	DATEPART(YEAR, In_Date) AS Admission_Year_Bucket,
	DATEPART(MONTH, In_Date) AS Admission_Month_Bucket,
	DATEPART(DAY, In_Date) AS Admission_Day_Bucket,
	DATEPART(WEEKDAY, In_Date) AS Admission_Day_of_Weekday_Bucket,
	DATEPART(WEEK, In_Date) AS Admission_Day_of_Week_Bucket,
	DATEPART(quarter, In_Date) AS Admission_Quarter_Bucket
FROM PRACTICE.patients;

-- DATANAME STORES THE NAME AS STRING INSTEAD OF NUMBER LIKE DATEPART

SELECT
	In_Date,
	DATENAME(YEAR, In_Date) AS Admission_Year_Bucket,
	DATENAME(MONTH, In_Date) AS Admission_Month_Bucket,
	DATENAME(DAY, In_Date) AS Admission_Day_Bucket,
	DATENAME(WEEKDAY, In_Date) AS Admission_Day_of_Weekday_Bucket,
	DATENAME(WEEK, In_Date) AS Admission_Day_of_Week_Bucket,
	DATENAME(quarter, In_Date) AS Admission_Quarter_Bucket
FROM PRACTICE.patients;

-- DATETRUNC GIVES THE STARTING DATE OF THE BUCKET (RESETS NOT REUIQRED DATA)

SELECT
	In_Date,
	DATETRUNC(YEAR, In_Date) AS Admission_Year_Bucket,
	DATETRUNC(MONTH, In_Date) AS Admission_Month_Bucket,
	DATETRUNC(DAY, In_Date) AS Admission_Day_Bucket
FROM PRACTICE.patients;

-- ANALSIS USING DATATRUNC (NO OF ADMISSIONS BY YEAR)

SELECT
	DATETRUNC(YEAR, In_Date) AS Admission_Year_Bucket,
	COUNT(*) AS Total_Admissions
FROM PRACTICE.patients
GROUP BY DATETRUNC(YEAR, In_Date);

-- DATE FOMATTING & CASTING

select 
	In_Date,
	FORMAT(In_Date, 'dd-MM-yyyy') AS full_date,
	FORMAT(In_Date, 'dd') AS Fd_f2,
	FORMAT(In_Date, 'ddd') AS Fd_f3,
	FORMAT(In_Date, 'dddd') AS Fd_f4,
	FORMAT(In_Date, 'MM') AS Fd_M1,
	FORMAT(In_Date, 'MMM') AS Fd_M2,
	FORMAT(In_Date, 'MMMM') AS Fd_M3,
	FORMAT(In_Date, 'yy') AS Fd_y1,
	FORMAT(In_Date, 'yyy') AS Fd_y2,
	FORMAT(In_Date, 'yyyy') AS Fd_y3
FROM PRACTICE.patients;

SELECT 
	In_Date,
	CONVERT(nvarchar, In_Date, 105) AS full_date,
	CONVERT(nvarchar, In_Date, 104) AS full_date_2,
	CONVERT(nvarchar, In_Date, 103) AS full_date_3,
	CONVERT(nvarchar, In_Date, 101) AS full_date_4,
	CONVERT(nvarchar, In_Date, 102) AS full_date_5
FROM PRACTICE.patients;

SELECT 
	In_Date,
	CAST(In_Date AS nvarchar) AS full_date,
	CAST(In_Date AS date) AS date_only,
	CAST(In_Date AS datetime) AS date_time
FROM PRACTICE.patients;

--DATE CALCULATIONS

SELECT 
	IN_DATE,
	OUT_DATE,
	DATEADD(DAY, 7, In_Date) AS Date_After_7_Days,
	DATEADD(MONTH, 1, In_Date) AS Date_After_1_Month,
	DATEADD(YEAR, 1, In_Date) AS Date_After_1_Year,
	DATEDIFF(DAY, In_Date, Out_Date) AS Total_Days_Admitted,
	DATEDIFF(MONTH, In_Date, Out_Date) AS Total_Months_Admitted,
	DATEDIFF(YEAR, In_Date, Out_Date) AS Total_Years_Admitted
FROM PRACTICE.patients;

SELECT
	Patient_ID,
	DOB, 
	IN_DATE,
	DATEDIFF(YEAR, DOB, In_Date) AS AGE_AT_ADMISSION
FROM PRACTICE.patients
ORDER BY AGE_AT_ADMISSION;

-- CASE STATEMENT

SELECT 
	AGE,
	CASE 
	WHEN AGE > 50 THEN 'RETIRED'
	WHEN AGE < 50 THEN 'WORKING'
	ELSE 'DONT KNOW'
END AS STATUS
FROM PRACTICE.TEST_SHOP

SELECT
STATUS,
count(age) AS Total_Customers
from
(SELECT 
	AGE,
	CASE 
	WHEN AGE > 50 THEN 'RETIRED'
	WHEN AGE < 50 THEN 'WORKING'
	ELSE 'DONT KNOW'
END AS STATUS
FROM PRACTICE.TEST_SHOP)t
group by status;

-- For = operator we can give column names ones that is enough

SELECT 
	Gender,
	CASE Gender
	WHEN 'Male' THEN 'King'
	WHEN 'Female' THEN 'Queen'
	ELSE 'DONT KNOW'
	END AS Category
FROM PRACTICE.TEST_SHOP
 
-- AGGREGATE FUNCTIONS

SELECT
	gender,
	count(*) AS total_amount,
	sum(Purchase_Amount_USD) AS sum,
	avg(Purchase_Amount_USD) AS avg,
	min(Purchase_Amount_USD) AS min,
	max(Purchase_Amount_USD) AS max
FROM PRACTICE.test_shop
GROUP BY Gender

-- WINDOW FUNCTIONS

SELECT
	Customer_ID,
	Age,
	GENDER,
	SUM(Purchase_Amount_USD) OVER () AS Total_Purchase_Amount_Whole,
	SUM(Purchase_Amount_USD) OVER (PARTITION BY GENDER) AS Total_Purchase_Amount_By_Gender,
	SUM(Purchase_Amount_USD) OVER (PARTITION BY GENDER, AGE) AS Total_Purchase_Amount_By_Gender_By_Age
FROM PRACTICE.test_shop
ORDER BY AGE, GENDER;

-- WE NEED TO USE SUBQUIRES BECAUSE WE CANT USE WHERE CLAUSE IN WINDOW FUNCTIONS

SELECT
*
FROM (
	SELECT
		GENDER,
		Purchase_Amount_USD,
		MIN(Purchase_Amount_USD) OVER (PARTITION BY GENDER) AS Min,
		MAX(Purchase_Amount_USD) OVER (PARTITION BY GENDER) AS Max
	FROM PRACTICE.test_shop
)t where Purchase_Amount_USD = Min or Purchase_Amount_USD = Max
order by Purchase_Amount_USD, GENDER desc;

SELECT
	Customer_ID,
	Age,
	GENDER,
	Purchase_Amount_USD,
	SUM(Purchase_Amount_USD) OVER () AS Total_Purchase_Amount_Whole,
	SUM(Purchase_Amount_USD) OVER (PARTITION BY GENDER) AS Total_Purchase_Amount_By_Gender,
	SUM(Purchase_Amount_USD) OVER (ORDER BY AGE) AS Running_Total_By_Age,
	SUM(Purchase_Amount_USD) OVER (ORDER BY AGE rows 2 PRECEDING) AS Rolling_Total_By_Age
FROM PRACTICE.test_shop;

-- RANKING FUNCTIONS

SELECT
	Item_Purchased,
	ROW_NUMBER() OVER (ORDER BY Item_Purchased) AS RN,
	RANK() OVER (ORDER BY Item_Purchased) AS RANK,
	DENSE_RANK() OVER (ORDER BY Item_Purchased) AS DENSE_RANK
FROM PRACTICE.test_shop;

SELECT
	Age,
	ROW_NUMBER() OVER (ORDER BY Age) AS RN,
	RANK() OVER (ORDER BY Age) AS RANK,
	DENSE_RANK() OVER (ORDER BY Age) AS DENSE_RANK
FROM PRACTICE.test_shop;

-- CUME_DIST GIVES THE CUMULATIVE DISTRIBUTION OF THE VALUES 
-- PERCENT_RANK GIVES THE RELATIVE RANK OF THE CURRENT ROW WITHIN THE ORDERED SET. 
-- NTILE DIVIDES THE ORDERED SET INTO A SPECIFIED NUMBER OF APPROXIMATELY EQUAL GROUP

SELECT
	department,
	ROUND(CUME_DIST() OVER (ORDER BY department),2) AS CUME_DIST, 
	ROUND(PERCENT_RANK() OVER (ORDER BY department), 2) AS PERCENT_RANK,
	NTILE(4) OVER (ORDER BY department) AS Age_Quartiles
FROM PRACTICE.doctors

SELECT
	department,
	NTILE(5) OVER (ORDER BY department) AS Dept_Quartiles
FROM PRACTICE.doctors;

-- WINDOW VALUE FUNCTIONS

SELECT 
	Patient_ID,
	LAG(Patient_ID,1,0) OVER (ORDER BY Patient_ID) AS Previous_Patient_ID,
	LEAD(Patient_ID,1,'ragu') OVER (ORDER BY Patient_ID) AS Next_Patient_ID,
	first_value(Patient_ID) OVER (ORDER BY Patient_ID) AS First_Patient_ID
FROM PRACTICE.patients

-- FOR LAST VALUE WE NEED TO USE FRAME SO IT WILL GIVE EXPECTED VALUE

SELECT 
    Patient_ID,
    LAST_VALUE(Patient_ID) 
    OVER (
        ORDER BY Patient_ID 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS Last_Patient_ID
FROM PRACTICE.patients

-- SUBQUERIES

-- SUBQUERIES USED IN FROM PRACTICE.CLAUSE

SELECT
* FROM 
	(SELECT 
		Customer_ID,
		Purchase_Amount_USD,
		Review_Rating,
		AVG(Purchase_Amount_USD) OVER () AS Average_Purchase_Amount
	FROM PRACTICE.test_shop)t
WHERE Purchase_Amount_USD >= Average_Purchase_Amount
ORDER BY Purchase_Amount_USD;

SELECT
	Category,
	Total_Purchase_Amount,
	RANK() OVER (ORDER BY Total_Purchase_Amount) AS Purchase_Rank
	FROM (SELECT
		Category,
		SUM(Purchase_Amount_USD) AS Total_Purchase_Amount
	FROM PRACTICE.test_shop
	GROUP BY Category)t

SELECT
	Item_Purchased,
	Total_Purchase_Amount,
	RANK() OVER (ORDER BY Total_Purchase_Amount) AS Purchase_Rank
	FROM (SELECT
		Item_Purchased,
		SUM(Purchase_Amount_USD) AS Total_Purchase_Amount
	FROM PRACTICE.test_shop
	GROUP BY Item_Purchased)t

-- IF WE WANT TO USE AGGREGATE FUNCTIONS IN THE SELECT STATEMENT WITHOUT GROUP BY THEN WE NEED TO USE SUBQUERIES
-- SUBQUERIES USED IN SELECT CLAUSES

SELECT 
	Customer_ID,
	Purchase_Amount_USD,
	Review_Rating,
	(SELECT COUNT(*) FROM PRACTICE.test_shop) AS Total_Purchases
FROM PRACTICE.test_shop

-- SUBQUERIES USED IN JOIN PRACTICE.CLAUSES

SELECT
	a.Customer_ID,
	a.Purchase_Amount_USD,
	b.Average_Purchase_Amount
	FROM PRACTICE.test_shop AS a
	LEFT JOIN
	(SELECT 
		Customer_ID,
		AVG(Purchase_Amount_USD) AS Average_Purchase_Amount
		FROM PRACTICE.test_shop
		GROUP BY Customer_ID) AS b
		ON a.Customer_ID = b.Customer_ID

-- SUBQUERIES USED IN WHERE CLAUSES

SELECT 
	Customer_ID,
	Purchase_Amount_USD,
	Review_Rating
FROM PRACTICE.test_shop
WHERE Purchase_Amount_USD >= (SELECT AVG(Purchase_Amount_USD) FROM PRACTICE.test_shop)
ORDER BY Purchase_Amount_USD;

SELECT
	Patient_ID,
	DOB,
	Doctor_ID,
	IN_DATE
FROM PRACTICE.patients
WHERE Doctor_ID IN (SELECT Doctor_ID FROM PRACTICE.doctors WHERE department = 'Cardiology' )

-- CTE

WITH CTE_Total_Doctors AS 
(
SELECT
	doctor_id,
	department,
	(SELECT COUNT(doctor_id) FROM PRACTICE.doctors) AS Total_Doctors
FROM PRACTICE.doctors
)

--Main Query

SELECT 
	p.Patient_ID,
	p.Doctor_ID,
	p.Follow_up,
	ctd.department,
	ctd.Total_Doctors
FROM PRACTICE.patients as p
LEFT JOIN CTE_Total_Doctors ctd
ON ctd.doctor_id = p.Doctor_ID

--VIEWS

CREATE VIEW PRACTICE.vw_Doctor_Patient AS
(SELECT 
	p.Patient_ID,
	p.Doctor_ID,
	p.Follow_up,
	d.department
	FROM PRACTICE.patients as p
	LEFT JOIN PRACTICE.doctors d
	ON d.doctor_id = p.Doctor_ID)

-- QUERYING THE VIEW
SELECT 
	department,
	COUNT(*) AS Total_Patients
FROM PRACTICE.vw_Doctor_Patient
GROUP BY department

-- CTAS AND TEMP TABLES

SELECT
	doctor_id,
	COUNT(Patient_ID) AS Total_Patients
	INTO PRACTICE.Doctor_Patient_Count
	FROM PRACTICE.patients
	GROUP BY doctor_id
	
DROP TABLE PRACTICE.Doctor_Patient_Count; -- Manually dropping the table after use


IF OBJECT_ID('Doctor_Patient_Count', 'U') IS NOT NULL
	DROP TABLE Doctor_Patient_Count;
GO
SELECT 
	doctor_id,
	COUNT(Patient_ID) AS Total_Patients
	INTO PRACTICE.Doctor_Patient_Count
	FROM PRACTICE.patients
	GROUP BY doctor_id
	
SELECT * FROM PRACTICE.Doctor_Patient_Count
ORDER BY doctor_id

--STORED PROCEDURES

CREATE PROCEDURE Get_Item AS
BEGIN
SELECT
	age,
	gender,
	purchase_amount_USD,
	Item_Purchased,
	Season,
	Subscription_Status
FROM PRACTICE.test_shop
WHERE Item_Purchased = 'Blouse'
END

EXEC Get_Item

-- PROCEDURE WITH PARAMETERS

CREATE PROCEDURE Get_Item_Purchased @Item NVARCHAR(20) 
AS
BEGIN
SELECT
	age,
	gender,
	purchase_amount_USD,
	Item_Purchased,
	Season,
	Subscription_Status,
	(SELECT COUNT(*) FROM PRACTICE.test_shop) AS Total_Items
FROM PRACTICE.test_shop
WHERE Item_Purchased = @Item
END

EXEC Get_Item_Purchased @Item = 'sweater'

-- Default value given to parameter

ALTER PROCEDURE Get_Item_Purchased @Item NVARCHAR(20) = 'Blouse' 
AS
BEGIN
SELECT
	age,
	gender,
	purchase_amount_USD,
	Item_Purchased,
	Season,
	Subscription_Status,
	(SELECT COUNT(*) FROM PRACTICE.test_shop) AS Total_Items
FROM PRACTICE.test_shop
WHERE Item_Purchased = @Item
END

