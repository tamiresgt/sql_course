-- Procedures Exercises
-- Functions learned: CREATE PROCEDURE, EXECUTE
-- Database: ContosoRetailDW

-- Note: The procedures in exercises 1 to 3 will be executed on the original tables in the database ContosoRetail.  

/* 1. Create a Procedure that summarizes the total number of products by category name. This Procedure 
should ask the user which brand should be considered in the analysis. */

SELECT * FROM DimProduct
SELECT * FROM DimProductSubcategory
SELECT * FROM DimProductCategory
USE ContosoRetailDW
CREATE OR ALTER PROCEDURE prSummaryProducts (@BrandName VARCHAR(MAX))
AS
BEGIN
	SELECT 
	BrandName,
	ProductCategoryName,
	COUNT(*) AS 'TotalProduct'
	FROM DimProduct
	LEFT JOIN DimProductSubcategory ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
		LEFT JOIN DimProductCategory ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
	WHERE BrandName = @BrandName
	GROUP BY ProductCategoryName, BrandName
	ORDER BY COUNT(*) DESC
END

EXECUTE prSummaryProducts @BrandName = 'Contoso'

/* 2. Create a Procedure that lists the top N customers according to the date of their first purchase. 
The value of N should be an input parameter of your Procedure.*/
SELECT * FROM DimCustomer

CREATE OR ALTER PROCEDURE prTopNCustumers (@TopN INT)
AS
BEGIN 
	SELECT TOP (@TopN) *		
	FROM DimCustomer 
	WHERE CustomerType = 'Person'
	ORDER BY DateFirstPurchase
END

EXECUTE prTopNCustumers @TopN = 10

/* 3. Create a Procedure that receives 2 arguments: MONTH (from 1 to 12) and YEAR (1996 to 2003). Your 
Procedure should list all the employees who were hired in the month/year entered. */
SELECT * FROM DimEmployee

CREATE OR ALTER PROCEDURE prEmployeesHired (@Month INT, @Year INT)
AS
BEGIN
	SELECT
	*,
	MONTH(StartDate) AS 'Month',
	YEAR(StartDate) AS 'Year'
	FROM DimEmployee
	WHERE MONTH(StartDate) = @Month AND YEAR(StartDate) = @Year
	ORDER BY HireDate
END

EXECUTE prEmployeesHired @Month = 1, @Year = 2000

-- Note: For exercises 4, 5 and 6, use the codes below. 

CREATE DATABASE RentalEasyProcedure 
USE RentalEasyProcedure 
CREATE TABLE Car( 
		id_car INT, 
		license_plate VARCHAR(100) NOT NULL, 
		model VARCHAR(100) NOT NULL, 
		[type] VARCHAR(100) NOT NULL, 
		[value] FLOAT NOT NULL, 
		CONSTRAINT car_id_car_pk PRIMARY KEY(id_car) 
) 
INSERT INTO Car(id_car, license_plate, model, type, value) VALUES 
			   (1, 'CRU-1111', 'Chevrolet Cruze', 'Sedan', 140000), 
			   (2, 'ARG-2222', 'Fiat Argo', 'Hatch', 80000), 
			   (3, 'COR-3333', 'Toyota Corolla', 'Sedan', 170000), 
			   (4, 'TIG-4444', 'Caoa Chery Tiggo', 'SUV', 190000)
			   
/* 4. Create a Procedure that inserts a new row into the Car table. This new row must contain 
the following data: -- id = 5 -- license plate = GOL-5555 -- model = Volkswagen Gol -- type = Hatch -- value = 80000 */


CREATE OR ALTER PROCEDURE prCarTable (@id_car INT, @license_plate VARCHAR(MAX), @model VARCHAR(MAX), @type VARCHAR(MAX), @value INT)
AS
BEGIN
	INSERT INTO Car(id_car, license_plate, model, [type], [value])
	VALUES (@id_car, @license_plate, @model, @type, @value)

	PRINT 'Car successfully registered'
END

EXECUTE prCarTable @id_car = 5 , @license_plate = 'GOL-5555', @model = 'Volkswagen Gol', @type = 'Hatch', @value = 80000

SELECT * FROM Car


/* 5. Create a procedure that changes the sale price of a car. The Procedure must receive 
as parameters the car_id and the new value. */ 

CREATE OR ALTER PROCEDURE prCarTableChange (@car_id INT, @value INT)
AS
BEGIN
	UPDATE Car
	SET value = @value 
	WHERE id_car = @car_id
	PRINT 'Successfully Updated'

END

SELECT * FROM Car
EXECUTE prCarTableChange @car_id = 2, @value = 15000


-- 6. Create a Precedure that deletes a car from the id entered.

CREATE OR ALTER PROCEDURE prCarTableDelete (@car_id INT)
AS
BEGIN
	DELETE FROM Car
	WHERE id_car = @car_id
	PRINT 'Successfully Deleted'
END

EXECUTE prCarTableDelete @car_id = 5
SELECT * FROM Car
