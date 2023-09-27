#!/bin/bash

export ORACLE_HOME=/u01/app/oracle/product/19.3.0.1/db_EE_01
export ORACLE_SID=TGCSDB
$ORACLE_HOME/bin/sqlplus / as sysdba <<EOF
spool /tmp/AWR_REPORT_AUTOMATION/snap_id.txt
set colsep'|'
SELECT SNAP_ID, to_char(end_interval_time, 'hh24:mi') begin
FROM DBA_HIST_SNAPSHOT
WHERE END_INTERVAL_TIME >= SYSTIMESTAMP - INTERVAL '1' DAY order by 1;
spool off
EOF
