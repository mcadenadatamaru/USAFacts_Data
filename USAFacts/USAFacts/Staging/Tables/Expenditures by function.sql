CREATE TABLE [Staging].[Expenditures by function] (
    [Function]      NVARCHAR (255) NULL,
    [Sub function]  NVARCHAR (255) NULL,
    [Year]          FLOAT (53)     NULL,
    [Measure]       NVARCHAR (255) NULL,
    [Unit]          NVARCHAR (255) NULL,
    [Expenditures ] FLOAT (53)     NULL, 
    [FileVersionId] INT NULL
);

