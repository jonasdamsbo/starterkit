USE Society;
GO

DECLARE @counter INT = 1;
DECLARE @friendCounter int = 1;

WHILE @counter <= 100
BEGIN
    DECLARE @guid UNIQUEIDENTIFIER = NEWID();
    INSERT INTO [dbo].[User] ([Id], [Email], [Password], [Name], [Description], [Image])
    VALUES (
		@guid,
		'user' + CONVERT(VARCHAR(10), @counter) + '@example.com',
		'fakePasswordNeedsToBeSha256',
		'user' + CONVERT(VARCHAR(10), @counter),
		REPLICATE('Very long description', 10),
		'');
    SET @counter = @counter + 1;
END;

DECLARE @value UNIQUEIDENTIFIER
DECLARE db_cursor CURSOR FOR
SELECT Id FROM [dbo].[User]
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @value

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @friendId UNIQUEIDENTIFIER
    DECLARE db_cursor1 CURSOR FOR
    SELECT top 20 percent Id FROM [dbo].[User] WHERE Id != @value ORDER BY NEWID()
    OPEN db_cursor1
    FETCH NEXT FROM db_cursor1 INTO @friendId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO [dbo].[Friend] ([UserId], [FriendId])
        VALUES (
            @value,
            @friendId);
        FETCH NEXT FROM db_cursor1 INTO @friendId
    END;
    CLOSE db_cursor1;
    DEALLOCATE db_cursor1;

    FETCH NEXT FROM db_cursor INTO @value
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;