CREATE TABLE [Finance].[BalanceSheets] (
    [RowId]          INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId]  INT            NULL,
    [Category]       NVARCHAR (255) NULL,
    [BalanceSheets] NVARCHAR (255) NULL,
    [Year]           FLOAT (53)     NULL,
    [Measure]        NVARCHAR (255) NULL,
    [Unit]           NVARCHAR (255) NULL,
    [Value]          FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_BalanceSheets] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

