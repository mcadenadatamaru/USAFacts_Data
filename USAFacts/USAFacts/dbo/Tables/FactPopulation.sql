CREATE TABLE [dbo].[FactPopulation] (
    [PopulationFactId] INT IDENTITY (1, 1) NOT NULL,
    [StateId]          INT NULL,
    [YearId]           INT NULL,
    [Population]       INT NULL,
    CONSTRAINT [PK_PopulationFact] PRIMARY KEY CLUSTERED ([PopulationFactId] ASC),
    CONSTRAINT [FK_PopulationFact_DateDim] FOREIGN KEY ([YearId]) REFERENCES [dbo].[DimYear] ([YearId]),
    CONSTRAINT [FK_PopulationFact_StateDim] FOREIGN KEY ([StateId]) REFERENCES [dbo].[DimState] ([StateId])
);

