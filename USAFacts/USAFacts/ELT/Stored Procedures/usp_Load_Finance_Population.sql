/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_Population] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_Finance_Population]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[Population]', N'U') IS NULL
	CREATE TABLE [Finance].[Population](
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
    [State][NVARCHAR](255) NULL,
    [State Code][NVARCHAR](255) NULL,
    [State Id][float] NULL,
    [Year][float] NULL,
    [Population] [float] NULL,
	  [RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_Population] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].Population AS Target
	USING (SELECT [State]
      ,[State Code]
      ,[State Id]
      ,[Year]
      ,[Population]
      ,[FileVersionId]
  	  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([State]),'')+ISNULL(RTRIM([State Code]),'')+ISNULL(RTRIM([State Id]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Population]),'')) AS RowHash
	  FROM [Staging].[Population]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[State] = Source.[State]
	   ,Target.[StateCode] = Source.[State Code]
     ,Target.[StateId] = Source.[State Id]
     ,Target.[Year] = Source.[Year]
     ,Target.[Population] = Source.[Population]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([State]
		,[StateCode]
    ,[StateId]
    ,[Year]
    ,[Population]
		,FileVersionId
		,[RowHash]
		)
		VALUES (
		 Source.[State]
		,Source.[State Code]
    ,Source.[State ID]
    ,Source.[Year]
    ,Source.[Population]
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