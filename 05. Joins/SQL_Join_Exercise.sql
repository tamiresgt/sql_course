-- Join module Exercises
-- Functions learned: LEFT JOIN, RIGTH JOIN, INNER JOIN, FULL JOIN, ANTI JOIN, CROSS JOIN, UNION, UNION ALL
-- Database: ContosoRetailDW


/* 1. Use INNER JOIN to bring the names of subcategories of products from the DimProductSubcategory table into the DimProduct table. */

select 
	DimProduct.*,
	DimProductSubcategory.ProductSubcategoryName
from DimProduct
inner join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey



/* 2. Identify a common column between the DimProductSubcategory and DimProductCategory tables. 
Use this column to supplement information in the DimProductSubcategory table from the DimProductCategory. Utilize o LEFT JOIN. */

select 
	DimProductSubcategory.*,
	DimProductCategory.ProductCategoryName,
	DimProductCategory.ProductCategoryDescription,
	DimProductCategory.ProductCategoryLabel
from DimProductSubcategory
left join DimProductCategory on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

select * from DimProductCategory


/*  3.	For each store in the DimStore table, find out which Continent and Country Name are associated (according to DimGeography). 
Your final SELECT must contain only the following columns: StoreKey, StoreName, EmployeeCount, ContinentName, and RegionCountryName. 
Use LEFT JOIN in this exercise. */

select * from DimStore
select * from DimGeography

select 
	DimStore.StoreKey,
	DimStore.StoreName,
	DimStore.EmployeeCount,
	DimGeography.ContinentName,
	DimGeography.RegionCountryName
from DimStore
left join DimGeography on DimStore.GeographyKey = DimGeography.GeographyKey

/* 4.	Complements the DimProduct table with ProductCategoryDescription information. 
Use LEFT JOIN and return in your SELECT only the 5 columns that you consider most relevant. */

select 
	DimProduct.ProductName,
	DimProduct.BrandName,
	DimProduct.UnitCost,
	DimProduct.UnitPrice,
	DimProductCategory.ProductCategoryDescription
from DimProduct
left join DimProductSubcategory 
	on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		left join DimProductCategory 
			on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

select * from DimProductSubcategory

/* 5.	The FactStrategyPlan table summarizes the company’s strategic planning. Each line represents an amount for a particular AccountKey.
a)	Do a SELECT of the first 100 lines of FactStrategyPlan to recognize the table.  */

select top 100 * from FactStrategyPlan

/* b) Do an INNER JOIN to create a table containing the AccountName for each AccountKey of the FactStrategyPlan table. Your final SELECT must contain the following columns:
• StrategyPlanKey 
• DateKey 
• AccountName 
• Amount */

select
	FactStrategyPlan.StrategyPlanKey,
	FactStrategyPlan.Datekey,
	FactStrategyPlan.Amount,
	DimAccount.AccountName
from FactStrategyPlan
inner join DimAccount 
	on FactStrategyPlan.AccountKey = DimAccount.AccountKey


/* 6. Let’s continue analyzing the FactStrategyPlan table. In addition to the AccountKey column that identifies the account type, there is also another column called ScenarioKey.
This column has the numbering that identifies the type of scenario: Real, Budgeted and Forecast.
Do an INNER JOIN to create a table containing the ScenarioName for each ScenarioKey of the FactStrategyPlan table. Your final SELECT must contain the following columns:

• StrategyPlanKey 
• DateKey 
• ScenarioName  
• Amount */

select 
	FactStrategyPlan.StrategyPlanKey,
	FactStrategyPlan.Datekey,
	FactStrategyPlan.Amount,
	DimScenario.ScenarioName
from FactStrategyPlan
inner join DimScenario on FactStrategyPlan.ScenarioKey=DimScenario.ScenarioKey



/* 7.	Some subcategories do not have any product copy. Identify which subcategories are these. */

select * from DimProduct
select * from DimProductSubcategory

select 
	DimProductSubcategory.*,
	DimProduct.ProductName
from DimProductSubcategory
left join DimProduct on DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
where ProductName is null


/* 8. The table below shows the combination between Brand and Sales Channel, for the brands Contoso, Fabrikam and Litware. Create a SQL code to get the same result. */ 

select
	DISTINCT(DimProduct.BrandName) as 'BrandName',
	DimChannel.ChannelName
from DimProduct
cross join DimChannel 
where BrandName IN ('Contoso', 'Fabrikam', 'Litware')



/* 9.	In this exercise, you must relate the FactOnlineSales tables to DimPromotion. 
Identify the column that both tables have in common and use it to create this relationship.
Return a table containing the following columns:

• OnlineSalesKey 
• DateKey 
• PromotionName 
• SalesAmount 
Your query should only consider sales lines for discounted products (PromotionName <> 'No Discount'). 
In addition, you should sort this table according to the DateKey column, in ascending order. */

select top 10 * from FactOnlineSales
select * from DimPromotion

select top(1000)
	FactOnlineSales.OnlineSalesKey,
	FactOnlineSales.DateKey,
	DimPromotion.PromotionName,
	FactOnlineSales.SalesAmount
from FactOnlineSales
left join DimPromotion on FactOnlineSales.PromotionKey = DimPromotion.PromotionKey
where PromotionName <> 'No Discount'
order by DateKey asc

-- 8727716 lines

/* 10.	The table below is the result of a Join between the FactSales table and the tables: DimChannel, DimStore and DimProduct.
Recreate this query and sort in descending order according to SalesAmount.
*/

select top 10 * from FactSales
select * from DimChannel
select * from DimStore
select * from DimProduct

select top 10
	FactSales.SalesKey,
	DimChannel.ChannelName,
	DimStore.StoreName,
	DimProduct.ProductName,
	FactSales.SalesAmount
from FactSales
left join DimChannel 
	on FactSales.channelKey = DimChannel.ChannelKey
left join DimStore 
	on FactSales.StoreKey = DimStore.StoreKey
left join DimProduct 
	on FactSales.ProductKey = DimProduct.ProductKey
order by SalesAmount desc