/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Finance_GovermentFinance] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE   PROCEDURE [ELT].[usp_Load_Finance_GovermentFinance]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[GovermentFinance]', N'U') IS NULL
	CREATE TABLE [Finance].[GovermentFinance](
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NOT NULL,
		[GovernmentType] [nvarchar](255) NULL,
		[StateCode] [float] NULL,
		[Type] [nvarchar](255) NULL,
		[Source] [nvarchar](255) NULL,
		[Grant] [nvarchar](255) NULL,
		[CensusCode] [nvarchar](255) NULL,
		[CensusDescription] [nvarchar](255) NULL,
		[Segmen1] [nvarchar](255) NULL,
		[Segment2] [nvarchar](255) NULL,
		[Segment3] [nvarchar](255) NULL,
		[Segment4] [nvarchar](255) NULL,
		[Year] [float] NULL,
		[Measure] [nvarchar](255) NULL,
		[Unit] [nvarchar](255) NULL,
		[Value] [float] NULL,
		[RowHash] [varbinary](max) NULL,
 CONSTRAINT [PK_GovermentFinance] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

	MERGE [Finance].GovermentFinance AS Target
	USING (SELECT [Government Type]
				  ,[State code]
				  ,[Type]
				  ,[Source]
				  ,[Grant]
				  ,[Census code]
				  ,[Census description]
				  ,[Segment 1]
				  ,[Segment 2]
				  ,[Segment 3]
				  ,[Segment 4]
				  ,[Year]
				  ,[Measure]
				  ,[Unit]
				  ,[Value ]
				  ,[FileVersionId]
				  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Government Type]),'')+ISNULL(RTRIM([State code]),'')+ISNULL(RTRIM([Type]),'')+ISNULL(RTRIM(Source),'')+ISNULL(RTRIM([Grant]),'')+ISNULL(RTRIM([Census code]),'')+ISNULL(RTRIM([Census description]),'')+ISNULL(RTRIM([Segment 1]),'')+ISNULL(RTRIM([Segment 2]),'')+ISNULL(RTRIM([Segment 3]),'')+ISNULL(RTRIM([Segment 4]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Measure]),'')+ISNULL(RTRIM([Unit]),'')+ISNULL(RTRIM([Value ]),'')) AS RowHash
			FROM [Staging].[Federal and S&L government P&L]
		   ) AS Source
		ON (Target.FileVersionId = Source.FileVersionId
				AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[GovernmentType] = Source.[Government Type]
	   ,Target.[StateCode] = Source.[State code]
	   ,Target.[Type] = Source.[Type]
	   ,Target.[Source] = Source.[Source]
	   ,Target.[Grant] = Source.[Grant]
	   ,Target.[CensusCode] = Source.[Census code]
	   ,Target.[CensusDescription] = Source.[Census description]
	   ,Target.[Segment1] = Source.[Segment 1]
	   ,Target.[Segment2] = Source.[Segment 2]
	   ,Target.[Segment3] = Source.[Segment 3]
	   ,Target.[Segment4] = Source.[Segment 4]
	   ,Target.[Year] = Source.[Year]
	   ,Target.[Measure] = Source.[Measure]
	   ,Target.[Unit] = Source.[Unit]
	   ,Target.[Value] = Source.[Value ]
	   ,Target.FileVersionId = Source.FileVersionId
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([GovernmentType]
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
		,FileVersionId
		,[RowHash]
		)
		VALUES (
		 Source.[Government Type]
		,Source.[State Code]
		,Source.[Type]
		,Source.[Source]
		,Source.[Grant]
		,Source.[Census Code]
		,Source.[Census Description]
		,Source.[Segment 1]
		,Source.[Segment 2]
		,Source.[Segment 3]
		,Source.[Segment 4]
		,Source.[Year]
		,Source.[Measure]
		,Source.[Unit]
		,Source.[Value ]
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