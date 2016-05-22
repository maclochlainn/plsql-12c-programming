/* ================================================================
||   Program Name: expanding_view.sql
||   Date:         2013-12-02
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 2
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script creates objects that support a complete example
||   of how you use the new EXPAND_SQL_TEXT procedure of the 
||   DBMS_UTILITY package.
|| ================================================================*/

-- Create a view from a join of two tables and one view of two tables
-- for subsequenct use.
CREATE OR REPLACE VIEW group_view AS
  SELECT   cr.full_name
  FROM     member m INNER JOIN current_rental cr
  ON       m.account_number = cr.account_number
  WHERE    m.member_type =
            (SELECT   common_lookup_id
             FROM     common_lookup
             WHERE    common_lookup_type = 'GROUP');

-- Describe GROUP_VIEW.
DESC group_view

-- Converts a long column to a CLOB data type.
CREATE OR REPLACE FUNCTION long_to_clob
( pv_view_name      VARCHAR2
, pv_column_length  INTEGER )
RETURN CLOB AS

  /* Declare local variables. */
  lv_cursor    INTEGER := dbms_sql.open_cursor;
  lv_feedback  INTEGER;         -- Acknowledgement of dynamic execution
  lv_length    INTEGER;          -- Length of string
  lv_return    CLOB;            -- Function output
  lv_stmt      VARCHAR2(2000);  -- Dynamic SQL statement
  lv_string    VARCHAR2(32760); -- Maximum length of LONG data type

