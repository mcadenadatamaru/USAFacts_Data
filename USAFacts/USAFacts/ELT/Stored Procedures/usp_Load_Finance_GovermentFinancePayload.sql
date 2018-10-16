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
CREATE PROCEDURE [ELT].[usp_Load_Finance_GovermentFinancePayload]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Finance].[GovermentFinancePayload]', N'U') IS NULL
	CREATE TABLE [Finance].[GovermentFinancePayload](
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
 CONSTRAINT [PK_GovermentFinancePayload] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC, FileVersionId
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- Load data from Staging

--DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

--	MERGE [Finance].[GovermentFinancePayload] AS Target
--	USING (SELECT  [Source]
--				  ,[Segment1]
--				  ,[Segment2]
--				  ,[Segment3]
--				  ,[Segment4]
--				  ,[Segment5]
--				  ,[Memo1]
--				  ,[Memo2]
--				  ,[Memo3]
--				  ,[StateCode]
--				  ,[GovernmentTypeID]
--				  ,[Year]
--				  ,[Chargeable]
--				  ,[Value]
--				  ,[Measure]
--				  ,[Unit]
--				  ,[FileVersionId]
--				  ,HASHBYTES('SHA2_256', ISNULL(RTRIM([Source]),'')+ISNULL(RTRIM([Segment1]),'')+ISNULL(RTRIM([Segment2]),'')+ISNULL(RTRIM([Segment3]),'')+ISNULL(RTRIM([Segment4]),'')+ISNULL(RTRIM([Segment5]),'')+ISNULL(RTRIM([Memo1]),'')+ISNULL(RTRIM([Memo2]),'')+ISNULL(RTRIM([Memo3]),'')+ISNULL(RTRIM([StateCode]),'')+ISNULL(RTRIM([GovernmentTypeID]),'')+ISNULL(RTRIM([Year]),'')+ISNULL(RTRIM([Value]),'')++ISNULL(RTRIM([Chargeable]),'')) AS RowHash
--			FROM [Staging].[Finance_GovermentFinancePayload]
--		   ) AS Source
--		ON (Target.FileVersionId = Source.FileVersionId
--				AND Target.RowHash = Source.RowHash)
		
--	WHEN MATCHED THEN UPDATE SET 
--	    Target.[Source] = Source.[Source]
--	   ,Target.[Segment1] = Source.[Segment1]
--	   ,Target.[Segment2] = Source.[Segment2]
--	   ,Target.[Segment3] = Source.[Segment3]
--	   ,Target.[Segment4] = Source.[Segment4]
--	   ,Target.[Segment5] = Source.[Segment5]
--	   ,Target.[Memo1] = Source.[Memo1]
--	   ,Target.[Memo2] = Source.[Memo2]
--	   ,Target.[StateCode] = Source.[StateCode]
--	   ,Target.[GovernmentTypeID] = Source.[GovernmentTypeID]
--	   ,Target.[Year] = Source.[Year]
--	   ,Target.[Chargeable] = Source.[Chargeable]
--	   ,Target.[Value] = Source.[Value]
--	   ,Target.[Measure] = Source.[Measure]
--	   ,Target.[Unit] = Source.[Unit]
--	   ,Target.FileVersionId = Source.FileVersionId
	 
--	WHEN NOT MATCHED BY TARGET THEN INSERT
--		([GovernmentType]
--		,[StateCode]
--		,[Type]
--		,[Source]
--		,[Grant]
--		,[CensusCode]
--		,[CensusDescription]
--		,[Segment1]
--		,[Segment2]
--		,[Segment3]
--		,[Segment4]
--		,[Year]
--		,[Measure]
--		,[Unit]
--		,[Value]
--		,FileVersionId
--		,[RowHash]
--		)
--		VALUES (
--		 Source.[Government Type]
--		,Source.[State Code]
--		,Source.[Type]
--		,Source.[Source]
--		,Source.[Grant]
--		,Source.[Census Code]
--		,Source.[Census Description]
--		,Source.[Segment 1]
--		,Source.[Segment 2]
--		,Source.[Segment 3]
--		,Source.[Segment 4]
--		,Source.[Year]
--		,Source.[Measure]
--		,Source.[Unit]
--		,Source.[Value ]
--		,Source.FileVersionId
--		,Source.[RowHash]
--		)

--	OUTPUT $action INTO @SummaryOfChanges;
  
--	SELECT Change, COUNT(*) AS CountPerChange
--	FROM @SummaryOfChanges
--	GROUP BY Change;
	
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH
END