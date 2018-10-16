CREATE TABLE [dbo].[DimYear] (
    [YearId]      INT        IDENTITY (1, 1) NOT NULL,
    [Population]  INT        NULL,
    [2015Dollars] FLOAT (53) NULL,
    [SortId]      INT        NULL,
    CONSTRAINT [PK_DateDim] PRIMARY KEY CLUSTERED ([YearId] ASC)
);

