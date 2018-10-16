/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_Revenues] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_Finance_Revenues]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[Revenues]', N'U') IS NULL
	CREATE TABLE [Finance].Revenues(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
	  [RevenueType] [nvarchar](255) NULL,
	  [Source1] [nvarchar](255) NULL,
	  [Source2] [nvarchar](255) NULL,
	  [Source3] [nvarchar](255) NULL,
	  [Year] [float] NULL,
	  [Measure] [nvarchar](255) NULL,
	  [Unit] [nvarchar](255) NULL,
	  [Revenues] [float] NULL,
	  [RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_Revenues] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].Revenues AS Target
	USING (SELECT [Revenue type]
      ,[Source 1]
      ,[Source 2]
      ,[Source 3]
      ,[Year]
      ,[Measure]
      ,[Unit]
      ,[Revenues]
      ,[FileVersionId]
      ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Revenue type]),'')+ISNULL(RTRIM([Source 1]),'')+ISNULL(RTRIM([Source 2]),'')+ISNULL(RTRIM([Source 3]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Measure]),'')
                                                             +ISNULL(RTRIM([Unit]),'') +ISNULL(RTRIM([Revenues]),'')) AS RowHash
  FROM [Staging].[Revenues]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[RevenueType] = Source.[Revenue type]
	   ,Target.[Source1] = Source.[Source 1]
     ,Target.[Source2] = Source.[Source 2]
     ,Target.[Source3] = Source.[Source 3]
     ,Target.[Year] = Source.[Year]
     ,Target.[Measure] = Source.[Measure]
     ,Target.[Unit] = Source.[Unit]
     ,Target.[Revenues] = Source.[Revenues]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([RevenueType]
		,[Source1]
    ,[Source2]
    ,[Source3]
    ,[Year]
    ,[Measure]
    ,[Unit]
    ,[Revenues]
		,FileVersionId
		,[RowHash]
		)
		VALUES (
		 Source.[Revenue type]
		,Source.[Source 1]
    ,Source.[Source 2]
    ,Source.[Source 3]
    ,Source.[Year]
    ,Source.[Measure]
    ,Source.[Unit]
    ,Source.[Revenues]
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