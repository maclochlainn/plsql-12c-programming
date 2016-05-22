/* ================================================================
||   Program Name: create_components.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 9
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates the components package.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Package specification.
CREATE OR REPLACE PACKAGE components IS

  -- Declare package components.
  PROCEDURE set (value IN OUT VARCHAR2);
  FUNCTION get RETURN VARCHAR2;

END components;
/

-- Package body.
CREATE OR REPLACE PACKAGE BODY components IS
  -- Declare package scoped shared variables.
  key NUMBER := 0;
  variable VARCHAR2(20) := 'Initial Value';

  -- Define package-only function and procedure.
  FUNCTION locked RETURN BOOLEAN IS
    key NUMBER := 0;
  BEGIN
    IF components.key = key THEN
      components.key := 1;
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END locked;

  PROCEDURE unlock IS
    key NUMBER := 1;
  BEGIN
    IF components.key = key THEN
      components.key := 0;         -- Reset the key.
      variable := 'Initial Value'; -- Reset initial value of shared variable.
    END IF;
  END unlock;

  -- Define published function and procedure.
  FUNCTION get RETURN VARCHAR2 IS
  BEGIN
    RETURN variable;
  END get;

  PROCEDURE set (value VARCHAR2) IS
  BEGIN
    IF NOT locked THEN
      variable := value;
      dbms_output.put_line('The new value until release is ['||get||'].');
      unlock;
    END IF;
  END set;

END components;
/

-- Test scripts.
VARIABLE current_content VARCHAR2(20)
CALL components.get() INTO :current_content;
SELECT :current_content FROM dual;
EXECUTE components.set('New Value');
CALL components.get() INTO :current_content;
SELECT :current_content FROM dual;
