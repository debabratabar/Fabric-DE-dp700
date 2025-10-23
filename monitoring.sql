-- details about any connections 
SELECT * FROM sys.dm_exec_connections;;
-- details about sessions 
SELECT * FROM sys.dm_exec_sessions;
-- details about requests 
SELECT * FROM sys.dm_exec_requests;




-- stat of query 
SELECT * FROM queryinsights.exec_requests_history;


SELECT * FROM queryinsights.frequently_run_queries;


SELECT * FROM queryinsights.long_running_queries;