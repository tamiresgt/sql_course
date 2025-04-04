-- Regex - Regular Expressions Module 
-- Functions learned: COLLATE, LIKE
-- Database: ContosoRetailDW

-- COLLATION SQL SERVER
SELECT SERVERPROPERTY('COLLATION')
--> Latin1_General_CI_AS

-- COLLATION DATA BASES 
-- Properties of DataBase has this information --> SQL_Latin1_General_CP1_CI_AS
-- You can also specify the COLLATION when creating a database

CREATE DATABASE BD_Collation
COLLATE Latin1_General_CS_AS

-- You can alter the COLLATION
ALTER DATABASE BD_Collation COLLATE Latin1_General_CI_AS

-- To find out the COLLATION of a specific database use the command

SELECT DATABASEPROPERTYEX('BD_Collation','COLLATION')

-- COLLATION TABLE/COLUMN
CREATE TABLE Names(ID INT,
				   Name VARCHAR(100) COLLATE Latin1_General_CS_AS
				   )
-- Look the COLLATION of each column
sp_help Names


-- Example
CREATE DATABASE BD_CollationExample
COLLATE Latin1_General_CI_AS

USE BD_CollationExample
CREATE TABLE [Table] ( ID INT,
					   Name VARCHAR(100) COLLATE Latin1_General_CS_AS )

INSERT INTO [Table] (ID, Name)
VALUES
		(1, 'Mateus'),
		(2, 'Marcela'),
		(3, 'marcos'),
		(4, 'MAuricio'),
		(5, 'Marta'),
		(6, 'Miranda'),
		(7, 'Melissa'),
		(8, 'Lucas'),
		(9, 'luisa'),
		(10, 'Pedro')

SELECT * FROM [Table]
WHERE Name COLLATE Latin1_General_CI_AS = 'marcela'

-- LIKE Case Sensitive

-- LIKE
SELECT * FROM [Table]
WHERE Name LIKE 'ma%'

-- Returns the lines where the first letter is m the second a and the third r
SELECT * FROM [Table]
WHERE Name LIKE '[m][a][r]%'

-- returns the lines where the first letter is M the second is a and the third is r
SELECT * FROM [Table]
WHERE Name LIKE '[M][a][r]%'

-- returns the lines where the first letter is M or m and the second is A or a
SELECT * FROM [Table]
WHERE Name LIKE '[Mm][Aa]%'

-- LIKE: FILTERS THE FIRST CHARACTERS + CASE SENSITIVE
USE BD_CollationExample
CREATE TABLE [Text] ( ID INT,
					  Text VARCHAR(100) COLLATE Latin1_General_CS_AS )

INSERT INTO [Text] (ID, Text)
VALUES
		(1, 'Marcos'),
		(2, 'Excel'),
		(3, 'leandro'),
		(4, 'K'),
		(5, 'X7'),
		(6, '19'),
		(7, '#M'),
		(8, '@9'),
		(9, 'M'),
		(10, 'RT')

SELECT * FROM [Text]

-- returns names where the first letter M, E or K

SELECT * FROM [Text]
WHERE Text LIKE '[MEK]%'

-- returns names with just one characters
SELECT * FROM [Text]
WHERE Text LIKE '[A-z]'

-- returns names with two characters
SELECT * FROM [Text]
WHERE Text LIKE '[A-z][A-z]'

-- returns names with two characters: the first with letter and the second with numbers
SELECT * FROM [Text]
WHERE Text LIKE '[A-z][0-9]'


-- LIKE WITH MORE PERSONALIZED FILTERS
-- returns names with M or m, the second character can be anything and the third is R or r
SELECT * FROM [Table]
WHERE Name LIKE '[Mm]_[Rr]%'

-- LIKE WITH NEGATION OPERATOR

-- returns names that didn't start with L or l
SELECT * FROM [Table]
WHERE Name LIKE '[^Ll]%'

-- returns names with the first letter is any letter and the second is not E or e
SELECT * FROM [Table]
WHERE Name LIKE '_[^Ee]%'


-- LIKE: FILTER SPECIAL CHARACTERS
-- Identify special characters
SELECT * FROM [Text]
WHERE Text LIKE '%[^a-z0-9]%'

-- LIKE WITH NUMBERS
USE BD_CollationExample
CREATE TABLE Numbers( Number DECIMAL(20,2))

INSERT INTO Numbers(Number)
VALUES (50), (30.23), (9), (100.54), (15.9), (6.5), (10), (501.76), (1000.56), (31)

-- return numbers with two digits in the whole part
SELECT * FROM Numbers
WHERE Number LIKE  '[0-9][0-9].[0][0]' 

/* Return lines that:
1. They have 3 digits in the whole part, with the first digit being 5
2. The first decimal number is 7
3. The second decimal number is a number between 0 and 9  */

SELECT * FROM Numbers
WHERE Number LIKE '[5][0-9][0-9].[7][0-9]'

SELECT * FROM Numbers
WHERE Number LIKE '[5]__.[7][0-9]'
