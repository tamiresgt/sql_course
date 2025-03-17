-- Conditional Functions Exercise 
-- Functions learned: CASE WHEN..ELSE, CASE AND - OR, NESTED CASE, ADDITIVE CASE, IIF, ISNULL, 
-- Database: ContosoRetailDW


/* The sales department has decided to apply a discount to products according to their class. The percentage applied should be: 
Economy -> 5% 
Regular -> 7% 
Deluxe -> 9% 
a) Make a query to the DimProduct table that returns the following columns: ProductKey, 
ProductName, and two other columns that should return the % Discount and UnitPrice with 
discount.    */

SELECT
	ProductKey,
	ProductName,
	ClassName,
	UnitPrice,
	CASE
		WHEN ClassName = 'Economy' THEN 0.05
		WHEN ClassName = 'Regular' THEN 0.07
		ELSE 0.09
	END as '%Discount',
	ROUND((UnitPrice*(1 - 
	CASE
		WHEN ClassName = 'Economy' THEN 0.05
		WHEN ClassName = 'Regular' THEN 0.07
		ELSE 0.09
	END)),2)	as 'UnitPricewithDiscount'
FROM DimProduct

select * from DimProduct

-- b) Adapt the code so that the discount % of 5%, 7% and 9% can be easily modified (hint: use variables).

DECLARE 
	@varEconomyDiscount float = 0.05,
	@varRegularDiscount float = 0.07,
	@varDeluxeDiscount float = 0.09

	SELECT
	ProductKey,
	ProductName,
	ClassName,
	UnitPrice,
	CASE
		WHEN ClassName = 'Economy' THEN @varEconomyDiscount
		WHEN ClassName = 'Regular' THEN @varRegularDiscount
		ELSE @varDeluxeDiscount
	END as '%Discount',
	ROUND((UnitPrice*(1 - 
	CASE
		WHEN ClassName = 'Economy' THEN @varEconomyDiscount
		WHEN ClassName = 'Regular' THEN @varRegularDiscount
		ELSE @varDeluxeDiscount
	END)),2)	as 'UnitPricewithDiscount'
FROM DimProduct



/*  You are responsible for controlling the company's products and must analyze the quantity of products per brand. 
The division of brands into categories should be as follows: 
CATEGORY A: More than 500 products  
CATEGORY B: Between 100 and 500 products  
CATEGORY C: Less than 100 products  
Query the DimProduct table and return a table with a grouping of Total of Products by Brand, in addition to the Category column, according to the rule above. */

SELECT
	BrandName,
	COUNT(ProductKey) as 'QtdProduct',
	CASE
		WHEN COUNT(ProductKey) >= 500 THEN 'Category A'
		WHEN COUNT(ProductKey) >= 100 THEN 'Category B'
		ELSE 'Category C'
	END	as 'Category'
FROM DimProduct
GROUP BY BrandName
ORDER BY COUNT(ProductKey) desc


/* It will be necessary to create a categorization of each of the company's stores, taking into account the number of 
employees. The logic to be followed will be as below: 
EmployeeCount >= 50; 'Above 50 employees' 
EmployeeCount >= 40; 'Between 40 and 50 employees' 
EmployeeCount >= 30; 'Between 30 and 40 employees' 
EmployeeCount >= 20; 'Between 20 and 30 employees' 
EmployeeCount >= 40; 'Between 10 and 20 employees' 
Otherwise: 'Below 10 employees' 
Make a query to the DimStore table that returns the following information: StoreName, 
EmployeeCount and the category column, following the rule above. */

SELECT 
	StoreName,
	EmployeeCount,
	CASE
		WHEN EmployeeCount >= 50 THEN 'Above 50 employees'
		WHEN EmployeeCount >= 40 THEN 'Between 40 and 50 employees'
		WHEN EmployeeCount >= 30 THEN 'Between 30 and 40 employees'
		WHEN EmployeeCount >= 20 THEN 'Between 20 and 30 employees'
		WHEN EmployeeCount >= 10 THEN 'Between 20 and 10 employees'
		ELSE 'Below 10 employees' 
	END	as 'Category'
FROM DimStore

