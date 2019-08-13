CREATE TABLE [dbo].[ExecutionLog]
(
	LogID INT NOT NULL PRIMARY KEY IDENTITY(1,1)
	,LogDateTime datetime not null
	,LogMessage varchar(max) not null
	,ProcedureObjectID int null
	,RowCounter int null
	,AuditKey int null
	,ErrorNumber int
	,ErrorSeverity int 
	,ErrorState int
	,ErrorProcedure nvarchar(128)
	,ErrorLine int 
	,ErrorMessage nvarchar(4000)
) 