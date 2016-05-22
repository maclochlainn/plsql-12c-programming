/* ================================================================
||   Program Name: create_dbms_sql3.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 13
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates DBMS_SQL using placeholders or bind 
||   variables.
|| ================================================================*/
 
-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PROCEDURE insert_item
( asin     VARCHAR2
, title    VARCHAR2
, subtitle VARCHAR2 := NULL
, itype    VARCHAR2 := 'DVD_WIDE_SCREEN'
, rating   VARCHAR2
, agency   VARCHAR2
, release  DATE ) IS 

  -- Define local DBMS_SQL variables.
  c      INTEGER := dbms_sql.open_cursor;
  fdbk   INTEGER;
  stmt   VARCHAR2(2000);

  -- Variable to get OUT parameter value.
  client VARCHAR2(64);
BEGIN
  stmt := 'INSERT INTO item VALUES '
        || '( item_s1.nextval '
        || ',''ASIN''||CHR(58)|| :asin'
        || ',(SELECT   common_lookup_id '
        || '  FROM     common_lookup '
        || '  WHERE    common_lookup_type = :itype) '
        || ',:title'
        || ',:subtitle'
        || ', empty_clob() '
        || ', NULL '
        || ',:rating'
        || ',:agency'
        || ',:release'
        || ', :created_by, SYSDATE, :last_updated_by, SYSDATE)';

  dbms_application_info.read_client_info(client);
  
  IF client IS NOT NULL THEN
    client := TO_NUMBER(client);
  ELSE
    client := -1;
  END IF;
           
  -- Parse and execute the statement.
  dbms_sql.parse(c,stmt,dbms_sql.native);
  dbms_sql.bind_variable(c,'asin',asin);
  dbms_sql.bind_variable(c,'itype',itype);
  dbms_sql.bind_variable(c,'title',title);
  dbms_sql.bind_variable(c,'subtitle',subtitle);
  dbms_sql.bind_variable(c,'rating',rating);
  dbms_sql.bind_variable(c,'agency',agency);
  dbms_sql.bind_variable(c,'release',release);
  dbms_sql.bind_variable(c,'created_by',client);
  dbms_sql.bind_variable(c,'last_updated_by',client);
  fdbk := dbms_sql.execute(c);
  dbms_sql.close_cursor(c);
  dbms_output.put_line('Rows Inserted ['||fdbk||']');
END insert_item;
/
show errors
list
show user

BEGIN
  insert_item(asin => 'B000VBJEEG'
                     ,title => 'Ratatouille'
                     ,itype => 'DVD_WIDE_SCREEN'
                     ,rating => 'G'
                     ,agency => 'MPAA'
                     ,release => '06-NOV-2007');
END;
/