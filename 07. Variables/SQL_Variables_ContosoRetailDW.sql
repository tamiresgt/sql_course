-- Variables module
-- Functions learned: DECLARE, CAST, FORMAT, ROUND, FLOOR, CEILING, DECLARE, SET, PRINT
-- Database: ContosoRetailDW

-- Variables in ContosoRetailDW
-- 1. Apply 10% of discount in all the products price. Show ProductKey, ProductName, UnitiPrice and DiscountPrice

declare @discount float = 0.1
select 
	ProductKey,
	ProductName,
	UnitPrice,
	ROUND(UnitPrice*(1-@discount),2) as 'DiscountPrice'
from DimProduct

-- 2. Optimize the follow code:

declare @vardate datetime = '01/01/1980'
select
	FirstName,
	LastName,
	BirthDate,
	'Client' as 'Custumer'
from 
	DimCustomer
where BirthDate >= @vardate

UNION

select
	FirstName,
	LastName,
	BirthDate,
	'Funcionário' as 'Employee'
from 
	DimEmployee
where BirthDate >= @vardate
order by BirthDate

-- How to store the result of a select inside a variable

--1. Create a variable to store the total quantity of employees

declare @totalemployee int = (select COUNT(*) from DimEmployee)
select @totalemployee as 'TotalEmployee'

--2. Create a variable to store the quantity of Off Stories
declare @offstore1 int = 
		(select COUNT(*) from DimStore
			where Status = 'Off')
select @offstore1 as 'OffStores'

-- PRINT 
-- Print the quantity of On Stores and the Off Stores 

set nocount on -- the message about affected lines no longer appears in the message tab
declare @onstore int = (select COUNT(*) from DimStore where Status = 'On'),
		@offstore int = (select COUNT(*) from DimStore where Status = 'Off')

select @onstore as 'onstore', @offstore as 'offstore'

print 'The total of On Store is ' + CAST(@onstore as varchar(30))
print 'The total of Off Store is ' + CAST(@offstore as varchar(30))


-- STORE VALUE FROM A TABLE WITHIN A VARIABLE
select top 100 * from FactSales

--1. Which product name has the biggest sales in a single sale from FactSales

declare @MaxSalesQuantity int,
		@BestSellingProductKey int

select top 1
	@BestSellingProductKey = ProductKey,
	@MaxSalesQuantity = SalesQuantity
from FactSales
order by SalesQuantity desc

print @MaxSalesQuantity
print @BestSellingProductKey

select 
	ProductKey,
	ProductName
from
	DimProduct
where ProductKey = @BestSellingProductKey

-- ACCUMULATE VALUES WITHIN A VARIABLE
-- Print the list with the name of employees in Marketing Department

select * from DimEmployee
WHERE

select 
	CASE
	when MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ', LastName)
	else CONCAT(FirstName,' ', LastName)
	end as 'FullName',
	DepartmentName
from DimEmployee
where DepartmentName = 'Marketing' and Gender = 'F'

declare @varListNames varchar(50)
set @varListNames = ' '

select @varListNames = @varListNames +FirstName + ', ' + CHAR(10)
from DimEmployee
where DepartmentName = 'Marketing' and Gender='F'

print left(@varListNames, datalength(@varListNames)-3)

-- trying with full name

declare @varListFullName varchar(100)
set @varListFullName = ' '

select @varListFullName = @varListFullName + (
		CASE
		when MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ', LastName)
		else CONCAT(FirstName,' ', LastName)
		end)
		+ ', ' + CHAR (10)
from DimEmployee
where DepartmentName = 'Marketing' and Gender = 'F'
print left(@varListFullName, datalength(@varListFullName)-3)


-- global variables use @@
-- to discover the server name
select @@SERVERNAME
-- to discover the version
select @@VERSION
-- row count
select * from DimProduct 
select @@ROWCOUNT
