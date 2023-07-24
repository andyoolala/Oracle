set echo off;
set feedback off;
set heading off;
set linesize 300;
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
select * from (
SELECT s.logon_time,s.sid, s.username, s.program, i.block_changes,q.sql_text
FROM v$session s, v$sess_io i,v$sql q
WHERE s.sid = i.sid AND s.SQL_id=q.sql_id AND s.status='ACTIVE'
ORDER BY 5 desc)
where block_changes > 5000;