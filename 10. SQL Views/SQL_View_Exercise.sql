-- SQL Views Exercise 
-- Functions learned: CREATE VIEW, USE, ALTER VIEW, DROP VIEW
-- Database: ContosoRetailDW

/* 1. a) From the DimProduct table, create a View containing the information for 
ProductName, ColorName, UnitPrice and UnitCost from the DimProduct table. Call this view vwProducts. */

CREATE VIEW vwProducts AS
SELECT 
	ProductName,
	ColorName,
	UnitPrice,
	UnitCost
FROM DimProduct
GO

SELECT * FROM vwProducts

-- 1. b) From the DimEmployee table, create a View showing FirstName, BirthDate, DepartmentName. Call this view vwEmployees. 
GO
CREATE VIEW vwEmployees AS
SELECT
	FirstName,
	BirthDate,
	DepartmentName
FROM DimEmployee
GO

SELECT * FROM vwEmployees

-- 1. c) From the DimStore table, create a View showing StoreKey, StoreName and OpenDate. Call this View vwStores.
GO
CREATE VIEW vwStores AS
SELECT
	StoreKey,
	StoreName,
	OpenDate
FROM DimStore
GO

SELECT * FROM vwStores


/* 2. Create a View containing the information Full Name (FirstName + 
LastName), Gender (in full), E-mail and Annual Income (formatted in R$). 
Use the DimCustomer table. Call this view vwCustomers. */

GO
CREATE VIEW vwCustomers AS
SELECT
	CASE	
		WHEN MiddleName is not null THEN CONCAT(FirstName,' ', MiddleName,' ', LastName)
		ELSE  CONCAT(FirstName,' ', LastName)
	END AS 'FullName',
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Company'
	END AS 'Gender',
	EmailAddress,
	FORMAT(CAST(YearlyIncome AS money),'C', 'pt_BR') as 'YearlyIncomeReal'
FROM DimCustomer
GO

SELECT * FROM vwCustomers

-- 3. a) From the DimStore table, create a View that only considers active stores. Do a SELECT of all the columns. Call this view vwActiveStores. 
GO
CREATE VIEW vwActiveStores AS
SELECT *
FROM DimStore
WHERE CloseDate is null 
GO

SELECT * FROM vwActiveStores


/* 3. b) From the DimEmployee table, create a View of a table that considers only the 
employees in the Marketing area. SELECT the columns: FirstName, EmailAddress 
and DepartmentName. Call this vwEmployeesMkt. */

GO
CREATE VIEW vwEmployeesMkt AS
SELECT
	FirstName,
	EmailAddress,
	DepartmentName
FROM DimEmployee
WHERE DepartmentName = 'Marketing'
GO

SELECT * FROM vwEmployeesMkt

/* 3. c) Create a View of a table that only considers products from the Contoso and 
Litware brands. In addition, your View should only consider Silver-colored products. Do 
a SELECT of all the columns in the DimProduct table. Call this View 
vwContosoLitwareSilver. */

GO
CREATE VIEW vwContosoLitwareSilver AS
SELECT *
FROM DimProduct
WHERE BrandName IN ('Contoso', 'Litware') AND ColorName = 'Silver'
GO

SELECT * FROM vwContosoLitwareSilver

/* 4. Create a View that is the result of a grouping of the FactSales table. This 
grouping should consider the SalesQuantity (Total Quantity Sold) by Product Name. 
Name. Call this view vwTotalSoldProducts. 
NOTE: To do this, you will have to use a JOIN to link the FactSales and 
DimProduct. */

select top 10 * from FactSales

GO
ALTER VIEW vwTotalSoldProducts AS
SELECT
	ProductName,
	SUM(SalesQuantity) as 'TotalQuantitySold'
FROM DimProduct
INNER JOIN FactSales ON DimProduct.ProductKey = FactSales.ProductKey
GROUP BY ProductName
GO

select * from vwTotalSoldProducts

-- 5. Make the following changes to the tables in question 1. 
-- a. In the View created in letter a of question 1, add the BrandName column. 
GO
ALTER VIEW vwProducts AS
SELECT 
	ProductName,
	ColorName,
	UnitPrice,
	UnitCost,
	BrandName
FROM DimProduct
GO

SELECT * FROM vwProducts

-- b. In the View created in letter b of question 1, make a filter and consider only the female employees. 
GO
ALTER VIEW vwEmployees AS
SELECT
	FirstName,
	BirthDate,
	DepartmentName,
	Gender
FROM DimEmployee
WHERE Gender = 'F'
GO

SELECT * FROM vwEmployees

-- c. In the View created in letter c of question 1, make a change and filter only the active stores. 

GO
ALTER VIEW vwStores AS
SELECT
	StoreKey,
	StoreName,
	OpenDate,
	CloseDate
FROM DimStore
WHERE CloseDate is null 
GO

SELECT * FROM vwStores

-- 6. a) Create a View that is the result of a grouping of the DimProduct table. The expected result of the query should be the total number of products per brand. Call this View vw_6a. 
GO
CREATE VIEW vw_6a AS
SELECT 
	BrandName,
	COUNT(*) as 'Qty.Product'
FROM DimProduct
GROUP BY BrandName
GO

select * from vw_6a

-- b) Change the View created in the previous exercise, adding the total weight by brand. Warning: Your final View should then have 3 columns: Brand Name, Total Products and Total Weight. 

GO
ALTER VIEW vw_6a AS
SELECT 
	BrandName,
	COUNT(*) as 'Qty.Product',
	ROUND(SUM(Weight),2) as 'TotalWeight'
FROM DimProduct
GROUP BY BrandName
GO

select * from vw_6a

-- c) Delete View vw_6a. 

DROP VIEW vw_6a