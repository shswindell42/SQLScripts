
declare cur_executor cursor
FOR with cte_tabledef as (
	select replace(t.name, '_local', '') as TableName
		, string_agg(concat('[', c.name, ']'
							, ' '
							, CASE WHEN dt.Name like '%char' THEN CONCAT(dt.Name, '(', IIF(LEFT(dt.NAME, 1) = 'N', c.Max_length / 2, c.Max_Length), ')')
								WHEN dt.Name IN ('decimal', 'numeric') THEN CONCAT(dt.Name, '(', c.Precision, ',', c.Scale, ')')
								WHEN dt.Name = 'geography' THEN 'varbinary'
								ELSE dt.Name END
							), ',') as ColumnSet
	
	from sys.tables t
		inner join sys.columns c
			on t.object_id = c.object_id
		inner join sys.types dt
			on c.user_type_id = dt.user_type_id
	where t.name like 'ref_%'
		and t.is_external = 0
		--and t.name not like '%_local'
		and t.name not in (select concat(st.name, '_local')	
							from sys.tables st
							where is_external = 1)
	group by t.name
)
select CONCAT('sp_rename ''', TableName, ''', ''', TableName, '_local''') as RenameAction
	, CONCAT('CREATE EXTERNAL TABLE ', TableName, ' ( ', ColumnSet, ' ) WITH (DATA_SOURCE = ODS_NETB, SCHEMA_NAME = ''dbo'', OBJECT_NAME = ''', TableName, ''' )') as CreateExternalTableAction
from cte_tabledef

declare @renameAction nvarchar(max)
	,@createAction nvarchar(max)

open cur_executor;

fetch next from cur_executor
into @renameAction, @createAction

while @@fetch_status = 0
BEGIN

	select @renameAction, @createAction
	--exec sp_executesql @renameAction
	exec sp_executesql @createAction

	fetch next from cur_executor
	into @renameAction, @createAction

END

close cur_executor
deallocate cur_executor

