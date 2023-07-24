REM Creator : Andy jiang 2016/9/12
REM Objective : show session information plus kill script when lock events happened
REM Notice : Kill os process first and then kill db process
REM Notice : before kill os process,issue ps -ef |grep $proc# and verify it's a PGA process
REM Notice : After the procedure , check the status of killed session again (must be disappear)


set linesize 300;
col username format a10;
col machine format a20;
col event format a50;
col os_kill format a20;
col db_kill format a40;
select s.sid,s.username,s.machine,s.event,s.blocking_session,
'kill -9 '||p.spid||';' as os_kill,'alter system kill session '''||s.sid||','||s.serial#||''';' as db_kill
from v$session s,v$process p
where s.paddr=p.addr
and blocking_session is not null
union all
select s.sid,s.username,s.machine,s.event,s.blocking_session,
'kill -9 '||p.spid||';' as os_kill,'alter system kill session '''||s.sid||','||s.serial#||''';' as db_kill
from v$session s,v$process p
where s.paddr=p.addr
and sid in (select distinct blocking_session from v$session);