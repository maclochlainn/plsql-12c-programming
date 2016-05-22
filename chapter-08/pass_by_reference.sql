/* ================================================================
||   Program Name: pass_by_reference.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates how to write pass-by-reference
||   functions.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 99999
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE FUNCTION counting
( number_in IN OUT NUMBER ) RETURN VARCHAR2 IS
  TYPE numbers IS TABLE OF VARCHAR2(5);
  ordinal NUMBERS := numbers('One','Two','Three','Four','Five');
  retval VARCHAR2(9) := 'Not Found';
BEGIN
  -- Replace a null value to ensure increment.
  IF number_in IS NULL THEN
    number_in := 1;
  END IF; 
  -- Increment actual parameter when within range.
  IF number_in < 4 THEN
    retval := ordinal(number_in);
    number_in := number_in + 1;
  ELSE
    retval := ordinal(number_in);
  END IF;
  RETURN retval;
END;
/

DECLARE
  counter NUMBER := 1;
BEGIN
  FOR i IN 1..5 LOOP
    dbms_output.put('Counter ['||counter||']');
    dbms_output.put_line('['||counting(counter)||']');
  END LOOP;
END;
/
