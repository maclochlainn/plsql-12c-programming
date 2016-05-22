/* ================================================================
||   Program Name: hobbit.sql
||   Date:         2013-12-02
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 3
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script creates objects that support a complete example
||   of how you create a HOBBIT object type and body, as well as
||   anonymous blocks to test its effectiveness.
|| ================================================================*/


-- Conditionally drop the HOBBIT object type.
BEGIN
  FOR i IN (SELECT object_name
            FROM   user_objects
            WHERE  object_name = 'HOBBIT'
            AND    object_type = 'TYPE') LOOP
    /* Dynamically drop object type. */
    EXECUTE IMMEDIATE 'DROP TYPE '||i.object_name||' FORCE';
  END LOOP;
END;
/

-- Create or replace a hobbit type.
CREATE OR REPLACE TYPE hobbit IS OBJECT
( name VARCHAR2(20)
, CONSTRUCTOR FUNCTION hobbit RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hobbit
( name VARCHAR2 ) RETURN SELF AS RESULT
, MEMBER FUNCTION get_name RETURN VARCHAR2
, MEMBER FUNCTION set_name (name VARCHAR2)
  RETURN hobbit
, MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

-- Create or replace hobbit type body.
CREATE OR REPLACE TYPE BODY hobbit IS
  /* Default (no parameter) constructor. */
  CONSTRUCTOR FUNCTION hobbit RETURN SELF AS RESULT IS
    lv_hobbit HOBBIT := hobbit('Sam Gamgee');
  BEGIN
    self := lv_hobbit;
    RETURN;
  END hobbit;
  /* Override signature. */
  CONSTRUCTOR FUNCTION hobbit
  (name VARCHAR2) RETURN self AS RESULT IS
  BEGIN
    self.name := name;
    RETURN;
  END hobbit;
  /* Getter for the single attribute of the object type. */
  MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN self.name;
  END get_name;
  /* Setter for a new copy of the object type. */
  MEMBER FUNCTION set_name (name VARCHAR2)
  RETURN hobbit IS
    lv_hobbit HOBBIT;
  BEGIN
    lv_hobbit := hobbit(name);
    RETURN lv_hobbit;
  END set_name;
  /* Prints a salutation of the object type's attribute. */
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello '||self.name||'!';
  END to_string;
END;
/

-- Query the static object type.
COLUMN salutation FORMAT A20
SELECT hobbit().to_string() AS "Salutation"
FROM dual;

-- Query the instantiated object ype.
SELECT hobbit('Bilbo Baggins').to_string() AS "Salutation"
FROM dual;

-- Query the instantiated object type.
SELECT hobbit().set_name('Frodo Baggins').to_string() AS "Salutation"
FROM dual;

-- ------------------------------------------------------------
--   PL/SQL Record Type
-- ------------------------------------------------------------

CREATE OR REPLACE 
  TYPE string_table IS TABLE OF VARCHAR2(20);
/

CREATE OR REPLACE
  TYPE hobbit_table IS TABLE OF HOBBIT;
/

SELECT 'Hello' FROM dual;

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  -- Declare and initialize a collection of grains.
  lv_string_table string_TABLE :=
     string_table('Drogo Baggins','Frodo Baggins');
  lv_hobbit_table HOBBIT_TABLE := hobbit_table(
     hobbit('Bungo Baggins')
   , hobbit('Bilbo Baggins'));
BEGIN
  -- Assign the members from one collection to the other.
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

CREATE OR REPLACE FUNCTION get_hobbits
RETURN HOBBIT_TABLE IS
  -- Declare a collection of hobbits.
  lv_hobbit_table HOBBIT_TABLE := hobbit_table(
     hobbit('Bungo Baggins')
   , hobbit('Bilbo Baggins')
   , hobbit('Drogo Baggins')
   , hobbit('Frodo Baggins'));
BEGIN
  RETURN lv_hobbit_table;
END;
/

COLUMN hobbit_name FORMAT A14
SELECT name AS hobbit_name
FROM TABLE(get_hobbits())
ORDER BY 1;