BEGIN
  /* Create dynamic statement. */
  lv_stmt := 'SELECT text'||CHR(10)
          || 'FROM user_views'||CHR(10)
          || 'WHERE view_name = '''||pv_view_name||'''';

  /* Parse and define a long column. */
  dbms_sql.parse(lv_cursor, lv_stmt, dbms_sql.native);
  dbms_sql.define_column_long(lv_cursor,1);

  /* Only attempt to process the return value when fetched. */
  IF dbms_sql.execute_and_fetch(lv_cursor) = 1 THEN
    dbms_sql.column_value_long(
        lv_cursor
      , 1
      , pv_column_length
      , 0
      , lv_string
      , lv_length);
  END IF;

  /* Check for an open cursor. */
  IF dbms_sql.is_open(lv_cursor) THEN
    dbms_sql.close_cursor(lv_cursor);
  END IF;

  /* Create a local temporary CLOB in memory:
     - It returns a constructed lv_return_result.
     - It disables a cached version.
     - It set the duration to 12 (the value of the dbms_lob.call
       package-level variable) when the default is 10. */
  dbms_lob.createtemporary(lv_return, FALSE, dbms_lob.call);

  /* Append the Long to the empty temporary CLOB. */
  dbms_lob.write(lv_return, pv_column_length, 1, lv_string);

  RETURN lv_return;
END long_to_clob;
/

LIST

-- Describe LONG_TO_CLOB function.
DESC long_to_clob

-- Create the function to use dbms_utility.expand_sql_text procedure.
CREATE OR REPLACE FUNCTION expand_view 
( pv_view_name  VARCHAR2 ) RETURN CLOB IS

  /* Declare containers for views. */
  lv_input_view   CLOB;
  lv_output_view  CLOB;

  /* Declare a target variable,  because of the limit of SELECT-INTO. */
  lv_long_view  LONG;

  /* Declare a dynamic cursor. */
  CURSOR c (cv_view_name VARCHAR2) IS
    SELECT   text
    FROM     user_views
    WHERE    view_name = cv_view_name;
 
BEGIN
  /* Open, fetch, and close cursor to capture view text. */
  OPEN c(pv_view_name);
  FETCH c INTO lv_long_view;
  CLOSE c;

  /* Convert a LONG return type to a CLOB. */
  lv_input_view := long_to_clob(pv_view_name, LENGTH(lv_long_view));

  /* Send in the view text and receive the complete text. */
  dbms_utility.expand_sql_text(lv_input_view, lv_output_view);

  /* Return the output CLOB value by padding with a double white-space. */
  RETURN '  '||lv_output_view;
END;
/

-- Describe EXPAND_VIEW function.
DESC expand_view

-- Query the RETURN_VIEW_TEXT function.
SELECT return_view_text('GROUP_VIEW') AS "View Contents"
FROM   dual;

-- Set a column length.
COLUMN querytext FORMAT A30 HEADING "Query Text"

-- Test the expand_view function.
SELECT SUBSTR(expand_view('GROUP_VIEW'),1,INSTR(expand_view('GROUP_VIEW'),'"',1,4)) AS "querytext"
,      LENGTH(expand_view('GROUP_VIEW')) AS "Query Length"
FROM   dual;

-- Converts a long column to a CLOB data type.
CREATE OR REPLACE FUNCTION long_to_varchar2
( pv_view_name      VARCHAR2
, pv_column_length  INTEGER )
RETURN VARCHAR2 AS

  /* Declare local variables. */
  lv_cursor    INTEGER := dbms_sql.open_cursor;
  lv_feedback  INTEGER;          -- Acknowledgement of dynamic execution
  lv_length    INTEGER;          -- Length of string
  lv_return    VARCHAR2(32767);  -- Function output
  lv_stmt      VARCHAR2(2000);   -- Dynamic SQL statement
  lv_string    VARCHAR2(32760);  -- Maximum length of LONG data type

BEGIN
  /* Create dynamic statement. */
  lv_stmt := 'SELECT text'||CHR(10)
          || 'FROM user_views'||CHR(10)
          || 'WHERE view_name = '''||pv_view_name||'''';

  /* Parse and define a long column. */
  dbms_sql.parse(lv_cursor, lv_stmt, dbms_sql.native);
  dbms_sql.define_column_long(lv_cursor,1);

  /* Only attempt to process the return value when fetched. */
  IF dbms_sql.execute_and_fetch(lv_cursor) = 1 THEN
    dbms_sql.column_value_long(
        lv_cursor
      , 1
      , pv_column_length
      , 0
      , lv_string
      , lv_length);
  END IF;

  /* Check for an open cursor. */
  IF dbms_sql.is_open(lv_cursor) THEN
    dbms_sql.close_cursor(lv_cursor);
  END IF;

  /* Convert the long length string to a maximum size length. */
  lv_return := lv_string;

  RETURN lv_return;
END long_to_varchar2;
/

-- Describe LONG_TO_VARCHAR2 function.
DESC long_to_varchar2

-- Create the function to use dbms_utility.expand_sql_text procedure.
CREATE OR REPLACE FUNCTION expand_view 
( pv_view_name  VARCHAR2 ) RETURN CLOB IS

  /* Declare containers for views. */
  lv_input_view   CLOB;
  lv_output_view  CLOB;

  /* Declare a target variable,  because of the limit of SELECT-INTO. */
  lv_long_view  LONG;

  /* Declare a dynamic cursor. */
  CURSOR c (cv_view_name VARCHAR2) IS
    SELECT   text
    FROM     user_views
    WHERE    view_name = cv_view_name;
 
BEGIN
  /* Open, fetch, and close cursor to capture view text. */
  OPEN c(pv_view_name);
  FETCH c INTO lv_long_view;
  CLOSE c;

  /* Convert a LONG return type to a CLOB. */
  lv_input_view := long_to_clob(pv_view_name, LENGTH(lv_long_view));

  /* Send in the view text and receive the complete text. */
  dbms_utility.expand_sql_text(lv_input_view, lv_output_view);

  /* Return the output CLOB value. */
  RETURN lv_output_view;
END;
/

-- Describe EXPAND_VIEW function.
DESC expand_view

-- Create the function to return a view text.
CREATE OR REPLACE FUNCTION return_view_text 
( pv_view_name  VARCHAR2 ) RETURN VARCHAR2 IS

  /* Declare a target variable,  because of the limit of SELECT-INTO. */
  lv_long_view  LONG;

  /* Declare a dynamic cursor. */
  CURSOR c (cv_view_name VARCHAR2) IS
    SELECT   text
    FROM     user_views
    WHERE    view_name = cv_view_name;
 
BEGIN
  /* Open, fetch, and close cursor to capture view text. */
  OPEN c(pv_view_name);
  FETCH c INTO lv_long_view;
  CLOSE c;

  /* Return the output CLOB value by padding with a double white-space. */
  RETURN '  '||long_to_varchar2(pv_view_name, LENGTH(lv_long_view));
END;
/

-- Describe RETURN_VIEW_TEXT function.
DESC return_view_text

-- Query the RETURN_VIEW_TEXT function.
SELECT return_view_text('GROUP_VIEW') AS "View Contents"
FROM   dual;

-- Set a column length.
COLUMN querytext FORMAT A30 HEADING "Query Text"

-- Test the expand_view function.
SELECT SUBSTR(expand_view('GROUP_VIEW'),1,INSTR(expand_view('GROUP_VIEW'),'"',1,4)) AS "querytext"
,      LENGTH(expand_view('GROUP_VIEW')) AS "Query Length"
FROM   dual;
