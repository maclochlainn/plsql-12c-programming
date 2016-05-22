/* ================================================================
||   Program Name: white_list.sql
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

-- Create a HOBBIT object type.
CREATE OR REPLACE TYPE hobbit IS OBJECT
( name  VARCHAR2(20)
, CONSTRUCTOR FUNCTION hobbit  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hobbit
  ( name  VARCHAR2 ) RETURN SELF AS RESULT
, MEMBER FUNCTION get_name RETURN VARCHAR2
, MEMBER FUNCTION set_name (name VARCHAR2)
  RETURN hobbit
, MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/ 

-- Create a HOBBIT object body.
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
  (name  VARCHAR2) RETURN self AS RESULT IS
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

  /* Prints the a salutation of the object type’s attribute. */
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello '||self.name||'!';
  END to_string;
END;
/

-- Create an API package specfication.
CREATE OR REPLACE PACKAGE api IS
  FUNCTION whom
  ( pv_message  VARCHAR2 ) RETURN VARCHAR2;
END;
/

-- Create an API package body.
CREATE OR REPLACE PACKAGE BODY api IS
  FUNCTION whom
  ( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
  BEGIN
    RETURN library(pv_message);
  END;
END;
/

-- Create a GATEWAY function.
CREATE OR REPLACE FUNCTION gateway
( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  /* Return the result from the library. */
  RETURN library(pv_message);
END;
/


-- Create a LIBRARY function.
CREATE OR REPLACE FUNCTION library
( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  RETURN pv_message;
END;
/

-- Create a white-listed LIBRARY function.
CREATE OR REPLACE FUNCTION library
( pv_message  VARCHAR2 ) RETURN VARCHAR2
ACCESSIBLE BY
( FUNCTION  video.gateway
, PROCEDURE video.backdoor
, PACKAGE   video.api
, TYPE      video.hobbit ) IS
  lv_message  VARCHAR2(30) := 'Hello ';
BEGIN
  lv_message := lv_message || pv_message || '!';
  RETURN lv_message;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Create a BACKDOOR procedure, which fails because name is white listed as a procedure.
CREATE OR REPLACE FUNCTION backdoor
( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  /* Return the result from the library. */
  RETURN library(pv_message);
END;
/

-- Display errors.
SHOW ERRORS

-- Create a BLACK_NIGHT function, which fails because name isn't white listed. 
CREATE OR REPLACE FUNCTION black_night
( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  RETURN library(pv_message);
END;
/

-- Display errors.
SHOW ERRORS

-- Create a BLACK_NIGHT function, which fails because name isn't white listed. 
CREATE OR REPLACE FUNCTION gateway
( pv_message  VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  RETURN library(pv_message);
END;
/

-- Return the value from the white-listed function call.
SELECT gateway('GATEWAY function') AS "SELECT-List Value" FROM dual; 

-- Declare a session variable.
VARIABLE receiver VARCHAR2(80)

-- Run the white listed function.
CALL gateway('GATEWAY function') INTO :receiver;

-- Return the value from the session value.
SELECT :receiver AS "Session Variable" FROM dual;    