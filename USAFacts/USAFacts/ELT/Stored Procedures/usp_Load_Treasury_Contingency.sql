/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Treasury_Contingency] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE   PROCEDURE [ELT].[usp_Load_Treasury_Contingency]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Treasury].[Contingency]', N'U') IS NULL
	CREATE TABLE Treasury.Contingency(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
	  [Contingencies (In billions of dollars)] [nvarchar](255) NULL,
	  [Category] [nvarchar](255) NULL,
	  [Category2] [nvarchar](255) NULL,
	  [GovernmentType] [nvarchar](255) NULL,
	  [2009] [nvarchar](255) NULL,
	  [2010] [nvarchar](255) NULL,
	  [2011] [nvarchar](255) NULL,
	  [2012] [nvarchar](255) NULL,
	  [2013] [nvarchar](255) NULL,
	  [2014] [nvarchar](255) NULL,
	  [2015] [nvarchar](255) NULL,
	  [2016] [nvarchar](255) NULL,
	  [RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_Contingency] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE Treasury.Contingency AS Target
	USING ( SELECT [Contingencies (In billions of dollars)]
            ,[Category]
            ,[Category 2]
            ,[Government Type]
            ,[2009]
            ,[2010]
            ,[2011]
            ,[2012]
            ,[2013]
            ,[2014]
            ,[2015]
            ,[2016]
            ,[FileVersionId]
            ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Contingencies (In billions of dollars)]),'')+ISNULL(RTRIM([Category]),'')+ISNULL(RTRIM([Category 2]),'')+ISNULL(RTRIM([Government Type]),'')+ISNULL(RTRIM([2009]),'')+ISNULL(RTRIM([2010]),'')+ISNULL(RTRIM([2011]),'')+ISNULL(RTRIM([2012]),'')+ISNULL(RTRIM([2013]),'')+ISNULL(RTRIM([2014]),'')+ISNULL(RTRIM([2015]),'')+ISNULL(RTRIM([2016]),'')) AS RowHash
          FROM [Staging].[Note 18]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Contingencies (In billions of dollars)] = Source.[Contingencies (In billions of dollars)]
     ,Target.[Category] = SOURCE.[Category]
     ,Target.[Category2] = SOURCE.[Category 2]
	   ,Target.[GovernmentType] = Source.[Government Type]
     ,Target.[2009] = Source.[2009]
	   ,Target.[2010] = Source.[2010]
	   ,Target.[2011] = Source.[2011]
	   ,Target.[2012] = Source.[2012]
     ,Target.[2013] = Source.[2013]
     ,Target.[2014] = Source.[2014]
     ,Target.[2015] = Source.[2015]
     ,Target.[2016] = Source.[2016]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([Contingencies (In billions of dollars)]
		,[Category]
    ,[Category2]
    ,[GovernmentType]
		,[2009]
		,[2010]
		,[2011]
		,[2012]
    ,[2013]
    ,[2014]
    ,[2015]
    ,[2016]
		,[FileVersionId]
		,[RowHash]
		)
		VALUES (
		 Source.[Contingencies (In billions of dollars)]
    ,Source.Category
    ,Source.[Category 2]
		,Source.[Government Type]
		,Source.[2009]
		,Source.[2010]
		,Source.[2011]
		,Source.[2012]
    ,Source.[2013]
		,Source.[2014]
		,Source.[2015]
		,Source.[2016]
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