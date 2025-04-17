-- Pivot Table Module
-- Functions learned: 
-- Database: ContosoRetailDW

-- Create a Pivot Table

SELECT
	BrandName,
	COUNT(ProductKey) AS TotalProduct
FROM DimProduct
GROUP BY BrandName

-- 1. Select the data that will be used as the basis for creating the Pivot Table
SELECT 
	ProductKey,
	BrandName
FROM DimProduct

-- 2. Since we can't apply a Pivot directly to the data above, we need to do it indirectly

SELECT * FROM
(SELECT 
	ProductKey,
	BrandName
FROM DimProduct) AS Datas

-- 3. Now we can apply the Pivot Table including the desired calculation and the names of the columns to be taken into account.

SELECT * FROM
(SELECT 
	ProductKey,
	BrandName
FROM DimProduct) AS Datas
PIVOT(
	COUNT(ProductKey)
	FOR BrandName
	IN ( [Fabrikam]
		,[Adventure Works]
		,[Litware]
		,[Northwind Traders]
		,[Contoso]
		,[Tailspin Toys]
		,[Southridge Video]
		,[Wide World Importers]
		,[The Phone Company]
		,[A. Datum]
		,[Proseware]

	)
) AS PivotTable


-- To copy/paste the BrandName
SELECT 
	DISTINCT ',[' + TRIM(BrandName) + ']'
FROM DimProduct


-- ADDING ROW GROUPS TO THE PIVOT TABLE

SELECT
	DepartmentName,
	COUNT(EmployeeKey) AS 'TotalEmployees'
FROM DimEmployee
GROUP BY DepartmentName


SELECT * FROM 
(SELECT 
	DepartmentName,
	YEAR(HireDate) AS 'Year',
	EmployeeKey
FROM DimEmployee) AS EmployeesData
PIVOT(
	COUNT(EmployeeKey)
	FOR DepartmentName
	IN ( [Document Control]
		,[Engineering]
		,[Executive]
		,[Facilities and Maintenance]
		,[Finance]
		,['Human Resources Contral]
		,[Human Resources]
		,[Information Services]
		,[Marketing]
		,[Production Control]
		,[Production]
		,[Purchasing]
		,[Quality Assurance]
		,[Research and Development]
		,[Sales]
		,[Shipping and Receiving]
		,[Tool Design])

) AS PivotTableEmployees

-- For copy/paste DepartmentName
SELECT
	DISTINCT ',[' + TRIM(DepartmentName) + ']'
FROM DimEmployee

-- Or
SELECT DISTINCT
	',' + QUOTENAME(TRIM(DepartmentName))
FROM DimEmployee

-- SORT COLUMN IN PIVOT TABLE

SELECT * FROM 
(SELECT 
	DepartmentName,
	YEAR(HireDate) AS 'Year',
	EmployeeKey
FROM DimEmployee) AS EmployeesData
PIVOT(
	COUNT(EmployeeKey)
	FOR DepartmentName
	IN ( [Document Control]
		,[Engineering]
		,[Executive]
		,[Facilities and Maintenance]
		,[Finance]
		,['Human Resources Contral]
		,[Human Resources]
		,[Information Services]
		,[Marketing]
		,[Production Control]
		,[Production]
		,[Purchasing]
		,[Quality Assurance]
		,[Research and Development]
		,[Sales]
		,[Shipping and Receiving]
		,[Tool Design])

) AS PivotTableEmployees
ORDER BY Year DESC

-- SORT ALPHABETICALLY

SELECT DISTINCT
	',' + QUOTENAME(TRIM(DepartmentName))
FROM DimEmployee
ORDER BY ',' + QUOTENAME(TRIM(DepartmentName))

SELECT * FROM 
(SELECT 
	DepartmentName,
	YEAR(HireDate) AS 'Year',
	EmployeeKey
FROM DimEmployee) AS EmployeesData
PIVOT(
	COUNT(EmployeeKey)
	FOR DepartmentName
	IN ( [Document Control]
		,[Engineering]
		,[Executive]
		,[Facilities and Maintenance]
		,[Finance]
		,['Human Resources Contral]
		,[Human Resources]
		,[Information Services]
		,[Marketing]
		,[Production Control]
		,[Production]
		,[Purchasing]
		,[Quality Assurance]
		,[Research and Development]
		,[Sales]
		,[Shipping and Receiving]
		,[Tool Design])

) AS PivotTableEmployees
ORDER BY Year DESC

-- ADDING MORE GROUP ROWS TO PIVOT TABLE

SELECT * FROM 
(SELECT 
	DepartmentName,
	YEAR(HireDate) AS 'Year',
	DATENAME(MM,HireDate) AS 'Month',
	EmployeeKey
FROM DimEmployee) AS EmployeesData
PIVOT(
	COUNT(EmployeeKey)
	FOR DepartmentName
	IN ( [Document Control]
		,[Engineering]
		,[Executive]
		,[Facilities and Maintenance]
		,[Finance]
		,['Human Resources Contral]
		,[Human Resources]
		,[Information Services]
		,[Marketing]
		,[Production Control]
		,[Production]
		,[Purchasing]
		,[Quality Assurance]
		,[Research and Development]
		,[Sales]
		,[Shipping and Receiving]
		,[Tool Design])

) AS PivotTableEmployees
ORDER BY Year DESC, Month DESC

--  CORRECTING THE PIVOT TABLE LIMITATION

-- Declare variables as NVARCHAR(MAX) 
DECLARE @varColumnName NVARCHAR(MAX) = ''
DECLARE @SQL NVARCHAR(MAX) = ''

-- Recursively store the column names in the variable
SELECT @varColumnName += QUOTENAME(TRIM(DepartmentName)) + ','
FROM 
	(SELECT DISTINCT 
		DepartmentName 
	FROM DimEmployee) AS Auxiliary

-- Correct the comma at the end

SET @varColumnName = LEFT(@varColumnName, LEN(@varColumnName) -1)

-- PRINT @varColumnName

-- Add the entire Pivot Table command inside a variable, concatenating the values with the variable of the column names

SET @SQL = 
'SELECT * FROM 
(SELECT 
	DepartmentName,
	YEAR(HireDate) AS Year,
	DATENAME(MM,HireDate) AS Month,
	EmployeeKey
FROM DimEmployee) AS EmployeesData
PIVOT(
	COUNT(EmployeeKey)
	FOR DepartmentName
	IN (' + @varColumnName + ')

) AS PivotTableEmployees
ORDER BY Year DESC, Month DESC'

-- PRINT @SQL

-- Use sp_executesql 
EXECUTE sp_executesql @SQL