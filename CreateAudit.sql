CREATE PROCEDURE [etl].[CreateAudit]
	@ProcessName varchar(50)
	,@AuditKey int OUTPUT
AS
SET NOCOUNT ON;
-- create audit record
INSERT INTO dim.Audit
(ProcessName, StartDateTime, ProcessStatus)
SELECT @ProcessName, GETDATE(), 'Running'

-- return auditkey
SELECT @AuditKey = @@IDENTITY