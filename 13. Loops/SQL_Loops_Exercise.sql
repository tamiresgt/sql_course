-- Loops  Exercises 
-- Functions learned: WHILE, BREAK, CONTINUE
-- Database: ContosoRetailDW

/* 1. Use the While Loop to create a counter that starts at an initial value @InitialValue and
ends at a final value @FinalValue. You should print the following sentence on the screen:
“The counter value is: “ + ___ */

DECLARE @InitialValue INT,
		@FinalValue INT
SET @InitialValue = 0
SET @FinalValue = 10

WHILE @InitialValue <= @FinalValue
BEGIN
	PRINT 'The counter value is: ' + CONVERT(VARCHAR, @InitialValue)
	SET @InitialValue += 1
END

/* 2. You must create a repeating structure that prints the number of hires for each year, from 1996 to 2003. 
The hire date information is found in the HireDate column of the DimEmployee table. 
Use the format: 
X hires in 1996 
Y hires in 1997 
Z hires in 1998 ... ...
N hires in 2003 
Note: the HireDate column contains the full date (dd/mm/yyyy). 
Remember that you must print the number of hires per year. */ 

DECLARE @FirstYear INT = 1996,
		@LastYear INT = 2003

WHILE @FirstYear <= @LastYear
BEGIN
	DECLARE @QtyEmployees INT = (SELECT COUNT(*) FROM DimEmployee
								 WHERE YEAR(HireDate) = @FirstYear)
	PRINT CONCAT(@QtyEmployees, ' hires in ', @FirstYear)
	SET @FirstYear += 1
END

/* 3. Use a While Loop to create a table called Calendar, containing a column that
starts with the date 01/01/2021 and goes through 12/31/2021. */

CREATE TABLE Calendar (Date DATE)

DECLARE @varCalendarStart DATETIME = '01/01/2021',
		@varCalendarEnd DATETIME = '31/12/2021'

WHILE @varCalendarStart <= @varCalendarEnd
BEGIN
	INSERT INTO Calendar (Date) VALUES (@varCalendarStart)
	SET @varCalendarStart = DATEADD(DAY,1,@varCalendarStart)
END

SELECT * FROM Calendar
DROP TABLE Calendar