-- Manipulating Strings and Data  module
-- Functions learned: LEN, DATALENGTH, CONCAT, LEFT, RIGHT, REPLACE, TRANSLATE, STUFF, UPPER, LOWER, FORMAT, CHARINDEX, SUBSTRING, TRIM, LTRIM, RTRIM, 
-- DAY, MONTH, YEAR, DATEFROMPARTS, GETDATE, SYSDATETIME, DATEPART, DATENAME, DATEADD, DATEIFF
-- Database: ContosoRetailDW

/*  When  we  are  manipulating  tables,  it  is  important  to  think  about  how  the  data  will  be  presented  in  a  report.  Imagine  the  
names  of  the  products  in  the  DimProduct  table.  The  texts  are  quite  large  and  it  may  not  be  the  best  option  to  show  the  
full  names  of  the  products,  as  they  will  probably  not  fit  in  a  graph  and  the  visualization  will  be  poor
a) Your  manager  asks  you  to  list  all  the  products  so  that  a  chart  can  be  created  to  be  presented  at  the  daily  team  
meeting.  Query  the  DimProduct  table  that  returns  (1)  the  product  name  and  (2)  the  number  of  characters  each  
product  has,  and  sort  this  table  from  the  product  with  the  most  characters  to  the  least. */

select
	ProductName,
	LEN(ProductName) as 'NumberCaracters'
from DimProduct
order by LEN(ProductName) desc

-- b) What is the avarege of number caracteres? 40
select AVG(LEN(ProductName)) as 'AVGCaracteres'
from DimProduct

-- c)  Analyze  the  structure  of  the  product  names  and  see  if  it  would  be  possible  to  reduce  the  length  of  the  product  names.  

select 
	ProductName,
	REPLACE(REPLACE(ProductName, BrandName, ''),ColorName,'') as 'ReducedName',
	LEN(ProductName) as 'NumberCaracters',
	LEN(REPLACE(REPLACE(ProductName, BrandName, ''),ColorName,'')) as 'NewNumber'
from DimProduct
order by LEN(ProductName) desc

select * from DimProduct

-- d)  What  is  the  average  number  of  characters  in  this  new  scenario? The new AVG is 28

select AVG(LEN(REPLACE(REPLACE(ProductName, BrandName, ''),ColorName,''))) from DimProduct


/* 2. The  StyleName  column  of  the  DimProduct  table  has  some  codes  identified  by  distinct  numbers,  ranging  from  0  to  9,  as  
can  be  seen  in  the  example  below.  However,  the  control  sector  decided  to  change  the  StyleName  identification,  and  instead  of  using  numbers,  the  idea  now  is  
to  use  letters  to  replace  the  numbers,  as  shown  in  the  example  below:
 0  ->  A,  1  ->  B,  2  ->  C,  3  ->  D,  4  ->  E,  5  ->  F,  6  ->  G,  7  ->  H,  8  ->  I,  9  -  J
It  is  your  responsibility  to  change  the  numbers  to  letters  in  the  StyleName  column  of  the  DimProduct  table.  Use  a  function  
that  allows  you  to  make  these  substitutions  quickly  and  easily */

select
	StyleName as 'OldCode',
	TRANSLATE(StyleName,'0123456789','ABCDEFGHIJ') as 'NewCode'
from DimProduct

/* 3. The  IT  department  is  creating  a  system  to  individually  track  each  employee  at  Contoso.  Each  employee  
will  be  given  a  login  and  password.  Each  employee's  login  will  be  their  email  ID,  as  in  the  example  below
 The  password  will  be  the  employee's  FirstName  +  the  day  of  the  year  the  employee  was  born,  in  
CAPITAL  LETTERS.   The  IT  person  has  asked  for  your  help  in  returning  a  table  containing  the  following  columns  from  the  
DimEmployee  table:  Full  Name  (FirstName  +  LastName),  Email,  Email  ID,  and  Password.
 So,  query  the  DimProduct  table  and  return  that  result */

select
	CASE
	when MiddleName is not null then CONCAT(FirstName,' ',MiddleName,' ', LastName)
	else CONCAT(FirstName,' ', LastName)
	end as 'FullName',
	BirthDate,
	EmailAddress,
	SUBSTRING(EmailAddress,1, CHARINDEX('@', EmailAddress)-1)  as 'ID',
	UPPER(FirstName + DATENAME(DAYOFYEAR, BirthDate)) as 'Password'
from DimEmployee


/* 4.  The  DimCustomer  table  has  the  first  sales  record  in  the  year  2001.
 As  a  way  of  recognizing  customers  who  purchased  this  year,  the  Marketing  department  asked  you  to  return  
a  table  with  all  customers  who  made  their  first  purchase  this  year  so  that  an  order  with  a  gift  can  be  sent  
to  each  one. To  perform  this  filter,  you  can  use  the  DateFirstPurchase  column,  which  contains  information  about  the  
date  of  each  customer's  first  purchase  in  the  DimCustomer  table. You  should  return  the  columns  FirstName,  EmailAddress,  AddressLine1  and  DateFirstPurchase
from  the  DimCustomer  table,  considering  only  customers  who  made  their  first  purchase  in  2001 */

select 
	FirstName,
	EmailAddress,
	AddressLine1,
	DateFirstPurchase
from DimCustomer
where YEAR(DateFirstPurchase) = 2001


/* 5.  The  DimEmployee  table  contains  information  on  the  hire  date  (HireDate).  The  HR  department,  however,  
needs  the  information  on  these  dates  separated  into  day,  month  and  year,  as  an  automation  will  be  used  
to  create  an  HR  report,  and  it  would  be  much  easier  if  this  information  were  separated  into  a  table.
You  will  need  to  query  the  DimEmployee  table  and  return  a  table  containing  the  following  information:  
FirstName,  EmailAddress,  HireDate,  as  well  as  the  Day,  Month,  and  Year  of  Hire  columns.
 Note  1:  The  Month  column  must  contain  the  month  name  in  full,  not  the  month  number 
 Note  2:  Remember  to  name  each  of  these  columns  in  your  query  to  ensure  that  the  
understanding  of  each  piece  of  information  will  be  100%  clear */ 

select 
	FirstName,
	EmailAddress,
	HireDate,
	DAY(HireDate) as 'HireDay',
	FORMAT(CAST(MONTH(HireDate) as datetime),'MMMM') as 'HireMonth',
	YEAR(HireDate) as 'HireYear'
from DimEmployee

/* 6. Find  out  which  store  has  the  longest  uptime  (in  days).  You  should  query  the  DimStore  table,  
and  consider  the  OpenDate  column  as  a  reference  for  this  calculation. */

select
	StoreName,
	OpenDate,
	DATEDIFF(DAY, OpenDate, GETDATE()) AS 'ActiveDays'
from DimStore
where CloseDate is null
order by DATEDIFF(DAY, OpenDate, GETDATE()) desc