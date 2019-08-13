CREATE PROCEDURE [etl].[SetAuditStatus]
	@AuditKey int,
	@ProcessStatus varchar(100)
AS

update dim.Audit
set ProcessStatus = @ProcessStatus
where AuditKey = @AuditKey;

go

