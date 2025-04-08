-- Sequences Module 
-- Functions learned: SEQUENCE, START WITH, INCREMENT BY, MAXVALUE, MINVALUE, CYCLE, SELECT NEXT VALUE FOR, DROP SEQUENCE
-- Database: Exercises

-- Create a sequence for id_client

CREATE SEQUENCE client_seq
AS INT
START WITH 1
INCREMENT BY 1 
NO MAXVALUE
NO CYCLE

-- Next value 

SELECT NEXT VALUE FOR client_seq

-- Delete sequence
DROP SEQUENCE client_seq

-- Create a sequence for id_project

CREATE SEQUENCE project_seq
AS INT
START WITH 1
INCREMENT BY 1
NO MAXVALUE
NO CYCLE

CREATE TABLE dProject (
	id_project INT,
	name_project VARCHAR(100) NOT NULL,
	CONSTRAINT dAreas_id_area_pk PRIMARY KEY(id_project))

INSERT INTO dProject (id_project,name_project)
VALUES (NEXT VALUE FOR project_seq, 'Strategic Planning'),
	   (NEXT VALUE FOR project_seq, 'App Development'),
	   (NEXT VALUE FOR project_seq, 'Business Plan'),
	   (NEXT VALUE FOR project_seq, '3D Visualization')

SELECT * FROM dProject