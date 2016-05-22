/* ================================================================
||   Program Name: collection_api.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates the collection APIs.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

/* ================================================================
||  COUNT Method
|| ================================================================*/

DECLARE
  /* Define a table collection. */
  TYPE x_table IS TABLE OF INTEGER;

  /* Declare an initialized table collection. */
  lv_table  NUMBER_TABLE := number_table(1,2,3,4,5);
BEGIN
  DBMS_OUTPUT.PUT_LINE('How many? ['||lv_table.COUNT||']');
END;
/

/* ================================================================
||  DELETE Method
|| ================================================================*/

DECLARE
  /* Declare variable with meaningful name. */ 
  current INTEGER;
  
  /* Define a table collection. */
  TYPE x_table IS TABLE OF VARCHAR2(6);
  
  /* Declare an initialized table collection. */
  lv_table  X_TABLE := x_table('One','Two','Three','Four','Five');
BEGIN
  /* Remove one element with an index of 2. */
  lv_table.DELETE(2,2);
  
  /* Remove elements for an inclusive range of 4 to 5. */
  lv_table.DELETE(4,5);

  /* Set the starting index. */  
  current := x.FIRST;

  /* Read through index values in ascending order. */  
  WHILE (current <= x.LAST) LOOP
    dbms_output.put_line(
      'Index ['||current||'] Value ['||x(current)||']');
    /* Shift index to next higher value. */
    current := x.NEXT(current);
  END LOOP;
END;
/

/* ================================================================
||  EXISTS Method
|| ================================================================*/

DECLARE
  /* Define table. */
  TYPE x_table IS TABLE OF VARCHAR2(10);
  
  /* Declare an index counter. */
  lv_index  NUMBER := 1;
  
  /* Declare a local collection variable. */
  lv_table  X_TABLE := x_table();
BEGIN
  IF lv_table.EXISTS(lv_index) AND NOT lv_table.COUNT = 0 THEN
    dbms_output.put_line(lv_table(lv_index));
  END IF;
END;
/

DECLARE
  /* Define table. */
  TYPE x_table IS TABLE OF VARCHAR2(10);
  
  /* Declare an index counter. */
  lv_index  NUMBER := 1;
  
  /* Declare a local collection variable. */
  lv_table  X_TABLE := x_table() := x_table('Something');
BEGIN
  IF lv_table.EXISTS(lv_index) AND lv_table.COUNT > 0 THEN
    dbms_output.put_line(lv_table(lv_index));
  END IF;
END;
/

/* ================================================================
||  EXTEND Method
|| ================================================================*/

DECLARE
  /* Declare variable with meaningful name. */ 
  current INTEGER;
  
  /* Define a table collection. */
  TYPE x_table IS TABLE OF VARCHAR2(6);
  
  /* Declare an initialized table collection. */
  lv_table  X_TABLE := x_table('One');
BEGIN
  /* Extend space, and assign a value. */
  lv_table.EXTEND;
  
  /* Assign a value to the last allocated element. */
  lv_table(lv_table.COUNT) := 'Two';

  /* Set the starting index. */  
  current := lv_table.FIRST;

  /* Read through index values in ascending order. */  
  WHILE (current <= lv_table.LAST) LOOP
    dbms_output.put_line(
      'Index ['||current||'] Value ['||lv_table(current)||']');
    /* Shift index to next higher value. */
    current := lv_table.NEXT(current);
  END LOOP;
END;
/

/* ================================================================
||  FIRST Method
|| ================================================================*/

DECLARE
  /* Define an associative array. */
  TYPE x_table IS TABLE OF INTEGER
    INDEX BY VARCHAR2(9 CHAR);

  /* Declare an associative array variable. */
  lv_list  X_TABLE;
BEGIN
  /* Add elements to associative array. */
  lv_table('Seven') := 7;
  lv_table('Eight') := 8;

  /* Print the element returned by the lowest string index. */
  dbms_output.put_line(
    'Index ['||lv_table.FIRST||']['||lv_list(lv_list.FIRST)||']');
END;
/

/* ================================================================
||  LAST Method
|| ================================================================*/

DECLARE
  /* Define an associative array. */
  TYPE x_varray IS VARRAY(5) OF INTEGER;
  
  /* Declare an initialized table collection. */  
  lv_array  X_VARRAY := x_varray(1,2,3);
BEGIN
  /* Print the count and limit values. */
  dbms_output.put_line(
    'Count['||lv_array.COUNT||']: Limit['||lv_array.LIMIT||']');
END;
/

/* ================================================================
||  NEXT Method
|| ================================================================*/

DECLARE
  /* Declare variable with meaningful name. */ 
  current INTEGER;
  
  /* Define a table collection. */
  TYPE x_table IS TABLE OF VARCHAR2(6);
  
  /* Declare an initialized table collection. */
  lv_table  X_TABLE := x_table('One','Two','Three','Four','Five');
BEGIN
  /* Set the starting index. */  
  current := lv_table.FIRST;

  /* Read through index values in ascending order. */  
  WHILE (current <= lv_table.LAST) LOOP
    dbms_output.put_line(
      'Index ['||current||'] Value ['||lv_table(current)||']');
    /* Shift index to next higher value. */
    current := lv_table.NEXT(current);
  END LOOP;
END;
/

/* ================================================================
||  PRIOR Method
|| ================================================================*/

DECLARE
  /* Declare variable with meaningful name. */ 
  current INTEGER;
  
  /* Define a table collection. */
  TYPE x_table IS TABLE OF VARCHAR2(6);
  
  /* Declare an initialized table collection. */
  lv_table  X_TABLE := x_table('One','Two','Three','Four','Five');
BEGIN
  /* Set the starting index. */  
  current := lv_table.LAST;

  /* Read through index values in ascending order. */  
  WHILE (current >= lv_table.FIRST) LOOP
    dbms_output.put_line(
      'Index ['||current||'] Value ['||lv_table(current)||']');
    /* Shift index to next higher value. */
    current := lv_table.PRIOR(current);
  END LOOP;
END;
/

/* ================================================================
||  TRIM Method
|| ================================================================*/

DECLARE
  /* Declare variable with meaningful name. */
  current INTEGER;

  /* Define a table collection. */
  TYPE x_table IS TABLE OF VARCHAR2(6);

  /* Declare an initialized table collection. */
  lv_table  X_TABLE := x_table('One','Two','Three','Four','Five');
BEGIN
  /* Remove one element with an index of 2. */
  lv_table.TRIM(3);

  /* Set the starting index. */
  current := lv_table.FIRST;

  /* Read through index values in ascending order. */
  WHILE (current <= lv_table.LAST) LOOP
    dbms_output.put_line(
      'Index ['||current||'] Value ['||lv_table(current)||']');

      /* Shift index to next higher value. */
    current := lv_table.NEXT(current);
  END LOOP;
END;
/
