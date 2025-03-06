-- Exercise Order and Filters Module

/* 1. You are the manager of the purchasing area and need to create a report with the TOP 100 sales, according to the quantity sold. 
You need to do this in 10min because the purchasing director requested this information to present at a meeting. 
Use your knowledge in SQL to search these TOP 100 sales, according to the total sold (SalesAmount).  */

select top 100 *
from FactSales
order by SalesQuantity desc

/* 2. The TOP 10 products with higher UnitPrice have exactly the same price. However, the company wants to differentiate these prices according to the weight (Weight) of each. 
What you will need to do is sort these top 10 products according to the UnitPrice column and, in addition, establish a tie-break criterion so that it is shown in order, from highest to lowest. 
If there is still a tie between 2 or more products, think of a way to create a second tiebreaker (in addition to weight). */

select top 10
	ProductName,
	UnitPrice,
	[Weight],
convert(varchar(10),AvailableForSaleDate,103) as 'AvailableForSalaDate'
from DimProduct
order by 
	UnitPrice desc, 
	[Weight] desc, 
	convert(varchar(10),AvailableForSaleDate,103) asc


/* 3. You are responsible for the logistics sector of the company Contoso and need to size the transport of all products in categories, according to weight. 
Products of category A, weighing more than 100kg, must be transported in the first batch. 

Make a query in the database to find out what these products are in category A. 
a) You should return only 2 columns in this query: Product Name and Weight. 
b) Rename these columns with more intuitive names. 
c) Order these products from the heaviest to the lightest. */

select 
	ProductName as 'Product',
	[Weight]
from DimProduct
where Manufacturer = 'Contoso, Ltd' and Weight>100
order by Weight desc

/* 4. 4. You have been assigned to create a report of the stores currently registered with Contoso.  
a) Find out how many stores the company has in total. In the query you must make to the table 
DimStore, return the following information: StoreName, OpenDate, EmployeeCount 
b) Rename the previous columns to make your query more intuitive. 
c) From these stores, find out how many (and which) stores are still active.   */

-- How many contoso's store have? 299
-- How many contoso's storehas status on? 287

select 
	StoreName,
	OpenDate,
	EmployeeCount,
	[Status]
from DimStore
where StoreType like 'Store' and [Status]='On'

-- select * from DimStore

/* 5. The manager of the quality control area has notified Contoso that all Home Theater products of the Litware brand, made available for sale on March 15, 2009, have been identified with factory defects.  
What you should do is identify the ID’s of these products and pass it to the manager so that he can notify the stores and consequently request the suspension of sales of these products. */

select * from DimProduct
where 
	BrandName='Litware' 
	and ProductName like '%Home Theater%' 
	and CONVERT(varchar(10),AvailableForSaleDate,103) = '15/03/2009'

/* 6. Imagine you need to extract a report from the DimStore table, with store information. But you only need the stores that are no longer working currently.  
a) Use the Status column to filter the table and bring only the stores that are no longer working. 
b) Now imagine that this Status column does not exist in your table. What would be the other way 
that you would have to find out which stores are no longer working? */

select * from DimStore
where Status = 'Off'

select * from DimStore
where CloseDate is not null

/*  7. According to the number of employees, each store will receive a certain amount of coffee machines. The stores will be divided into 3 categories: 
CATEGORY 1: From 1 to 20 employees -> 1 coffee machine 
CATEGORY 2: From 21 to 50 employees -> 2 coffee machines 
CATEGORY 3: Above 51 employees -> 3 coffee machines 
Identify, for each case, which are the stores of each of the 3 categories above (just make a check). */

-- 1 to 20 employess -> 1 coffee machine -> 75 stores
select * from DimStore
where EmployeeCount between 1 and 20

-- 21 to 50 employess -> 2 coffee machine -> 187 stores
select * from DimStore
where EmployeeCount between 21 and 50

-- more than 50 employess -> 3 coffee machine -> 43 stores
select * from DimStore
where EmployeeCount > 50

/* 8. The company has decided that all LCD televisions will receive a super discount next month. 
Your job is to query the DimProduct table and return the ID’s, Names and Prices of all existing LCD products. */

select 
	ProductKey,
	ProductName,
	UnitPrice,
	ProductDescription
from DimProduct
where 
	ProductDescription like '%LCD%' 
	and ProductName like '%TV%'

-- select * from DimProduct

/* 9. Make a list with all products of the colors: Green, Orange, Black, Silver and Pink. These products must be exclusively from the brands: Contoso, Litware and Fabrikam.  */

select * from DimProduct
where 
	ColorName in ('Green', 'Orange', 'Black', 'Silver', 'Pink') 
	and BrandName in ('Contoso', 'Litware', 'Fabrikam')

/*  10. The company has 16 products of the brand Contoso, the color Silver and with a UnitPrice between 10 and 30. 
Find out what these products are and sort the result in descending order according to the price (UnitPrice). */

select
	ProductKey,
	ProductName,
	BrandName,
	ColorName,
	UnitPrice
from DimProduct
where 
	BrandName='Contoso' 
	and ColorName='Silver' 
	and UnitPrice between 10 and 30
order by UnitPrice desc