/*====================================================================================================================================
 PURPOSE:	        Used in ELT Process to load, process and load data from staging
 PARAMETERS:		None.
 USAGE:				EXEC ELT.usp_Load_PopulationFact
 
 HISTORY: 
 Date           Description
----------------------------------------------
03/13/2018		Created
======================================================================================================================================
*/
CREATE PROCEDURE [ELT].[usp_Load_PopulationFact]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
	INSERT INTO [dbo].[FactPopulation](StateID, YearId, [Population])

	SELECT b.StateId, unpvt.[YearId], unpvt.[Population]
	FROM 
	   (SELECT [State Code], 
				  [1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989]
				 ,[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999]
				 ,[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009]
				 ,[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017]
		FROM [Staging].[PopulationDim]
		WHERE [State Code] IS NOT NULL
	   ) p
	UNPIVOT
	   ([Population] FOR [YearId] IN 
				( [1980], [1981], [1982], [1983], [1984], [1985], [1986], [1987], [1988], [1989]
				 ,[1990], [1991], [1992], [1993], [1994], [1995], [1996], [1997], [1998], [1999]
				 ,[2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007], [2008], [2009]
				 ,[2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017]
				)
	)AS unpvt
	INNER JOIN [dbo].[DimState] b ON unpvt.[State Code] = b.StateCode
	ORDER BY [YearId], [State Code];
END TRY 
BEGIN CATCH
	EXEC dbo.usp_GetErrorInfo;
END CATCH 

END
