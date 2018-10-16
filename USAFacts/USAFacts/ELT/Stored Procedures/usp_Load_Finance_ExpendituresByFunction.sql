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
CREATE   PROCEDURE [ELT].[usp_Load_Finance_ExpendituresByFunction]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[ExpendituresByFunction]', N'U') IS NULL
	CREATE TABLE Finance.ExpendituresByFunction(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NULL,
		[Function] [nvarchar](255) NULL,
		[SubFunction] [nvarchar](255) NULL,
		[Year] [float] NULL,
		[Measure] [nvarchar](255) NULL,
		[Unit] [nvarchar](255) NULL,
		[Expenditures] [float] NULL,
		[RowHash] [Varbinary] (max) NULL,
	 CONSTRAINT [PK_ExpendituresByFunction] PRIMARY KEY CLUSTERED 
	(
		[RowId] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].ExpendituresByFunction AS Target
	USING (SELECT [Function]
			  ,[Sub function]
			  ,[Year]
			  ,[Measure]
			  ,[Unit]
			  ,[Expenditures ]
			  ,FileVersionId AS FileVersionId
			  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Function]),'')+ISNULL(RTRIM([Sub function]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Measure]),'')+ISNULL(RTRIM([Unit]),'')+ISNULL(RTRIM([Expenditures ]),'')) AS RowHash
		   FROM [Staging].[Expenditures by function]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Function] = Source.[Function]
	   ,Target.[SubFunction] = Source.[Sub function]
	   ,Target.[Year] = Source.[Year]
	   ,Target.[Measure] = Source.[Measure]
	   ,Target.[Unit] = Source.[Unit]
	   ,Target.[Expenditures] = Source.[Expenditures ]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([Function]
		,[SubFunction]
		,[Year]
		,[Measure]
		,[Unit]
		,[Expenditures]
		,[FileVersionId]
		,[RowHash]
		)
		VALUES (
		 Source.[Function]
		,Source.[Sub function]
		,Source.[Year]
		,Source.[Measure]
		,Source.[Unit]
		,Source.[Expenditures ]
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
