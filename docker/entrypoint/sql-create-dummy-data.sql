USE mydb;
GO

IF NOT EXISTS (SELECT * FROM ExampleModels)
BEGIN

	DECLARE @counter INT = 1;

	WHILE @counter <= 100
	BEGIN
		DECLARE @guid UNIQUEIDENTIFIER = NEWID();
		INSERT INTO [dbo].[ExampleModels] ([Id], [Title], [Description], [WebUrl])
		VALUES (
			@guid,
			'title' + CONVERT(VARCHAR(10), @counter),
			REPLICATE('some description ', 3),
			'weburl' + CONVERT(VARCHAR(10), @counter) + '@example.com');
		SET @counter = @counter + 1;
	END;

	DECLARE @value UNIQUEIDENTIFIER
	DECLARE db_cursor CURSOR FOR
	SELECT Id FROM [dbo].[ExampleModels]
	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @value

	CLOSE db_cursor;
	DEALLOCATE db_cursor;

END
GO