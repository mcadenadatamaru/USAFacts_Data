CREATE TABLE [Finance].[Population] (
    [RowId]         INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId] INT            NULL,
    [State]         NVARCHAR (255) NULL,
    [StateCode]    NVARCHAR (255) NULL,
    [StateId]      FLOAT (53)     NULL,
    [Year]          FLOAT (53)     NULL,
    [Population]    FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Population] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

