-- SQL CRUDE Module 
-- Functions learned: CRUDE, CREATE, DROP DATABESE, CREATE TABLE, INSERT SELECT, INSERT INTO, INSERT, UPDATE, DELETE, DROP TABLE, ALTER TABLE, 
-- Database: Created during the module

-- Create a database
CREATE DATABASE Test
DROP DATABASE Test

-- Create a BD_SQLCOURSE
CREATE DATABASE BD_SQLCOURSE

-- We have two database, so USE is a command that 
USE BD_SQLCOURSE

-- Create a table call 'Products' with 4 columns: id_product, product_name, expiration_date, unit_price and with teh values from dimProduct ContosoRetailDW

USE BD_SQLCOURSE
CREATE TABLE Products (
	id_product INT,
	product_name VARCHAR(100),
	expiration_date DATETIME,
	unit_price FLOAT)

SELECT * FROM Products

INSERT INTO Products (id_product, product_name, expiration_date, unit_price)
SELECT
	ProductKey,
	ProductName,
	AvailableForSaleDate,
	UnitPrice
FROM ContosoRetailDW.dbo.DimProduct

SELECT * FROM Products

-- -- Delete the table created before and construct another one with data input 

CREATE TABLE Products (
	id_product INT,
	product_name VARCHAR(200),
	expiration_date DATETIME,
	unit_price FLOAT )

INSERT INTO Products (id_product,product_name,expiration_date,unit_price)
VALUES
	(1,'Rice', '31/12/2021', 22.50),
	(2,'Bean', '20/11/2022', 8.99)

-- reverse the order and leave a column blank to see what happens

INSERT INTO Products(expiration_date, id_product, unit_price)
VALUES 
	('31/05/2023', 3, 33.99)

-- UPDATE
UPDATE Products
SET product_name = 'Pasta'
WHERE id_product = 3

-- DELETE 
DELETE FROM Products
WHERE id_product = 3

-- DROP TABLE 
DROP TABLE Products

-- Create a new table call Employee

USE BD_SQLCOURSE
CREATE TABLE Employee (
	id_employee INT,
	employee_name VARCHAR(100),
	salary FLOAT,
	BirthDate DATETIME
)

INSERT INTO Employee (id_employee, employee_name, salary, BirthDate)
VALUES 
	(1, 'Lucas', 1500, '20/03/1990'),
	(2, 'Andressa', 2300, '07/12/1988'),
	(3, 'Felipe', 4000, '13/02/1993'),
	(4, 'Marcelo', 7100, '10/04/1993'),
	(5, 'Carla', 3200, '02/09/1986'),
	(6, 'Juliana', 5500, '21/01/1989'),
	(7, 'Mateus', 1900, '02/11/1993'),
	(8, 'Sandra', 3900, '09/05/1990'),
	(9, 'Andre', 1000, '13/03/1994'),
	(10, 'Julio', 4700, '05/07/1992')

-- ALTER 
-- Add column
ALTER TABLE Employee
ADD position VARCHAR(100), bonus FLOAT

UPDATE Employee
SET position = 'Analyst', bonus = 0.15
WHERE id_employee = 1

-- change data type

ALTER TABLE Employee
ALTER COLUMN salary INT

-- delete column 

ALTER TABLE Employee
DROP COLUMN position, bonus

SELECT * FROM Employee
