CREATE PROCEDURE [PBI].[usp_10K_BalanceSheets]
@FileVersionId INT 
AS
BEGIN 
SET NOCOUNT ON; 
	BEGIN TRY 
		SELECT [RowId]
			,[FileVersionId]
			,[Category]
			,[BalanceSheets]
			,[Year]
			,[Measure]
			,[Unit]
			,[Value]
		FROM [Finance].[BalanceSheets]
		WHERE FileVersionId = @FileVersionId;
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END
