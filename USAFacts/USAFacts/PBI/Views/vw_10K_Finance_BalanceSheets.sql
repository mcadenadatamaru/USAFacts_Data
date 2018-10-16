
CREATE VIEW [PBI].[vw_10K_Finance_BalanceSheets]
AS
SELECT        Category, BalanceSheets, Year, Measure, Unit, Value
FROM            Finance.BalanceSheets
WHERE        (FileVersionId = 20180320)