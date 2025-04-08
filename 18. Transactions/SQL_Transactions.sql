-- Transactions Module 
-- Functions learned: BEGIN TRANSACTION, COMMIT, ROLLBACK, TRY, CATCH, TRANCOUNT
-- Database: ExercisesConstraint


-- Create an auxiliary table with dClient information
SELECT * 
INTO client_aux
FROM dClient

-- Start a transaction with COMMIT

SELECT * FROM client_aux

BEGIN TRANSACTION 
INSERT INTO client_aux(NameClient,Gender,BirthDate,CPF)
VALUES ('Maria Julia', 'F', '30/04/1995' ,'987.654.321-00')

COMMIT TRANSACTION 
ROLLBACK TRANSACTION 

BEGIN TRANSACTION
UPDATE client_aux
SET CPF = '999.999.999-99'
WHERE id_client = 1 

ROLLBACK TRANSACTION 

-- Naming a transiction
BEGIN TRANSACTION T1
INSERT INTO client_aux(NameClient,Gender,BirthDate,CPF)
VALUES ('Naldo Reis', 'M','10/02/1992', '412.889.311-90')

SELECT * FROM client_aux
COMMIT TRANSACTION T1

-- CONDITIONAL WITH COMMIT AND ROLLBACK
-- You must enter a new customer called Ruth Campos. If this name already exists, redo the transaction. If it doesn't exist, save the transaction

SELECT * FROM client_aux

DECLARE @varCount INT

BEGIN TRANSACTION Conditional1
INSERT INTO client_aux(NameClient, Gender, BirthDate, CPF)
VALUES('Ruth Campos', 'F', '23/03/1992', '324.731.903-89')

SELECT @varCount = COUNT(*) 
FROM client_aux
WHERE NameClient = 'Ruth Campos'

IF @varCount = 1
	BEGIN 
		COMMIT TRANSACTION Conditional1
		PRINT 'Ruth Campos successfully registered'
	END
ELSE
	BEGIN
		ROLLBACK TRANSACTION Conditional1
		PRINT 'Ruth Campos already exist'
	END

-- HANDLING ERRORS IN TRANSACTIONS: TRY / CATCH

BEGIN TRY
	BEGIN TRANSACTION T1
		UPDATE client_aux
		SET BirthDate = '15 de março de 1992'
		WHERE id_client = 4
	COMMIT TRANSACTION T1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T1
	PRINT 'Date invalid'
END CATCH

BEGIN TRY
	BEGIN TRANSACTION T1
		UPDATE client_aux
		SET BirthDate = '15/03/1992'
		WHERE id_client = 4
	COMMIT TRANSACTION T1
	PRINT 'Date successfully registered'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T1
	PRINT 'Date invalid'
END CATCH

SELECT * FROM client_aux

-- TRANCOUNT AND NESTED TRANSACTION

BEGIN TRANSACTION T2
BEGIN TRANSACTION T3

COMMIT TRANSACTION T1

PRINT @@TRANCOUNT

-- NESTED TRANSACTION 
BEGIN TRANSACTION T1
	PRINT @@TRANCOUNT

	BEGIN TRANSACTION T2
		PRINT @@TRANCOUNT

	COMMIT TRANSACTION T2
	PRINT @@TRANCOUNT

COMMIT TRANSACTION T1
PRINT @@TRANCOUNT


