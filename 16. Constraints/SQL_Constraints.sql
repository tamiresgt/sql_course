-- Constraints Module 
-- Functions learned: NOT NULL, UNIQUE, CHECK, DEFAULT, IDENTITY, PRIMARY KEY, FOREIGN KEY 
-- Database: ExercisesConstraints

-- Table 1: dClient where:
-- Column 1: id_client INT -> PrimaryKey and identity
-- Column 2: name_client VARCHAR -> NOT NULL
-- Column 3: gender VARCHAR -> NOT NULL and has to be M, F, O, PNS
-- Column 4: birthdate DATE -> NOT NULL
-- Column 5: cpf VARCHAR -> NOT NULL and no duplicate

CREATE DATABASE ExercisesConstraints

USE ExercisesConstraints
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

USE ExercisesConstraints
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


USE ExercisesConstraints
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

-- CONSTRAINTS VIOLATION
-- Violation NOT NULL and CHECK

INSERT INTO dClient(NameClient,Gender,BirthDate,CPF) 
VALUES ('Katia Lopes', 'F', '10/01/1989', '123.234.812-20')

SELECT * FROM dClient

INSERT INTO dClient(NameClient,Gender,BirthDate,CPF) 
VALUES ('Lucia Campos', 'Feminino', '23/10/1994', '999.234.812-20')

-- Violation UNIQUE
INSERT INTO dClient(NameClient,Gender,BirthDate,CPF) 
VALUES ('Lucia Campos', 'F', '23/10/1994', '149.283.190-00')
	
-- Violation FK and PK
SELECT * FROM dClient
SELECT * FROM dManager
SELECT * FROM fContracts

INSERT INTO fContracts(date_signature,id_client,id_manager,contract_value)
VALUES ('12/03/2022',1,1,1500);

INSERT INTO fContracts(date_signature,id_client,id_manager,contract_value)
VALUES ('12/03/2022',4,10,1500);

-- MANAGER CONSTRAINTS -- ADD, REMOVE AND RENAME 

-- Remove a PK from fContracts
ALTER TABLE fContracts
DROP CONSTRAINT fContracts_id_contract_pk

-- Remove FK from id_clients from fContracts
ALTER TABLE fContracts
DROP CONSTRAINT fContracts_id_client_fk

-- ADD fContracts_id_contract_pk
ALTER TABLE fContracts
ADD CONSTRAINT fContracts_id_contract_pk PRIMARY KEY (id_contract)

-- ADD FK from id_clients from fContracts
ALTER TABLE fContracts
ADD CONSTRAINT fContracts_id_client_fk FOREIGN KEY(id_client) REFERENCES dClient(id_client)

-- RENAME a constraint -> right click on the constraint in object explorer and rename 
