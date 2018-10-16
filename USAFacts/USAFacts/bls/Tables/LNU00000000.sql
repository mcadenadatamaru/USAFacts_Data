CREATE TABLE [bls].[LNU00000000] (
    [Series_Id]  NVARCHAR (50) NOT NULL,
    [Year]       INT           NOT NULL,
    [Period]     NVARCHAR (50) NOT NULL,
    [Value]      NVARCHAR (50) NOT NULL,
    [Modified]   DATETIME2 (0) CONSTRAINT [DF_[LNU00000000_Modified] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedBy] NVARCHAR (50) CONSTRAINT [DF_[LNU00000000_ModifiedBy] DEFAULT (suser_sname()) NOT NULL,
    [Created]    DATETIME2 (0) CONSTRAINT [DF_[LNU00000000_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedBy]  NVARCHAR (50) CONSTRAINT [DF_[LNU00000000_CreatedBy] DEFAULT (suser_sname()) NOT NULL
);




GO

CREATE TRIGGER bls.trg_LNU00000000_After_Update ON bls.LNU00000000
FOR UPDATE AS 
BEGIN 
  SET NOCOUNT ON 

  IF (( SELECT TRIGGER_NESTLEVEL()) > 1 )
    RETURN

  UPDATE bls.LNU00000000
  SET Created = deleted.Created,
      CreatedBy = deleted.CreatedBy,
      Modified = SYSUTCDATETIME(),
      ModifiedBy = SUSER_SNAME()
  FROM bls.LNU00000000
  INNER JOIN deleted
    ON bls.LNU00000000.[Year] = deleted.[Year]
        AND bls.LNU00000000.[Period] = deleted.[Period];
END
GO

-- Triggers
CREATE TRIGGER bls.trg_LNU00000000_After_Insert ON bls.LNU00000000
FOR INSERT AS
  BEGIN 
    SET NOCOUNT ON

    UPDATE bls.LNU00000000
    SET Created = SYSUTCDATETIME(),
        CreatedBy = SUSER_SNAME(),
        Modified = SYSUTCDATETIME(),
        ModifiedBy = SUSER_SNAME()
    FROM bls.LNU00000000
    INNER JOIN inserted 
      ON bls.LNU00000000.[Year] = inserted.[Year]
        AND bls.LNU00000000.[Period] = inserted.[Period];
  END