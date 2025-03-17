-- Conditional Functions Module 
-- Functions learned: CASE WHEN..ELSE, CASE AND - OR, NESTED CASE, ADDITIVE CASE, IIF, ISNULL, 
-- Database: ContosoRetailDW

-- CASE WHEN ... ELSE 
-- Determine the student's situation. Average >= 6 -> Approved. Otherwise failed

declare @varScore float
set @varScore = 7 

SELECT
	CASE
		WHEN @varScore >= 6 THEN 'Approved'
		ELSE 'Failed'
	END as 'Situation'

-- The expiration date of a product is 03/10/2024. Perform a logical test to check whether the product has passed its expiration date or not.

DECLARE @varDate datetime = GETDATE(), @varExpirationDate datetime = '03/10/2022'

SELECT
	CASE
		WHEN @varExpirationDate > @varDate THEN 'Not passed'
		ELSE 'Passed'
	END as 'Check'
	
-- Select the CustomerKey, FirstName and Gender columns from the DimCustomer table and use CASE to create a fourth column with the information 'Male' or 'Female'.

SELECT 
	CustomerKey,
	FirstName,
	Gender,
	CASE
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Male'
	END as 'FullGender'
FROM DimCustomer

/* Example 1:

Create a code to check the student's grade and determine the status:
- Passed: grade greater than or equal to 6
- Final exam: grade between 4 and 6
- Fail: grade below 4 */

declare @varScore float
set @varScore = 6.5

SELECT
	CASE	
		WHEN @varScore >= 6 THEN 'Passed'
		WHEN @varScore BETWEEN 4 and 6 THEN 'Final Exam' 
		ELSE 'Fail'
	END as 'Result'
	   
-- Example 2: Classify the product according to its price:
-- Price >= 40000: Luxury
-- Price >= 10000 and Price < 40000: Economy
-- Price < 10000: Basic */ 

SELECT
	UnitPrice,
	CASE
		WHEN UnitPrice >= 40000 THEN 'Luxury'
		WHEN UnitPrice >= 10000 THEN 'Economy'
		ELSE 'Basic'
	END as 'Class'
FROM DimProduct

-- Example: Create a column to replace 'M' with 'Male' and 'F' with 'Female'. Check if you need to make any corrections.

SELECT 
	CustomerKey,
	FirstName,
	Gender,
	CASE
		WHEN Gender = 'F' THEN 'Female'
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Company'
	END as 'FullGender'
FROM DimCustomer


-- Query the DimProduct table and return the ProductName, BrandName, ColorName, UnitPrice columns and a discounted price column.

-- a) If the product is branded Contoso AND colored Red, the product will be discounted by 10%. Otherwise, there will be no discount.

-- b) If the product is branded Litware OR Fabrikam, it will receive a 5% discount. Otherwise, there will be no discount.

SELECT 
	ProductName,
	BrandName,
	ColorName,
	UnitPrice,
	CASE
		WHEN BrandName = 'Contoso' and ColorName = 'Red' THEN 0.1
		WHEN BrandName = 'Litware' or BrandName = 'Fabrikam' THEN 0.05
		ELSE 0
	END as 'Discount'	
FROM DimProduct

-- NESTED CASE
-- 4 Positions (Title):
-- Sales Group Manager
-- Sales Region Manager
-- Sales State Manager
-- Sales Store Manager

-- Salaried (SalariedFlag)?
-- SalariedFlag = 0: not salaried
-- SalariedFlag = 1: salaried

-- Situation: Bonus calculation
-- Sales Group Manager: If salaried, 20%; If not, 15%.
-- Sales Region Manager: 15%
-- Sales State Manager: 7%
-- Sales Store Manager: 2%

SELECT 
	Title,
	SalariedFlag,
	CASE
		WHEN Title = 'Sales Group Manager' THEN
		CASE
			WHEN SalariedFlag = 1 THEN 0.2
			ELSE 0.15
		END
		WHEN Title = 'Sales Region Manager' THEN 0.15
		WHEN Title = 'Sales State Manager' THEN 0.07
		WHEN Title = 'Sales Store Manager' THEN 0.02
		ELSE 0
	END as 'BonusCalculation'
FROM DimEmployee

-- ADDITIVE CASE
-- Products from the 'TV and Video' category will receive a 10% discount
-- If, in addition to being from the 'TV and Video' category, the product is from the 'Televisions' subcategory, you will receive an additional 5%. Total 15%

SELECT 
	ProductKey,
	ProductName,
	DimProductCategory.ProductCategoryName,
	DimProductSubcategory.ProductSubcategoryName,
	CASE
		WHEN ProductCategoryName = 'TV and Video' THEN 0.10
		ELSE 0
		END
   +CASE
		WHEN ProductSubcategoryName = 'Televisions' THEN 0.05
		ELSE 0
	END as 'Discount'
FROM DimProduct
INNER JOIN DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
	INNER JOIN DimProductCategory
		ON DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey

-- IIF
-- Example 1: What is the risk category of the project below, according to its score?
-- High Risk: Classicacao >= 5
-- Low Risk: Rating < 5

DECLARE @varClass int = 9

SELECT 
	IIF(
		@varClass>=5, 
		'High Risk',
		'Low Risk'
		) as 'CategoryRisk'

	
-- Example 2: Create a single 'Customer' column, containing the name of the customer, be it a person or a company. Also bring in the CustomerKey and CustomerType column.

SELECT 
	CustomerKey,
	CustomerType,
	IIF(CustomerType = 'Person', FirstName, CompanyName) as 'Customer'
FROM DimCustomer


-- Composite IIF
/* Example: There are 3 types of stock: High, Mid and Low. Make a SELECT containing the columns ProductKey, ProductName, StockTypeName and Name of the person responsible for the product, according to the stock type. 
The rule should be as follows:
John is responsible for High products
Maria is responsible for Mid products
Luis is responsible for Low products */

SELECT 
	ProductKey,
	ProductName,
	StockTypeName,
	IIF(StockTypeName = 'High', 'John', IIF(StockTypeName = 'Mid', 'Maria', 'Luis')) as 'Name'
FROM DimProduct


-- ISNULL 
-- Example: Make a query that replaces all the null values of CityName in the DimGeography table with the text 'Unknown location'.

SELECT 
	GeographyKey,
	ContinentName,
	CityName,
	ISNULL(CityName, 'Unknown location') as 'CityNameAdjusted'
FROM DimGeography
