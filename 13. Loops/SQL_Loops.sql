-- Loops  Module 
-- Functions learned: WHILE, BREAK, CONTINUE
-- Database: ContosoRetailDW

-- Basic Structure 
-- Create a counter that counts from 1 to 10 with WHILE

DECLARE @varCounter INT
SET @varCounter = 1

WHILE @varCounter <=10
BEGIN 
	PRINT 'The Counter Value is:' + CONVERT(VARCHAR, @varCounter)
	SET @varCounter = @varCounter + 1
END

-- Infinity While 
DECLARE @varCounterInfinity INT
SET @varCounterInfinity = 1

WHILE @varCounterInfinity <=5
BEGIN 
	PRINT @varCounterInfinity
	-- SET @varCounterInfinity = @varCounterInfinity +1
END

-- BREAK 
-- Create a counter from 1 to 100, but if the value is equal to 15, the loop will have to stop

DECLARE @varCounterBreak INT
SET @varCounterBreak = 1

WHILE @varCounterBreak <= 100
BEGIN 
	PRINT @varCounterBreak
		IF @varCounterBreak = 15 
	BREAK
	SET @varCounterBreak = @varCounterBreak + 1
END

-- CONTINUE
-- Create a counter from 1 to 10 but the numbers 3 and 6 cannot be printed

DECLARE @varCounterContinue INT
SET @varCounterContinue = 0

WHILE @varCounterContinue < 10 
BEGIN 
	SET @varCounterContinue +=1
	IF @varCounterContinue = 3 OR @varCounterContinue = 6
	CONTINUE
	PRINT @varCounterContinue
END