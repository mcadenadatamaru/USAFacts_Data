CREATE TABLE [Census].[Finance_2012] (
    [ID_Code]                             VARCHAR (50)  NOT NULL,
    [Item_Code]                           VARCHAR (50)  NOT NULL,
    [Year_of_Data]                        INT           NOT NULL,
    [ID_Name]                             VARCHAR (MAX) NULL,
    [County_Name]                         VARCHAR (MAX) NULL,
    [FIPS_State]                          VARCHAR (50)  NULL,
    [FIPS_County]                         VARCHAR (50)  NULL,
    [FIPS_Place]                          VARCHAR (50)  NULL,
    [Population]                          REAL          NULL,
    [Population_Year]                     VARCHAR (50)  NULL,
    [Enrollment]                          VARCHAR (50)  NULL,
    [Enrollment_Year]                     VARCHAR (50)  NULL,
    [Function_Code_For_Special_Districts] VARCHAR (50)  NULL,
    [School_Level_Code]                   VARCHAR (50)  NULL,
    [Fiscal_Year_Ending]                  VARCHAR (50)  NULL,
    [Survey_Year]                         VARCHAR (50)  NULL,
    [Amount_Thousands_Dollars]            REAL          NULL,
    [Imputation_Type_Item_Data_Flag]      VARCHAR (50)  NULL,
    [State]                               VARCHAR (50)  NULL,
    [Government_Type]                     VARCHAR (50)  NULL,
    [County_Type]                         VARCHAR (50)  NULL,
    [Unit_Identifier]                     VARCHAR (50)  NULL,
    [Government_Flag]                     VARCHAR (50)  NULL,
    CONSTRAINT [PK_Finance_2012] PRIMARY KEY CLUSTERED ([ID_Code] ASC, [Item_Code] ASC, [Year_of_Data] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_Census_Finance_2012]
    ON [Census].[Finance_2012]([Year_of_Data] ASC, [State] ASC);

