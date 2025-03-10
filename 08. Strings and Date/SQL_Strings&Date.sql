-- Manipulating Strings and Data Exercise 
-- Functions learned: LEN, DATALENGTH, CONCAT, LEFT, RIGHT, REPLACE, TRANSLATE, STUFF, UPPER, LOWER, FORMAT, CHARINDEX, SUBSTRING, TRIM, LTRIM, RTRIM, 
-- DAY, MONTH, YEAR, DATEFROMPARTS, GETDATE, SYSDATETIME, DATEPART, DATENAME, DATEADD, DATEIFF
-- Database: ContosoRetailDW

-- LEN DATALENGTH
-- Found the number of caracteres of 'SQL Hashtag'

select len('SQL Hashtag   ') as 'Len', -- does not count the spaces after the word
	   DATALENGTH('SQL Hashtag   ') as 'Datalength' -- count the extra spaces

-- CONCAT
select 
	CASE
	when MiddleName is not null then CONCAT(FirstName, ' ', MiddleName, ' ', LastName) 
	else CONCAT(FirstName,' ', LastName)
	end as 'FullName',
	EmailAddress
from DimCustomer

-- LEFT - extract characters from left to right 
-- RIGHT - extract from right to left

select * from DimProduct
select 
	productname,
	unitprice,
	LEFT(StyleName,7) as 'Product',
	RIGHT(StyleName,7) as 'Code'
from DimProduct

-- REPLACE
select REPLACE('The Excel is the best', 'Excel', 'SQL')

SELECT 
	FirstName,
	LastName,
	REPLACE(REPLACE(Gender, 'M', 'Masculino'), 'F', 'Feminino') as 'Gender'
from DimCustomer

-- TRANSLATE 
select TRANSLATE('10.241/444.124k23/1', './k','---')
select TRANSLATE('ABCD-490123','ABCD', 'WXYX')
select TRANSLATE(

-- STUFF - replace any text with a limited number of characters with another text

select STUFF('VBA Impressionador',1,3,'Excel')

-- UPPER / LOWER

select 
	UPPER(firstname) as 'NOME',
	LOWER(FirstName) as 'nome',
	EmailAddress
from DimCustomer

-- FORMAT
-- 1. Number format
-- 5123
-- Geral 
select FORMAT(5123,'G')

-- Number
select FORMAT(5123,'N')

-- Coin - get the computer language to give the coin
select FORMAT(5123, 'C')

-- Data 23/04/2020

-- date
select FORMAT(CAST('23/04/2020' as datetime), 'dd/MMM/yy', 'en-US')

-- day
select FORMAT(CAST('23/04/2020' as datetime), 'dd')

-- month
select FORMAT(CAST('23/04/2020' as datetime), 'MMMM')

-- year
select FORMAT(CAST('23/04/2020' as datetime), 'yyyy')

-- custom
-- 1234567 --> 12-34-567
select FORMAT(1234567,'##-##-###')

-- SUBSTRING -> extract a character from a text 
-- CHARINDEX -> find the position of a given character in the text

select 'Raquel Moreno' as 'Nome'

-- Find teh position of surname:
select CHARINDEX('M', 'Raquel Moreno')
select CHARINDEX('Moreno', 'Raquel Moreno')

-- Use SUBSTRING to extract the surname:
select SUBSTRING('Raquel Moreno',8,6) as 'sobrenome'

-- Combine SUBSTRING and CHARINDEX to extract any surname 

declare @varName varchar(100) = 'Tamires Gomes'

select SUBSTRING(@varName,(CHARINDEX(' ',@varName)+1), 100)

-- TRIM -> removes extra spaces from the left and right of the text
-- LTRIM -> removes extra spaces from the left of the text
-- RTRIM -> removes extra spaces from the right of the text


declare @varCode varchar(100) = '  ABC123   '
select 
	TRIM(@varCode) as 'TRIM',
	LTRIM(@varCode) as 'LTRIM',
	RTRIM(@varCode) as 'RTRIM'

select 
	DATALENGTH(TRIM(@varCode)) as 'TRIM',
	DATALENGTH(LTRIM(@varCode)) as 'LTRIM',
	DATALENGTH(RTRIM(@varCode)) as 'RTRIM'

-- Date
-- DAY / MONTH / YEAR -> 18/05/2020

declare @varDate datetime = '18/05/2020'
select 
	DAY(@vardate) as 'Day',
	MONTH(@vardate) as 'Month',
	YEAR(@varDate) as 'Year'

-- DATEFROMPARTS

declare @varDay int = 15, @varMonth int = 6, @varYear  int = 2017
select DATEFROMPARTS(@varYear,@varMonth,@varDay) as 'Date'


-- GETDATE -> returns the current system date/time
-- SYSDATETIME -> returns the current system date/time more precisely than GETDATE
-- DATENAME/DATEPART -> returns information (day, month, year, week, etc.) about a date

select GETDATE() as 'GetDate'
select SYSDATETIME() as 'Sysdatetime' -- mostra os milésimos de segundo

declare @varDate2 datetime = GETDATE()
select 
	DATENAME(DAY,@varDate2) as 'DateName',
	DATEPART(DAY,@varDate2) as 'DatePart'

select 
	SQL_VARIANT_PROPERTY(DATENAME(DAY,@varDate2), 'BaseType'),
	SQL_VARIANT_PROPERTY(DATEPART(DAY,@varDate2), 'BaseType')

-- DATEADD -> adds or subtracts a given number of days, months or years to a date
-- DATEDIFF -> calculates the difference between two dates

declare @varData3 datetime = '10/07/2020', @varData4 datetime = '05/03/2020', @varData5 datetime = '14/11/2021'

select 
	DATEADD(DAY,30,@varData3) as 'Plus30day',
	DATEADD(QUARTER,1,@varData3) as 'Plus1Quarter',
	DATEADD(MONTH,-1,@varData3) as 'Less1Month',
	DATEDIFF(DAY, @varData4, @varData5) as 'DaysBetweenDates'