/* . The logistics sector will have to carry out a cargo transport of the products in the Seattle warehouse to the Sunnyside warehouse.  
We don't have much information about the products in the warehouse. There are 100 copies of each Sub-Category. In other words, 100 laptops, 100 digital cameras, 100 
fans, and so on. The logistics manager has decided that the products will be transported by two different routes.
In addition, the division of the products on each of the routes will be done according to subcategories (i.e. that is, all the products in the same subcategory will be transported on the same route): 

Route 1: Sub-categories that have a total sum of less than 1000 kg must be transported by Route 1. 
Route 2: Sub-categories that have a total sum greater than or equal to 1000 kg must be transported by Route 2. 
You will need to query the DimProduct table and divide the subcategories by each route. A few tips:
- Tip 1: Your query should have a total of 3 columns: Subcategory Name, Total Weight and Route. 
- Tip 2: Since you don't know which products are in the warehouse, only that there are 100 copies of each subcategory, you will have to find out the average weight of each subcategory and 
multiply this average by 100, so that you find out roughly what the total weight of the products per subcategory.
- Tip 3: Your final answer should have a JOIN and a GROUP BY. */

-- Looking the bases
select * from DimProductCategory
select * from DimProductSubcategory
select * from DimProduct

-- Convertion to kg and answer 
	SELECT 
		ProductSubcategoryName,
		ROUND(AVG((Weight / (
		CASE 
		WHEN WeightUnitMeasureID = 'ounces' THEN 35.274
		WHEN WeightUnitMeasureID = 'pounds' THEN 2.205
		WHEN WeightUnitMeasureID = 'grams' THEN 1000
		ELSE 1
	END)*100)),2) as 'AVGWeightinKG',
		CASE
				WHEN 
					(AVG(ROUND( (Weight / (
				CASE 
				WHEN WeightUnitMeasureID = 'ounces' THEN 35.274
				WHEN WeightUnitMeasureID = 'pounds' THEN 2.205
				WHEN WeightUnitMeasureID = 'grams' THEN 1000
				ELSE 1
			END)*100),2))) < 1000 THEN 'Route 1'
		ELSE 'Route 2'
		END as 'Route'
	FROM DimProduct
	LEFT JOIN DimProductSubcategory ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
	WHERE Weight is not null 
	GROUP BY ProductSubcategoryName

/* The marketing sector has some ideas for actions to boost sales in 2021. One is to hold a prize draw among the company's customers.  This draw will be divided into categories: 
'Mother of the Year Draw': All women with children will take part in this category. 
'Father of the Year Draw': All fathers with children will take part in this category. 
'Prize Truck': All other customers (men and women without children) will take part in this category. women without children). 
Your role will be to query the DimCustomer table and return 3 columns: - FirstName AS 'Name' - Gender AS 'Sex' - TotalChildren AS 'Qty. Children' - EmailAdress AS 'E-mail' - Marketing Action: in this column you should divide customers according to categories 
'Mother of the Year Draw', 'Father of the Year Draw' and 'Prize Truck'. */

SELECT *
FROM DimCustomer

SELECT 
	FirstName as 'Name',
	Gender as 'Sex',
	TotalChildren as 'Qty.Children',
	EmailAddress as 'E-mail',
	CASE
		WHEN Gender = 'F' and TotalChildren > 0 THEN 'Mother of the Year Draw'
		WHEN Gender = 'M' and TotalChildren > 0 THEN 'Father of the Year Draw'
		ELSE 'Prize Truck'
	END	as 'Marketing Action'
FROM DimCustomer

 /* Find out which store has been in business the longest (in days). You will need to make this 
query in the DimStore table, and take the OpenDate column as a reference for this calculation. 
Attention: remember that there are stores that have been closed. */ 

SELECT * FROM DimStore

SELECT 
	StoreName,
	DATEDIFF(DAY,OpenDate,GETDATE()) as 'OpenDate' 
FROM DimStore
WHERE CloseDate is null 
ORDER BY DATEDIFF(DAY,GETDATE(),OpenDate)


-- Using CASE to consider closed stores

SELECT 
	StoreName,
	CASE	
		WHEN CloseDate is null THEN DATEDIFF(DAY,OpenDate,GETDATE())
		ELSE DATEDIFF(DAY,OpenDate,GETDATE())
	END AS 'DaysActive'
FROM DimStore
ORDER BY DATEDIFF(DAY,GETDATE(),OpenDate)