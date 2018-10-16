CREATE VIEW PBI.[vw_10K_Finance_ExpendituresByFunction]
AS
	SELECT [Function]
		  ,[SubFunction]
		  ,[Year]
		  ,[Measure]
		  ,[Unit]
		  ,[Expenditures]
		FROM [Finance].[ExpendituresByFunction]
  WHERE FileVersionId = 20180320;