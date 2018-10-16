CREATE TABLE [Property].[FederalLandHistory] (
    [RowId]         INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId] INT            NULL,
    [StateName]    NVARCHAR (255) NULL,
    [State]        NVARCHAR (255) NULL,
    [StateCode]    NVARCHAR (255) NULL,
    [1990]          FLOAT (53)     NULL,
    [2000]          FLOAT (53)     NULL,
    [2010]          FLOAT (53)     NULL,
    [2015]          FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_FederalLandOwnershipChanges] PRIMARY KEY CLUSTERED ([RowId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nci_FileVersionId]
    ON [Property].[FederalLandHistory]([FileVersionId] ASC);

