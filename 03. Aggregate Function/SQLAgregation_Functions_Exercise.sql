-- Agregation Functions Exercise
-- Functions learned: SUM, COUNT, DISTINCT COUNT, MIN, MAX, AVG
-- Database: ContosoRetailDW

/* 1. The sales manager asked you for an analysis of Quantity Sold and Returned Quantity for the company’s most important sales channel  : Store.
Use a SQL function to make these queries in your database. Note: Make this analysis considering the FactSales table. */

select 
	SUM(FactSales.SalesQuantity) as 'TotalSales',
	SUM(FactSales.ReturnQuantity) as 'TotalReturn',
	DimStore.StoreType
from FactSales
LEFT JOIN	DimStore ON FactSales.StoreKey = DimStore.StoreKey
WHERE StoreType = 'Store'
GROUP BY StoreType

/*SELECT TOP 10 * FROM FactSales
SELECT  * FROM DimStore */


/* 2. A new action in the Marketing sector will need to evaluate the average salary of all clients of the company, but only of Professional occupation.
Use an SQL command to achieve this result. */

select	
	AVG(YearlyIncome) as 'AVGYearlyIncome',
	Occupation
from DimCustomer
where Occupation = 'Professional'
group by Occupation

/* 3. You will need to make an analysis of the number of employees of the stores registered in the company. 
Your manager asked you for the following numbers and information: 

-- a. How many employees does the largest store have? 325
-- b. What is the name of this store? Contoso North America Online Store
-- c. How many employees does the smallest store have? 7
-- d. What is the name of this store? Contoso Europe Online Store */ 

select 
	MAX(EmployeeCount) as 'LargestStore',
	MIN(EmployeeCount) as 'SmallestStore'
from DimStore

select 
	StoreName,
	EmployeeCount
from DimStore
where EmployeeCount = 325 or EmployeeCount = 7


-- Another way
SELECT 
    'LargestStore' AS StoreType,
    StoreName,
	EmployeeCount
FROM DimStore
WHERE EmployeeCount = (SELECT MAX(EmployeeCount) FROM DimStore)

UNION ALL

SELECT 
    'SmallestStore' AS StoreType,
    StoreName,
	EmployeeCount
FROM DimStore
WHERE EmployeeCount = (SELECT MIN(EmployeeCount) FROM DimStore);



/* 4. The HR area is with a new action for the company, and for this need to know the total number of employees male and female.
a)	Discover these two information using SQL. */

select
	Gender,
	COUNT(EmployeeKey) as 'TotalGender'
from DimEmployee
Group by Gender

-- b)	The oldest employee will receive a tribute. Find out the following information from each of them: Name, E-mail, Date of Hiring. 
select
	CASE
		when MiddleName is not Null then CONCAT(FirstName,' ',MiddleName,' ',LastName)
		else CONCAT(FirstName,' ',LastName) 
		end as 'FullName',
	EmailAddress,
	HireDate,
	Gender
from DimEmployee
ORDER BY HireDate asc

-- select * from DimEmployee

/* 5. Now you need to do an analysis of the products. You will need to find out the following information:

a)	Distinct quantity of colors of products.
b)	Distinct quantity of marks
c)	Distinct quantity of product classes
For simplicity, you can do this in a single query. */

select 
	COUNT(DISTINCT(BrandName)) as 'Brand',
	COUNT(Distinct(ColorName)) as 'Color',
	COUNT(DISTINCT(ClassName)) as 'Class'
from DimProduct