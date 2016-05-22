/* ================================================================
||   Program Name: create_dbms_sql2.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 13
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates DBMS_SQL to glue a string 
||   conditionally.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Define local DBMS_SQL variables.
  c      INTEGER := dbms_sql.open_cursor;
  fdbk   INTEGER;
  stmt1  VARCHAR2(2000);
  stmt2  VARCHAR2(20) := '-1,SYSDATE)';

  -- Variable to get OUT parameter value.
  client VARCHAR2(64);
BEGIN
  stmt1 := 'INSERT INTO item VALUES '
        || '( item_s1.nextval '
        || ',''ASIN'||CHR(58)||' B000VBJEEG'''
        || ',(SELECT   common_lookup_id '
        || '  FROM     common_lookup '
        || '  WHERE    common_lookup_type = ''DVD_WIDE_SCREEN'') '
        || ',''Ratatouille'''
        || ','''''
        || ', empty_clob() '
        || ', NULL '
        || ',''G'''
        || ',''MPAA'''
        || ',''06-NOV-2007'''
        || ', 3, SYSDATE,';

  dbms_application_info.read_client_info(client);
  IF client IS NOT NULL THEN
    stmt1 := stmt1 || client || ',SYSDATE)';
  ELSE
    stmt1 := stmt1 || stmt2;
  END IF;
           
  -- Parse and execute the statement.
  dbms_sql.parse(c,stmt1,dbms_sql.native);
  fdbk := dbms_sql.execute(c);
  dbms_sql.close_cursor(c);
  dbms_output.put_line('Rows Inserted ['||fdbk||']');
END;
/

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000VBJEEG'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Ratatouille'
,''
, empty_clob()
, NULL
,'G'
,'MPAA'
,'06-NOV-2007'
, 3, SYSDATE, 3, SYSDATE);
