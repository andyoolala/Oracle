set linesize 200
set pages 300
col username for a10
col machine for a15
col module for a15
col event for a30
select * from (
select
(se.SID),ss.username,ss.machine,ss.module,ss.status,ss.sql_id,ss.event,ss.last_call_et,se.VALUE/100 cpu_usage_sec
from v$session ss,v$sesstat se,
v$statname sn, v$process p, v$sql q
where
se.STATISTIC# = sn.STATISTIC#
AND ss.sql_address = q.address
AND ss.sql_hash_value = q.hash_value
and NAME like '%CPU used by this session%'
and se.SID = ss.SID
and ss.username !='SYS'
and ss.status='ACTIVE'
and ss.username is not null
and ss.paddr=p.addr and value > 0
order by se.VALUE desc);
