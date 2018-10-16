CREATE PROCEDURE [bls].[usp_ProcessSeriesData] 
@SeriesId NVARCHAR(100)
AS 
BEGIN 
  SET NOCOUNT ON; 
  DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20)); 

  -- Validate SeriesId value...
  IF (ISNULL(@SeriesId, '') = '')
  BEGIN
      RAISERROR('Invalid parameter: @SeriesId cannot be NULL or empty', 18, 0)
      RETURN
  END

  IF NOT EXISTS (SELECT SeriesId FROM [bls].[SeriesReports] WHERE SeriesId = @SeriesId) 
  BEGIN
      RAISERROR('Invalid SeriesId : @SeriesId Is not in the group of supported Series', 18, 0)
      RETURN
  END

  -- Check if Series data is valid JSON
  DECLARE @DataIsValidJSON BIT 

   SELECT @DataIsValidJSON = ISJSON(SeriesData) 
   FROM [bls].[SeriesReports]
   WHERE SeriesId = @SeriesId

  IF (ISNULL(@DataIsValidJSON, 0) = 0)
  BEGIN
      RAISERROR('Data for SeriesId is not valid JSON, reload by calling API again...', 18, 0)
      RETURN
END

DECLARE @Status AS NVARCHAR(100)
DECLARE @Message AS NVARCHAR(255)

-- Check API Response status...
  SELECT 
   @Status =JSON_VALUE(SeriesData, '$.status')
 -- ,JSON_VALUE(SeriesData, '$.responseTime') AS [ResponseTime]
  , @Message = JSON_VALUE(SeriesData, '$.message') 
  --,JSON_VALUE(SeriesData, '$.Results.series[0].seriesID') AS [SeriesId]
 FROM  [bls].[SeriesReports]
 WHERE SeriesId = @SeriesId

 IF (@Status <> 'REQUEST_SUCCEEDED') 
 BEGIN 
    RAISERROR('API Status response is not REQUEST_SUCEEDED, reload data by calling API again...', 18, 0)
    RETURN
 END 
 
 BEGIN TRY 
   DECLARE @json NVARCHAR(MAX) 

   SELECT @json = SeriesData 
   FROM [bls].[SeriesReports]
   WHERE SeriesId = @SeriesId
   
   DROP TABLE IF EXISTS [bls].[Seriestemp]
  
   SELECT @SeriesId AS [SeriesId], [Year], [Period], [Value]
   INTO [bls].[Seriestemp]
   FROM OPENJSON (@json, '$.Results.series[0].data')
   WITH ([Year] INT '$.year' , [Period] NVARCHAR(25) '$.period', [Value] NVARCHAR(25) '$.value');
   
   DECLARE @SQL AS NVARCHAR(MAX)

   SELECT @SQL = '
   MERGE [bls].['+@SeriesId+'] AS Target 
   USING (SELECT [SeriesId]
            , [Year]
            , [Period]
            , [Value]
          FROM bls.SeriesTemp) AS Source 
   ON (Target.Series_Id = Source.SeriesId
       AND Target.[Year] = Source.[Year]
       AND Target.[Period] = Source.[Period])

   WHEN MATCHED THEN UPDATE SET 
     Target.[Series_Id] = Source.[SeriesId]
    ,Target.[Year] = Source.[Year]
    ,Target.[Period] = Source.[Period]
    ,Target.[Value] = Source.[Value]
   
   WHEN NOT MATCHED BY TARGET THEN INSERT
   ( [Series_Id]
    ,[Year]
    ,[Period]
    ,[Value]
   )
   VALUES 
   ( Source.[SeriesId]
    ,Source.[Year]
    ,Source.[Period]
    ,Source.[Value]
   );'
       
--PRINT @SQL
EXECUTE dbo.sp_executesql @SQL;

----DECLARE @SeriesId AS NVARCHAR(MAX) 

DECLARE @SQL2 AS NVARCHAR(MAX)

SELECT @SQL2 = N'
  UPDATE bls.SeriesReports
  SET MinPeriod = (SELECT MIN (CONCAT([Year] , REPLACE([Period],''M'','''') )) FROM [bls].['+@SeriesId+']) 
    , MaxPeriod = (SELECT MAX (CONCAT([Year] , REPLACE([Period],''M'','''') )) FROM [bls].['+@SeriesId+'])
  WHERE bls.SeriesReports.SeriesId = '''+@SeriesId+''';'

  --  PRINT @SQL2;
  
  EXECUTE dbo.sp_executesql @SQL2;

 -- OUTPUT $action INTO @SummaryOfChanges;
  
	--SELECT Change, COUNT(*) AS CountPerChange
	--FROM @SummaryOfChanges
	--GROUP BY Change;
	
END TRY 
BEGIN CATCH
  EXEC dbo.usp_GetErrorInfo;
END CATCH
END