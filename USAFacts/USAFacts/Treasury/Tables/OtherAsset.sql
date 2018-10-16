CREATE TABLE [Treasury].[OtherAsset] (
    [RowId]                                 INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId]                         INT            NULL,
    [Other assets (In billions of dollars)] NVARCHAR (255) NULL,
    [GovernmenType]                       NVARCHAR (255) NULL,
    [2009]                                  FLOAT (53)     NULL,
    [2010]                                  FLOAT (53)     NULL,
    [2011]                                  FLOAT (53)     NULL,
    [2012]                                  FLOAT (53)     NULL,
    [2013]                                  FLOAT (53)     NULL,
    [2014]                                  FLOAT (53)     NULL,
    [2015]                                  FLOAT (53)     NULL,
    [2016]                                  FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Note9] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

