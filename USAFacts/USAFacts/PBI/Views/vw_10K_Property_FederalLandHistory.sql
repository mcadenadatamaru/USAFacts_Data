
CREATE VIEW [PBI].[vw_10K_Property_FederalLandHistory]
AS
SELECT [StateName]
      ,[State]
      ,[StateCode]
      ,[1990]
      ,[2000]
      ,[2010]
      ,[2015]
  FROM [Property].[FederalLandHistory]
  WHERE FileVersionId = 20180320;