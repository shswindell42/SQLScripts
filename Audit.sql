CREATE TABLE [dim].[Audit] (
    [AuditKey]      INT           IDENTITY (1, 1) NOT NULL,
    [ProcessName]   VARCHAR (100) NOT NULL,
    [ProcessStatus] VARCHAR (100) NOT NULL,
    [StartDateTime] DATETIME      NOT NULL,
    [EndDateTime]   DATETIME      NOT NULL,
    CONSTRAINT [PK_dim.Audit] PRIMARY KEY CLUSTERED ([AuditKey] ASC)
);