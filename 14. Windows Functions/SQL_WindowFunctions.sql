-- Window Functions  Module 
-- Functions learned: OVER, ROW NUMBER, RANK, DENSE RANK, NTILE, PARTITION BY, LAG, LEAD, MoM, FIRST VALUE, LAST VALUE
-- Database: ContosoRetailDW

CREATE DATABASE WF
USE WF

CREATE TABLE Stores(
ID_Store INT,
Name_Store VARCHAR(100),
Region VARCHAR(100),
QtySold FLOAT)

INSERT INTO Stores(ID_Store,Name_Store,Region,QtySold)
VALUES
	(1, 'Botafogo Praia&Mar', 'Sudeste', 1800),
	(2, 'Lojas Vitoria', 'Sudeste', 800),
	(3, 'Emporio Mineirinho', 'Sudeste', 2300),
	(4, 'Central Paulista', 'Sudeste', 1800),
	(5, 'Rio 90 graus', 'Sudeste', 700),
	(6, 'Casa Flor & Anópolis', 'Sul', 2100),
	(7, 'Pampas & Co', 'Sul', 990),
	(8, 'Paraná Papéis', 'Sul', 2800),
	(9, 'Amazonas Prime', 'Norte', 4200),
	(10, 'Pará Bens', 'Norte', 3200),
	(11, 'Tintas Rio Branco', 'Norte', 1500),
	(12, 'Nordestemido Hall', 'Nordeste', 1910),
	(13, 'Cachoerinha Loft', 'Nordeste', 2380)

	SELECT * FROM Stores

-- Aggregation Functions

-- 1. Create a column with the SUM of TotalSold 
USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	SUM(QtySold) OVER() as  'TotalSales'
FROM Stores

-- 2. Create a column with the SUM of TotalSold  by Region
USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	SUM(QtySold) OVER(PARTITION BY Region) as  'TotalSales'
FROM Stores
ORDER BY ID_Store

-- 3. Create a column with the count of stores by region
USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	COUNT(*) OVER(PARTITION BY Region) as  'QtyStore'
FROM Stores
ORDER BY ID_Store

-- 4. Create a column with avg of qtysold
USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	AVG(QtySold) OVER() as  'TotalSales'
FROM Stores

-- 5. Create a column with MIN and MAX QtySold
USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	MIN(QtySold) OVER() as  'TotalSales'
FROM Stores

USE WF
SELECT 
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	MAX(QtySold) OVER() as  'TotalSales'
FROM Stores

-- CALCULATION OF PERCENTAGE OF TOTAL
-- 1. Calcule the % share of each store in relation to the total sales of all stores
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	SUM(QtySold) OVER() as 'TotalSales',
	FORMAT(QtySold/SUM(QtySold) OVER(), '0.00%') as 'MktShare'
FROM Stores

-- 2. Calcule the % of share of each store in relation to the total sales of region 
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	SUM(QtySold) OVER(PARTITION BY Region) as 'TotalSales',
	FORMAT(QtySold/SUM(QtySold) OVER(PARTITION BY Region), '0.00%') as 'MktSharebyRegion'
FROM Stores
ORDER BY ID_Store

-- CLASSIFICATION FUNCTIONS
-- 1. ROW_NUMBER: 
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	ROW_NUMBER() OVER(ORDER BY QtySold DESC) as 'RowNumber'
FROM Stores

-- 2. RANK 
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	ROW_NUMBER() OVER(ORDER BY QtySold DESC) as 'RowNumber',
	RANK() OVER(ORDER BY QtySold DESC) as 'Rank'
FROM Stores

-- 3. DENSE_RANK
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	ROW_NUMBER() OVER(ORDER BY QtySold DESC) as 'RowNumber',
	RANK() OVER(ORDER BY QtySold DESC) as 'Rank',
	DENSE_RANK() OVER(ORDER BY QtySold DESC) as 'DenseRank'
FROM Stores

-- 4. NTILE
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	ROW_NUMBER() OVER(ORDER BY QtySold DESC) as 'RowNumber',
	RANK() OVER(ORDER BY QtySold DESC) as 'Rank',
	DENSE_RANK() OVER(ORDER BY QtySold DESC) as 'DenseRank',
	NTILE(2) OVER(ORDER BY QtySold DESC) as 'Ntile'
