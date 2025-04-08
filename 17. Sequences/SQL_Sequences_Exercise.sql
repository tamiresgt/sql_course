-- Sequences Exercises 
-- Functions learned: SEQUENCE, START WITH, INCREMENT BY, MAXVALUE, MINVALUE, CYCLE, SELECT NEXT VALUE FOR, DROP SEQUENCE
-- Database: Exercises

-- 0. Create the RentalEasySequence database, where the exercise sequences and tables will be created. 
CREATE DATABASE RentalEasySequence
USE RentalEasySequence

/* 1. Let's create Sequences that will be used in the tables: Car, Customer and Rentals. 
These sequences will be called: client_seq, car_seq and leases_seq. 
All these sequences must start with the number 1, increment every 1 and have no 
maximum value. */

CREATE SEQUENCE client_seq
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE

CREATE SEQUENCE car_seq
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE

CREATE SEQUENCE leases_seq
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE

/* 2. Use the sequences in the 3 tables: Car, Customer and Rentals. Remember that you don't need to use the IDENTITY constraint on the 
primary key columns since the Sequences will be used on them.  

Table 1: Client - id_cliente - nome_cliente - cnh - cartao 
The Customer table has 4 columns.  
The id_client column must be the table's primary key. 
The client_name, cnh and card_number columns cannot accept null values, i.e. for every 
customer, these fields must be filled in. 
Finally, the cnh column cannot accept duplicate values. */

CREATE TABLE Client (
	id_client INT,
	name_client VARCHAR(100) NOT NULL,
	CNH VARCHAR(100) NOT NULL,
	card_number VARCHAR(100) NOT NULL,
	CONSTRAINT Client_id_client_pk PRIMARY KEY(id_client),
	CONSTRAINT Client_CNH_un UNIQUE(CNH)
	)

INSERT INTO Client (id_client,name_client,CNH,card_number)
VALUES (NEXT VALUE FOR client_seq, 'name1', 'cnh1', 'cardnumber1'),
	   (NEXT VALUE FOR client_seq, 'name2', 'cnh2', 'cardnumber2')

SELECT * FROM Client

/* Table 2: Car - car_id - license plate - model - type 
The Car table has 3 columns. 
The id_car column must be the table's primary key. 
The model, type and license plate columns cannot accept null values. 
The car types registered must be: Hatch, Sedan, SUV. 
Finally, the license plate column cannot accept duplicate values. */

CREATE TABLE Car (
	car_id INT,
	license_plate VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	car_type VARCHAR(100) NOT NULL,
	CONSTRAINT Car_car_id_pk PRIMARY KEY(car_id),
	CONSTRAINT Car_car_type_ck CHECK(car_type IN ('Hatch', 'Sedan', 'SUV')),
	CONSTRAINT Car_license_plate_un UNIQUE(license_plate)
	)

INSERT INTO Car (car_id,license_plate,model,car_type)
VALUES (NEXT VALUE FOR car_seq, 'licenseplate1', 'model1', 'Hatch'),
	   (NEXT VALUE FOR car_seq, 'licenseplate2', 'model2', 'SUV')

SELECT * FROM Car

DROP SEQUENCE car_seq
DROP TABLE Car


/* Table 3: Leases - lease_id - lease_date - return_date - car_id - customer_id 
The Leases table has 5 columns. 
The id_location column must be the primary key of the table. 
None of the other columns should accept null values. 
The id_car and id_cliente columns are foreign keys that will allow the relationship between the 
table with the Car and Customer tables.*/

CREATE TABLE Leases (
	lease_id INT,
	lease_date DATE NOT NULL,
	return_date DATE NOT NULL,
	car_id INT NOT NULL,
	id_client INT NOT NULL,
	CONSTRAINT Leases_lease_id_pk PRIMARY KEY(lease_id),
	CONSTRAINT Leases_car_id_fk FOREIGN KEY (car_id) REFERENCES Car(car_id),
	CONSTRAINT Leases_id_client_fk FOREIGN KEY (id_client) REFERENCES Client(id_client))

INSERT INTO Leases(lease_id,lease_date,return_date,car_id,id_client)
VALUES (NEXT VALUE FOR leases_seq, '10/02/2025', '10/03/2025', '1', '1'),
	   (NEXT VALUE FOR leases_seq, '01/10/2024', '25/12/2024', '2', '2')

SELECT * FROM Leases

DROP SEQUENCE leases_seq
DROP TABLE Leases

-- 3. Delete the sequences created.
