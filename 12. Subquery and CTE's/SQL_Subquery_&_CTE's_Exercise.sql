-- Subquery and CTE's  Exercises 
-- Functions learned: SUBQUERY, ANY, SOME, ALL, EXISTS, SELECT, FROM, NESTED SUBQUERY, CTE, 
-- Database: ContosoRetailDW

/* 1. For tax purposes, the company's accounting department needs a table containing all the sales 
for the 'Contoso Orlando Store'. This is because this store is in a region where taxation has recently changed. 
Therefore, create a query to the Database to obtain a FactSales table containing all the 
sales for this store. */

SELECT *
FROM FactSales
WHERE StoreKey = 
	(SELECT StoreKey FROM DimStore
	 WHERE StoreName = 'Contoso Orlando Store')

/* 2. The product control department wants to do an analysis to find out which products 
that have a UnitPrice greater than the UnitPrice of the product with ID 1893. 
a) Your resulting query must contain the columns ProductKey, ProductName and UnitPrice columns from the DimProduct table. 
b) In this query you should also return an extra column, which tells you the UnitPrice of the product 1893.  */ 

SELECT 
	ProductKey,
	ProductName,
	UnitPrice,
	(SELECT UnitPrice FROM DimProduct
		WHERE ProductKey = 1893) AS 'ID1893UnitPrice'
FROM DimProduct
WHERE UnitPrice >
		(SELECT UnitPrice FROM DimProduct
		WHERE ProductKey = 1893)

/* 3. The Contoso company has created a bonus program called “All for 1”. This 
program consisted of the following: 1 employee would be chosen at the end of the year as the outstanding employee. 
but the bonus would be received by everyone in that particular employee's area.
The aim of this program was to encourage collective collaboration between the 
employees in the same area. In this way, the outstanding employee would benefit not only himself, 
but also to all the colleagues in their area. 
At the end of the year, the employee chosen as the highlight was Miguel Severino. This meant that 
all the employees in Miguel's area would benefit from the program. 
Your goal is to query the DimEmployee table and return all the employees in the “winning” area. 
from the “winning” area so that the Finance department can make the bonus payments. */ 

SELECT
	CASE
	WHEN MiddleName is not null THEN CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
	ELSE CONCAT(FirstName, ' ', LastName)
	END AS 'FullName',
	EmailAddress,
	Phone,
	DepartmentName
FROM DimEmployee
WHERE DepartmentName =
	(SELECT DepartmentName FROM DimEmployee
		WHERE FirstName = 'Miguel' AND LastName = 'Severino')

/* 4. Make a query that returns the customers who receive an above-average annual salary. Your 
query should return the CustomerKey, FirstName, LastName, EmailAddress and YearlyIncome columns. 
Note: only consider customers who are 'Individuals'. */

SELECT 
	CustomerKey,
	FirstName,
	LastName,
	EmailAddress,
	YearlyIncome
FROM DimCustomer 
WHERE YearlyIncome >
	(SELECT AVG(YearlyIncome) 
	FROM DimCustomer
	WHERE CustomerType = 'Person')
AND CustomerType = 'Person'
	 
/* 5. The Asian Holiday Promotion discount action was one of the company's most successful. 
Now, Contoso wants to understand a little more about the profile of the customers who bought products with this promotion. 
Their job is to create a query that returns a list of customers who bought products with this promotion. */

SELECT TOP 10 * FROM FactOnlineSales
SELECT * FROM DimCustomer
SELECT * FROM DimPromotion

SELECT *
FROM DimCustomer
WHERE CustomerKey IN 
	(SELECT CustomerKey FROM FactOnlineSales
	 WHERE PromotionKey IN
		(SELECT PromotionKey FROM DimPromotion
		 WHERE PromotionName = 'Asian Holiday Promotion'))

/* 6. The company has implemented a business customer loyalty program. All those 
who buy more than 3000 units of the same product will receive discounts on further purchases. 
You need to find out the CustomerKey and CompanyName of these customers. */

SELECT * FROM FactOnlineSales
SELECT * FROM DimCustomer
-- First step
SELECT
	CustomerKey,
	ProductKey,
	COUNT(*) as 'QtyProduct'
FROM FactOnlineSales
GROUP BY CustomerKey,ProductKey
HAVING COUNT(*) >3000

-- Secund step
SELECT 
	CustomerKey,
	CompanyName
FROM DimCustomer
WHERE CustomerKey IN
	(SELECT CustomerKey 
	FROM FactOnlineSales
	GROUP BY CustomerKey, ProductKey
	HAVING COUNT(*) > 3000)

/* 7. You need to create a query for the sales department that shows the following columns from the 
table DimProduct: 
ProductKey, 
ProductName, 
BrandName, 
UnitPrice 
Average of UnitPrice. */

SELECT
	ProductKey,
	ProductName,
	BrandName,
	UnitPrice,
	(SELECT ROUND(AVG(UnitPrice),2) FROM DimProduct) as 'AVGUnitPrice'
FROM DimProduct

/* 8. Run a query to find out the following indicators for your products: 
Highest number of products per brand 
Lowest number of products per brand 
Average number of products per brand */

SELECT MAX(QtyProduct) as 'Max',
	   MIN(QtyProduct) as 'Min',
	   AVG(QtyProduct) as 'AVG'
FROM (
SELECT
	BrandName,
	COUNT(*) as 'QtyProduct'
FROM DimProduct
GROUP BY BrandName) AS T -- When you use a subquery with from you need to give a name for the table 
	
/* 9. Create a CTE that is the grouping of the DimProduct table, storing the total of 
products by brand. Then perform a SELECT on this CTE, finding out what the 
products for a brand. Call this CTE CTE_QtyProductsByBrand. */

WITH CTE_QtyProductsByBrand AS
	(SELECT
		BrandName,
		COUNT(*) as 'QtyProduct'
	FROM DimProduct
	GROUP BY BrandName)

SELECT * FROM CTE_QtyProductsByBrand
ORDER BY QtyProduct DESC

/* 10. Create two CTEs:  
(i) the first should contain the columns ProductKey, ProductName, ProductSubcategoryKey, 
BrandName and UnitPrice columns from the DimProduct table, but only the products of the Adventure 
Works. Call this CTE CTE_ProductsAdventureWorks. 
(ii) the second must contain the columns ProductSubcategoryKey, ProductSubcategoryName, from the 
table, but only for the subcategories 'Televisions' and 'Monitors'. 
Call this CTE CTE_CategoryTelevisionsERadio. 
Do a Join between these two CTEs, and the result should be a query containing all the columns 
of the two tables. Note in this example the difference between LEFT JOIN and INNER JOIN. */

WITH CTE_ProductsAdventureWorks AS
	(SELECT 
		ProductKey,
		ProductSubcategoryKey,
		BrandName,
		UnitPrice
	FROM DimProduct
	WHERE BrandName = 'Adventure Works'),

CTE_CategoryTelevisionsERadio AS
	(SELECT
		ProductSubcategoryKey,
		ProductSubcategoryName
	 FROM DimProductSubcategory
	 WHERE ProductSubcategoryName IN ('Televisions', 'Monitors'))

SELECT *
FROM CTE_ProductsAdventureWorks
INNER JOIN CTE_CategoryTelevisionsERadio ON CTE_ProductsAdventureWorks.ProductSubcategoryKey = CTE_CategoryTelevisionsERadio.ProductSubcategoryKey