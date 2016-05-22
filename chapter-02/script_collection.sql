/* ================================================================
||   Program Name: script_collection.sql
||   Date:         2013-12-02
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 3
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script creates objects that support a complete example
||   of how you white-list functions, procedures, types, and packages.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ------------------------------------------------------------
--   Block Structure
-- ------------------------------------------------------------
--   Basic Block Structure
-- ------------------------------------------------------------

-- A basic heelo_world.sql script.
BEGIN
  dbms_output.put_line('Hello World.');
END;
/

-- An anonymous block with a substitution variable.
BEGIN
  dbms_output.put_line('['||'&input'||']');
END;
/

-- Declare a SQL*Plus variable.
VARIABLE bind_variable VARCHAR2(20)

-- Anonymous block with a bind variable assignment.
BEGIN
  :bind_variable := 'Hello Krypton.';
  dbms_output.put_line('['||:bind_variable||']');
END;
/

-- ------------------------------------------------------------
--   Declaration Block
-- ------------------------------------------------------------

-- Anonymous block managing bind variable values.
DECLARE
  lv_input VARCHAR2(30);
BEGIN
  lv_input := :bind_variable;
  dbms_output.put_line('['||lv_input||']');
END;
/

-- ------------------------------------------------------------
--   Declaration Block
-- ------------------------------------------------------------

-- Anonymous block raises an error when a string is passed
-- because it's not quoted. 
BEGIN
  dbms_output.put_line('['||&input||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line(SQLERRM);
END;
/

-- ------------------------------------------------------------
--   Behavior of Variables in Blocks
-- ------------------------------------------------------------
--   Anonymous Block
-- ------------------------------------------------------------

-- Anonymous blocks without declaration.
DECLARE
  lv_sample  NUMBER;
BEGIN
  dbms_output.put_line('Value is ['||lv_sample||']');
END;
/

-- Anonymous blocks with a constant declaration.
DECLARE
  lv_sample CONSTANT NUMBER := 1;
BEGIN
  dbms_output.put_line('Value is ['||lv_sample||']');
END;
/

-- Anonymous block with a substitution variable in the declaration block.
DECLARE
  lv_input VARCHAR2(10) := '&input';
BEGIN
  dbms_output.put_line('['||lv_input||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line(SQLERRM);
END;
/

-- Anonymous block with proper substitution in the execution block.
DECLARE
  lv_input VARCHAR2(10);
BEGIN
  lv_input := '&input';
  dbms_output.put_line('['||lv_input||']');
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line(SQLERRM);
  END;
/

-- Anonymous block with a down cast from a real number to an integer.
DECLARE
  lv_input INTEGER;
BEGIN
  lv_input := 4.67;
  dbms_output.put_line('['||lv_input||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('['||SQLERRM||']');
END;
/

-- ------------------------------------------------------------
--   Nested Anonymous Block
-- ------------------------------------------------------------

-- Anonymous nested blocks.
DECLARE
  -- Declare local variable.
  lv_input VARCHAR2(30) DEFAULT 'OUTER';
BEGIN
  -- Print the value before the inner block.
  dbms_output.put_line('Outer block ['||lv_input||']');

  -- Nested block.
  BEGIN
    -- Print the value before the assignment.
    dbms_output.put_line('Inner block ['||lv_input||']');

    -- Assign new value to variable.
    lv_input := 'INNER';

    -- Print the value after the assignment.
    dbms_output.put_line('Inner block ['||lv_input||']');
  END;

  -- Print the value after the nested block.
  dbms_output.put_line('Outer block ['||lv_input||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/

-- Autonomous block with a nested anonymous block.
DECLARE
  -- Declare local variable.
  lv_outer VARCHAR2(30) DEFAULT 'OUTER';
  lv_active VARCHAR2(30) DEFAULT 'OUTER';

BEGIN
  -- Print the value before the inner block.
  dbms_output.put_line('Outer ['||lv_outer||']['||lv_active||']');

  -- Nested block.
  DECLARE
    -- Declare local variable.
    lv_active VARCHAR2(30) DEFAULT 'INNER';

  BEGIN
    -- Print the value before the assignment.
    dbms_output.put_line('Inner ['||lv_outer||']['||lv_active||']');

    -- Assign new value to variable.
    lv_outer := 'INNER';

    -- Print the value after the assignment.
    dbms_output.put_line('Inner ['||lv_outer||']['||lv_active||']');
  END;

  -- Print the value after the nested block.
  dbms_output.put_line('Outer ['||lv_outer||']['||lv_active||']');

EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('Exception '||SQLERRM||']');
END;
/

-- ------------------------------------------------------------
--   Local Named Blocks
-- ------------------------------------------------------------

-- Nested named block in an anonymous block.
DECLARE
  -- Declare local variable.
  lv_outer VARCHAR2(30) DEFAULT 'OUTER';
  lv_active VARCHAR2(30) DEFAULT 'OUTER';

  -- A local procedure without any formal parameters.
  PROCEDURE local_named IS
  -- Declare local variable.
  lv_active VARCHAR2(30) DEFAULT 'INNER';

  BEGIN
    -- Print the value before the assignment.
    dbms_output.put_line(
     'Inner ['||lv_outer||']['||lv_active||']');

    -- Assign new value to variable.
    lv_local := 'INNER';

    -- Print the value after the assignment.
    dbms_output.put_line(
     'Inner ['||lv_outer||']['||lv_active||']');
  END local_named;

BEGIN
  -- Print the value before the inner block.
  dbms_output.put_line(
    'Outer '||lv_outer||']['||lv_active||']');

  -- Call to the locally declared named procedure.
  local_named;

  -- Print the value after the nested block.
  dbms_output.put_line(
   'Outer ['||lv_outer||']['||lv_active||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/

-- Scope access problem with nested named blocks.
DECLARE
  PROCEDURE jack IS
  BEGIN
    dbms_output.put_line(hector||' World!');
  END jack;
  FUNCTION hector RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello';
  END hector;
BEGIN
  jack;
END;
/

-- Implements a forward referencing stubs.
DECLARE
  PROCEDURE jack;
  FUNCTION hector RETURN VARCHAR2;
  PROCEDURE jack IS
  BEGIN
    dbms_output.put_line(b||' World!');
  END jack;
  FUNCTION hector RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello';
  END hector;
BEGIN
  jack;
END;
/

-- ------------------------------------------------------------
--   Stored Named Block
-- ------------------------------------------------------------

-- A stand alone named procedure.
CREATE OR REPLACE PROCEDURE local_named IS
  -- Declare local variable.
  lv_active VARCHAR2(30) DEFAULT 'INNER';
  lv_outer VARCHAR2(30) DEFAULT ' ';

BEGIN
  -- Print the value before the assignment.
  dbms_output.put_line(
   'Inner ['||lv_outer||']['||lv_active||']');

  -- Assign new value to variable.
  lv_outer := 'INNER';

  -- Print the value after the assignment.
  dbms_output.put_line(
   'Inner ['||lv_outer||']['||lv_active||']');
END local_named;
/

-- An anonymous block program that calls the named block program.
DECLARE
  -- Declare local variable.
  lv_outer VARCHAR2(30) DEFAULT 'OUTER';
  lv_active VARCHAR2(30) DEFAULT 'OUTER';

BEGIN
  -- Print the value before the inner block.
  dbms_output.put_line('Outer ['||lv_outer||']['||lv_active||']');

  -- Call to the locally declared named procedure.
  local_named;

  -- Print the value after the nested block.
  dbms_output.put_line('Outer ['||lv_outer||']['||lv_active||']');
EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/

-- ------------------------------------------------------------
--   Basic Scalar and Composite Data Types
-- ------------------------------------------------------------
--   Scalar Data Types
-- ------------------------------------------------------------

-- String data types.
DECLARE
  lv_fixed CHAR(40) := 'Something not quite long.';
  lv_variable VARCHAR2(40) := 'Something not quite long.';
BEGIN
  dbms_output.put_line('Fixed Length ['||LENGTH(lv_fixed)||']');
  dbms_output.put_line('Varying Length ['||LENGTH(lv_variable)||']');
END;
/

-- Date data types. 
DECLARE
  lv_date_1 DATE := '28-APR-75';
  lv_date_2 DATE := '29-APR-1975';
  lv_date_3 DATE := TO_DATE('19750430','YYYYMMDD');
BEGIN
  dbms_output.put_line('Implicit ['||lv_date_1||']');
  dbms_output.put_line('Implicit ['||lv_date_2||']');
  dbms_output.put_line('Explicit ['||lv_date_3||']');
END;
/

-- Number data types.
DECLARE
  lv_number1 NUMBER;
  lv_number2 NUMBER(4,2) := 99.99;
BEGIN
  lv_number1 := lv_number2;
  dbms_output.put_line(lv_number1);
END;
/

-- ------------------------------------------------------------
--   SQL UDT
-- ------------------------------------------------------------

@hobbit.sql

-- ------------------------------------------------------------
--   PL/SQL Record Type
-- ------------------------------------------------------------

-- Create and populate a record.
DECLARE
  -- Declare a local user-defined record structure.
  TYPE title_record IS RECORD
  ( title VARCHAR2(60)
  , subtitle VARCHAR2(60));

  -- Declare a variable that uses the record structure.
  lv_title_record TITLE_RECORD;
BEGIN
  -- Assign values to the record structure.
  lv_title_record.title := 'Star Trek';
  lv_title_record.subtitle := 'Into Darkness';

  -- Print the elements of the structure.
  dbms_output.put_line('['||lv_title_record.title||']'||
   '['||lv_title_record.subtitle||']');
END;
/

-- Create or replace STRING_TABLE type.
CREATE OR REPLACE
  TYPE string_table IS TABLE OF VARCHAR2(30);
/

-- Create or replace STRING_VARRAY type.
CREATE OR REPLACE
  TYPE string_varray IS VARRAY(3) OF VARCHAR2(30);
/

-- Anonymous block to loop through an array.
DECLARE
  -- Declare and initialize a collection of grains.
  lv_string_list STRING_TABLE := string_table('Corn','Wheat');
BEGIN
  -- Print the first item in the array.
  FOR i IN 1..2 LOOP
    dbms_output.put_line('['||i||']['||lv_string_list(i)||']');
  END LOOP;
END;
/

-- An anonymous block that transfers from a list to an array.
DECLARE
  -- Declare and initialize a collection of grains.
  lv_string_table STRING_TABLE :=
    string_table('Corn','Wheat','Rye','Barley');
  lv_string_varray STRING_VARRAY := string_varray();
BEGIN
  -- Print the first item in the array.
  FOR i IN 1..lv_string_table.COUNT LOOP
    lv_string_varray.EXTEND;
    lv_string_varray(i) := lv_string_table(i);
  END LOOP;
END;
/

-- ------------------------------------------------------------
--   UDT Collection
-- ------------------------------------------------------------

@hobbit.sql

-- ------------------------------------------------------------
--   PL/SQL Collection
-- ------------------------------------------------------------

-- Anonymous block with a table collection.
DECLARE
  -- Declare a collection data type of numbers.
  TYPE number_table IS TABLE OF NUMBER;

  -- Declare a variable of the collection data types.
  lv_collection NUMBER_TABLE := number_type(1,2,3);
BEGIN
  -- Loop through the collection and print values.
  FOR i IN 1..lv_collection.COUNT LOOP
    dbms_output.put_line(lv_collection(i));
  END LOOP;
END;
/

-- Anonymous block with a varray collection.
DECLARE
  -- Declare a collection data type of numbers.
  TYPE number_table IS VARRAY(3) OF NUMBER;

  -- Declare a variable of the collection data types.
  lv_collection NUMBER_TABLE := number_type(1,2,3);
BEGIN
  -- Loop through the collection and print values.
  FOR i IN 1..lv_collection.COUNT LOOP
    dbms_output.put_line(lv_collection(i));
  END LOOP;
END;
/

-- Anonymous block with an associative array.
DECLARE
  -- Declare a collection data type of numbers.
  TYPE numbers IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

  -- Declare a variable of the collection data types.
  lv_collection NUMBERS;
BEGIN
  -- Assign a value to the collection.
  lv_collection(0) := 1;
END;
/

-- Anonymous block with an associative array.
DECLARE
  -- Declare a collection data type of numbers.
  TYPE numbers IS TABLE OF NUMBER INDEX BY VARCHAR2(10);

  -- Declare a variable of the collection data types.
  lv_collection NUMBERS;
BEGIN
  -- Assign a value to the collection.
  lv_collection('One') := 1;
END;
/

-- Anonymous block with a SQL UDT type.
DECLARE
  -- Declare a local collection of hobbits.
  TYPE hobbit_table IS TABLE OF HOBBIT;

  -- Declare and initialize a collection of grains.
  lv_string_table STRING_TABLE :=
  string_table('Drogo Baggins','Frodo Baggins');
  lv_hobbit_table HOBBIT_TABLE := hobbit_table(
      hobbit('Bungo Baggins')
    , hobbit('Bilbo Baggins'));
BEGIN
  -- Print the first item in the array.
  FOR i IN 1..lv_string_table.COUNT LOOP
    lv_hobbit_table.EXTEND;
    lv_hobbit_table(lv_hobbit_table.COUNT) :=
    hobbit(lv_string_table(i));
  END LOOP;
  -- Print the members of the hobbit table.
  FOR i IN 1..lv_hobbit_table.COUNT LOOP
    dbms_output.put_line(
      lv_hobbit_table(i).to_string());
  END LOOP;
END;
/

-- Anonymous block with an associative array of composite variables.
DECLARE
  -- Declare a local user-defined record structure.
  TYPE dwarf_record IS RECORD
  ( dwarf_name VARCHAR2(20)
  , dwarf_home VARCHAR2(20));

  -- Declare a local collection of hobbits.
  TYPE dwarf_table IS TABLE OF DWARF_RECORD
    INDEX BY PLS_INTEGER;

  -- Declare and initialize a collection of grains.
  list DWARF_TABLE;
BEGIN
  -- Add two elements to the associative array.
  list(1).dwarf_name := 'Gloin';
  list(1).dwarf_home := 'Durin''s Folk';
  list(2).dwarf_name := 'Gimli';
  list(2).dwarf_home := 'Durin''s Folk';

  -- Print the first item in the array.
  FOR i IN 1..list.COUNT LOOP
    dbms_output.put_line(
     '['||list(i).dwarf_name||']'||
     '['||list(i).dwarf_home||']');
  END LOOP;
END;
/

-- ------------------------------------------------------------
--   Control Structures
-- ------------------------------------------------------------
--   Conditional Structures
-- ------------------------------------------------------------

-- If, elsif, and else statements.
DECLARE
  lv_boolean BOOLEAN;
  lv_number NUMBER;
BEGIN
  IF NVL(lv_boolean,FALSE) THEN
    dbms_output.put_line('Prints when the variable is true.');
  ELSIF NVL((lv_number < 10),FALSE) THEN
    dbms_output.put_line('Prints when the expression is true.');
  ELSE
    dbms_output.put_line('Prints when variables are null values.');
  END IF;
END;
/

-- Case statements.
DECLARE
  lv_selector VARCHAR2(20);
BEGIN
  lv_selector := '&input';
  CASE lv_selector
    WHEN 'Apple' THEN
      dbms_output.put_line('Is it a red delicious apple?');
    WHEN 'Orange' THEN
      dbms_output.put_line('Is it a navel orange?');
    ELSE
      dbms_output.put_line('It''s a ['||lv_selector||']?');
  END CASE;
END;
/

-- Case statements based on truth.
BEGIN
  CASE
    WHEN (1 <> 1) THEN
      dbms_output.put_line('Impossible!');
    WHEN (3 > 2) THEN
      dbms_output.put_line('A valid range comparison.');
    ELSE
      dbms_output.put_line('Never reached.');
  END CASE;
END;
/

-- Case statement based on falsity.
BEGIN
  CASE FALSE
    WHEN (1 <> 1) THEN
      dbms_output.put_line('Impossible!');
    WHEN (3 > 2) THEN
      dbms_output.put_line('A valid range comparison.');
    ELSE
      dbms_output.put_line('Never reached.');
  END CASE;
END;
/

-- ------------------------------------------------------------
--   Iterative Structures
-- ------------------------------------------------------------

-- A forward for-loop statement.
BEGIN
  FOR i IN 0..9 LOOP
    dbms_output.put_line('['||i||']['||TO_CHAR(i+1)||']');
  END LOOP;
END;
/

-- A reverse for-loop statement.
BEGIN
  FOR i IN REVERSE 1..9 LOOP
    dbms_output.put_line('['||i||']['||TO_CHAR(i+1)||']');
  END LOOP;
END;
/

-- An implicit cursor for-loop statement.
BEGIN
  FOR i IN (SELECT item_title FROM item) LOOP
    dbms_output.put_line(i.item_title);
  END LOOP;
END;
/

-- An explicit static cursor for-loop statement.
DECLARE
  CURSOR c IS
    SELECT item_title FROM item;
BEGIN
  FOR i IN c LOOP
    dbms_output.put_line(i.item_title);
  END LOOP;
END;
/

-- An explicit dynamic cursor for-loop statement.
DECLARE
  lv_search_string VARCHAR2(60);
  CURSOR c (cv_search VARCHAR2) IS
    SELECT item_title
    FROM item
    WHERE REGEXP_LIKE(item_title,'^'||cv_search||'*+');
BEGIN
  FOR i IN c ('&input') LOOP
    dbms_output.put_line(i.item_title);
  END LOOP;
END;
/

-- ------------------------------------------------------------
--   WHERE OF Clause
-- ------------------------------------------------------------

-- A static cursor for an anonymous block.
DECLARE
  CURSOR c IS
    SELECT * FROM item
    WHERE item_id BETWEEN 1031 AND 1040
    FOR UPDATE;
BEGIN
  FOR I IN c LOOP 
    UPDATE item SET last_updated_by = 3
    WHERE CURRENT OF c;
  END LOOP;
END;
/

-- A static bulk cursor for an anonymous block.
DECLARE
  TYPE update_record IS RECORD
  ( last_updated_by NUMBER
  , last_update_date DATE );
  TYPE update_table IS TABLE OF UPDATE_RECORD;
  updates UPDATE_TABLE;
  CURSOR c IS
    SELECT last_updated_by, last_update_date
    FROM item
    WHERE item_id BETWEEN 1031 AND 1040
    FOR UPDATE;
BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT INTO updates LIMIT 5;
    EXIT WHEN updates.COUNT = 0;
    FORALL i IN updates.FIRST..updates.LAST
    UPDATE item
    SET last_updated_by = updates(i).last_updated_by
    , last_update_date = updates(i).last_update_date
    WHERE CURRENT OF c;
  END LOOP;
END;
/

-- A correlated update statement.
UPDATE item i1
SET last_updated_by = 3
, last_update_date = TRUNC(SYSDATE)
WHERE EXISTS (SELECT NULL FROM item i2
              WHERE item_id BETWEEN 1031 AND 1040
              AND i1.ROWID = i2.ROWID);

-- ------------------------------------------------------------
--   While loop Statements
-- ------------------------------------------------------------
-- Demonstrating the WHILE loop and a CONTINUE.
DECLARE
  lv_counter NUMBER := 1;
BEGIN
  WHILE (lv_counter < 5) LOOP
    dbms_output.put('Index at top ['||lv_counter||']');
    IF lv_counter >= 1 THEN
      IF MOD(lv_counter,2) = 0 THEN
        dbms_output.new_line();
        lv_counter := lv_counter + 1;
        CONTINUE;
      END IF;
      dbms_output.put_line('['||lv_counter||']');
    END IF;
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

-- Demonstrating the WHILE loop and a GOTO statement.
DECLARE
  lv_counter NUMBER := 1;
BEGIN
  WHILE (lv_counter < 5) LOOP
    dbms_output.put('Index at top ['||lv_counter||']');
    IF lv_counter >= 1 THEN
      IF MOD(lv_counter,2) = 0 THEN
        dbms_output.new_line();
        GOTO skippy;
      END IF;
      dbms_output.put_line('['||lv_counter||']');
    END IF;
    << skippy >>
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

-- Show how to capture row updates.
BEGIN
  UPDATE system_user
  SET last_update_date = SYSDATE;
  IF SQL%FOUND THEN
    dbms_output.put_line('Updated ['||SQL%ROWCOUNT||']');
  ELSE
    dbms_output.put_line('Nothing updated!');
  END IF;
END;
/

-- Show how you capture row updates.
DECLARE
  lv_id item.item_id%TYPE; -- This is an anchored type.
  lv_title VARCHAR2(60);
  CURSOR c IS
    SELECT item_id, item_title
    FROM item;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO lv_id, lv_title;
    EXIT WHEN c%NOTFOUND;
    dbms_output.put_line('Title ['||lv_title||']');
  END LOOP;
  CLOSE c;
END;
/

-- Show how you capture rows from a cursor anchored to a record type.
DECLARE
  lv_item_record item%ROWTYPE; -- This is an anchored type.
  CURSOR c IS
    SELECT *
    FROM item;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO lv_item_record;
    EXIT WHEN c%NOTFOUND;
    dbms_output.put_line('Title ['||lv_item_record.item_title||']');
  END LOOP;
  CLOSE c;
END;
/

-- Show how you capture rows from a cursor anchored to a record type.
DECLARE
  TYPE item_record IS RECORD
  ( id NUMBER
  , title VARCHAR2(60));
  lv_item_record ITEM_RECORD; -- This is an anchored type.
  CURSOR c IS
    SELECT item_id, item_title
    FROM item;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO lv_item_record;
    EXIT WHEN c%NOTFOUND;
    dbms_output.put_line('Title ['||lv_item_record.title||']');
  END LOOP;
  CLOSE c;
END;
/

-- Show how you caputre rows from a cursor anchored to a cursor.
DECLARE
  CURSOR c IS
    SELECT *
    FROM item;
  lv_item_record c%ROWTYPE;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO lv_item_record;
    EXIT WHEN c%NOTFOUND;
    dbms_output.put_line('Title ['||lv_item_record.item_title||']');
  END LOOP;
  CLOSE c;
END;
/

-- ------------------------------------------------------------
--   Exceptions
-- ------------------------------------------------------------
--   Introduction
-- ------------------------------------------------------------

-- Basic error message.
DECLARE
  lv_letter VARCHAR2(1);
  lv_phrase VARCHAR2(2) := 'AB';
BEGIN
  lv_letter := lv_phrase;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error: '||CHR(10)||SQLERRM);
END;
/

-- Basic error message with a named error message.
DECLARE
  lv_letter VARCHAR2(1);
  lv_phrase VARCHAR2(2) := 'AB';
BEGIN
  lv_letter := lv_phrase;
EXCEPTION
  WHEN VALUE_ERROR THEN -- Specific error handler.
    dbms_output.put_line('Error: '||CHR(10)||SQLERRM);
  WHEN OTHERS THEN -- General error handler.
    dbms_output.put_line('Error: '||CHR(10)||SQLERRM);
END;
/

-- ------------------------------------------------------------
--   User-Defined Exceptions
-- ------------------------------------------------------------

-- Show a user-defined exception in an anonymous block.
DECLARE
  lv_error EXCEPTION;
BEGIN
  RAISE lv_error;
  dbms_output.put_line('Can''t get here.');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = 1 THEN
      dbms_output.put_line('This is ['||SQLERRM||']');
    END IF;
END;
/

-- Show a user-defined exception with a customized exception.
DECLARE
  lv_sys_context VARCHAR2(20);
  lv_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(lv_error,-2003);
BEGIN
  lv_sys_context := SYS_CONTEXT('USERENV','PROXY_PUSHER');
  RAISE lv_error;
  dbms_output.put_line('Can''t get here.');
EXCEPTION
  WHEN lv_error THEN
    dbms_output.put_line('This is ['||SQLERRM||']');
END;
/

-- Show a user-defined exception with a raised application error.
DECLARE
  lv_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(lv_error,-20001);
BEGIN
  RAISE_APPLICATION_ERROR(-20001,'A less original message.');
EXCEPTION
  WHEN lv_error THEN
    dbms_output.put_line('['||SQLERRM||']');
END;
/

-- ------------------------------------------------------------
--   Bulk Operations
-- ------------------------------------------------------------
--   Introduction
-- ------------------------------------------------------------

-- Show bulk collections in an anonymous block.
DECLARE
  TYPE title_record IS RECORD
  ( title VARCHAR2(60)
  , subtitle VARCHAR2(60)); 
  TYPE title_collection IS TABLE OF TITLE_RECORD;
  lv_title_collection TITLE_COLLECTION;
  CURSOR c IS
    SELECT item_title, item_subtitle
    FROM item;
BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT INTO lv_title_collection LIMIT 20;
    EXIT WHEN lv_title_collection.COUNT = 0;
    FOR i IN 1..lv_title_collection.COUNT LOOP
      dbms_output.put_line('['||lv_title_collection(i).title||']');
    END LOOP;
  END LOOP;
  CLOSE c;
END;
/

-- Show bulk collection with a FORALL statement.
DECLARE
  TYPE title_record IS RECORD
  ( id NUMBER
  , title VARCHAR2(60)
  , subtitle VARCHAR2(60));
  TYPE title_collection IS TABLE OF TITLE_RECORD;
  lv_title_collection TITLE_COLLECTION;
  CURSOR c IS
    SELECT item_id, item_title, item_subtitle
    FROM item;
BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT INTO lv_title_collection LIMIT 20;
    EXIT WHEN lv_title_collection.COUNT = 0;
    FORALL i IN lv_title_collection.FIRST..lv_title_collection.LAST
      UPDATE item_temp
      SET    item_title = lv_title_collection(i).title
      ,      item_subtitle = lv_title_collection(i).subtitle
      WHERE  item_id = lv_title_collection(i).id;
  END LOOP;
END;
/

-- ------------------------------------------------------------
--   Functions, procedures, and packages
-- ------------------------------------------------------------
--   Functions
-- ------------------------------------------------------------

-- Create or replace a JOIN_STRINGS function.
CREATE OR REPLACE FUNCTION join_strings
( string1 VARCHAR2
, string2 VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  RETURN string1 ||' '|| string2||'.';
END;
/

-- Queries working with the function.
SELECT join_strings('Hello','World') FROM dual;
VARIABLE session_var VARCHAR2(30)
CALL join_strings('Hello','World') INTO :session_var;
SELECT :session_var FROM dual;

-- Create or replace formatting procedure.
CREATE OR REPLACE PROCEDURE format_string
( string_in IN OUT VARCHAR2 ) IS
BEGIN
  string_in := '['||string_in||']';
END;
/

-- Testing scripts for the JOIN_STRINGS function and FORMAT_STRING procedure.
VARIABLE session_var VARCHAR2(30)
CALL join_strings('Hello','World') INTO :session_var;
CALL format_string(:session_var);
EXECUTE format_string(:session_var);
SELECT :session_var FROM dual;

-- Create or replace the overloading package specification.
CREATE OR REPLACE PACKAGE overloading IS

  -- Force fresh copy of shared cursor.
  PRAGMA SERIALLY_REUSABLE;

  -- Define a default salutation.
  FUNCTION salutation
  ( pv_long_phrase VARCHAR2 DEFAULT 'Hello'
  , pv_name VARCHAR2 ) RETURN VARCHAR2;

  -- Define an overloaded salutation.
  FUNCTION salutation
  ( pv_long_phrase VARCHAR2 DEFAULT 'Hello'
  , pv_name VARCHAR2
  , pv_language VARCHAR2 ) RETURN VARCHAR2;
END;
/

-- Create the SALUTATION_TRANSLATION table.
CREATE TABLE salutation_translation
( short_salutation VARCHAR2(4)
, long_salutation VARCHAR2(12)
, phrase_language VARCHAR2(12));

-- Insert four records into the table.
INSERT INTO salutation_translation VALUES ('Hi','HELLO','ENGLISH');
INSERT INTO salutation_translation VALUES ('Bye','GOODBYE','ENGLISH');
INSERT INTO salutation_translation VALUES ('Ciao','SALUTE','ITALIAN');
INSERT INTO salutation_translation VALUES ('Ciao','ADDIO','ITALIAN');

-- Create or replace the overloading package body.
CREATE OR REPLACE PACKAGE BODY overloading IS

  -- Force fresh copy of shared cursor.
  PRAGMA SERIALLY_REUSABLE;
  -- Shared cursor.
  CURSOR c
  ( cv_long_phrase VARCHAR2
  , cv_language VARCHAR2 ) IS
  SELECT short_salutation
  , long_salutation
  FROM salutation_translation
  WHERE long_salutation = UPPER(cv_long_phrase)
  AND phrase_language = UPPER(cv_language);

  -- Declare a default salutation.
  FUNCTION salutation
  ( pv_long_phrase VARCHAR2 DEFAULT 'Hello'
  , pv_name VARCHAR2 ) RETURN VARCHAR2 IS

    -- Local variables.
    lv_short_salutation VARCHAR2(4) := '';
    lv_language VARCHAR2(10) DEFAULT 'ENGLISH';
 
  BEGIN
    -- Read shared cursor and return concatenated result.
    FOR i IN c(pv_long_phrase, lv_language) LOOP
      lv_short_salutation := i.short_salutation;
    END LOOP;
    RETURN lv_short_salutation || ' ' || pv_name || '!';
  END;

  -- Define an overloaded salutation.
  FUNCTION salutation
  ( pv_long_phrase VARCHAR2 DEFAULT 'Hello'
  , pv_name VARCHAR2
  , pv_language VARCHAR2) RETURN VARCHAR2 IS
 
    -- Local variable.
    lv_short_salutation VARCHAR2(4) := '';

  BEGIN
    -- Read shared cursor and return concatenated result.
    FOR i IN c(pv_long_phrase, pv_language) LOOP
      lv_short_salutation := i.short_salutation;
    END LOOP;
    RETURN lv_short_salutation || ' ' || pv_name || '!';
  END;
END;
/

-- Test the OVERLOADING package.
VARIABLE message VARCHAR2(30)
CALL overloading.salutation('Hello','Ringo') INTO :message;
CALL overloading.salutation('Addio','Lennon','Italian') INTO :message;
SELECT :message AS "Goodbye Message" FROM dual;
SELECT overloading.salutation('Addio','Lennon','Italian') AS "Message" FROM dual;

-- ------------------------------------------------------------
--   Functions, procedures, and packages
-- ------------------------------------------------------------
--   Functions
-- ------------------------------------------------------------


BEGIN
  -- Set savepoint.
  SAVEPOINT all_or_nothing;

  -- First insert.
  INSERT INTO member
  VALUES
  ( member_s1.NEXTVAL -- Surrogate primary key
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'MEMBER'
    AND      common_lookup_column = 'MEMBER_TYPE'  )
16 , SYSDATE);
17
18 -- Second insert.
19 INSERT INTO contact
20 VALUES
21 ( contact_s1.NEXTVAL -- Surrogate primary key
22 , member_s1.CURRVAL -- Surrogate foreign key
...
30 , SYSDATE);
30
31 -- Commit records.
32 COMMIT;
33
34 EXCEPTION
35 -- Rollback to savepoint and raise exception.
36 WHEN others THEN
37 ROLLBACK TO all_or_nothing;
38 dbms_output.put_line(SQLERRM);
39 END;
40 /



-- -----------


-------------------------------------------------
--   A
-- ------------------------------------------------------------
