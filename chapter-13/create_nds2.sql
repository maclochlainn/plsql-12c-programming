/* ================================================================
||   Program Name: create_nds2.sql
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

CREATE OR REPLACE PROCEDURE insert_item
( table_name    VARCHAR2
, asin          VARCHAR2
, item_type     VARCHAR2
, item_title    VARCHAR2
, item_subtitle VARCHAR2 := ''
, rating        VARCHAR2
, agency        VARCHAR2
, release_date  VARCHAR2 ) IS

  stmt VARCHAR2(2000);

BEGIN
  stmt := 'INSERT INTO '||dbms_assert.simple_sql_name(table_name)||' VALUES '
        || '( item_s1.nextval '
        || ','||dbms_assert.enquote_literal('ASIN'||CHR(58)||asin)
        || ',(SELECT   common_lookup_id '
        || '  FROM     common_lookup '
        || '  WHERE    common_lookup_type = '
        ||      dbms_assert.enquote_literal(item_type)||')'
        || ','||dbms_assert.enquote_literal(item_title)
        || ','||dbms_assert.enquote_literal(item_subtitle)
        || ', empty_clob() '
        || ', NULL '
        || ','||dbms_assert.enquote_literal(rating)
        || ','||dbms_assert.enquote_literal(agency)
        || ','||dbms_assert.enquote_literal(release_date)
        || ', 3, SYSDATE, 3, SYSDATE)';
        dbms_output.put_line(stmt);
  EXECUTE IMMEDIATE stmt;

END insert_item;
/

BEGIN
  insert_item (table_name => 'ITEM'
              ,asin => 'B00005O3VC'
              ,item_type => 'DVD_FULL_SCREEN'
              ,item_title => 'Monty Python and the Holy Grail'
              ,item_subtitle => 'Special Edition'
              ,rating => 'PG'
              ,agency => 'MPAA'
              ,release_date => '23-OCT-2001');
END;
/
