
CREATE VIEW [PBI].[vw_10K_Finance_Population]
AS

SELECT [State]
      ,[StateCode]
      ,[StateId]
      ,[Year]
      ,[Population]
  FROM [Finance].[Population]
  WHERE FileVersionId = 20180320;