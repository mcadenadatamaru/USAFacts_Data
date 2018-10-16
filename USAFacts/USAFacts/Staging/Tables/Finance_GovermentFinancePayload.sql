CREATE TABLE [Staging].[Finance_GovermentFinancePayload] (
    [FileVersionId]    INT             NOT NULL,
    [Source]           NVARCHAR (255)  NULL,
    [Segment1]         NVARCHAR (255)  NULL,
    [Segment2]         NVARCHAR (255)  NULL,
    [Segment3]         NVARCHAR (255)  NULL,
    [Segment4]         NVARCHAR (255)  NULL,
    [Segment5]         NVARCHAR (255)  NULL,
    [Memo1]            NVARCHAR (255)  NULL,
    [Memo2]            NVARCHAR (255)  NULL,
    [Memo3]            NVARCHAR (255)  NULL,
    [StateCode]        FLOAT (53)      NULL,
    [GovernmentTypeID] FLOAT (53)      NULL,
    [Year]             FLOAT (53)      NULL,
    [Chargeable]       FLOAT (53)      NULL,
    [Value]            FLOAT (53)      NULL,
    [Measure]          NVARCHAR (255)  NULL,
    [Unit]             NVARCHAR (255)  NULL,
    [RowHash]          VARBINARY (MAX) NULL
);

