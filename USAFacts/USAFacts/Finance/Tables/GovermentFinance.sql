CREATE TABLE [Finance].[GovermentFinance] (
    [RowId]             INT             IDENTITY (1, 1) NOT NULL,
    [FileVersionId]     INT             NOT NULL,
    [GovernmentType]    NVARCHAR (255)  NULL,
    [StateCode]         FLOAT (53)      NULL,
    [Type]              NVARCHAR (255)  NULL,
    [Source]            NVARCHAR (255)  NULL,
    [Grant]             NVARCHAR (255)  NULL,
    [CensusCode]        NVARCHAR (255)  NULL,
    [CensusDescription] NVARCHAR (255)  NULL,
    [Segment1]          NVARCHAR (255)  NULL,
    [Segment2]          NVARCHAR (255)  NULL,
    [Segment3]          NVARCHAR (255)  NULL,
    [Segment4]          NVARCHAR (255)  NULL,
    [Year]              FLOAT (53)      NULL,
    [Measure]           NVARCHAR (255)  NULL,
    [Unit]              NVARCHAR (255)  NULL,
    [Value]             FLOAT (53)      NULL,
    [RowHash]           VARBINARY (MAX) NULL,
    CONSTRAINT [PK_GovermentFinance] PRIMARY KEY CLUSTERED ([RowId] ASC, [FileVersionId] ASC)
);





