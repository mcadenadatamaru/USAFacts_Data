CREATE TABLE [Treasury].[EnvironmentalLiability] (
    [RowId]                                                           INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId]                                                   INT            NULL,
    [Environmental and disposal liabilities (In billions of dollars)] NVARCHAR (255) NULL,
    [Category]                                                        NVARCHAR (255) NULL,
    [GovernmentType]                                                 NVARCHAR (255) NULL,
    [2009]                                                            FLOAT (53)     NULL,
    [2010]                                                            FLOAT (53)     NULL,
    [2011]                                                            FLOAT (53)     NULL,
    [2012]                                                            FLOAT (53)     NULL,
    [2013]                                                            FLOAT (53)     NULL,
    [2014]                                                            FLOAT (53)     NULL,
    [2015]                                                            FLOAT (53)     NULL,
    [2016]                                                            FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Note13] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

