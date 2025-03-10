-- Group Functions Exercise
-- Functions learned: GROUP BY, ORDER BY, WHERE, HAVING
-- Database: ContosoRetailDW


/* 1.	a) Make a summary of the quantity sold (SalesQuantity) according to the sales channel (channelkey). */

select 
	dimchannel.ChannelName,
	sum(factsales.salesquantity) as 'SalesQuantity'
from FactSales
left join DimChannel on factsales.channelkey = dimchannel.channelkey
group by DimChannel.ChannelName


/* b)	Make a grouping showing the total quantity sold (SalesQuantity  ) and total quantity returned (Return Quantity) according to the store ID (StoreKey). */
select
	FactSales.StoreKey,
	DimStore.StoreName,
	sum(FactSales.SalesQuantity) as 'TotalSalesQtd',
	sum(FactSales.ReturnQuantity) as 'TotalReturn'
from FactSales
left join DimStore on FactSales.StoreKey = DimStore.StoreKey
group by FactSales.StoreKey, DimStore.StoreName

-- select * from DimStore

/* c)	Make a summary of the total value sold (SalesAmount) for each sales channel, but only for the year 2007. */

select
	DimChannel.ChannelName,
	round(sum(factSales.SalesAmount),2) as 'TotalSales'
from FactSales
left join DimChannel on FactSales.channelKey = DimChannel.ChannelKey
where FactSales.DateKey between '20070101' AND '20071231'
group by DimChannel.ChannelName


/* 2.	You need to do a sales analysis by products. The ultimate goal is to find out the total value sold (SalesAmount) per product (ProductKey).

a)	The final table should be ordered according to the quantity sold and, in addition, show only those products that had a final sales result greater than $5,000,000. */

select 
	DimProduct.ProductName,
	ROUND(sum(FactSales.SalesAmount),2) as 'TotalAmount'
from FactSales
left join DimProduct on FactSales.ProductKey = DimProduct.ProductKey
group by DimProduct.ProductName
having ROUND(sum(FactSales.SalesAmount),2) >= 5000000
order by ROUND(sum(FactSales.SalesAmount),2) desc


/* b)	Make an adaptation in the previous year and show the top 10 products with more sales. Disregard the $5,000,000 filter applied. */

select top 10
	DimProduct.ProductName,
	round(SUM(FactSales.SalesAmount),2) as 'TotalAmount'
from FactSales
left join DimProduct on FactSales.ProductKey = DimProduct.ProductKey
group by DimProduct.ProductName
order by round(SUM(FactSales.SalesAmount),2) desc

/* 3.	a) You must make a query to the FactOnlineSales table and find out which is the ID (CustomerKey) of the customer who made most online purchases (according to the SalesQuantity column). */

select
	CustomerKey,
	sum(SalesQuantity) as 'TotalQuantity'
from FactOnlineSales
group by CustomerKey
order by sum(SalesQuantity) desc

/* b)	After that, make a grouping of total sold (SalesQuantity) by product ID and find out which were the top 3 products most bought by the customer from letter a). */

select top 3
	ProductKey,
	CustomerKey,
	sum(SalesQuantity) as 'TotalQuantity'
from FactOnlineSales
where CustomerKey = 19037
group by ProductKey, CustomerKey
order by sum(SalesQuantity) desc


/* 4.	a) Make a grouping and find the total quantity of products by brand. */

select
	BrandName,
	COUNT(*) as 'QtdProduct'
from DimProduct
group by BrandName

/* b)	Determine the average unit price (UnitPrice) for each ClassName. */
select 
	ClassName,
	round(AVG(UnitPrice),2) as 'AVGUnitPrice'
from DimProduct
group by ClassName

/* c)	Make a color grouping and find out the total weight that each product color has. */
select
	ColorName,
	round(SUM(Weight),2) as 'Total Weight'
from DimProduct
group by ColorName
order by round(SUM(Weight),2) desc

/* 5.	You must find the total weight for each type of product (StockTypeName).

The final table should consider only the 'Contoso' mark and have its values sorted in descending order. */

select
	StockTypeName,
	ROUND(SUM(Weight),2) as 'TotalWeight'
from DimProduct
where BrandName = 'Contoso'
group by StockTypeName
order by ROUND(SUM(Weight),2) desc

/* 6.	Would you be able to confirm that all brands of products have available all 16 color options? */

select distinct ColorName from DimProduct

select
	BrandName,
	COUNT(DISTINCT(ColorName)) as 'NumberColor'
from DimProduct
group by BrandName
order by COUNT(DISTINCT(ColorName)) desc

/* 7.	Make a grouping to know the total number of customers according to sex and also the average salary according to sex.
Fix any "unexpected" result with your knowledge of SQL. */

select
	Gender,
	COUNT(CustomerKey) as 'TotalCustomer',
	round(AVG(YearlyIncome),2) as 'AVGYearlyIncome'
from DimCustomer
where Gender is not null
group by Gender


/* 8.	Make a grouping to find out the total amount of clients and the average salary according to your school level. 
Use the Education column of the DimCustomer table to make this grouping.*/

select
	Education,
	COUNT(CustomerKey) as 'TotalCustomer',
	round(AVG(YearlyIncome),2) as 'AVGYearlyIncome'
from DimCustomer
where Education is not null
group by Education

/* 9. Make a summary table showing the total number of employees according to the Department (DepartmentName).
Important: You should only consider active employees. */
select
	DepartmentName,
	count(EmployeeKey) as 'TotalEmployee'
from DimEmployee
where EndDate is null 
group by DepartmentName
order by count(EmployeeKey) desc

/* 10.	Make a summary table showing the total VacationHours for each position (Title). 
You should consider only women, from the departments of Production, Marketing, Engineering and Finance, to employees hired between the years 1999 and 2000. */ 
select
	Title,
	SUM(VacationHours) as 'TotalHoursVacation'
from DimEmployee
where 
	Gender = 'F' and 
	DepartmentName in ('Production', 'Marketing', 'Engineering', 'Finance') and
	HireDate between '1999-01-01' and '2000-12-31'
group by Title

SELECT * FROM DimEmployee