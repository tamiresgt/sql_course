-- Subquery and CTE's  Module 
-- Functions learned: SUBQUERY, ANY, SOME, ALL, EXISTS, SELECT, FROM, NESTED SUBQUERY, CTE, 
-- Database: ContosoRetailDW

-- Select products that have a higher than average price

SELECT AVG(UnitPrice) as 'AVGPrice'
FROM DimProduct

-- AVG = 356.8301
SELECT *
FROM DimProduct
WHERE UnitPrice > 356.8301

-- SUBQUERY 
SELECT *
FROM DimProduct
WHERE UnitPrice > (SELECT AVG(UnitPrice) from DimProduct)

-- Example 1: Which products in the DimProduct table have above-average costs?

SELECT * 
FROM DimProduct
WHERE UnitCost > (SELECT AVG(UnitCost) FROM DimProduct)

/* Example 2: Make a query to return the products in the 'Televisions' category. 
Be careful because we don't have the Subcategory Name information in the DimProduct table. 
Therefore, we will need to create a SELECT that finds the ID of the 'Televisions' category and pass this result as the value we want to filter within the WHERE. */

SELECT * FROM DimProduct
WHERE ProductSubcategoryKey = 
	(SELECT ProductSubcategoryKey FROM DimProductSubcategory 
		WHERE ProductSubcategoryName = 'Televisions')

-- using join
SELECT *
FROM DimProduct
LEFT JOIN DimProductSubcategory ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
WHERE DimProductSubcategory.ProductSubcategoryName = 'Televisions'

-- Example 3: Filter the FactSales table and show only sales relating to stores with 100 or more employees

SELECT * FROM FactSales
WHERE StoreKey IN 
	(SELECT StoreKey FROM DimStore
		WHERE EmployeeCount >= 100)

-- ANY, SOME, ALL

CREATE TABLE Employees (
	id_employee INT,
	employee_name VARCHAR(100),
	age INT,
	gender VARCHAR(30)
	)

INSERT INTO Employees (id_employee,employee_name,age,gender)
VALUES 
	(1, 'Julia', 20, 'F'),
	(2, 'Daniel', 21, 'M'),
	(3, 'Amanda', 22, 'F'),
	(4, 'Pedro', 23, 'M'),
	(5, 'André', 24, 'M'),
	(6, 'Luisa', 25, 'F')

SELECT * FROM Employees

-- Select all male employees, but use the column age to do this
SELECT * FROM Employees
WHERE age IN (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- ANY
SELECT * FROM Employees
WHERE age = ANY (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- > ANY 
SELECT * FROM Employees
WHERE age > ANY (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- < ANY
SELECT * FROM Employees
WHERE age < ANY (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- > ALL
SELECT * FROM Employees
WHERE age > ALL (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- < ALL
SELECT * FROM Employees
WHERE age < ALL (
	SELECT age FROM Employees
		WHERE gender = 'M')

-- EXIST 
-- Example: Return a table with all the products (Product ID and Product Name) that had any sales on 01/01/2007
SELECT * FROM DimProduct
SELECT TOP 10 * FROM FactSales

-- Using IN
SELECT 
	ProductKey,
	ProductName
FROM DimProduct
WHERE ProductKey IN 
	(SELECT ProductKey FROM FactSales
		WHERE DateKey = '01/01/2007')

-- Using EXIST
SELECT 
	ProductKey,
	ProductName
FROM DimProduct
WHERE EXISTS 
	(SELECT ProductKey FROM FactSales
		WHERE DateKey = '01/01/2007'
		AND FactSales.ProductKey = DimProduct.ProductKey) -- this is because we need just the products that sold, not all the products 

-- Return a table with all products (ProductKey and ProductName) and also the total sales for each product
SELECT 
	ProductKey,
	ProductName,
	(SELECT COUNT(*) FROM FactSales
	WHERE FactSales.ProductKey = DimProduct.ProductKey) as 'TotalSales'
FROM DimProduct
ORDER BY (SELECT COUNT(*) FROM FactSales
	WHERE FactSales.ProductKey = DimProduct.ProductKey) desc

-- Return the quantity of products from Contoso Brand
SELECT 
	COUNT(*) as 'Qty.Products' 
FROM DimProduct
WHERE BrandName = 'Contoso'

-- Using Subquery
SELECT 
	COUNT(*) as 'Qty.Products' 
FROM 
	(SELECT * FROM DimProduct
		WHERE BrandName = 'Contoso') as T -- as T is the name of the table create with the subquery

-- Nested Subquery 
-- Find the name of the customers who earn the second highest salary

SELECT 
	CASE
	WHEN MiddleName is not null THEN CONCAT(FirstName,' ',MiddleName,' ',LastName)
	ELSE CONCAT(FirstName,' ',LastName)
	END as 'FullName',
	YearlyIncome
FROM DimCustomer
WHERE YearlyIncome = 
	(SELECT MAX(YearlyIncome)
		FROM DimCustomer
		WHERE YearlyIncome < 
			(SELECT MAX(YearlyIncome) FROM DimCustomer
				WHERE CustomerType = 'Person'
	)) -- returning the maximum value that is less than the maximum value

-- Test with the third highest salary

	SELECT 
	CASE
	WHEN MiddleName is not null THEN CONCAT(FirstName,' ',MiddleName,' ',LastName)
	ELSE CONCAT(FirstName,' ',LastName)
	END as 'FullName',
	YearlyIncome
FROM DimCustomer
WHERE YearlyIncome = 
	(SELECT MAX(YearlyIncome)
		FROM DimCustomer
		WHERE YearlyIncome < 
			(SELECT MAX(YearlyIncome) FROM DimCustomer
				WHERE YearlyIncome <
				(SELECT MAX(YearlyIncome) FROM DimCustomer
					WHERE CustomerType = 'Person')
	))

-- CTEs
-- Create a CTE to store the result of a query with ProductKey, ProductName, BrandName, ColorName, and UnitPrice, for the Contoso brand only

WITH cte AS (
SELECT 
	ProductKey,
	ProductName,
	BrandName,
	ColorName,
	UnitPrice
FROM DimProduct
WHERE BrandName ='Contoso'
)

SELECT * FROM cte

-- Create a CTE that is the result of grouping total products by brand. Take an average of products by brand

WITH cte AS
	(SELECT
		BrandName,
		COUNT(*) as 'Qty_Products'
	FROM DimProduct
	GROUP BY BrandName)

SELECT AVG(Qty_Products) as 'AVG' FROM cte

-- Column Name

WITH cte (BrandName, QtyProducts) AS
	(SELECT
		BrandName,
		COUNT(*) 
	FROM DimProduct
	GROUP BY BrandName)

SELECT AVG(QtyProducts) as 'AVG' FROM cte

-- Multiple CTEs
-- 1. Create a CTE called contoso_products that should contain the columns ProductKey, ProductName, BrandName
-- 2. Create a CTE called sales_top100 that should be a top 100 of the most recent sales considering SalesKey, ProductKey, DataKey and SalesQuantity
-- 3. Make a INNER JOIN 

WITH contoso_products AS (
	SELECT 
		ProductKey,
		ProductName,
		BrandName
	FROM DimProduct
	WHERE BrandName = 'Contoso')
	,
	sales_top100 AS (
	SELECT TOP 100
		SalesKey,
		ProductKey,
		DateKey,
		SalesQuantity
	FROM FactSales
	ORDER BY DateKey desc)

SELECT *
FROM contoso_products
INNER JOIN sales_top100 ON contoso_products.ProductKey = sales_top100.ProductKey