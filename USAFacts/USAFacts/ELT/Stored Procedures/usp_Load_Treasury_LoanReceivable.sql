﻿/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Treasury_LoanReceivable] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE   PROCEDURE [ELT].[usp_Load_Treasury_LoanReceivable]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Treasury].[LoanReceivable]', N'U') IS NULL
	CREATE TABLE Treasury.LoanReceivable(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
	  [Loans Receivable and Mortgage-Backed Securities, Net (In billion] [NVARCHAR](255) NULL,
	  [Category] [nvarchar](255) NULL,
	  [GovernmentType] [nvarchar](255) NULL,
	  [2009] [float] NULL,
	  [2010] [float] NULL,
	  [2011] [float] NULL,
	  [2012] [float] NULL,
	  [2013] [float] NULL,
	  [2014] [float] NULL,
	  [2015] [float] NULL,
	  [2016] [float] NULL,
	  [RowHash] [varbinary](MAX) NULL,
 CONSTRAINT [PK_Note4] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE Treasury.LoanReceivable AS Target
	USING ( SELECT [Loans Receivable and Mortgage-Backed Securities, Net (In billion]
            ,[Category]
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
            ,HASHBYTES ('SHA2_256', ISNULL(RTRIM([Loans Receivable and Mortgage-Backed Securities, Net (In billion]),'')+ISNULL(RTRIM([Category]),'')+ISNULL(RTRIM([Government Type]),'')+ISNULL(RTRIM([2009]),'')+ISNULL(RTRIM([2010]),'')+ISNULL(RTRIM([2011]),'')+ISNULL(RTRIM([2012]),'')+ISNULL(RTRIM([2013]),'')+ISNULL(RTRIM([2014]),'')+ISNULL(RTRIM([2015]),'')+ISNULL(RTRIM([2016]),'')) AS RowHash
          FROM [Staging].[Note 4]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[Loans Receivable and Mortgage-Backed Securities, Net (In billion] = Source.[Loans Receivable and Mortgage-Backed Securities, Net (In billion]
     ,Target.[Category] = Source.[Category]
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
		([Loans Receivable and Mortgage-Backed Securities, Net (In billion]
    ,[Category]
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
		 Source.[Loans Receivable and Mortgage-Backed Securities, Net (In billion]
    ,Source.Category
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