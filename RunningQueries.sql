set nocount on;

select session_id
	,start_time
	,qs.user_id
	,status
	,command
	,db_name(database_id) as DatabaseName
	,USER_NAME(user_id) as UserName
	,blocking_session_id
	,wait_type
	,wait_time
	,last_wait_type
	,wait_resource
	,qs.transaction_id
	,cpu_time
	,total_elapsed_time
	,reads
	,writes
	,logical_reads
	,st.text
	,SUBSTRING(st.text, (qs.statement_start_offset/2)+1,   
        ((CASE qs.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE qs.statement_end_offset  
         END - qs.statement_start_offset)/2) + 1) AS statement_text  
	,qp.query_plan
from sys.dm_exec_requests qs WITH(NOLOCK)
	cross apply sys.dm_exec_sql_text(qs.sql_handle) st
	outer apply sys.dm_exec_query_plan(qs.plan_handle) qp;


