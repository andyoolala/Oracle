set linesize 200
set pages 300
col username for a10
col machine for a15
col module for a15
col event for a30
select s.sid,s.username,s.machine,s.event,s.module,s.status,s.sql_id
from v$session s,v$process p
where s.paddr=p.addr and p.spid='&1';
