/* ================================================================
||   Program Name: dynamic_range.sql
||   Date:         2013-12-02
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 2
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script creates objects that support a complete example
||   of how you white-list functions, procedures, types, and packages.
|| ================================================================*/

-- Conditionally drop the ITEM_TITLE_TABLE object type.
BEGIN
  FOR i IN (SELECT object_name
            FROM   user_objects
            WHERE  object_name = 'ITEM_TITLE_TABLE'
            AND    object_type = 'TYPE') LOOP
    /* Dynamically drop object type. */
    EXECUTE IMMEDIATE 'DROP TYPE '||i.object_name||' FORCE';
  END LOOP;
END;
/

-- Create or replace an ADT collection type. 
CREATE OR REPLACE
  TYPE item_title_table AS TABLE OF VARCHAR2(60);
/

-- Enable SERVEROUTPUT for the script.
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Create or replace a DYNAMIC_RANGE function.
CREATE OR REPLACE FUNCTION dynamic_range
( pv_offset  NUMBER
, pv_rows    NUMBER ) RETURN item_title_table IS

  /* Declare a collection type. */
  lv_item_title_table  ITEM_TITLE_TABLE := item_title_table();

  /* Local variable length string. */
  lv_item_title   VARCHAR2(60);

  /* Declare a local counter. */
  lv_counter  NUMBER := 1;

  /* Local NDS statement and cursor variables. */
  lv_stmt    VARCHAR2(2000);
  lv_cursor  SYS_REFCURSOR;

BEGIN

  /* Assigned a dynamic SQL statement to local variable. */
  lv_stmt := 'SELECT   i.item_title'||CHR(10)
          || 'FROM     item i'||CHR(10)
          || 'OFFSET :bv_offset ROWS FETCH FIRST :bv_rows ROWS ONLY';
 
  /* Open cursor for dynamic DNS statement. */
  OPEN lv_cursor FOR lv_stmt USING pv_offset, pv_rows;
  LOOP
    /* Fetch element from cursor and assign to local variable. */
    FETCH lv_cursor INTO lv_item_title;

    /* Exit when no more record found. */
    EXIT WHEN lv_cursor%NOTFOUND;

    /* Extend space, assign a value, and increment counter. */
    lv_item_title_table.EXTEND;
    lv_item_title_table(lv_counter) := lv_item_title;
    lv_counter := lv_counter + 1;
  END LOOP;

  /* Close cursor. */
  CLOSE lv_cursor;

  /* Return collection. */
  RETURN lv_item_title_table;
END;
/

-- Query the values returned by a dynamically limited cursor.
SELECT   COLUMN_VALUE AS item_title
FROM     TABLE(dynamic_range(2,5));