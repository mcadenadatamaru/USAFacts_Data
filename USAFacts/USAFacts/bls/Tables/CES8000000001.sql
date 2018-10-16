CREATE TABLE [bls].[CES8000000001] (
    [Series_Id] NVARCHAR (50) NOT NULL,
    [Year]      INT           NOT NULL,
    [Period]    NVARCHAR (50) NOT NULL,
    [Value]     NVARCHAR (50) NOT NULL,
        
    [Modified]    DATETIME2(0)  CONSTRAINT [DF_CES8000000001_Modified] DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [ModifiedBy]  NVARCHAR(50)  CONSTRAINT [DF_CES8000000001_ModifiedBy] DEFAULT (SUSER_SNAME())NOT NULL, 
    [Created]     DATETIME2(0)  CONSTRAINT [DF_CES8000000001_Created] DEFAULT (SYSUTCDATETIME())NOT NULL,
    [CreatedBy]   NVARCHAR (50) CONSTRAINT [DF_CES8000000001_CreatedBy] DEFAULT (SUSER_SNAME())NOT NULL
);
GO

-- Triggers
CREATE TRIGGER bls.trg_CES8000000001_After_Insert ON bls.CES8000000001
FOR INSERT AS
  BEGIN 
    SET NOCOUNT ON

    UPDATE bls.CES8000000001
    SET Created = SYSUTCDATETIME(),
        CreatedBy = SUSER_SNAME(),
        Modified = SYSUTCDATETIME(),
        ModifiedBy = SUSER_SNAME()
    FROM bls.CES8000000001
    INNER JOIN inserted 
      ON bls.CES8000000001.[Year] = inserted.[Year]
        AND bls.CES8000000001.[Period] = inserted.[Period];
  END
GO

CREATE TRIGGER bls.trg_CES8000000001_After_Update ON bls.CES8000000001
FOR UPDATE AS 
BEGIN 
  SET NOCOUNT ON 

  IF (( SELECT TRIGGER_NESTLEVEL()) > 1 )
    RETURN

  UPDATE bls.CES8000000001
  SET Created = deleted.Created,
      CreatedBy = deleted.CreatedBy,
      Modified = SYSUTCDATETIME(),
      ModifiedBy = SUSER_SNAME()
  FROM bls.CES8000000001
  INNER JOIN deleted
    ON bls.CES8000000001.[Year] = deleted.[Year]
        AND bls.CES8000000001.[Period] = deleted.[Period];
END
GO
