CREATE TABLE [bls].[LNU05026639] (
    [Series_Id]  NVARCHAR (50) NOT NULL,
    [Year]       INT           NOT NULL,
    [Period]     NVARCHAR (50) NOT NULL,
    [Value]      NVARCHAR (50) NOT NULL,
    [Modified]   DATETIME2 (0) CONSTRAINT [DF_LNU05026639_Modified] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedBy] NVARCHAR (50) CONSTRAINT [DF_LNU05026639_ModifiedBy] DEFAULT (suser_sname()) NOT NULL,
    [Created]    DATETIME2 (0) CONSTRAINT [DF_LNU05026639_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedBy]  NVARCHAR (50) CONSTRAINT [DF_LNU05026639_CreatedBy] DEFAULT (suser_sname()) NOT NULL
);




GO

-- Triggers
CREATE TRIGGER bls.trg_LNU05026639_After_Insert ON bls.LNU05026639
FOR INSERT AS
  BEGIN 
    SET NOCOUNT ON

    UPDATE bls.LNU05026639
    SET Created = SYSUTCDATETIME(),
        CreatedBy = SUSER_SNAME(),
        Modified = SYSUTCDATETIME(),
        ModifiedBy = SUSER_SNAME()
    FROM bls.LNU05026639
    INNER JOIN inserted 
      ON bls.LNU05026639.[Year] = inserted.[Year]
        AND bls.LNU05026639.[Period] = inserted.[Period];
  END