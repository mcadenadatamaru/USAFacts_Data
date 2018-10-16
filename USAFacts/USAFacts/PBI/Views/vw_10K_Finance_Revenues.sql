
CREATE VIEW [PBI].[vw_10K_Finance_Revenues]
AS

SELECT [RevenueType]
      ,[Source1]
      ,[Source2]
      ,[Source3]
      ,[Year]
      ,[Measure]
      ,[Unit]
      ,[Revenues]
  FROM [Finance].[Revenues]
  WHERE FileVersionId = 20180320;