-- Window Functions  Exercise 
-- Functions learned: OVER, ROW NUMBER, RANK, DENSE RANK, NTILE, PARTITION BY, LAG, LEAD, MoM, FIRST VALUE, LAST VALUE
-- Database: ContosoRetailDW

/* To solve exercises 1 to 4, create a View called vwProdutosExercise, which contains the grouping of the columns BrandName, ColorName 
and the total quantity sold by brand/color and also the total revenue by brand/color. */

-- Look the databases 
SELECT TOP 1 * FROM FactSales
SELECT * FROM DimProduct

CREATE VIEW vwProductsExercise AS
SELECT
	BrandName,
	ColorName,
	SUM(SalesQuantity) as 'TotalQty',
	ROUND(SUM(SalesAmount),2) as 'TotalAmount'
FROM DimProduct
INNER JOIN FactSales ON DimProduct.ProductKey = FactSales.ProductKey
GROUP BY BrandName, ColorName

SELECT * FROM vwProductsExercise
ORDER BY BrandName

-- 1. Use the vwProducts View to create an extra column calculating the total quantity of products sold.
SELECT 
	BrandName,
	ColorName,
	TotalQty,
	TotalAmount,
	SUM(TotalQty) OVER() as 'FullTotal'
FROM vwProductsExercise
ORDER BY BrandName

-- 2. Create another column in the previous query, including the total number of products sold for each brand.
SELECT 
	BrandName,
	ColorName,
	TotalQty,
	TotalAmount,
	SUM(TotalQty) OVER() as 'FullTotal',
	SUM(TotalQty) OVER(PARTITION BY BrandName) as 'TotalBrand'
FROM vwProductsExercise

-- 3. Calculate the % share of total product sales by brand.
SELECT 
	BrandName,
	ColorName,
	TotalQty,
	TotalAmount,
	SUM(TotalQty) OVER() as 'FullTotal',
	SUM(TotalQty) OVER(PARTITION BY BrandName) as 'TotalBrand',
	FORMAT(1.0*SUM(TotalQty) OVER(PARTITION BY BrandName)/SUM(TotalQty) OVER(), '0.00%') AS 'MktShareBrand'
FROM vwProductsExercise


/* 4. Create a query to View vwProductsExercise, selecting the columns Brand, Color, 
Sold_Quantity columns and also creating an extra Rank column to find out the position of 
each Brand/Color. You should get the result below. Note: Your query must be filtered so that 
that only the Contoso brand is shown. */

SELECT
	BrandName,
	ColorName,
	TotalQty,
	RANK() OVER(ORDER BY TotalQty DESC) as 'Rank'
FROM vwProductsExercise
WHERE BrandName = 'Contoso'

/* Exercise Challenge 1. 
To answer the next 2 exercises, you will need to create an auxiliary View. Unlike 
you won't have access to this view's code before the template. 
Your view should be called vwHistoricoLojas and should contain a history of the number of 
stores open each year/month. The challenges are: 
(1) Create an ID column for this View 
(2) Relate the DimDate and DimStore tables 
Tips: 
1- The ID column will be created from a window function. You should pay attention to  
how this column should be sorted, thinking that we want to visualize an order of 
Year/Month: 2005/january, 2005/February... and not 2005/April, 2005/August... 
2- The columns Year, Month and Qty_Stores correspond, respectively, to the following columns: 
CalendarYear and CalendarMonthLabel from the DimDate table and a count from the OpenDate column 
column of the DimStore table. */

-- LOOKING THE TABLES
SELECT * FROM DimDate
SELECT * FROM DimStore

CREATE VIEW vwHistoricoLojas AS 
SELECT
	CalendarYear as 'Year',
	CalendarMonthLabel as 'Month',
	CONCAT(CAST(CalendarYear as VARCHAR(100)),'/', CalendarMonthLabel) as 'ID',
	COUNT(OpenDate) as 'QtyStores',
	ROW_NUMBER() OVER(ORDER BY CalendarMonth) as 'RowNumber'
FROM DimDate
LEFT JOIN DimStore ON DimDate.DateKey = DimStore.OpenDate 
GROUP BY CalendarYear, CalendarMonthLabel, CalendarMonth

SELECT
	[Year],
	ID,
	QtyStores
FROM vwHistoricoLojas
ORDER BY RowNumber 

/* 5. From the view created in the previous exercise, you will have to make a moving sum 
always considering the current month + 2 months back. */

