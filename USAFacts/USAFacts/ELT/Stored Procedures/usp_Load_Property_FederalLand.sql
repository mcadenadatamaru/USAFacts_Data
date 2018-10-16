/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Property_FederalLand] <20180320>
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE   PROCEDURE [ELT].[usp_Load_Property_FederalLand]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Property].[FederalLand]', N'U') IS NULL
	CREATE TABLE [Property].FederalLand(
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NULL,
		[StateName] [nvarchar](255) NULL,
		[State] [nvarchar](255) NULL,
		[StateCode] [nvarchar](255) NULL,
		[BLM] [float] NULL,
		[FS] [float] NULL,
		[FWS] [float] NULL,
		[NPS] [float] NULL,
		[DOD] [float] NULL,
		[TotalFederalAcreage] [float] NULL,
		[TotalAcreageInState] [float] NULL,
 CONSTRAINT [PK_FederalLand] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

SET IDENTITY_INSERT dbo.DimYear ON;
	MERGE [Property].[FederalLand] AS Target
	USING (SELECT [State Name]
			  ,[State ]
			  ,[State Code]
			  ,[BLM]
			  ,[FS]
			  ,[FWS]
			  ,[NPS]
			  ,[DOD]
			  ,[Total Federal Acreage]
			  ,[Total Acreage in State]
			  ,[FileVersionId]
        ,HASHBYTES('SHA2_256', ISNULL(RTRIM([State Name]),'')+ISNULL(RTRIM([State ]),'')+ISNULL(RTRIM([State Code]),'')
                              +ISNULL(RTRIM([BLM]),'')+ISNULL(RTRIM([FS]),'')+ISNULL(RTRIM([FWS]),'')
                              +ISNULL(RTRIM([NPS]),'')+ISNULL(RTRIM([DOD]),'')+ISNULL(RTRIM([Total Federal Acreage]),'')
                              +ISNULL(RTRIM([Total Acreage in State]),'')) AS RowHash
		  FROM [Staging].[Federal owned land]
		  ) AS SOURCE
		ON (Target.FileVersionId = Source.FileVersionId 
		 AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[State] = Source.[State ]
	   ,Target.[StateCode] = Source.[State Code]
	   ,Target.[BLM] = Source.[BLM]
	   ,Target.[FS] = Source.[FS]
	   ,Target.[FWS] = Source.[FWS]
	   ,Target.[NPS] = Source.[NPS]
	   ,Target.[DOD] = Source.[DOD]
	   ,Target.[TotalFederalAcreage] = Source.[Total Federal Acreage]
	   ,Target.[FileVersionId] = Source.[FileVersionId]
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([StateName]
		,[State]
		,[StateCode]
		,[BLM]
		,[FS]
		,[FWS]
		,[NPS]
		,[DOD]
		,[TotalFederalAcreage]
		,[TotalAcreageInState]
		,[FileVersionId]
    ,[RowHash]
		)
		VALUES (
		 Source.[State Name]
		,Source.[State ]
		,Source.[State Code]
		,Source.[BLM]
		,Source.[FS]
		,Source.[FWS]
		,Source.[NPS]
		,Source.[DOD]
		,Source.[Total Federal Acreage]
		,Source.[Total Acreage in State]
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
