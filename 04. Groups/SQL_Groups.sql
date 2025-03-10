-- Group Functions
-- Functions learned: GROUP BY, ORDER BY, WHERE, HAVING
-- Database: ContosoRetailDW

-- Group by
select 
	BrandName,
	COUNT(*) as 'CountProduct'
from DimProduct
group by BrandName

-- 2. Number of Employees by StoreType
select
	StoreType,
	SUM(EmployeeCount) as 'TotalEmployee'
from DimStore
group by StoreType

-- 3. AVG of UnitCost by brand
select 
	BrandName,
	ROUND(AVG(UnitCost),2) as 'AVGPrice'
from DimProduct
group by BrandName
order by ROUND(AVG(UnitCost),2) desc

-- 4. Wich is the max unit price by class
select 
	ClassName,
	MAX(UnitPrice) as 'MAXUnitPrice'
from DimProduct
group by ClassName

-- 5. Group by story type and show the number of employee
select 
	StoreType,
	SUM(EmployeeCount) as 'TotalEmployee'
from DimStore
group by StoreType
order by SUM(EmployeeCount) desc

-- 6. Group by color and found the quantity of products
select 
	ColorName,
	BrandName,
	COUNT(*) as 'Qtd.Product'
from DimProduct
where BrandName = 'Contoso'
group by ColorName, BrandName
order by COUNT(*) desc


-- HAVING with GROUP BY
select 
	BrandName,
	COUNT(*) as 'TotalProduct'
from DimProduct
group by BrandName
having COUNT(*) >=200
order by COUNT(*) desc

-- HAVING vs WHERE
select 
	BrandName,
	COUNT(BrandName) as 'TotalBrand'
from DimProduct
where ClassName = 'Economy' -- Filter the original table, before grouping
group by BrandName
having COUNT(BrandName) >= 200 -- Filter the table after grouping
