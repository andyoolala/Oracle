set line 180
set pages 300
col username for a20
col program for a20 trunc
col event for a30 trunc
select sid,username,program,sql_id,event,last_call_et,FINAL_BLOCKING_SESSION "FBLK"
from v$session where type='USER' and status='ACTIVE'
order by last_call_et,sql_id;