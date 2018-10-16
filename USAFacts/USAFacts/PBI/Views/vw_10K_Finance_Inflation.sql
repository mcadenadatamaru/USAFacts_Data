
CREATE VIEW [PBI].[vw_10K_Finance_Inflation]
AS
SELECT [Year]
      ,[InflationAdjustmentTo2015Dollars]
  FROM [Finance].[Inflation]
  WHERE FileVersionId = 20180320;