FROM Stores

-- Using PARTITION BY with classification functions 
USE WF
SELECT
	ID_Store,
	Name_Store,
	Region,
	QtySold,
	ROW_NUMBER() OVER(PARTITION BY Region ORDER BY QtySold DESC) as 'RowNumber',
	RANK() OVER(PARTITION BY Region ORDER BY QtySold DESC) as 'Rank',
	DENSE_RANK() OVER(PARTITION BY Region ORDER BY QtySold DESC) as 'DenseRank',
	NTILE(2) OVER(PARTITION BY Region ORDER BY QtySold DESC) as 'Ntile'
FROM Stores
ORDER BY ID_Store

-- Create a table with the total sales by region and add a column with the rank

SELECT
	Region,
	SUM(QtySold) as 'TotalSales',
	RANK() OVER(ORDER BY SUM(QtySold) DESC) as 'Rank'
FROM Stores
GROUP BY Region
ORDER BY SUM(QtySold) desc

CREATE TABLE Region (Region VARCHAR(100), TotalSales INT, [Rank] INT)

INSERT INTO Region (Region, TotalSales, Rank)
SELECT
	Region,
	SUM(QtySold),
	RANK() OVER(ORDER BY SUM(QtySold) DESC)
	FROM Stores
	GROUP BY Region

SELECT * FROM Region

DROP TABLE Region

-- MOVING AVERAGE AND MOVING SUM 

CREATE TABLE Results (
	ClosingDate DATETIME,
	Month_Year VARCHAR(100),
	InvoicingMM FLOAT)

INSERT INTO Results(ClosingDate,Month_Year,InvoicingMM)
VALUES
	('01/01/2020', 'JAN-20', 8),
	('01/02/2020', 'FEB-20', 10),
	('01/03/2020', 'MAR-20', 6),
	('01/04/2020', 'APR-20', 9),
	('01/05/2020', 'MAY-20', 5),
	('01/06/2020', 'JUN-20', 4),
	('01/07/2020', 'JUL-20', 7),
	('01/08/2020', 'AUG-20', 11),
	('01/09/2020', 'SEP-20', 9),
	('01/10/2020', 'OCT-20', 12),
	('01/11/2020', 'NOV-20',11),
	('01/12/2020', 'DEC-20', 10)

SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	SUM(InvoicingMM) OVER(ORDER BY ClosingDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as 'MovingSum'
FROM Results

SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	AVG(InvoicingMM) OVER(ORDER BY ClosingDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as 'MovingAVG'
FROM Results

-- CUMULATIVE CALCULATION - UNBOUNDED
SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	SUM(InvoicingMM) OVER(ORDER BY ClosingDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'MovingSum'
FROM Results

-- FOLLOWING 
SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	SUM(InvoicingMM) OVER(ORDER BY ClosingDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as 'MovingSum'
FROM Results

-- OFFSET FUNCTIONS: LAG AND LEAD

SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	LAG(InvoicingMM,1, 0) OVER(ORDER BY ClosingDate) as 'LAG', -- PREVIOUS
	LEAD(InvoicingMM,1,0) OVER(ORDER BY ClosingDate) as 'LEAD' -- NEXT 
FROM Results

-- MONTH OVER MONTH

SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	LAG(InvoicingMM,1, 0) OVER(ORDER BY ClosingDate) as 'LAG', -- PREVIOUS
	InvoicingMM - LAG(InvoicingMM,1, 0) OVER(ORDER BY ClosingDate) as 'AbsoluteMoM',
	FORMAT((InvoicingMM/NULLIF(LAG(InvoicingMM,1) OVER(ORDER BY ClosingDate),0))-1, '0.00%') as '%MoM'
FROM Results

-- FIRST VALUE AND LAST VALUE

SELECT
	ClosingDate,
	Month_Year,
	InvoicingMM,
	FIRST_VALUE(InvoicingMM) OVER(ORDER BY ClosingDate) as 'FirstValue',
	LAST_VALUE(InvoicingMM) OVER(ORDER BY ClosingDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'LastValue'
FROM Results
ORDER BY ClosingDate
