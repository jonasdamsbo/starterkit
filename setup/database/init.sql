USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Society')
BEGIN
  CREATE DATABASE [Society];
END;
GO

USE [Society];
GO

DROP TABLE IF EXISTS [dbo].[Friend];
GO

DROP TABLE IF EXISTS [dbo].[User];
GO

CREATE TABLE [dbo].[User] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY,
  [Email] NVARCHAR(100),
  [Password] NVARCHAR(100),
  [Name] NVARCHAR(100),
  [Description] NVARCHAR(MAX),
  [Image] IMAGE
);
GO

CREATE TABLE [dbo].[Friend] (
  [UserId] UNIQUEIDENTIFIER,
  [FriendId] UNIQUEIDENTIFIER,
  FOREIGN KEY ([UserId]) REFERENCES [dbo].[User](Id),
  FOREIGN KEY ([FriendId]) REFERENCES [dbo].[User](Id),
);
GO