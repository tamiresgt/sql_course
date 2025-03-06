-- Introduction module
-- Functions learned: SELECT, SELECT TOP, TOP PERCENT, DISTINCT
-- Database: ContosoRetailDW

-- Return the first 10 rows of the product table
select top 10 * from DimProduct

-- Return 10% first rows of the customers table
select top 10 percent * from DimCustomer

-- Return distinct values
select
	DISTINCT(ColorName)
from DimProduct

-- Retornar distinct values from Department
select
	DISTINCT(DepartmentName)
from DimEmployee

-- Select 3 columns of dimProduct
select 
	ProductName,
	BrandName as 'Brand',
	ColorName as 'Color'
from DimProduct

-- Exercise
-- Check if there are 2517 products > Answer: YES
select * from DimProduct

-- Check if there are 19.500 customer > Answer: NO
select * from DimCustomer

-- Create a new table for dimCustomer
select
	CustomerKey as 'Key',
	FirstName as 'Name',
	EmailAddress as 'Email',
	BirthDate as 'Birth'
from DimCustomer

-- Found the first 100 clients 
select TOP 100
	FirstName,
	EmailAddress,
	BirthDate
from DimCustomer

-- Found 20% of clients 
select TOP 20 percent
	FirstName,
	EmailAddress,
	BirthDate
from DimCustomer

