CREATE PROCEDURE [etl].<SPName>
	@AuditKey int
AS
SET NOCOUNT ON;

BEGIN TRY

	EXEC dbo.InsertLogRecord 'BEGIN <SPName>', @@PROCID, NULL, @AuditKey

	-- get dates from tracking table
	DECLARE @lastLoadDate datetime

	EXEC etl.GetTableTracking '<SPName>', '<SourceTable>', @lastLoadDate OUTPUT


	-- load stage table
    -- TODO: Load stage table 
	EXEC dbo.InsertLogRecord 'Stage loaded', @@PROCID, @@ROWCOUNT, @AuditKey

	--- update dimension
    -- TODO: Update existing records
    /*
    UPDATE d
    SET ...
    FROM <dimTable> d
        inner join #stage s
            on <key>
    */

	EXEC dbo.InsertLogRecord 'Updated table', @@PROCID, @@ROWCOUNT, @AuditKey


	-- insert new records
	/*
    INSERT INTO <dimTable>
	(
		...
	)
	SELECT ...
	FROM #stage s
	WHERE NOT EXISTS (SELECT *
						FROM <dimTable> d
						WHERE <key>)
    */
	EXEC dbo.InsertLogRecord 'Inserted new records', @@PROCID, @@ROWCOUNT, @AuditKey

	-- update tracking table
	DECLARE @maxLastLoad datetime

	SELECT @maxLastLoad = MAX(LastModifiedDate) 
	FROM #stage

	EXEC etl.SetTableTracking '<SPName>', '<SourceTable>', @maxLastLoad


    EXEC dbo.InsertLogRecord 'END <SPName>', @@PROCID, NULL, @AuditKey;

END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		ROLLBACK;

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE()
		,@ErrorServerity int = ERROR_SEVERITY()
		,@ErrorNumber int = ERROR_NUMBER()
		,@ErrorLine int = ERROR_LINE()
		,@ErrorState int = ERROR_STATE()
		,@ErrorProcedure nvarchar(128) = ERROR_PROCEDURE();

	EXEC dbo.InsertLogRecord 'ERROR <SPName>', @@PROCID, NULL, @AuditKey, @ErrorNumber, @ErrorServerity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage;

    THROW;

END CATCH



