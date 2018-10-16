/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_ExpendituresByFunction] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_Finance_BalanceSheets]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[BalanceSheets]', N'U') IS NULL
	CREATE TABLE Finance.BalanceSheets(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
		[Category] [nvarchar](255) NULL,
		[BalanceSheets] [nvarchar](255) NULL,
		[Year] [float] NULL,
		[Measure] [nvarchar](255) NULL,
		[Unit] [nvarchar](255) NULL,
		[Value] [float] NULL,
		[RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_BalanceSheets] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].BalanceSheets AS Target
	USING (SELECT [Category]
			  ,[Balance sheets]
			  ,[Year]
			  ,[Measure]
			  ,[Unit]
			  ,[Value]
			  ,[FileVersionId]
			  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Category]),'')+ISNULL(RTRIM([Balance sheets]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Measure]),'')+ISNULL(RTRIM([Unit]),'')+ISNULL(RTRIM([Value]),'')) AS RowHash
			FROM [Staging].[Balance Sheets]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Category] = Source.[Category]
	   ,Target.[BalanceSheets] = Source.[Balance sheets]
	   ,Target.[Year] = Source.[Year]
	   ,Target.[Measure] = Source.[Measure]
	   ,Target.[Unit] = Source.[Unit]
	   ,Target.[Value] = Source.[Value]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([Category]
		,[BalanceSheets]
		,[Year]
		,[Measure]
		,[Unit]
		,[Value]
		,[FileVersionId]
		,[RowHash]
		)
		VALUES (
		 Source.[Category]
		,Source.[Balance sheets]
		,Source.[Year]
		,Source.[Measure]
		,Source.[Unit]
		,Source.[Value]
		,Source.[FileVersionId]
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
