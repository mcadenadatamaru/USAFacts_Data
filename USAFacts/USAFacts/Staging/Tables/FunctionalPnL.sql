CREATE TABLE [Staging].[FunctionalPnL] (
    [Gov Type]        NVARCHAR (255) NULL,
    [Type]            NVARCHAR (255) NULL,
    [Function]        NVARCHAR (255) NULL,
    [_Sub function]   NVARCHAR (255) NULL,
    [Year]            DATETIME       NULL,
    [Value]           FLOAT (53)     NULL,
    [FunctionSort]    FLOAT (53)     NULL,
    [SubfunctionSort] FLOAT (53)     NULL,
    [Sub function]    NVARCHAR (255) NULL, 
    [FileVersionId] INT NULL
);

