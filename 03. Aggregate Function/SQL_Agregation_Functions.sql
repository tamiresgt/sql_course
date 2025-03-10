-- Agregation Functions module
-- Functions learned: SUM, COUNT, DISTINCT COUNT, MIN, MAX, AVG
-- Database: ContosoRetailDW

--- SUM 
select 
	SUM(SalesQuantity) as 'TotalSalesQuantity',
	sum(returnquantity) as 'TotalReturnQuantity'
from FactSales

select top 100
	ProductKey,
	SUM(SalesQuantity) as 'TotalSalesQuantity',
	sum(ReturnQuantity) as 'TotalReturnQuantity'
from FactSales
Group by ProductKey

-- COUNT
select 
	COUNT(*) as 'TotalProducts'
from DimProduct

-- DISTINCT COUNT
select
	COUNT(DISTINCT(ProductKey)) as 'TotalDistinct'
from DimProduct

select 
	COUNT(DISTINCT(ColorName)) as 'TotalColorName'
from DimProduct

-- MIN and MAX
select
	MAX(UnitPrice) as 'MaxPrice',
	MIN(UnitPrice) as 'MinPrice'
from DimProduct

select
	MAX(UnitCost) as 'MaxPrice',
	MIN(UnitCost) as 'MinPrice'
from DimProduct

-- AVG
select 
	AVG(YearlyIncome) as 'AVGYearIncome'
from DimCustomer
