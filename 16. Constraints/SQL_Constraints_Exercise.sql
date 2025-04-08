-- Constraints Exercise 
-- Functions learned: NOT NULL, UNIQUE, CHECK, DEFAULT, IDENTITY, PRIMARY KEY, FOREIGN KEY 
-- Database: ExercisesConstraints

/* 1. You are responsible for creating a database with some tables that will store 
information associated with renting cars from a car rental company.  
a) The first step is to create a database called RentalEasy. */

CREATE DATABASE RentalEasy

/* b) Your database should contain 3 tables and the description of each is shown 
below: 
Note: you will identify the constraints of the tables from their descriptions. 
Table 1: Client - id_client - name_client - cnh - number_card 
The Customer table has 4 columns.  
The id_cliente column must be the primary key of the table, and is auto-incremented automatically. 
The name_client, cnh and number_card columns cannot accept null values, i.e. for every 
customer, these fields must be filled in. 
Finally, the cnh column cannot accept duplicate values. */

CREATE TABLE Client (
	id_client INT IDENTITY(1,1),
	name_client VARCHAR(100) NOT NULL,
	CNH VARCHAR(100) NOT NULL,
	number_card VARCHAR(100) NOT NULL,
	CONSTRAINT Client_id_client_pk PRIMARY KEY(id_client),
	CONSTRAINT Client_CNH_un UNIQUE(CNH)
	)


/* Table 2: Car - car_id - license plate - model - type 
The Car table has 3 columns. 
The id_car column must be the table's primary key and must be auto-incremented automatically.  
The model, type and license plate columns cannot accept null values. 
The car types registered must be: Hatch, Sedan, SUV. 
Finally, the license plate column cannot accept duplicate values. */

CREATE TABLE Car (
	car_id INT IDENTITY(1,1),
	license_plate VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	car_type VARCHAR(100) NOT NULL,
	CONSTRAINT Car_car_id_pk PRIMARY KEY(car_id),
	CONSTRAINT Car_car_type_ck CHECK(car_type IN ('Hatch', 'Sedan', 'SUV')),
	CONSTRAINT Car_license_plate_un UNIQUE(license_plate)
	)

/* Table 3: Leases - lease_id - lease_date - return_date - car_id - id_client
The Rentals table has 5 columns. 
The id_location column must be the primary key of the table, and it must be auto-incremented automatically. 
None of the other columns should accept null values. 
The id_car and id_client columns are foreign keys that will allow the relationship between the 
rental table with the Car and Customer tables. */

CREATE TABLE Leases (
	lease_id INT IDENTITY(1,1),
	lease_date DATE NOT NULL,
	return_date DATE NOT NULL,
	car_id INT NOT NULL,
	id_client INT NOT NULL,
	CONSTRAINT Leases_lease_id_pk PRIMARY KEY(lease_id),
	CONSTRAINT Leases_car_id_fk FOREIGN KEY (car_id) REFERENCES Car(car_id),
	CONSTRAINT Leases_id_client_fk FOREIGN KEY (id_client) REFERENCES Client(id_client)
	)

SELECT * FROM Client
SELECT * FROM Car
SELECT * FROM Leases
/* 2.  Try to violate the constraints created for each table. This exercise is free. 
Note: To do the constraints violation exercise, simply use the INSERT INTO command to 
to add values to the tables that don't respect the constraints established when the 
creation of the tables. 
At the end, delete the database you have created.*/

INSERT INTO Car (license_plate,model,car_type)
VALUES ('license1', 'model1', 'Sport')

INSERT INTO Client(name_client,CNH,number_card)
VALUES ('Name1','125.458-89', '321.569.784-89'),
	   ('Name2','125.458-89', '568.478.555-65')

INSERT INTO Leases(lease_date,return_date,car_id)
VALUES ('10/02/2025','10/03/2025','1')


DROP DATABASE RentalEasy