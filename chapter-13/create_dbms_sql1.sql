/* ================================================================
||   Program Name: create_dbms_sql1.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 13
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates DBMS_SQL to conditionally drop a table.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define local DBMS_SQL variables.
  c         INTEGER := dbms_sql.open_cursor;
  fdbk      INTEGER;
  stmt      VARCHAR2(2000);

BEGIN
  -- Use a loop to check whether to drop a sequence.
  FOR i IN (SELECT null
            FROM   user_objects
            WHERE  object_name = 'SAMPLE_SEQUENCE') LOOP

    -- Build dynamic SQL statement.
    stmt := 'DROP SEQUENCE sample_sequence';

    -- Parse and execute the statement.
    dbms_sql.parse(c,stmt,dbms_sql.native);
    fdbk := dbms_sql.execute(c);

    -- Close the open cursor.
    dbms_sql.close_cursor(c);

    -- Print output line.
    dbms_output.put_line('Dropped Sequence [SAMPLE_SEQUENCE]');
  END LOOP;
END;
/