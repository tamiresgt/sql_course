-- Triggers DDL Module
-- Functions learned: TRIGGER DML, DML - AFTER, INSERTED, DELETED, INSTEAD OF, DISABLE, DROP
-- Database: ExercisesTriggers

-- Create a Trigger DDL

CREATE OR ALTER TRIGGER tgRefuseTable
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	PRINT 'Creating, modifying or deleting tables is not allowed'
	ROLLBACK
END


CREATE TABLE test (ID INT)

-- enable or disable a trigger

DISABLE TRIGGER tgRefuseTable ON DATABASE

ENABLE TRIGGER tgRefuseTable ON DATABASE

-- enable or disable all triggers

DISABLE TRIGGER ALL ON DATABASE

-- drop a trigger

DROP TRIGGER tgRefuseTable ON DATABASE