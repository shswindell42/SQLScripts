CREATE PROCEDURE [dbo].[InsertLogRecord]
    @LogMessage varchar(max)
    ,@ProcedureObjectID int = NULL
	,@RowCounter int = null
    ,@AuditKey int = NULL
    ,@ErrorNumber int = NULL
    ,@ErrorSeverity int = NULL
    ,@ErrorState int = NULL
    ,@ErrorProcedure nvarchar(128) = NULL
    ,@ErrorLine int = NULL
    ,@ErrorMessage nvarchar(4000) = NULL
AS
       
       INSERT INTO dbo.ExecutionLog
       (
              LogDateTime
              ,LogMessage
              ,ProcedureObjectID
			  ,RowCounter
              ,AuditKey
              ,ErrorNumber
              ,ErrorSeverity
              ,ErrorState
              ,ErrorProcedure
              ,ErrorLine
              ,ErrorMessage
       )
       SELECT GETDATE() 
			,@LogMessage 
			,@ProcedureObjectID 
			,@RowCounter
			,@AuditKey
			,@ErrorNumber 
			,@ErrorSeverity 
			,@ErrorState 
			,@ErrorProcedure 
			,@ErrorLine 
			,@ErrorMessage 

