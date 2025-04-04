-- SQL CRUDE Exercise 
-- Functions learned: CRUDE, CREATE, DROP DATABESE, CREATE TABLE, INSERT SELECT, INSERT INTO, INSERT, UPDATE, DELETE, DROP TABLE, ALTER TABLE, 
-- Database: Created during the exercises

-- 1. a) Create a database called BD_Test. 
CREATE DATABASE BD_Test
-- b) Delete the database created in the previous item. 
DROP DATABASE BD_Test
-- c) Create a database called Exercises.
CREATE DATABASE Exercises

/* 2. In the database created in the previous exercise, create 3 tables, each containing the following 
columns: 
Table 1: dClient - Client_ID - Client_Name - Date_of _Birth 
Table 2: dManager - Manager_ID - Manager_Name - Date_of_Hire - Salary 
Table 3: fContracts - Contract_ID - Signature_Date - Client_ID - Manager_ID - Contract_Value 
Remember the following points: 
a) Ensure that the Database is selected. 
b) Define the most appropriate data type for each column in the tables. Remember that 
the most common data types are: INT, FLOAT, VARCHAR and DATETIME. 
Finally, perform a SELECT to view each table. */

USE Exercises
CREATE TABLE dClient(
	dClient INT,
	Client_ID INT,
	Client_Name VARCHAR(100),
	Date_of_Birth DATETIME
)

USE Exercises
CREATE TABLE dManager(
	dManager INT,
	Manager_ID INT,
	Manager_Name VARCHAR(100),
	Date_of_Hire DATETIME,
	Salary FLOAT
)

USE Exercises
CREATE TABLE fContracts(
	fContracts INT,
	Contract_ID INT,
	Signature_Date DATETIME,
	Client_ID INT,
	Manager_ID INT,
	Contract_Value FLOAT
)

-- 3. In each of the 3 tables, add the following values: 

USE Exercises
INSERT INTO dClient (Client_ID, Client_Name, Date_of_Birth)
VALUES
	(1, 'Andre Martins', '12/02/1989'),
	(2, 'Barbara Campos', '07/05/1992'),
	(3, 'Carol Freitas', '23/04/1985'),
	(4, 'Diego Cardoso', '11/10/1994'),
	(5, 'Eduardo Pereira', '09/11/1988'),
	(6, 'Fabiana Silva', '02/09/1989'),
	(7, 'Gustavo Barb', '27/06/1993'),
	(8, 'Helen Viana', '11/02/1990')

USE Exercises
INSERT INTO dManager (Manager_ID, Manager_Name, Date_of_Hire, Salary)
VALUES
	(1, 'Lucas Sampaio', '21/03/2015', 6700),
	(2, 'Mariana Padiha', '10/01/2011', 9900),
	(3, 'Nathalia Santos', '03/10/2018', 7200),
	(4, 'Otavio Costa', '18/04/2017', 11000)

USE Exercises
INSERT INTO fContracts (Contract_ID, Signature_Date, Client_ID, Manager_ID, Contract_Value)
VALUES 
	(1, '12/01/2019', 8, 1, 2300),
	(2, '10/02/2019', 3, 2, 155500),
	(3, '07/03/2019', 7, 2, 6500),
	(4, '15/03/2019', 1, 3, 33000),
	(5, '21/03/2019', 5, 4, 11100),
	(6, '23/03/2019', 4, 2, 5500),
	(7, '28/03/2019', 9, 3, 55000),
	(8, '04/04/2019', 2, 1, 31000),
	(9, '05/04/2019', 10, 4, 3400),
	(10, '05/04/2019', 6, 2, 9200)

/* 4. New data should be added to the dCustomer, dManager and fContracts tables. Feel free 
to add a new row to each table containing, respectively,  
(1) a new customer (customer id, name and date of birth) 
(2) a new manager (manager id, name, hire date and salary) 
(3) a new contract (id, signature date, client id, manager id, contract value) */

USE Exercises
INSERT INTO dClient (Client_ID, Client_Name, Date_of_Birth)
VALUES 
	(9, 'Amanda Correia', '21/05/1995')

USE Exercises
INSERT INTO dManager(Manager_ID, Manager_Name, Date_of_Hire, Salary)
VALUES 
	(5, 'Gustavo Correia', '21/01/2016', 30000)

USE Exercises
INSERT INTO fContracts(Contract_ID, Signature_Date, Client_ID, Manager_ID, Contract_Value)
VALUES 
	(11, '30/03/2019', 9, 5, 50000)

/* 5. The contract with ID 4 was registered with some errors in the fContracts table. Make a 
change to the table by updating the following values: 
Signature_Date: 17/03/2019 
Manager_ID: 2 
Contract_Value: 33500 */

UPDATE fContracts
SET Signature_Date = '17/03/2019', 
	Contract_Value = 33500, 
	Manager_ID = 2
WHERE Contract_ID = 4

-- 6. Delete the row from the fContracts table that you created in question 4. 

DELETE FROM fContracts
WHERE Contract_ID = 11


-- 7. Delete columns 
ALTER TABLE dClient 
DROP COLUMN dClient

ALTER TABLE dManager
DROP COLUMN dManager

ALTER TABLE fContracts
DROP COLUMN fContracts

SELECT * FROM dClient
SELECT * FROM dManager
SELECT * FROM fContracts

