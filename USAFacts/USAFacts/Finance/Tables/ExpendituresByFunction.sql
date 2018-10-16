CREATE TABLE [Finance].[ExpendituresByFunction] (
    [RowId]         INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId] INT            NULL,
    [Function]      NVARCHAR (255) NULL,
    [SubFunction]  NVARCHAR (255) NULL,
    [Year]          FLOAT (53)     NULL,
    [Measure]       NVARCHAR (255) NULL,
    [Unit]          NVARCHAR (255) NULL,
    [Expenditures] FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_ExpendituresByFunction] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

