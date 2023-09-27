#!/bin/bash
export ORACLE_HOME=/u01/app/oracle/product/19.3.0.1/db_EE_01
export ORACLE_SID=TGCSDB

# Run the Python script and capture its output into Bash variables
output=$(python semiadvancedscraper1.py)

# Check if both variables have values
if [ -n "$output" ]; then
    # Extract snapshot IDs from the output (adjust this line based on the actual format)
    snapshot_id1=$(echo "$output" | head -n 1)
    snapshot_id2=$(echo "$output" | tail -n 1)

    if [ -n "$snapshot_id1" ] && [ -n "$snapshot_id2" ]; then
        echo "Snapshot ID 1: $snapshot_id1"
        echo "Snapshot ID 2: $snapshot_id2"

        # Define the timestamp
        timestamp=$(date '+%Y_%m_%d_%H_%M_%S')

        # Create the SQL script with placeholders for snapshot_id1 and snapshot_id2
        sql_script="SET TIMING ON
DEFINE timestamp = TO_CHAR(SYSDATE, 'YYYY_MM_DD_HH_24_MI_SS')
spool /tmp/AWR_REPORT_AUTOMATION/AWR_REPORTS/AWR_REPORT_${timestamp}.html
SELECT output FROM TABLE(
   DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(
     73906513,  1, ${snapshot_id1}, ${snapshot_id2}) ) ;
spool off
exit"
        # Save the SQL script to a temporary file
        echo "$sql_script" > /tmp/AWR_REPORT_AUTOMATION/awr_sql_script.sql

        # Run the SQL script with SQL*Plus as sysdba
       /u01/app/oracle/product/19.3.0.1/db_EE_01/bin/sqlplus / as sysdba @/tmp/AWR_REPORT_AUTOMATION/awr_sql_script.sql

        # Clean up the temporary file
        rm /tmp/AWR_REPORT_AUTOMATION/awr_sql_script.sql

        # You can use $snapshot_id1 and $snapshot_id2 in other processing here
    else
        echo "Not enough snapshot IDs found for the specified dates."
    fi
else
   
