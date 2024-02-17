select * from (
	select
		 SQL_ID ,
		 sum(decode(session_state,'ON CPU',1,0)) as CPU,
		 sum(decode(session_state,'WAITING',1,0)) - sum(decode(session_state,'WAITING', decode(wait_class, 'User I/O',1,0),0)) as WAIT,
		 sum(decode(session_state,'WAITING', decode(wait_class, 'User I/O',1,0),0)) as IO,
		 sum(decode(session_state,'ON CPU',1,1)) as TOTAL
	from v$active_session_history
	where SQL_ID is not NULL AND sample_time BETWEEN TO_DATE('2024-01-31 16:00:00', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2024-01-31 16:30:00', 'YYYY-MM-DD HH24:MI:SS') 
	group by sql_id
	order by sum(decode(session_state,'ON CPU',1,1))   desc
	)
where rownum <11