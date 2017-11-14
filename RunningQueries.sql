select session_id
	,start_time
	,status
	,command
	,db_name(database_id) as DatabaseName
	,USER_NAME(user_id) as UserName
	,blocking_session_id
	,wait_type
	,wait_time
	,last_wait_type
	,wait_resource
	,percent_complete
	,estimated_completion_time
	,cpu_time
	,total_elapsed_time
	,reads
	,writes
	,logical_reads
	,SUBSTRING(st.text, (qs.statement_start_offset/2)+1,   
        ((CASE qs.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE qs.statement_end_offset  
         END - qs.statement_start_offset)/2) + 1) AS statement_text  
from sys.dm_exec_requests qs
	cross apply sys.dm_exec_sql_text(qs.sql_handle) st



