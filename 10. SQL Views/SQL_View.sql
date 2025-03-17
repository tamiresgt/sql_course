-- SQL Views Module 
-- Functions learned: CREATE VIEW, USE, ALTER VIEW, DROP VIEW
-- Database: ContosoRetailDW

-- CREATE VIEW
-- 1. Create a view with FirstName, EmailAdress, BirthDate from DimCustomer. Call this view as vwClients

CREATE VIEW vwClients AS
SELECT
	FirstName,
	EmailAddress,
	BirthDate
FROM DimCustomer
GO -- mark the end of create view

select * from vwClients

-- 1. Create a view with ProductKey, ProductName, ProductSubcategoryKey, BrandName, UnitPrice from DimProduct. Call this view as vwProducts
GO
CREATE VIEW vwProducts AS
SELECT
	ProductKey,
	ProductName,
	ProductSubcategoryKey,
	BrandName,
	UnitPrice
FROM DimProduct
GO

select * from vwProducts

-- ALYTER VIEW
-- 1. Alter vwClients to include only gender equal F
GO
ALTER VIEW  vwClients AS
SELECT 
	FirstName,
	EmailAddress,
	BirthDate,
	Gender
FROM DimCustomer
WHERE Gender = 'F'
GO

SELECT * FROM vwClients

-- DROP VIEW 
-- Delete vwClients and vwProducts

DROP VIEW vwClients
DROP VIEW vwProducts
