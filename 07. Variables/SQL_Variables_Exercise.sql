-- Variables module exercises
-- Functions learned: DECLARE, CAST, FORMAT, ROUND, FLOOR, CEILING, DECLARE, SET, PRINT
-- Database: ContosoRetailDW

-- 1. 1.	Declare 4 integer variables. Assign the following values to them: 10,5,34,7

declare 
	@var1 int = 10,
	@var2 int = 5,
	@var3 int = 34,
	@var4 int = 7

-- a)	Create a new variable to store the result of the sum between valor1 and valor2. Call this sum variable.

declare @soma int = @var1 + @var2
print 'Sum = ' + cast(@soma as varchar(10))

--b)	Create a new variable to store the result of subtraction between valor3 and value 4. Call this variable subtracao.

declare @subtraction int = @var3 - @var4
print 'Subtraction = ' + cast(@subtraction as varchar(10))

-- c)	Create a new variable to store the result of multiplication between value 1 and value 4. Call this variable multiplication.

declare @multiplication int = @var1 * @var4
print 'Multiplication = ' + cast(@multiplication as varchar(10))

-- d)	Create a new variable to store the result of the division of valor3 by valor4. Call this variable divisao. Note: The result should be in decimal, not integer. 
-- e)	Round the result of d) to 2 decimal places.

declare @split float = ROUND(cast(@var3 as float)/cast(@var4 as float),2)
print 'Split = ' + cast(@split as varchar(10))

/* 2.	For each declaration of the variables below, attention to the type of data that should be specified.
a)	Declare a variable called 'product' and assign the value of 'Mobile'.
b)	Declare a variable called 'quantity' and assign the value of 12.
c)	Declare a variable called 'preco' and assign the value 9.99.
d)	Declare a variable called 'billing' and assign the result of the multiplication between 'quantity' and 'price'.
e)	Visualize the result of these 4 variables in a single query, through SELECT. */


declare 
	@Product varchar(30) = 'Celular',
	@Quantity int = 12,
	@Price float = 9.99,
	@Revenue float 
	
set @Revenue = ROUND(@Price * @Quantity,2)

select @Product as 'ProductName',
	   @Quantity as 'Quantity',
	   @Price as 'Price',
	   @Revenue as 'Revenue'

/* 3.	You are responsible for managing a database where external user data is received. In summary, these data are:
-	User name
-	Date of birth
-	Number of pets that user has

You will need to create an SQL code capable of joining the information provided by this user. 
To simulate this data, create 3 variables, called: name, data_nascimentoe num_pets. You should store the values 'André', '10/02/1998' and 2, respectively. */


declare @Name varchar(30) = 'André',
		@BirthDate datetime = '10/02/1998',
		@QuantityPets int = 2

select 'My name is ' + @Name + ', I was born in ' + FORMAT(@BirthDate, 'dd/MM/yyyy') + ' and I have ' + CAST(@QuantityPets as varchar(3)) + ' pets.'

-- 4. You are responsable for the quality control of the company's stores. They told that 2008 was a difficult year because this year the mainly store close.
-- Found the name of the stores that closed in 2008 and show the result as 'The stores that closed in 2008 was: 'name of store' using the print 

declare @StoreName varchar(100) = ' ',
		@CloseDate datetime = ' '

select
	@StoreName = @StoreName + StoreName + ', ',
	@CloseDate = CloseDate
from DimStore
where CloseDate between '01/01/2008' and '31/12/2008'
-- where FORMAT(CloseDate, 'yyyy') = 2008


print 'The stores that was closed in 2008 was: ' + left(@StoreName, datalength(@StoreName)-2)

-- 5. You need to creat a consult that show the list of products for the categorie 'Lamps' 

-- print left(@ProductName, datalength(@ProductName)-3) -- print has a limit of 400 characters so it cannot be used
select @ProductName as 'ProductName'

declare @varIDSubcategory int,
		@varSubcategoryName varchar(30)

set @varSubcategoryName = 'Lamps'
set @varIDSubcategory = (SELECT ProductSubcategoryKey from DimProductSubcategory where ProductSubcategoryName = @varSubcategoryName)

select * from DimProduct
where ProductSubcategoryKey = @varIDSubcategory

