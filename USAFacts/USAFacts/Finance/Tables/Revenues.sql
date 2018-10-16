CREATE TABLE [Finance].[Revenues] (
    [RowId]         INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId] INT            NULL,
    [RevenueType]  NVARCHAR (255) NULL,
    [Source1]      NVARCHAR (255) NULL,
    [Source2]      NVARCHAR (255) NULL,
    [Source3]      NVARCHAR (255) NULL,
    [Year]          FLOAT (53)     NULL,
    [Measure]       NVARCHAR (255) NULL,
    [Unit]          NVARCHAR (255) NULL,
    [Revenues]      FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_Revenues] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

