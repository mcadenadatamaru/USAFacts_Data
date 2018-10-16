
CREATE PROCEDURE [Census].[usp_FinanceDataCheck]
AS
SET NOCOUNT ON;
BEGIN
BEGIN TRY 

  DECLARE @StringVariable NVARCHAR(50);
  SET @StringVariable = N'Error: Data mistmatch!! - Investigate.';  
    
  DECLARE @temp TABLE (
                        [Year_Of_Data] INT
                       ,RowCnt INT
                       ,[Amount_Thousands_Dollars] BIGINT
                      )
  INSERT INTO @temp VALUES (2012,1739436,19943228863)
                          ,(2013,654996,20057090024)
						              ,(2014,653017,20721647738)
                          ,(2015,652703,20876614112)
  SELECT * FROM @temp
  EXCEPT
  SELECT [Year_Of_Data]
    , COUNT(*) AS RowCnt
    , SUM(CONVERT(BIGINT,[Amount_Thousands_Dollars])) AS [Amount_Thousands_Dollars]
    FROM Census.Finance2
    GROUP BY [Year_of_Data]
    ORDER BY [Year_of_Data];

    IF @@ROWCOUNT >= 1
    BEGIN
      RAISERROR (@StringVariable, -- Message text.  
           10, -- Severity,  
           1, -- State,  
           N'');  

    RETURN 1;
    END
END TRY 
BEGIN CATCH
  EXEC dbo.usp_GetErrorInfo;
END CATCH
END