set linesize 200;
set feedback off;
col file_name format a50;
col bytes format 99999.99;
select file_name,tablespace_name,bytes/1024/1024 as MB,autoextensible
from dba_data_files where tablespace_name in
(
SELECT df.tablespace_name TABLESPACE
FROM (SELECT tablespace_name, SUM(bytes) TOTAL_SPACE,
ROUND(SUM(bytes) / 1048576) TOTAL_SPACE_MB
FROM dba_data_files
GROUP BY tablespace_name) df,
(SELECT tablespace_name, SUM(bytes) FREE_SPACE,
ROUND(SUM(bytes) / 1048576) FREE_SPACE_MB
FROM dba_free_space
GROUP BY tablespace_name) fs
WHERE df.tablespace_name = fs.tablespace_name (+)
);