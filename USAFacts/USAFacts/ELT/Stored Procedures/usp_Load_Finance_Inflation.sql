/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_Inflation] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_Finance_Inflation]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[Inflation]', N'U') IS NULL
	CREATE TABLE [Finance].[Inflation](
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
  	[Year] [float] NULL,
	  [InflationAdjustmentTo2015Dollars] [float] NULL,
	  [RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_Inflation] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].Inflation AS Target
	USING (SELECT [Year]
      ,[Inflation adjustment to 2015 dollars]
      ,[FileVersionId]
  	  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Inflation adjustment to 2015 dollars]),'')) AS RowHash
	  FROM [Staging].[Inflation]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Year] = Source.[Year]
	   ,Target.[InflationAdjustmentTo2015Dollars] = Source.[Inflation adjustment to 2015 dollars]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([Year]
		,[InflationAdjustmentTo2015Dollars]
		,FileVersionId
		,[RowHash]
		)
		VALUES (
		 Source.[Year]
		,Source.[Inflation adjustment to 2015 dollars]
		,Source.FileVersionId
		,Source.[RowHash]
		)

	OUTPUT $action INTO @SummaryOfChanges;
  
	SELECT Change, COUNT(*) AS CountPerChange
	FROM @SummaryOfChanges
	GROUP BY Change;
	
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END