/* ================================================================
||   Program Name: create_package_variables.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 9
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates how to use package variables.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE PACKAGE package_variables IS
  PRAGMA SERIALLY_REUSABLE;
  -- Declare package components.
  PROCEDURE set(value VARCHAR2);
  FUNCTION get RETURN VARCHAR2;
END package_variables;
/

show errors

CREATE OR REPLACE PACKAGE BODY package_variables IS
  PRAGMA SERIALLY_REUSABLE;
  -- Declare package scope variable.
  variable VARCHAR2(20) := 'Initial Value';

  -- Define function
  FUNCTION get RETURN VARCHAR2 IS
  BEGIN
    RETURN variable;
  END get;

  -- Define procedure.
  PROCEDURE set(value VARCHAR2) IS
  BEGIN
    variable := value;
  END set;
END package_variables;
/

VARIABLE outcome VARCHAR2(20)

CALL package_variables.get() INTO :outcome;

SELECT :outcome AS outcome FROM dual;

EXECUTE package_variables.set('New Value');

CALL package_variables.get() INTO :outcome;

SELECT :outcome AS outcome FROM dual;

