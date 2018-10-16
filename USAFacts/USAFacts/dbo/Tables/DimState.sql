CREATE TABLE [dbo].[DimState] (
    [StateId]   INT          IDENTITY (1, 1) NOT NULL,
    [StateCode] CHAR (2)     NULL,
    [StateName] VARCHAR (25) NULL,
    CONSTRAINT [PK_StateDim] PRIMARY KEY CLUSTERED ([StateId] ASC)
);

