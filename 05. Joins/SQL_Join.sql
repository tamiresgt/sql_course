-- Join module
-- Functions learned: LEFT JOIN, RIGTH JOIN, INNER JOIN, FULL JOIN, ANTI JOIN, CROSS JOIN, UNION, UNION ALL
-- Database: ContosoRetailDW

-- JOIN 
select top 1000 * from FactSales
select * from DimChannel

-- LEFT (OUTER) JOIN
-- create table: Product
create table produtos2(
id_produto int,
nome_produto varchar(30),
id_subcategoria int)

insert into produtos2(id_produto,nome_produto,id_subcategoria)
VALUES
(1,'Fone JBL',5),
(2,'PS4',6),
(3,'Notebook',2),
(4,'Iphone',1),
(5,'Moto',1);

-- Create table: subcategory
create table subcategoria2(
id_subcategoria int,
nome_subcategoria varchar(30))

insert into subcategoria2(id_subcategoria,nome_subcategoria)
values
(1,'Celular'),
(2,'Notebook'),
(3,'Camera'),
(4, 'TV'),
(5,'Fone');

-- analisis
select * from produtos2
select * from subcategoria2

-- LEFT JOIN
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
left join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria


-- RIGHT JOIN
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
right join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria

-- INNER JOIN - intersection between the two tables i.e. matching rows between the tables
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
inner join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria

-- FULL JOIN
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	subcategoria2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
full join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria


-- LEFT ANTI JOIN
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
left join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria
where subcategoria2.nome_subcategoria is null

-- RIGHT ANTI JOIN
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
right join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria
where id_produto is null


-- FULL ANTI JOIN 
select 
	produtos2.id_produto,
	produtos2.nome_produto,
	produtos2.id_subcategoria,
	subcategoria2.nome_subcategoria
from produtos2
full join subcategoria2 on produtos2.id_subcategoria = subcategoria2.id_subcategoria
where id_produto is null or nome_subcategoria is null


-- Exempla INNER, LEFT, RIGHT

select ProductKey, ProductName, ProductSubcategoryKey from DimProduct
select ProductSubcategoryKey, ProductSubcategoryName from DimProductSubcategory

-- INNER (intersection between two tables)
select
	ProductKey,
	ProductName,
	DimProduct.ProductSubcategoryKey,
	ProductSubcategoryName
from DimProduct
inner join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey

-- left : using inner and left join gives the same result, meaning there is no one in the left table who is not in the right table
select
	ProductKey,
	ProductName,
	DimProduct.ProductSubcategoryKey,
	ProductSubcategoryName
from DimProduct
left join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey

-- right 
select
	ProductKey,
	ProductName,
	DimProduct.ProductSubcategoryKey,
	ProductSubcategoryName
from DimProduct
right join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey


-- CROSS JOIN
create table marca(
id_marca int, marca varchar(20))

insert into marca(id_marca,marca)
values
(1,'Apple'),
(2, 'Samsung'),
(3,'Motorola');


create table subcategoria3 (id_subcategoria int, nome_subcategoria  varchar(30))
insert into subcategoria3(id_subcategoria,nome_subcategoria)
values
(1,'Celular'),
(2,'Notebook'),
(3,'Camera'),
(4,'Televisão'),
(5,'Fone');

select 
	marca,
	nome_subcategoria
from marca cross join subcategoria3

-- Multiples Joins
select ProductKey, ProductSubcategoryKey from DimProduct
select ProductSubcategoryKey, ProductSubcategoryName, ProductCategoryKey from DimProductSubcategory
select ProductCategoryKey, ProductCategoryName from DimProductCategory

select 
	DimProduct.ProductName,
	DimProductSubcategory.ProductSubcategoryName,
	DimProductCategory.ProductCategoryName
from DimProduct
left join DimProductSubcategory on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
left join DimProductCategory on DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey

-- UNION 
select * from DimCustomer
where Gender = 'F'
UNION
select * from DimCustomer
where Gender = 'M'

-- UNION ALL
select
	FirstName,
	BirthDate
from DimCustomer
where Gender = 'F'
UNION ALL
select
	FirstName,
	BirthDate
from DimCustomer
where Gender = 'M'