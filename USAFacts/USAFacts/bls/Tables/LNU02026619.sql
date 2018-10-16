CREATE TABLE [bls].[LNU02026619] (
    [Series_Id]  NVARCHAR (50) NOT NULL,
    [Year]       INT           NOT NULL,
    [Period]     NVARCHAR (50) NOT NULL,
    [Value]      NVARCHAR (50) NOT NULL,
    [Modified]   DATETIME2 (0) CONSTRAINT [DF_[LNU02026619_Modified] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedBy] NVARCHAR (50) CONSTRAINT [DF_[LNU02026619_ModifiedBy] DEFAULT (suser_sname()) NOT NULL,
    [Created]    DATETIME2 (0) CONSTRAINT [DF_[LNU02026619_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedBy]  NVARCHAR (50) CONSTRAINT [DF_[LNU02026619_CreatedBy] DEFAULT (suser_sname()) NOT NULL
);




GO

CREATE TRIGGER bls.trg_LNU05026639_After_Update ON bls.LNU02026619
FOR UPDATE AS 
BEGIN 
  SET NOCOUNT ON 

  IF (( SELECT TRIGGER_NESTLEVEL()) > 1 )
    RETURN

  UPDATE bls.LNU05026639
  SET Created = deleted.Created,
      CreatedBy = deleted.CreatedBy,
      Modified = SYSUTCDATETIME(),
      ModifiedBy = SUSER_SNAME()
  FROM bls.LNU05026639
  INNER JOIN deleted
    ON bls.LNU05026639.[Year] = deleted.[Year]
        AND bls.LNU05026639.[Period] = deleted.[Period];
END
GO

CREATE TRIGGER bls.trg_LNU02026619_After_Update ON bls.LNU02026619
FOR UPDATE AS 
BEGIN 
  SET NOCOUNT ON 

  IF (( SELECT TRIGGER_NESTLEVEL()) > 1 )
    RETURN

  UPDATE bls.LNU02026619
  SET Created = deleted.Created,
      CreatedBy = deleted.CreatedBy,
      Modified = SYSUTCDATETIME(),
      ModifiedBy = SUSER_SNAME()
  FROM bls.LNU02026619
  INNER JOIN deleted
    ON bls.LNU02026619.[Year] = deleted.[Year]
        AND bls.LNU02026619.[Period] = deleted.[Period];
END
GO

-- Triggers
CREATE TRIGGER bls.trg_LNU02026619_After_Insert ON bls.LNU02026619
FOR INSERT AS
  BEGIN 
    SET NOCOUNT ON

    UPDATE bls.LNU02026619
    SET Created = SYSUTCDATETIME(),
        CreatedBy = SUSER_SNAME(),
        Modified = SYSUTCDATETIME(),
        ModifiedBy = SUSER_SNAME()
    FROM bls.LNU02026619
    INNER JOIN inserted 
      ON bls.LNU02026619.[Year] = inserted.[Year]
        AND bls.LNU02026619.[Period] = inserted.[Period];
  END