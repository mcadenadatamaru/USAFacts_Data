

CREATE VIEW [PBI].[vw_Census_USAFactsMapping] 
AS
SELECT [Census_Description]
      ,[Census_Item_Code]
      ,[Census_Type]
      ,[USAFACTS_Category_1]
      ,[USAFACTS_Category_2]
      ,[USAFACTS_Category_3]
      ,[USAFACTS_Category_4]
      ,[USAFACTS_Category_5]
      ,[USAFACTS_Memo_1]
      ,[USAFACTS_Memo_2]
      ,[USAFACTS_Memo_3]
      ,[USAFACTS_Type]
  FROM [Census].[USAFactsMapping]