/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC [ELT].[usp_Load_Property_FederalLandHistory] 20180320
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE   PROCEDURE [ELT].[usp_Load_Property_FederalLandHistory]
@FileVersionId INT 
AS
BEGIN 

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

-- Prepare destination tables
IF OBJECT_ID(N'[Property].[FederalLandHistory]', N'U') IS NULL
	CREATE TABLE [Property].[FederalLandHistory](
		[RowId] [int] IDENTITY(1,1) NOT NULL,
		[FileVersionId] [int] NULL,
		[StateName] [nvarchar](255) NULL,
		[State] [nvarchar](255) NULL,
		[StateCode] [nvarchar](255) NULL,
		[1990] [float] NULL,
		[2000] [float] NULL,
		[2010] [float] NULL,
		[2015] [float] NULL,
	 CONSTRAINT [PK_FederalLandHistory] PRIMARY KEY CLUSTERED 
	(
		[RowId] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

-- Load data from Staging

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

SET IDENTITY_INSERT dbo.DimYear ON;
	MERGE [Property].[FederalLandHistory] AS Target
	USING (SELECT [State Name]
				,[State ]
				,[State Code]
				,[1990]
				,[2000]
				,[2010]
				,[2015]
				,[FileVersionId]
        ,HASHBYTES('SHA2_256', ISNULL(RTRIM([State Name]),'')+ISNULL(RTRIM([State ]),'')+ISNULL(RTRIM([State Code]),'')+
                               ISNULL(RTRIM([1990]),'')+ISNULL(RTRIM([2000]),'')+ISNULL(RTRIM([2010]),'')+
                               ISNULL(RTRIM([2015]),'')) AS RowHash
			FROM [Staging].[Federal land ownership changes] 
		  ) AS SOURCE
		ON (Target.FileVersionId = Source.FileVersionId 
		 AND Target.RowHash = Source.RowHash)
		
	WHEN MATCHED THEN UPDATE SET 
	    Target.[State] = Source.[State ]
	   ,Target.[StateCode] = Source.[State Code]
	   ,Target.[1990] = Source.[1990]
	   ,Target.[2000] = Source.[2000]
	   ,Target.[2010] = Source.[2010]
	   ,Target.[2015] = Source.[2015]
	 
	WHEN NOT MATCHED BY TARGET THEN INSERT
		([StateName]
		,[State]
		,[StateCode]
		,[1990]
		,[2000]
		,[2010]
		,[2015]
		,[FileVersionId]
    ,[RowHash]
		)
		VALUES (
		 Source.[State Name]
		,Source.[State ]
		,Source.[State Code]
		,Source.[1990]
		,Source.[2000]
		,Source.[2010]
		,Source.[2015]
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

