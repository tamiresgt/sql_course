-- Transactions Exercise 
-- Functions learned: BEGIN TRANSACTION, COMMIT, ROLLBACK, TRY, CATCH, TRANCOUNT
-- Database: ExercisesTransaction

-- 1. Create a table called Car with the data below.  Note: don't worry about constraints, you can create a simple table.

CREATE DATABASE ExercisesTransaction
USE ExercisesTransaction

CREATE TABLE Car (id_car INT IDENTITY(1,1), 
				  car_label VARCHAR(100),
				  model VARCHAR(100),
				  car_type VARCHAR(100),
				  CONSTRAINT Car_car_type_ck CHECK(car_type IN('Hatch', 'Sedan', 'SUV'))
				 )

SELECT * FROM Car

INSERT INTO Car (car_label,model,car_type)
VALUES ('DAS-1412', 'Hyundai HB20', 'Hatch'),
	   ('JHG-3902', 'Fiat Cronos', 'Sedan'),
	   ('IPW-9018', 'Citroen C4', 'SUV'),
	   ('JKR-8891', 'Nissa Kicks', 'SUV'),
	   ('TRF-5904', 'Chevrolet Onix', 'Sedan')

-- 2. Run the following transactions on the database, always on the Car table. Remember to COMMIT to make each transaction effective. 
/* a) Insert a new row with the following values: 
car_id = 6 
license plate = CDR-0090 
model = Fiat Argo 
type = Hatch */

BEGIN TRANSACTION T1
INSERT INTO Car (car_label,model,car_type)
VALUES ('CDR-0090', 'Fiat Argo', 'Hatch')

COMMIT TRANSACTION T1

SELECT * FROM Car

-- b) Update the car type of id = 1 from Hatch to Sedan. 
BEGIN TRANSACTION T2
UPDATE Car
SET car_type = 'Sedan'
WHERE id_car = 1

COMMIT TRANSACTION T2

-- c) Delete the line referring to car id = 6.

BEGIN TRANSACTION T3
DELETE FROM Car
WHERE id_car = 6 
COMMIT TRANSACTION T3