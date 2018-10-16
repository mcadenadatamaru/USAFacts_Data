CREATE TABLE [Property].[FederalLand] (
    [RowId]                  INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId]          INT            NULL,
    [StateName]             NVARCHAR (255) NULL,
    [State]                 NVARCHAR (255) NULL,
    [StateCode]             NVARCHAR (255) NULL,
    [BLM]                    FLOAT (53)     NULL,
    [FS]                     FLOAT (53)     NULL,
    [FWS]                    FLOAT (53)     NULL,
    [NPS]                    FLOAT (53)     NULL,
    [DOD]                    FLOAT (53)     NULL,
    [TotalFederalAcreage]  FLOAT (53)     NULL,
    [TotalAcreageInState] FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_FederalOwnedLand] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

