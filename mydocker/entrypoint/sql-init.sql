USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'testdb')
BEGIN

-- create db
	CREATE DATABASE [testdb];
	USE [testdb];
	
	DROP TABLE IF EXISTS [dbo].[test];
	
	CREATE TABLE [dbo].[test] (
	  [id] UNIQUEIDENTIFIER PRIMARY KEY,
	  [name] NVARCHAR(100)
	);

-- create dummy data
	USE testdb;

	DECLARE @counter INT = 1;

	WHILE @counter <= 10
	BEGIN
		DECLARE @guid UNIQUEIDENTIFIER = NEWID();
		INSERT INTO [dbo].[test] ([id], [name])
		VALUES (
			@guid,
			'name' + CONVERT(VARCHAR(10), @counter) + '@example.com');
		SET @counter = @counter + 1;
	END;

END;
GO