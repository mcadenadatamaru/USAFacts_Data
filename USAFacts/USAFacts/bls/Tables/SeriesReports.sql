CREATE TABLE [bls].[SeriesReports] (
    [SeriesId]   NVARCHAR (255) NOT NULL,
    [Title]      NVARCHAR (255) NULL,
    [ReportType] NVARCHAR (255) NULL,
    [Industry]   NVARCHAR (255) NULL,
    [File]       NVARCHAR (255) NULL,
    [API]        NVARCHAR (255) NULL,
    [SeriesData] NVARCHAR (MAX) NULL,
    [MinPeriod]  INT            NULL,
    [MaxPeriod]  INT            NULL,
    [Modified]   DATETIME2 (7)  CONSTRAINT [DF_SeriesReports_Modified] DEFAULT (sysutcdatetime()) NOT NULL,
    [ModifiedBy] NVARCHAR (25)  CONSTRAINT [DF_SeriesReports_ModifiedBy] DEFAULT (suser_sname()) NOT NULL,
    [Created]    DATETIME2 (7)  CONSTRAINT [DF_SeriesReports_Created] DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedBy]  NVARCHAR (25)  CONSTRAINT [DF_SeriesReports_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_SeriesReports] PRIMARY KEY CLUSTERED ([SeriesId] ASC),
    CONSTRAINT [SeriesData should be formatted as JSON] CHECK (isjson([SeriesData])=(1))
);


GO
CREATE TRIGGER [bls].TRG_Seriesreports_After_Update
    ON bls.Seriesreports
    FOR UPDATE
    AS
    BEGIN
        SET NOCOUNT ON
        
        IF ( (SELECT trigger_nestlevel() ) > 1 )
            RETURN
            
        UPDATE bls.Seriesreports
            SET Created = deleted.Created,
                CreatedBy = deleted.CreatedBy,
                Modified = sysutcdatetime(),
                ModifiedBy = suser_sname()
        FROM bls.Seriesreports 
        INNER JOIN deleted
            ON bls.Seriesreports.SeriesId = deleted.SeriesId;
        
    END
GO
CREATE TRIGGER [bls].TRG_Seriesreports_After_Insert
    ON bls.Seriesreports
    FOR INSERT
    AS
    BEGIN
        SET NOCOUNT ON
        
        UPDATE bls.Seriesreports
            SET Created = SYSUTCDATETIME(),
                CreatedBy = SUSER_SNAME(),
                Modified = SYSUTCDATETIME(),
                ModifiedBy = SUSER_SNAME()
        FROM dbo.Seriesreports INNER JOIN inserted 
            ON bls.Seriesreports.SeriesId = inserted.SeriesId;
    END