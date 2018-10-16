/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_YearDim]
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_YearDim]
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

SET IDENTITY_INSERT dbo.DimYear ON;
	MERGE dbo.DimYear AS Target
	USING (SELECT CAST([Year] AS INT) as [Year]
			,CAST([Population] AS INT) AS [Population]
			,[2015 Dollars]
			,CAST([SortId] AS INT) AS [SortId]
		   FROM [Staging].[YearDim]
		  ) AS Source
		ON (Target.YearId = Source.[Year] )
		
	
	WHEN MATCHED THEN UPDATE SET 
		Target.[Population] = Source.[Population]
	   ,Target.[2015Dollars] = Source.[2015 Dollars]
	   ,Target.[SortId] = Source.[SortId]
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([YearId]
		,[Population]
		,[2015Dollars]
		,[SortId]
		)
		VALUES (
		 Source.[Year]
		,Source.[Population]
		,Source.[2015 Dollars]
		,Source.[SortId]
		)

	OUTPUT $action INTO @SummaryOfChanges;
  
  SET IDENTITY_INSERT dbo.DimYear OFF;

	SELECT Change, COUNT(*) AS CountPerChange
	FROM @SummaryOfChanges
	GROUP BY Change;
	
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END
