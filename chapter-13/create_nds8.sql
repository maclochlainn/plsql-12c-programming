/* ================================================================
||   Program Name: create_nds8.sql
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
  -- Declare explicit record structure and table of structure.
  TYPE title_record IS RECORD
  ( item_title     VARCHAR2(60)
  , item_subtitle  VARCHAR2(60));
  TYPE title_table IS TABLE OF title_record;
  -- Declare dynamic variables.  
  title_cursor  SYS_REFCURSOR;
  title_rows    TITLE_TABLE;
  -- Declare DBMS_SQL variables.
  c             INTEGER := dbms_sql.open_cursor;
  fdbk          INTEGER;
  -- Declare local variables.
  counter       NUMBER := 1;
  column_names  DBMS_SQL.VARCHAR2_TABLE;
  item_ids      DBMS_SQL.NUMBER_TABLE;
  stmt          VARCHAR2(2000);
  substmt       VARCHAR2(2000) := '';
BEGIN
  -- Find the rows that meet the criteria. 
  FOR i IN (SELECT 'item_ids' AS column_names
            ,       item_id
            FROM    item
            WHERE   REGEXP_LIKE(item_title,'^Harry Potter')) LOOP
    column_names(counter) := counter;
    item_ids(counter) := i.item_id;
    counter := counter + 1;
  END LOOP;
 
  dbms_sql.close_cursor(c);
  -- Dynamically create substatement.
  IF item_ids.COUNT = 1 THEN
    substmt := 'WHERE item_id IN (:item_ids)';
  ELSE
    substmt := 'WHERE item_id IN (';
    FOR i IN 1..item_ids.COUNT LOOP
      IF i = 1 THEN
        substmt := substmt ||':'||i;
      ELSE
        substmt := substmt ||',:'||i;
      END IF;
    END LOOP;
    substmt := substmt || ')';
  END IF;

  -- Set statement.
  stmt := 'SELECT  item_title, item_subtitle '
       || 'FROM    item '
       ||  substmt;
       
  -- Parse the statement with DBMS_SQL
  dbms_sql.parse(c,stmt,dbms_sql.native);

  -- Bind the bind variable name and value.  
  FOR i IN 1..item_ids.COUNT LOOP
    dbms_sql.bind_variable(c,column_names(i),item_ids(i));
  END LOOP;

  -- Execute using DBMS_SQL.  
  fdbk := dbms_sql.execute(c);
  
  -- Convert the cursor to NDS.
  title_cursor := dbms_sql.to_refcursor(c);
  
  -- Open and read dynamic curosr, then close it.
  FETCH title_cursor BULK COLLECT INTO title_rows;

  FOR i IN 1..title_rows.COUNT LOOP
    dbms_output.put_line(
      '['||title_rows(i).item_title||']['||title_rows(i).item_subtitle||']');
  END LOOP;

  -- Close the System Reference Cursor.
  CLOSE title_cursor;
END;
/

