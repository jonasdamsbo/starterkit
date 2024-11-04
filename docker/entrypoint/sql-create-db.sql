-- Create db

USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'mydb')
BEGIN
  CREATE DATABASE [mydb];
END;
GO

-- Create table

USE [mydb];
GO

--DROP TABLE IF EXISTS [dbo].[ExampleModels];
--GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ExampleModels')
BEGIN
  CREATE TABLE [dbo].[ExampleModels] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [Title] NVARCHAR(100),
    [Description] NVARCHAR(100),
    [WebUrl] NVARCHAR(100),
  );
END
GO