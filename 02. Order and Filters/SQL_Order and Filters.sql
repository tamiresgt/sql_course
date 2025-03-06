-- Order and Filters module
-- Functions learned: GROUP BY, WHERE, ORDER BY, AND, OR, NOT, LIKE, BETWEEN, NOT BETWEEN, IS NULL, IS NOT NULL
-- Database: ContosoRetailDW

--Found the highest unit price with order by and select top
 select top(1) UnitPrice from DimProduct
order by UnitPrice desc

-- Show only the Manufacturer name
select Manufacturer from DimProduct
GROUP BY Manufacturer

select distinct(Manufacturer) from DimProduct

-- How many products has the price over $1000? 
select 
	ProductName,
	UnitPrice
from DimProduct
where UnitPrice>2000
order by UnitPrice desc


--  Show just the brands name
select 
	DISTINCT(BrandName)
from DimProduct

-- Show info about the brand Fabrikam and ColorName Black
select * from DimProduct
where BrandName = 'Fabrikam' and ColorName = 'Black'

-- How many custumers born after 31/12/1970
select * from DimCustomer
where BirthDate >= '1970-12-31'
order by BirthDate desc

-- Show all results that the ColorName are not Blue
select * from DimProduct
where NOT ColorName = 'Blue'

-- Show all results that brand is Contoso or Color White
select * from DimProduct
where BrandName= 'Contoso' or ColorName= 'White'

-- Select all employee where Departament is not Marketing
select * from DimEmployee
where not DepartmentName = 'Marketing'

-- Select all woman and Financy Employees
select * from DimEmployee
where Gender='F' and DepartmentName='Finance'

-- Select Brand products Contoso, Red and Unit Price >= 100
select * from DimProduct
where BrandName='Contoso' and ColorName='Red' and UnitPrice>=100

-- Select Brand Litware or Fabrikan or color Black
select * from DimProduct
where BrandName='Litware' or BrandName='Fabrikam' or ColorName='Black'

-- Select Europe but the country is not Italy
select * from DimSalesTerritory
where SalesTerritoryGroup='Europe' and not SalesTerritoryCountry = 'Italy'

-- Select color Black or Red but the Brand is just Fabrikam
select * from DimProduct
where BrandName='Fabrikam' and (ColorName='Black' or ColorName='Red')

-- Select all Blue, Whithe, Red, Black without use OR 
select * from DimProduct
where ColorName IN ('Silver', 'Blue', 'White', 'Red', 'Black')

-- Select the Employee using IN
select * from DimEmployee
where DepartmentName in ('Production', 'Marketing', 'Tool Design')

-- LIKE
select * from DimProduct
where ProductName like '%MP3 Player%'

select * from DimProduct
where ProductDescription like 'Type%'

-- BETWEEN
select * from DimProduct
where UnitPrice between 50 and 100

-- NOT BETWEEN
select * from DimProduct
where UnitPrice not between 50 and 100

-- BETWEEN with data
select * from DimEmployee
where HireDate between '2000-01-01'and '2000-12-31'

-- is not null: use to found the B2B customers 
select * from DimCustomer
where CompanyName is not null 

-- is null: use to found the B2C customers 
select * from DimCustomer
where CompanyName is null 

