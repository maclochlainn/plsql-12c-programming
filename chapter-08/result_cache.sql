/* ================================================================
||   Program Name: result_cache.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates result cache function.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Create a scalar collection of strings.
CREATE OR REPLACE TYPE strings AS TABLE OF VARCHAR2(60);
/

CREATE OR REPLACE FUNCTION get_title
( partial_title VARCHAR2 ) RETURN STRINGS
RESULT_CACHE RELIES_ON(item) IS
  -- Declare a collection control variable and collection variable. 
  counter      NUMBER  := 1;
  return_value STRINGS := strings();

  -- Define a parameterized cursor.
  CURSOR get_title
  ( partial_title VARCHAR2 ) IS
  SELECT   item_title
  FROM     item
  WHERE    UPPER(item_title) LIKE '%'||UPPER(partial_title)||'%';
BEGIN
  -- Read the data and write it to the collection in a cursor FOR loop.
  FOR i IN get_title(partial_title) LOOP
    return_value.EXTEND;
    return_value(counter) := i.item_title;
    counter := counter + 1;
  END LOOP;
  RETURN return_value;
END get_title;
/

list
show errors

CREATE OR REPLACE FUNCTION get_common_lookup
( table_name VARCHAR2, column_name VARCHAR2 ) RETURN LOOKUP
RESULT_CACHE RELIES_ON(common_lookup) IS
  -- A local variable of the user-defined scalar collection type.
  lookups LOOKUP;
 
  -- A cursor to concatenate the columns into one string with a delimiter.
  CURSOR c (table_name_in VARCHAR2, table_column_name_in VARCHAR2) IS
    SELECT   common_lookup_id||'|'||common_lookup_type||'|'||common_lookup_meaning
    FROM     common_lookup
    WHERE    common_lookup_table = UPPER(table_name_in)
    AND       common_lookup_column = UPPER(table_column_name_in);
BEGIN
  OPEN c(table_name, column_name);
  LOOP
    FETCH c BULK COLLECT INTO lookups;
    EXIT WHEN c%NOTFOUND;
  END LOOP;
  RETURN lookups;
END get_common_lookup;
/
DECLARE
  list STRINGS;
BEGIN
  list := get_title('Harry');
  FOR i IN 1..list.LAST LOOP
    dbms_output.put_line('list('||i||') : ['||list(i)||']');
  END LOOP;
END;
/