SELECT
	[Year],
	ID,
	QtyStores,
	SUM(QtyStores) OVER(ORDER BY RowNumber ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as 'MovingSUM'
FROM vwHistoricoLojas
ORDER BY RowNumber 

-- 6. Use vwHistoricalStores to calculate the number of stores open each year/month. 

SELECT
	[Year],
	ID,
	QtyStores,
	SUM(QtyStores) OVER(ORDER BY RowNumber ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'MovingSUM'
FROM vwHistoricoLojas
ORDER BY RowNumber

/* Exercise Challenge 2 
In this challenge, you will have to create your own tables and views in order to solve exercises 7 and 8. 
The next exercises will involve analyzing new customers. To do this, you will need to create a new table and a new view. 
Below is a step-by-step guide to solving the problem in parts. */

-- STEP 1: Create a new database called Challenge and select this database. 
CREATE DATABASE Challenge 
USE Challenge


/* STEP 2: Create a table of dates between January 1st of the year with the purchase 
(DateFirstPurchase) and December 31st of the year with the most recent purchase.  
Note1: Call this table Calendar. 
Note 2: In principle, this table should only contain 1 column, called date and of type DATE. */

DECLARE @varYearFirstPurschase INT = YEAR((SELECT MIN(DateFirstPurchase) FROM ContosoRetailDW.dbo.DimCustomer))
DECLARE @varYearLastPurschace INT = YEAR((SELECT MAX(DateFirstPurchase) FROM ContosoRetailDW.dbo.DimCustomer))

DECLARE @varDateFirstPurschase DATETIME = DATEFROMPARTS(@varYearFirstPurschase, 1,1)
DECLARE	@varDateLastPurschase DATETIME = DATEFROMPARTS(@varYearLastPurschace, 12,31)

CREATE TABLE CalendarChallenge ([Date] DATETIME)
WHILE @varDateLastPurschase >= @varDateFirstPurschase
BEGIN
	INSERT INTO  CalendarChallenge(Date) VALUES (@varDateFirstPurschase)
	SET @varDateFirstPurschase = DATEADD(DAY,1,@varDateFirstPurschase)
END


SELECT * FROM CalendarChallenge

-- STEP 3: Create auxiliary columns in the Calendar table called: Year, Month, Day, YearMonth and NameMonths. All of them of type INT. 

ALTER TABLE CalendarChallenge 
ADD [Year] INT,
	[Month] INT,
	[Day] INT,
	YearMonth INT,
	NameMonths VARCHAR(50)

-- STEP 4: Add the values Year, Month, Day, YearMonth and NameMonth (name of the month in Portuguese) to the table. 
-- Tip: use the CASE statement to check the month and return the correct name.

UPDATE CalendarChallenge SET [Year] = YEAR(Date)
UPDATE CalendarChallenge SET [Month] = MONTH(Date)
UPDATE CalendarChallenge SET [Day] = DAY(Date)
UPDATE CalendarChallenge SET YearMonth = CONCAT(YEAR(Date),FORMAT(MONTH(Date),'00'))
UPDATE CalendarChallenge SET NameMonths = CASE
											WHEN MONTH(Date) = 1 THEN 'January'
											WHEN MONTH(Date) = 2 THEN 'February'
											WHEN MONTH(Date) = 3 THEN 'March'
											WHEN MONTH(Date) = 4 THEN 'April'
											WHEN MONTH(Date) = 5 THEN 'May'
											WHEN MONTH(Date) = 6 THEN 'June'
											WHEN MONTH(Date) = 7 THEN 'July'
											WHEN MONTH(Date) = 8 THEN 'August'
											WHEN MONTH(Date) = 9 THEN 'September'
											WHEN MONTH(Date) = 10 THEN 'October'
											WHEN MONTH(Date) = 11 THEN 'November'
											WHEN MONTH(Date) = 12 THEN 'December'
										  END
SELECT * FROM CalendarChallenge

-- STEP 5: Create View vwNewCustomers, which should have the columns shown below: ID, Ano, NomeMês, Novos_Clientes */

CREATE VIEW vwNewCustomers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY YearMonth) as 'ID',
	[Year],
	NameMonths,
	COUNT(DimCustomer.CustomerKey) as 'NewClients'
FROM CalendarChallenge
LEFT JOIN ContosoRetailDW.dbo.DimCustomer ON CalendarChallenge.Date = DimCustomer.DateFirstPurchase
GROUP BY Year, NameMonths, YearMonth

SELECT * FROM vwNewCustomers

-- 7.  a) Calculate the moving sum of new customers over the last 2 months.
SELECT
	ID,
	[Year],
	NameMonths,
	NewClients,
	SUM(NewClients) OVER(ORDER BY ID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS 'MovingSum'
FROM vwNewCustomers


-- b) Calculate the moving average of new customers over the last 2 months. 
SELECT
	ID,
	[Year],
	NameMonths,
	NewClients,
	AVG(NewClients) OVER(ORDER BY ID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as 'MovingAVG'
FROM vwNewCustomers

-- c) Calculate the cumulative number of new customers over time.

SELECT
	ID,
	[Year],
	NameMonths,
	NewClients,
	SUM(NewClients) OVER(ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'Cumulative'
FROM vwNewCustomers

-- d) Make an intra-year cumulative calculation, i.e. a cumulative that runs from January to December of each year, and do the cumulative calculation again the following year. 
SELECT
	ID,
	[Year],
	NameMonths,
	NewClients,
	SUM(NewClients) OVER(PARTITION BY Year ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'IntraYearCumulative'
FROM vwNewCustomers

-- 8. Calculate MoM and YoY to assess the percentage growth in new customers, between the current month and the previous month, and between the current month and the same month of the previous year.

SELECT
	ID,
	[YEAR],
	NameMonths,
	NewClients,
	FORMAT((1.0*NewClients/NULLIF(LAG(NewClients,1) OVER(ORDER BY ID),0))-1, '0.00%')AS 'MoM',
	FORMAT((1.0*NewClients/NULLIF(LAG(NewClients,12) OVER(ORDER BY ID),0))-1, '0.00%') AS 'YoY'
FROM vwNewCustomers



			