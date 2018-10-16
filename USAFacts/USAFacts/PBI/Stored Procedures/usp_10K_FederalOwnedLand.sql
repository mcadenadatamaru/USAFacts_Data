CREATE PROCEDURE PBI.usp_10K_FederalOwnedLand
@FileVersionId INT 
AS
BEGIN 
SET NOCOUNT ON; 
	BEGIN TRY 
		SELECT [StateName]
			,[State]
			,[StateCode]
			,[BLM]
			,[FS]
			,[FWS]
			,[NPS]
			,[DOD]
			,[TotalFederalAcreage]
			,[TotalAcreageInState]
		FROM Property.FederalLand
		WHERE FileVersionId = @FileVersionId
	END TRY 
	BEGIN CATCH
		EXEC dbo.usp_GetErrorInfo;
	END CATCH
END