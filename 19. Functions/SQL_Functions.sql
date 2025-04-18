﻿-- Functions Module 
-- Functions learned: CREATE FUNCTION, ALTER FUNCTION, DROP FUNCTION 
-- Database: ExercisesFunction

CREATE DATABASE ExerciseFunctions
USE ExerciseFunctions

-- Table 1: dClient where:
-- Column 1: id_client INT -> PrimaryKey and identity
-- Column 2: name_client VARCHAR -> NOT NULL
-- Column 3: gender VARCHAR -> NOT NULL and has to be M, F, O, PNS
-- Column 4: birthdate DATE -> NOT NULL
-- Column 5: cpf VARCHAR -> NOT NULL and no duplicate

CREATE TABLE dClient (
	id_client INT IDENTITY(1,1),
	NameClient VARCHAR(100) NOT NULL,
	Gender VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	CPF VARCHAR(100) NOT NULL,
	CONSTRAINT dClient_id_client_pk PRIMARY KEY(id_client),
	CONSTRAINT dClient_Gender_ck CHECK(Gender IN ('M','F','O','PNS')),
	CONSTRAINT dClient_CPF_un UNIQUE(CPF)
	)


INSERT INTO dClient(NameClient,Gender,BirthDate,CPF)
VALUES 	
	('André Martins',  'M',  '12/02/1989', '839.283.190-00'),
	('Bárbara Campos',  'F', '07/05/1992', '351.391.410-02'),
	('Carol Freitas',  'F',  '23/04/1985', '139.274.921-12'),
	('Diego Cardoso',   'M', '11/10/1994', '192.371.081-17'),
	('Eduardo Pereira', 'M', '09/11/1988', '193.174.192-82'),
	('Fabiana Silva',  'F',  '02/09/1989', '231.298.471-98'),
	('Gustavo Barbosa', 'M', '27/06/1993', '240.174.171-76'),
	('Helen Viana',    'F',  '11/02/1990', '193.129.183-01'),
	('Igor Castro',    'M',  '21/08/1989', '184.148.102-29'),
	('Juliana Pires',   'F', '13/01/1991', '416.209.192-47')

SELECT * FROM dClient

-- Table 2: dManager
-- Column 1: id_manager INT -> PrimaryKey and identity
-- Column 2: name_manager VARCHAR -> NOT NULL
-- Column 3: hiring_date VARCHAR -> NOT NULL 
-- Column 4: salary FLOAT -> NOT NULL and >0

CREATE TABLE dManager (
	id_manager INT IDENTITY(1,1),
	name_manager VARCHAR(100) NOT NULL,
	hiring_date VARCHAR(100) NOT NULL,
	salary FLOAT NOT NULL,
	CONSTRAINT dManager_id_manager_pk PRIMARY KEY(id_manager),
	CONSTRAINT dManager_salary_ck CHECK(salary >0))

INSERT INTO dManager(name_manager,hiring_date,salary)
VALUES 
	('Lucas Sampaio',   '21/03/2015', 6700),
	('Mariana Padilha', '10/01/2011', 9900),
	('Nathália Santos', '03/10/2018', 7200),
	('Otávio Costa',    '18/04/2017', 11000)

SELECT * FROM dManager

-- Table 3: fContracts
-- Column 1: id_contract of type INT --> Primary Key and auto-incremental
-- Column 2: date_signature of type DATE --> Default Value (GETDATE) if not filled in
-- Column 3: id_client of type INT --> Foreign Key
-- Column 4: id_manager of type INT --> Foreign Key
-- Column 5: contract_value of type FLOAT --> Does not accept null values ​​and must be greater than zero


CREATE TABLE fContracts (
	id_contract INT IDENTITY(1,1),
	date_signature DATE DEFAULT GETDATE(),
	id_client INT ,
	id_manager INT,
	contract_value FLOAT NOT NULL,
	CONSTRAINT fContracts_id_contract_pk PRIMARY KEY(id_contract),
	CONSTRAINT fContracts_id_client_fk FOREIGN KEY(id_client) REFERENCES dClient(id_client),
	CONSTRAINT fContracts_id_manager_fk FOREIGN KEY(id_manager) REFERENCES dManager(id_Manager),
	CONSTRAINT fContracts_contract_value_ck CHECK(contract_value >0))

INSERT INTO fContracts(date_signature, id_client, id_manager, contract_value)
VALUES
	('12/01/2019', 8, 1, 23000),
	('10/02/2019', 3, 2, 15500),
	('07/03/2019', 7, 2, 6500),
	('15/03/2019', 1, 3, 33000),
	('21/03/2019', 5, 4, 11100),
	('23/03/2019', 4, 2, 5500),
	('28/03/2019', 9, 3, 55000),
	('04/04/2019', 2, 1, 31000),
	('05/04/2019', 10, 4, 3400),
	('05/04/2019', 6, 2, 9200)

SELECT * FROM fContracts


-- Imagine you want to format the date of birth column differently with the DATENAME function
SELECT * FROM dClient

SELECT
	NameClient,
	BirthDate,
	DATENAME(DW,BirthDate) +','+ -- DW = day week
	DATENAME(D,BirthDate) +' de '+
	DATENAME(M,BirthDate) + ' de'+
	DATENAME(YY, BirthDate)
FROM dClient

-- How to create a Function? 

CREATE FUNCTION fnFullDate (@Date AS DATE)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN DATENAME(DW, @Date) + ',' + 
		   DATENAME(D, @Date) + ' de' +
		   DATENAME(M, @Date) + 'de' +
		   DATENAME(YY, @Date) 
END

SELECT 
	NameClient,
	BirthDate,
	[dbo].[fnFullDate](BirthDate) AS 'FullDate'
FROM dClient

-- CHANGING AND DELETING A FUNCTION
CREATE OR ALTER FUNCTION fnFullDate (@Date AS DATE)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN DATENAME(DW, @Date) + ',' + 
		   DATENAME(D, @Date) + ' de' +
		   DATENAME(M, @Date) + 'de' +
		   DATENAME(YY, @Date) + ' - ' +
		   CASE
			   WHEN MONTH(@Date) <= 6 THEN '(1º Semester)'
			   ELSE '(2º Semester)'
		   END
END

SELECT 
	NameClient,
	BirthDate,
	[dbo].[fnFullDate](BirthDate) AS 'FullDate'
FROM dClient

DROP FUNCTION fnFullDate

-- Create a Function to return the first name of each manager

SELECT * FROM dManager

SELECT
	name_manager,
	LEFT(name_manager,CHARINDEX(' ',name_manager) - 1) AS 'FirstName'
FROM dManager

INSERT INTO dManager(name_manager,hiring_date,salary)
VALUES ('João', '10/01/2019', 3100)

-- Function:

CREATE OR ALTER FUNCTION fnFirstName (@FullName AS VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @PositionSpace AS INT
	DECLARE @Answer AS VARCHAR(MAX)

	SET @PositionSpace = CHARINDEX(' ',@FullName)

	IF @PositionSpace = 0 
		SET @Answer = @FullName
	ELSE 
		SET @Answer = LEFT(@FullName,@PositionSpace - 1)
	RETURN @Answer
END

SELECT
	name_manager,
	dbo.fnFirstName(name_manager) AS 'FirstName'
FROM dManager