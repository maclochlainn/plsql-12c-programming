/* ================================================================
||   Program Name: associative_array.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates small programs that support exception
||   types, built-in functions, and user-defined exceptions.
|| ================================================================*/

DECLARE
  lv_a VARCHAR2(1);
  lv_b VARCHAR2(2) := 'AB';
BEGIN
  lv_a := lv_b;
EXCEPTION
  WHEN value_error THEN
    dbms_output.put_line(
      'You can''t put ['||lv_b||'] in a one character string.');
END;
/

DECLARE
  lv_a  VARCHAR2(1);
BEGIN
  DECLARE
    lv_b VARCHAR2(2);
  BEGIN
    SELECT 1 INTO lv_b
    FROM dual
    WHERE 1 = 2;
    lv_a := lv_b;
  EXCEPTION
    WHEN value_error THEN
      dbms_output.put_line(
       'You can''t put ['||lv_b||'] in a one character string.');
  END;
EXCEPTION
  WHEN others THEN
    dbms_output.put_line(
      'Caught in outer block ['||SQLERRM||'].');
END;
/

DECLARE
  lv_a  VARCHAR2(1);
  e     EXCEPTION;
BEGIN
  DECLARE
    lv_b VARCHAR2(2) := 'AB';
  BEGIN
    RAISE e;
  EXCEPTION
    WHEN others THEN
      lv_a := lv_b;
      dbms_output.put_line('Never reaches this line.');
  END;
EXCEPTION
  WHEN others THEN
    dbms_output.put_line(
      'Caught in outer block->'||dbms_utility.format_error_backtrace);
END;
/

DECLARE
  lv_a CHAR := '&input';
BEGIN
  dbms_output.put_line('['||lv_a||']');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('['||SQLERRM||']'
END;
/

BEGIN
  DECLARE
    lv_a CHAR := '&input';
  BEGIN
    dbms_output.put_line('['||lv_a||']');
  END;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('['||SQLERRM||']');
END;
/

CREATE OR REPLACE FUNCTION runtime_error
(lv_input  VARCHAR2) RETURN VARCHAR2 IS
  a VARCHAR2(1) := lv_input;
BEGIN
  NULL;
EXCEPTION
  WHEN others THEN
    dbms_output.put_line('Function error.');
END;
/

SELECT runtime_error ('AB') FROM dual;

DECLARE
  e EXCEPTION;
BEGIN
  RAISE e;
  dbms_output.put_line('Can''t get here.');
EXCEPTION
  WHEN OTHERS THEN  /* Catch all exceptions. */
    /* Check user-defined exception. */
    IF SQLCODE = 1 THEN
      dbms_output.put_line('This is a ['||SQLERRM||'].');
    END IF;
END;
/

DECLARE
  lv_a VARCHAR2(20);
  invalid_userenv_parameter EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_userenv_parameter,-2003);
BEGIN
  lv_a := SYS_CONTEXT('USERENV','PROXY_PUSHER');
EXCEPTION
  WHEN invalid_userenv_parameter THEN
    dbms_output.put_line(SQLERRM);
END;
/

DECLARE
  e  EXCEPTION;
  PRAGMA EXCEPTION_INIT(e,-20001);
BEGIN
  RAISE e;
EXCEPTION
  WHEN e THEN
  dbms_output.put_line(SQLERRM);
END;
/

BEGIN
  RAISE_APPLICATION_ERROR(-20001,'A not too original message.');
EXCEPTION
  WHEN others THEN
    dbms_output.put_line(SQLERRM);
END;
/

DECLARE
   e EXCEPTION;
  PRAGMA EXCEPTION_INIT(e,-20001);
BEGIN
  RAISE_APPLICATION_ERROR(-20001,'A less original message.');
EXCEPTION
  WHEN e THEN
    dbms_output.put_line(SQLERRM);
END;
/

DECLARE
  lv_a         VARCHAR2(1);
  lv_b VARCHAR2(2) := 'AB';
BEGIN
  lv_a := lv_b;
  dbms_output.put_line('Never reaches this line.');
EXCEPTION
  WHEN value_error THEN
    RAISE_APPLICATION_ERROR(-20001,'A specific message.');
  WHEN others THEN
    dbms_output.put_line(SQLERRM);
END;
/