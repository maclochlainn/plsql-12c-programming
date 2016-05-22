/* ================================================================
||   Program Name: create_dbms_sql4.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 13
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates DBMS_SQL querying a row return. 
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  c                         INTEGER := dbms_sql.open_cursor;
  fdbk                      INTEGER;
  statement                 VARCHAR2(2000);
  item_id                   NUMBER := 1081;
  item_title                VARCHAR2(60);
  item_subtitle             VARCHAR2(60);

BEGIN

  -- Build and parse SQL statement.
  statement := 'SELECT item_title, item_subtitle '
            || 'FROM item WHERE item_id = :item_id';
  dbms_sql.parse(c,statement,dbms_sql.native);

  -- Define column mapping, execute statement, and copy results.
  dbms_sql.define_column(c,1,item_title,60);    -- Define OUT mode variable.
  dbms_sql.define_column(c,2,item_subtitle,60); -- Define OUT mode variable.
  dbms_sql.bind_variable(c,'item_id',item_id);  -- Bind IN mode variable.
  fdbk := dbms_sql.execute_and_fetch(c);
  dbms_sql.column_value(c,1,item_title);        -- Copy query column to variable.
  dbms_sql.column_value(c,2,item_subtitle);     -- Copy query column to variable.

  -- Print return value and close cursor.
  dbms_output.put_line('['||item_title||']['||NVL(item_subtitle,'None')||']');
  dbms_sql.close_cursor(c);

END;
/