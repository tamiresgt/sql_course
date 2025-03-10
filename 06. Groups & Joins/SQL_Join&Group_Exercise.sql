-- Join plus Group module
-- Functions learned: LEFT JOIN, RIGTH JOIN, INNER JOIN, FULL JOIN, ANTI JOIN, CROSS JOIN, UNION, UNION ALL, GROUP BY, ORDER BY
-- Database: ContosoRetailDW


/* 1.	a) Make a summary of the quantity sold (Sales Quantity) according to the name of the sales channel (ChannelName). 
You must sort the final table according to SalesQuantity, in descending order.*/

select 
	DimChannel.ChannelName,
	SUM(FactSales.SalesQuantity) as 'TotalSales'
from FactSales
inner join DimChannel 
	on FactSales.channelKey = DimChannel.ChannelKey
group by DimChannel.ChannelName
order by SUM(FactSales.SalesQuantity) desc

/* b)	Make a grouping showing the total quantity sold (Sales Quantity) and total quantity returned (Return Quantity) according to the store name (StoreName). */

select
	DimStore.StoreName,
	SUM(SalesQuantity) as 'TotalSales',
	SUM(ReturnQuantity) as 'TotalReturn'
from FactSales
inner join DimStore 
	on FactSales.StoreKey = DimStore.StoreKey
group by DimStore.StoreName

/* c)	Make a summary of the total value sold (Sales Amount) for each month (CalendarMonthLabel) and year (CalendarYear). */

select
	DimDate.CalendarMonthLabel,
	DimDate.CalendarYear,
	round(SUM(SalesAmount),2) as 'TotalAmount'
from 
	FactSales
inner join DimDate
	on FactSales.DateKey = DimDate.Datekey
group by CalendarMonthLabel, CalendarYear, CalendarMonth
order by CalendarMonth 


/* 2.	You need to do a sales analysis by products. The ultimate goal is to find out the total value sold (SalesQuantity) per product.
a)	Find out which color of product is the most sold (according to SalesQuantity).
*/

select 
	DimProduct.ColorName,
	SUM(SalesQuantity) as 'TotalSales'
from 
	FactSales
inner join DimProduct
	on FactSales.ProductKey = DimProduct.ProductKey
group by ColorName
order by SUM(SalesQuantity) desc

/* b)	How many colors had a sold quantity above 3,000,000. */

select 
	DimProduct.ColorName,
	SUM(SalesQuantity) as 'TotalSales'
from FactSales
inner join DimProduct
	on FactSales.ProductKey = DimProduct.ProductKey
group by ColorName
having SUM(SalesQuantity) > 3000000
order by SUM(SalesQuantity) desc

/* 3.	Create a sold quantity grouping (SalesQuantity) by product category (ProductCategoryName). 
Note: You will need to do more than 1 INNER JOIN, since the relationship between FactSales and DimProductCategory is not direct.*/

select
	DimProductCategory.ProductCategoryName,
	SUM(SalesQuantity) as 'TotalSales'
from 
	FactSales
inner join DimProduct 
	on FactSales.ProductKey = DimProduct.ProductKey
		inner join DimProductSubcategory
			on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
				inner join DimProductCategory 
					on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
group by ProductCategoryName

	select top 100 * from FactSales
	select * from DimProductSubcategory
	select * from DimProduct
	select * from DimProductCategory

/* 4.	a) You should make a query to the FactOnlineSales table and find out which is the full name of the customer who made most online purchases (according to the SalesQuantity column). */

select 
	CASE
	when DimCustomer.MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ',LastName)
	else CONCAT(FirstName,' ',LastName)
	end as 'FullName',
	FactOnlineSales.CustomerKey,
	SUM(SalesQuantity) as 'TotalSales'
from FactOnlineSales
inner join DimCustomer
	on FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
where CustomerType = 'Person'
group by 
	FactOnlineSales.CustomerKey,
	CASE
	when DimCustomer.MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ',LastName)
	else CONCAT(FirstName,' ',LastName)
	end
having 
	CASE
	when DimCustomer.MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ',LastName)
	else CONCAT(FirstName,' ',LastName)
	end <> ' ' 
order by SUM(SalesQuantity) desc


/*b) After that, make a grouping of products and find out which were the top 10 products most bought by the customer from letter a, considering the name of the product. */

select top 10
	ProductName,
	SUM(SalesQuantity) as 'TotalSales'
from FactOnlineSales
left join DimProduct
	on FactOnlineSales.ProductKey = DimProduct.ProductKey
left join DimCustomer
	on FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
where FirstName = 'Robert' and MiddleName = 'C' and LastName = 'Long'
group by ProductName
order by SUM(SalesQuantity) desc

/* 5.	Make a summary showing the total of products purchased (Sales Quantity) according to the gender of customers. */

select 
	Gender,
	SUM(SalesQuantity) as 'TotalSales'
from FactOnlineSales
left join DimCustomer
	on FactOnlineSales.CustomerKey = DimCustomer.CustomerKey
GROUP BY Gender
having Gender is not null
 
/* 6.	Make a summary table showing the average exchange rate according to each CurrencyDescription. The final table should contain only rates between 10 and 100. */

select * from FactExchangeRate
select * from DimCurrency

select
	AVG(AverageRate) as 'AVGRate',
	DimCurrency.CurrencyDescription
from FactExchangeRate
left join DimCurrency
	on FactExchangeRate.CurrencyKey= DimCurrency.CurrencyKey
group by DimCurrency.CurrencyDescription
having AVG(AverageRate) between 10 and 100


/* 7.	Calculate the SUM TOTAL of AMOUNT referring to the table FactStrategyPlan intended for scenarios: Current and Budget.
Tip: The DimScenario table will be important for this exercise. */

select
	DimScenario.ScenarioName,
	SUM(Amount) as 'TotalAmount'
from FactStrategyPlan
left join DimScenario
	ON FactStrategyPlan.ScenarioKey = DimScenario.ScenarioKey
where ScenarioName IN ('Actual', 'Budget')
group by ScenarioName

/* 8. Make a summary table showing the result of strategic planning per year. */

select 
	DimDate.CalendarYear,
	round(SUM(Amount),2) as 'TotalAmount'
from FactStrategyPlan
left join DimDate
	on FactStrategyPlan.Datekey = DimDate.Datekey
group by CalendarYear
order by CalendarYear desc

select top 2 * from FactStrategyPlan

/* 9.	Make a grouping of quantity of products by ProductSubcategoryName. 
Take into account in your analysis only the brand Contoso and the color Silver. */

select
	DimProductSubcategory.ProductSubcategoryName,
	COUNT(ProductName) as 'Qtd.Product'
from DimProduct
left join DimProductSubcategory
	ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
where BrandName = 'Contoso' and ColorName = 'Silver'
group by ProductSubcategoryName
order by COUNT(ProductName) desc

/*10.	Make a double grouping of quantity of products by BrandName and ProductSubcategoryName.
The final table should be ordered according to the BrandName column. */

select 
	BrandName,
	ProductSubcategoryName,
	COUNT(ProductName) as 'QtdProduct'
from DimProduct
left join DimProductSubcategory
	on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
group by BrandName,ProductSubcategoryName
order by BrandName