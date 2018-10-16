CREATE PROCEDURE [PBI].[usp_10K_GovermentFinance]
@FileVersionId INT 
AS
BEGIN 
SET NOCOUNT ON; 
	BEGIN TRY 
	SELECT [GovernmentType]
		  ,[StateCode]
		  ,[Type]
		  ,[Source]
		  ,[Grant]
		  ,[CensusCode]
		  ,[CensusDescription]
		  ,[Segment1]
		  ,[Segment2]
		  ,[Segment3]
		  ,[Segment4]
		  ,[Year]
		  ,[Measure]
		  ,[Unit]
		  ,[Value]
	  FROM [Finance].[GovermentFinance]
	  WHERE FileVersionId = @FileVersionId;

END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END

