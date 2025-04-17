-- Functions Exercise 
-- Functions learned: CREATE FUNCTION, ALTER FUNCTION, DROP FUNCTION 
-- Database: ContosoRetailDW

/* 1. Create a function that calculates the time (in years) between two dates. This function must 
receive two arguments: start_date and end_date. If the end_date is not entered, the 
function should automatically take the system's current date. This function will be used 
to calculate each employee's home time. 
Note: the DATEDIFF function is not enough to solve this problem. */

SELECT * FROM DimEmployee

-- Without function
SELECT 
	FirstName,
	StartDate,
	EndDate,
	CASE
	WHEN EndDate IS NULL THEN DATEDIFF(YEAR,StartDate,GETDATE())
	ELSE DATEDIFF(YEAR,StartDate,EndDate) 
	END AS 'HomeTime'
FROM DimEmployee

-- With Function
CREATE OR ALTER FUNCTION fnEmployees_HomeTime (@StartDate AS DATE, @EndDate AS DATE)
RETURNS INT
AS
BEGIN
	RETURN 
	CASE
	WHEN @EndDate IS NULL THEN DATEDIFF(YEAR,@StartDate,GETDATE())
	ELSE DATEDIFF(YEAR,@StartDate,@EndDate) 
	END
END

SELECT 
	FirstName,
	StartDate,
	EndDate,
	dbo.fnEmployees_HomeTime(StartDate, EndDate) AS 'HomeTime'
FROM DimEmployee

-- Another way using IF
CREATE OR ALTER FUNCTION fnEmployeesHomeTime (@StartDate AS DATE, @EndDate AS DATE)
RETURNS INT
AS
BEGIN
	IF @EndDate IS NULL 
		SET @EndDate = GETDATE()
	RETURN DATEDIFF(YEAR, @StartDate, @EndDate)
END

SELECT 
	FirstName,
	StartDate,
	EndDate,
	dbo.fnEmployeesHomeTime(StartDate, EndDate) AS 'HomeTime'
FROM DimEmployee

/* 2. Create a function that calculates each employee's bonus (5% more than the BaseRate). 
But be careful! Not all employees should receive a bonus... */

SELECT * FROM DimEmployee

-- Without Function
SELECT 
	FirstName,
	BaseRate,
	CASE
	WHEN EndDate IS NULL THEN CAST(BaseRate*(0.05 + 1) AS VARCHAR(MAX))
	ELSE 'Employee dismissed'
	END AS 'Bonus'
FROM DimEmployee

-- With Function

CREATE OR ALTER FUNCTION fnBonus(@BaseRate FLOAT, @EndDate DATE)
RETURNS VARCHAR(MAX)
AS
BEGIN
	IF @EndDate IS NOT NULL 
		RETURN 'Employee dismissed'
	RETURN ROUND(CAST(@BaseRate*(0.05 + 1) AS VARCHAR(MAX)),2)
END

SELECT 
	FirstName,
	BaseRate,
	dbo.fnBonus(BaseRate, EndDate) AS 'Bonus'
FROM DimEmployee

/* 3. Create a function that returns a table. This function should take as a parameter the 
customer's gender as a parameter and return all customers who are of the gender entered in the function. 
Note that this function will be used particularly with the DimCustomer table. */

SELECT * FROM DimCustomer

CREATE OR ALTER FUNCTION fnCustomerbyGender (@Gender VARCHAR(MAX))
RETURNS TABLE 
AS 
RETURN (SELECT
			CustomerKey,
			FirstName,
			MiddleName,
			LastName,
			Gender
		FROM DimCustomer
		WHERE Gender = @Gender)

SELECT * FROM fnCustomerbyGender('F')

/* 4. Create a Function that returns a summary table with the total number of products by color. Your 
function should receive 1 argument, where you can specify which brand you want the summary. */

SELECT * FROM DimProduct

SELECT
	BrandName,
	ColorName,
	COUNT(*) AS 'QtyProduct'	
FROM DimProduct
GROUP BY BrandName, ColorName
ORDER BY BrandName

CREATE OR ALTER FUNCTION fnProductBrandbyColor (@BrandName VARCHAR(MAX))
RETURNS TABLE
AS
RETURN (SELECT
			BrandName,
			ColorName,
			COUNT(*) AS 'QtyProduct'	
		FROM DimProduct
		WHERE BrandName = @BrandName
		GROUP BY BrandName, ColorName)

SELECT * FROM fnProductBrandbyColor('Contoso')
ORDER BY QtyProduct DESC


