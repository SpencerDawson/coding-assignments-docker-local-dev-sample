-- Function for checking if file exists.
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_FileExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
    PRINT 'Creating function "fn_FileExists".'
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'
    CREATE FUNCTION dbo.fn_FileExists(@path varchar(512))
    RETURNS BIT
    AS
    BEGIN
        DECLARE @result INT
        EXEC master.dbo.xp_fileexist @path, @result OUTPUT
        RETURN cast(@result as bit)
    END'
    EXEC sp_executesql @sql
END
ELSE
BEGIN
    PRINT 'Function "fn_FileExists" already exists.'
END
GO

-- Variable for backup file to be used on initialization.
DECLARE @backup VARCHAR(512);
SET @backup = '/var/opt/mssql/backup/DB1.bak'

-- Message and Error variables.
DECLARE @msg VARCHAR(512);
DECLARE @err VARCHAR(512);

-- Check if file exists. If not, raise error and terminate. Backup file must exist in container, whether copied or mapped.
IF (dbo.fn_FileExists(@backup) = 'true')
BEGIN
    -- Check if database exists. If not, run restore from .bak file.
    IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DB1')
    BEGIN
        RESTORE DATABASE DB1 FROM DISK=@backup WITH  
        MOVE 'DB1' to '/var/opt/mssql/data/DB1.mdf',  
        MOVE 'DB1_log' to '/var/opt/mssql/data/DB1_log.ldf'
        SET @msg = 'Database DB1 restored.'
        PRINT @msg
    END
    ELSE
    BEGIN
        SET @msg = 'Databse DB1 already exists.'
        PRINT @msg
    END
END
ELSE
BEGIN
    SET @err = CONCAT('bak file "',@backup,'" does not exist.')
    RAISERROR(@err, 10, -1) with log
END

-- Check if DBs exists. If not, create it.
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DB2')
BEGIN
    CREATE DATABASE [DB2]
    SET @msg = 'Databse DB2 created.'
    PRINT @msg
END
ELSE
BEGIN
    SET @msg = 'Databse DB2 already exists.'
    PRINT @msg
END
GO
