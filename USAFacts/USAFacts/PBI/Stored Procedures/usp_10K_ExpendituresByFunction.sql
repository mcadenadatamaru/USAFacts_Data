CREATE PROCEDURE [PBI].[usp_10K_ExpendituresByFunction]
@FileVersionId INT 
AS
BEGIN 
SET NOCOUNT ON; 
	BEGIN TRY 
		SELECT [Function]
		  ,[SubFunction]
		  ,[Year]
		  ,[Measure]
		  ,[Unit]
		  ,[Expenditures]
		FROM [Finance].[ExpendituresByFunction]
		WHERE FileVersionId = @FileVersionId;
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END
