CREATE PROCEDURE dbo.usp_TruncateAllTables
AS

BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON; 

BEGIN TRY 

DECLARE @SQLStmt VARCHAR(8000) = N''
DECLARE @FileVersionId VARCHAR(10) = '20180630'


--Delete all data from all tables
SELECT @SQLStmt = @SQLStmt + 'TRUNCATE TABLE ' + SCHEMA_NAME(a.schema_id) + '.' +'['+ a.name + '];' + CHAR(013) 

--'DELETE FROM ' + SCHEMA_NAME(schema_id) + '.' +'['+ name + '] WHERE FileversionId = '+ @FileVersionId +';'
FROM sys.tables a
INNER JOIN sys.schemas b ON a.schema_id = b.schema_id 
WHERE b.name IN ('Staging' , 'Property', 'Finance', 'Treasury')

SET @SQLStmt = 'SET NOCOUNT ON;' + CHAR(013)  + @SQLStmt
-- EXEC (@SQLStmt)
--SET @SQLStmt = N''

PRINT @SQLStmt

END TRY 
BEGIN CATCH
  EXEC dbo.usp_GetErrorInfo;
END CATCH 
END