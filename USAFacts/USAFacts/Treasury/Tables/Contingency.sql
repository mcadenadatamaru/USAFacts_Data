CREATE TABLE [Treasury].[Contingency] (
    [RowId]                                  INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId]                          INT            NULL,
    [Contingencies (In billions of dollars)] NVARCHAR (255) NULL,
    [Category]                               NVARCHAR (255) NULL,
    [Category2]                             NVARCHAR (255) NULL,
    [GovernmentType]                        NVARCHAR (255) NULL,
    [2009]                                   NVARCHAR (255) NULL,
    [2010]                                   NVARCHAR (255) NULL,
    [2011]                                   NVARCHAR (255) NULL,
    [2012]                                   NVARCHAR (255) NULL,
    [2013]                                   NVARCHAR (255) NULL,
    [2014]                                   NVARCHAR (255) NULL,
    [2015]                                   NVARCHAR (255) NULL,
    [2016]                                   NVARCHAR (255) NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Note18] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

