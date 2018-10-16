﻿/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_ExpendituresBySegment] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE  PROCEDURE [ELT].[usp_Load_Finance_ExpendituresBySegment]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[ExpendituresBySegment]', N'U') IS NULL
	CREATE TABLE Finance.ExpendituresBySegment(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
		[Segment1] [nvarchar](255) NULL,
		[Segment2] [nvarchar](255) NULL,
		[Segment3] [nvarchar](255) NULL,
		[Segment4] [nvarchar](255) NULL,
		[Year] [float] NULL,
		[Measure] [nvarchar](255) NULL,
		[Unit] [nvarchar](255) NULL,
		[Expenditures] [float] NULL,
		[RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_ExpendituresBySegment] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].ExpendituresBySegment AS Target
	USING (SELECT [Segment 1]
			  ,[Segment 2]
			  ,[Segment 3]
			  ,[Segment 4]
			  ,[Year]
			  ,[Measure]
			  ,[Unit]
			  ,[Expenditures ]
			  ,[FileVersionId]
			  ,HASHBYTES ('SHA2_256', ISNULL(RTRIM([Segment 1]),'')+ISNULL(RTRIM([Segment 2]),'')+ISNULL(RTRIM([Segment 3]),'')+ISNULL(RTRIM([Segment 4]),'')+ISNULL(RTRIM(Year),'')+ISNULL(RTRIM(Measure),'')+ISNULL(RTRIM(Unit),'')+ISNULL(RTRIM([Expenditures ]),'')) as RowHash
	FROM [Staging].[Expenditures by segment]
		  ) AS SOURCE
		ON (Target.FileVersionId = Source.FileVersionId 
			AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Segment1] = Source.[Segment 1]
	   ,Target.[Segment2] = Source.[Segment 2]
	   ,Target.[Segment3] = Source.[Segment 3]
	   ,Target.[Segment4] = Source.[Segment 4]
	   ,Target.[Year] = Source.[Year]
	   ,Target.[Measure] = Source.[Measure]
	   ,Target.[Unit] = Source.[Unit]
	   ,Target.[Expenditures] = Source.[Expenditures ]
	   ,Target.FileversionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
			([Segment1]
			,[Segment2]
			,[Segment3]
			,[Segment4]
			,[Year]
			,[Measure]
			,[Unit]
			,[Expenditures]
			,[FileVersionId]
			,[RowHash]
		)
		VALUES (
			 Source.[Segment 1]
			,Source.[Segment 2]
			,Source.[Segment 3]
			,Source.[Segment 4]
			,Source.[Year]
			,Source.[Measure]
			,Source.[Unit]
			,Source.[Expenditures ]
			,Source.[FileVersionId]
			,Source.RowHash
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