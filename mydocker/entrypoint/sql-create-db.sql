USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'mydb')
BEGIN
  CREATE DATABASE [mydb];
END;
GO

USE [mydb];
GO

--DROP TABLE IF EXISTS [dbo].[PortfolioProject];
--GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PortfolioProject')
BEGIN
  CREATE TABLE [dbo].[PortfolioProject] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [Title] NVARCHAR(100),
    [Description] NVARCHAR(100),
    [WebUrl] NVARCHAR(100),
  );
END
GO