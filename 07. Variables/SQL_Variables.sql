-- Variables module
-- Functions learned: DECLARE, CAST, FORMAT, ROUND, FLOOR, CEILING, DECLARE, SET, PRINT
-- Database: ContosoRetailDW

-- Basic Operations

select 10 as 'Number'
select 'Tamires' as 'Name'
select '21/06/2021' as 'Date'

-- Operations with numbers

select 10+20 as 'Sum'
select 20-5 as 'Subtraction'
select 31*40 as 'Multiplication'
select 431/23 as 'Split'
select 431.0/23 as 'Split'

-- Text operations
select 'Tamires' + ' '+ 'Gomes' as 'Name'

-- Date operations
select '20/06/2021' + 1

-- Define which data type
select 10 as 'Número'
select 49.50 as 'Decimal'
select 'Tamires' as 'Nome'
select '21/06/2021' as 'Data'

select SQL_VARIANT_PROPERTY (10, 'BaseType')
select SQL_VARIANT_PROPERTY (49.5, 'BaseType')
select SQL_VARIANT_PROPERTY ('Tamires', 'BaseType')
select SQL_VARIANT_PROPERTY ('21/06/2021', 'BaseType')

-- GPT Chat: to see the types of variables within a table use INFORMATION_SCHEMA.COLUMNSSELECT 
    COLUMN_NAME, 
    DATA_TYPE 
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'DimChannel';  -- Substitua 'DimChannel' pelo nome da sua tabela


-- CAST -> specifying a data type

select CAST(21.45 AS INT)
select CAST(21.45 as float)
select CAST(18.7 as float)
select CAST('15.6' as float)
select CAST('20/06/2021' as datetime)

select SQL_VARIANT_PROPERTY(cast(21.45 as int),'BaseType')

-- Create a query joining the text 'The price of the product' with the value 30.99

select 'O preço do produto'+' '+CAST(30.99 as varchar(50))

-- Add 1 to the date '20/06/2021'

select cast('20/06/2021' as datetime)+1

-- FORMAT
-- a) numeric
	select FORMAT(1000,'N') -- N equals number
	select FORMAT(1000,'G') -- G equals general
-- b)	custom
	select FORMAT(123456789, '###-##-###')
-- c) date
	select FORMAT(CAST('21/03/2021' as datetime), 'dd/MM/yyyy')
	select FORMAT(CAST('21/03/2021' as datetime),'dddd')

-- Show the mensage 'The product expiration date is:' with the data '17/abr/2022'

	select 'The product expiration date is: ' + format(cast('17/04/2022' as datetime), 'dd/MMM/yyyy')

-- ROUND, FLOOR E CEILING - Rounding functions

select 431.0/23

-- ROUND - rounds to the last decimal place
select ROUND(431.0/23,2)

-- ROUND (Truncate) - the third argument being any non-zero number does not round, just stops/truncates the number to the second place
select ROUND(431.0/23,2,1)

-- FLOOR - round down
select FLOOR(431.0/23)

-- CEILING - round up
select CEILING(431.0/23)

-- Declaring variables:
-- A variable is an object that stores a data value
-- Structure:
/*
DECLARE @VAR type
SET @VAR = value
select @VAR */

-- declare a variable called age and store the value 30
declare @age int
set @age = 30
select @age as 'Idade'

-- declare a variable called price and store the value 10.89
declare @price float
set @price = 10.89
select @price as 'Price'

-- declare a variable called name and store the value Tamires
declare @name varchar(30)
set @name = 'Tamires'
select @name as 'Name'

-- declare a variable called date and store the date of today
declare @date datetime
set @date = '27/02/2025'
select @date as 'Today'

-- DECLARE MORE THAN ONE VARIABLE

declare @var1 int
declare @texto varchar(30)
declare @data datetime

set @var1 =10
set @texto = 'Texto'
set @data = '10/02/2021'

select @var1 as 'Number', @texto as 'Texto', @data as 'date'

-- BETTER WAY

declare @var1 int,
		@texto varchar(30),
		@data datetime

set @var1 =15
set @texto = 'Texxxxto'
set @data = '10/03/2021'

select @var1 as 'Number', @texto as 'Texto', @data as 'date'

-- SO MUCH BETTER
declare @var1 int = 10 ,
		@texto varchar(30) = 'Texto',
		@data datetime = '10/03/2021'

select @var1 as 'Number', @texto as 'Texto', @data as 'date'

-- The store sells 100 t-shirts, which one costs 89.99. Show the revenue

declare @quantity int = 100,
		@unitprice float = 89.99
select @quantity*@unitprice as 'TotalRevenue'
