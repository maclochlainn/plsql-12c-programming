/* ================================================================
||   Program Name: associative_array.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates associative arrays.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  /* Define an associative array of a scalar data type. */
  TYPE suit_table IS TABLE OF VARCHAR2(7 CHAR)
    INDEX BY BINARY_INTEGER;

  /* Declare and attempt to construct an object. */
  lv_suit SUIT_TABLE;
BEGIN
  /* Assign values to an ADT. */
  lv_suit(1) := 'Club';
  lv_suit(2) := 'Heart';
  lv_suit(3) := 'Diamond';
  lv_suit(4) := 'Spade';
  
  /* Loop through a densely populated indexed collection. */
  FOR i IN lv_suit.FIRST..lv_suit.LAST LOOP
    dbms_output.put_line(lv_suit(i));
  END LOOP;
END;
/

DECLARE
  /* Variable name carries meaning. */
  current  VARCHAR2(11);
  
  /* Define an associative array of a scalar data type. */
  TYPE card_table IS TABLE OF NUMBER
    INDEX BY VARCHAR2(11);

  /* Declare and attempt to construct an object. */
  lv_card CARD_TABLE;
BEGIN
  /* Assign values to an ADT. */
  lv_card('One') := 1;
  lv_card('Two') := 2;
  lv_card('Three') := 3;
  lv_card('Four') := 4;
  lv_card('Five') := 5;
  lv_card('Six') := 6;
  lv_card('Seven') := 7;
  lv_card('Eight') := 8;
  lv_card('Nine') := 9;
  lv_card('Ten') := 10;
  lv_card('Eleven') := 11;
  lv_card('Twelve') := 12;
  lv_card('Thirteen') := 13;
  
  /* Set the starting point. */
  current := lv_card.FIRST;
  
  /* Check pseudo index value less than last index value. */  
  WHILE (current <= lv_card.LAST) LOOP
    /* Print current value. */
    dbms_output.put_line(
      'Values ['||current||']['||lv_card(current)||']');

    /* Shift the index to the next value. */
    current := lv_card.NEXT(current);    
  END LOOP;
END;
/

CREATE OR REPLACE
  TYPE prominent_object IS OBJECT
  ( name     VARCHAR2(20)
  , age      VARCHAR2(10));
/

DECLARE
  /* Declare a local type of a SQL composite data type. */
  TYPE prominent_table IS TABLE OF prominent_object
    INDEX BY PLS_INTEGER;

  /* Declare a local variable of the collection data type. */
  lv_array  PROMINENT_TABLE;
BEGIN
  /* The initial element uses a -100 as an index value. */
  lv_array(-100) := prominent_object('Bard the Bowman','3rd Age');

  /* Check whether there are any elements to retrieve. */
  IF lv_array.EXISTS(-100) THEN
    dbms_output.put_line(
      '['||lv_array(-100).name||']['||lv_array(-100).age||']');
  END IF;
END;
/

DECLARE
  /* Declare a local type of a SQL composite data type. */
  TYPE prominent_table IS TABLE OF prominent_object
    INDEX BY PLS_INTEGER;

  /* Declare a local variable of the collection data type. */
  lv_array  PROMINENT_TABLE;
BEGIN
  /* The initial element uses a -100 as an index value. */
  lv_array(-100);

  /* Assign values to the two fields of the element. */
  lv_array(-100).name := 'Bard the Bowman';
  lv_array(-100).age  := '3rd Age';
  
  /* Check whether there are any elements to retrieve. */
  IF lv_array.EXISTS(-100) THEN
    dbms_output.put_line(
      '['||lv_array(-100).name||']['||lv_array(-100).age||']');
  END IF;
END;
/

DECLARE
  /* Declare a record type. */
  TYPE prominent_record IS RECORD
  ( name     VARCHAR2(20)
  , age      VARCHAR2(10));

  /* Declare a local type of a SQL composite data type. */
  TYPE prominent_table IS TABLE OF prominent_record
    INDEX BY PLS_INTEGER;

  /* Declare a local variable of the record data type. */
  lv_record  PROMINENT_RECORD;

  /* Declare a local variable of the collection data type. */
  lv_array   PROMINENT_TABLE;
BEGIN
  /* The initial element uses a -100 as an index value. */
  lv_record.name := 'Bard the Bowman';
  lv_record.age  := '3rd Age';

  /* Assign a record value to the element of the collection. */
  lv_array(-100) := lv_record;
  
  /* Check whether there are any elements to retrieve. */
  IF lv_array.EXISTS(-100) THEN
    dbms_output.put_line(
      '['||lv_array(-100).name||']['||lv_array(-100).age||']');
  END IF;
END;
/
