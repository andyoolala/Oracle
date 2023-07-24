set pagesize 18;
set echo off;
set feedBack off;
set colsep "|";
set tab off;
col TABLESPACE format a15;
col TOTALSPACE_MB heading TOTAL(MB);
col USED_SPACE_MB heading USED(MB);
col FREE_SPACE_MB heading FREE(MB);
col PCT_USED heading USED(%);
col NOTE format a4;
SELECT df.tablespace_name TABLESPACE,
df.total_space_mb TOTALSPACE_MB,
(df.total_space_mb - fs.free_space_mb) USED_SPACE_MB,
fs.free_space_mb FREE_SPACE_MB,
ROUND(100 * ((df.total_space - fs.free_space) / df.total_space),2) PCT_USED,
CASE WHEN ROUND(100 * ((df.total_space - fs.free_space) / df.total_space),2) > 90 THEN '<<<' END AS NOTE
FROM (SELECT tablespace_name, SUM(bytes) TOTAL_SPACE,
ROUND(SUM(bytes) / 1048576) TOTAL_SPACE_MB
FROM dba_data_files
GROUP BY tablespace_name) df,
(SELECT tablespace_name, SUM(bytes) FREE_SPACE,
ROUND(SUM(bytes) / 1048576) FREE_SPACE_MB
FROM dba_free_space
GROUP BY tablespace_name) fs
WHERE df.tablespace_name = fs.tablespace_name (+)
ORDER BY PCT_USED DESC;