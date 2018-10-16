CREATE TABLE [Finance].[Inflation] (
    [RowId]                                INT        IDENTITY (1, 1) NOT NULL,
    [FileVersionId]                        INT        NULL,
    [Year]                                 FLOAT (53) NULL,
    [InflationAdjustmentTo2015Dollars] FLOAT (53) NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Inflation] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

