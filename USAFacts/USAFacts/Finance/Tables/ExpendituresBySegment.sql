CREATE TABLE [Finance].[ExpendituresBySegment] (
    [RowId]         INT            IDENTITY (1, 1) NOT NULL,
    [FileVersionId] INT            NULL,
    [Segment1]     NVARCHAR (255) NULL,
    [Segment2]     NVARCHAR (255) NULL,
    [Segment3]     NVARCHAR (255) NULL,
    [Segment4]     NVARCHAR (255) NULL,
    [Year]          FLOAT (53)     NULL,
    [Measure]       NVARCHAR (255) NULL,
    [Unit]          NVARCHAR (255) NULL,
    [Expenditures] FLOAT (53)     NULL,
    [RowHash] VARBINARY(MAX) NULL, 
    CONSTRAINT [PK_ExpendituresBySegment] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

