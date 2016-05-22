/* ================================================================
||   Program Name: associative_array.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates programs that support how you 
||   manage stack traces.
|| ================================================================*/


CREATE OR REPLACE PROCEDURE handle_errors
( pv_object_name         IN  VARCHAR2
, pv_module_name         IN  VARCHAR2 := NULL
, pv_table_name          IN  VARCHAR2 := NULL
, pv_error_code          IN  NUMBER   := NULL
, pv_error_message       IN  VARCHAR2 := NULL
, pv_user_error_message  IN  VARCHAR2 := NULL ) IS

  /* Declare a local exception. */
  lv_error  EXCEPTION;

  -- Define a collection type and initialize it.
  TYPE error_stack IS TABLE OF VARCHAR2(100);
  lv_errors        ERROR_STACK := error_stack();

  /* Define a local function to get object type. */
  FUNCTION get_object_type
  ( pv_object_name  IN  VARCHAR2 ) RETURN VARCHAR2 IS
    /* Local return variable. */
    lv_return_type  VARCHAR2(12) := 'Unidentified';
  BEGIN
    FOR i IN ( SELECT object_type FROM user_objects
               WHERE  object_name = pv_object_name ) LOOP
      lv_return_type := i.object_type;
    END LOOP;
    RETURN lv_return_type;
  END get_object_type;
BEGIN
  -- Allot space and assign a value to collection.
  lv_errors.EXTEND;
  lv_errors(lv_errors.COUNT) :=
    get_object_type(pv_object_name)||' ['||pv_object_name||']';

  -- Substitute actual parameters for default values.
  IF pv_module_name IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'Module Name: ['||pv_module_name||']';
  END IF;
  IF pv_table_name IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'Table Name: ['||pv_table_name||']';
  END IF;
  IF pv_error_code IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'SQLCODE Value: ['||pv_error_code||']';
  END IF;
  IF pv_error_message IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := 'SQLERRM Value: ['||pv_error_message||']';
  END IF;
  IF pv_user_error_message IS NOT NULL THEN
    lv_errors.EXTEND;
    lv_errors(lv_errors.COUNT) := pv_user_error_message;
  END IF;

  lv_errors.EXTEND;
  lv_errors(lv_errors.COUNT) := '----------------------------------------';
  RAISE lv_error;
EXCEPTION
  WHEN lv_error THEN
    FOR i IN 1..lv_errors.COUNT LOOP
      dbms_output.put_line(lv_errors(i));
    END LOOP;
    RETURN;
END;
/

CREATE OR REPLACE PROCEDURE pear IS
  /* Declare two variables. */
  lv_one_character  VARCHAR2(1);
  lv_two_character  VARCHAR2(2) := 'AB';
BEGIN
  lv_one_character := lv_two_character; 
END pear;
/

SHOW ERRORS

CREATE OR REPLACE PROCEDURE orange IS
BEGIN
  pear();
END orange;
/

SHOW ERRORS

CREATE OR REPLACE PROCEDURE apple IS
BEGIN
  orange();
END apple;
/

SHOW ERRORS

BEGIN
  apple;
EXCEPTION
  WHEN others THEN
    FOR i IN REVERSE 1..utl_call_stack.backtrace_depth LOOP
      /* Check for an anonymous block. */
      IF utl_call_stack.backtrace_unit(i) IS NULL THEN
        /* utl_call_stack doesn't show an error, manually override. */
        dbms_output.put_line(
       	  'ORA-06512: at Anonymous Block, line '||
           utl_call_stack.backtrace_line(i));
      ELSE
         /* utl_call_stack doesn't show an error, manually override. */
        dbms_output.put_line(
          'ORA-06512: at '||utl_call_stack.backtrace_unit(i)||
          ', line '||utl_call_stack.backtrace_line(i));
      END IF;

      /* The backtrace and error depth are unrelated, and the depth of
         calls can and generally is higher than the depth of errors.    */
      IF i = utl_call_stack.error_depth THEN
        dbms_output.put_line(
        	'ORA-'||LPAD(utl_call_stack.error_number(i),5,0)
             ||' '||utl_call_stack.error_msg(i));
      END IF;
    END LOOP;
END;
/

DECLARE
  lv_length   NUMBER;
  lv_counter  NUMBER := 0;
  lv_begin    NUMBER := 1;
  lv_end      NUMBER;
  lv_index    NUMBER := 0;
  lv_trace    VARCHAR2(2000);
BEGIN
  apple;
EXCEPTION
  WHEN others THEN
    FOR i IN REVERSE 1..utl_call_stack.backtrace_depth LOOP
      /* The backtrace and error depth are unrelated, and the depth of
         calls can and generally is higher than the depth of errors.    */
      IF i = utl_call_stack.error_depth THEN
        /* Capture the stack trace. */
        lv_trace := dbms_utility.format_error_backtrace;

        /* Count the number of line returns - ASCII 10s. */
        lv_length := REGEXP_COUNT(lv_trace,CHR(10),1);

        /* Read through the stack to remove line returns. */
        WHILE (lv_counter < lv_length) LOOP
          /* Increment the counter at the top. */
          lv_counter := lv_counter + 1;

          /* Get the next line return. */
          lv_end := REGEXP_INSTR(lv_trace,CHR(10),lv_begin,1);

          /* Cutout the first substring from the stack trace. */
          dbms_output.put_line(SUBSTR(lv_trace,lv_begin,lv_end - lv_begin));

          /* Assign the substring ending to the beginning. */
          lv_begin := lv_end + 1;

        END LOOP;

        /* Print the actual original error message. */
        dbms_output.put_line(
            'ORA-'||LPAD(utl_call_stack.error_number(i),5,0)
             ||' '||utl_call_stack.error_msg(i));
      END IF;
    END LOOP;
END;
/

DECLARE
  lv_length   NUMBER;
  lv_counter  NUMBER := 0;
  lv_begin    NUMBER := 1;
  lv_end      NUMBER;
  lv_index    NUMBER := 0;
  lv_trace    VARCHAR2(2000);
  lv_break    VARCHAR2(6) := '<br />';
BEGIN
  apple;
EXCEPTION
  WHEN others THEN
    FOR i IN REVERSE 1..utl_call_stack.backtrace_depth LOOP
      /* The backtrace and error depth are unrelated, and the depth of
         calls can and generally is higher than the depth of errors.    */
      IF i = utl_call_stack.error_depth THEN
        /* Capture the stack trace. */
        lv_trace := dbms_utility.format_error_backtrace;

        /* Count the number of line returns - ASCII 10s. */
        lv_length := REGEXP_COUNT(lv_trace,CHR(10),1);

        /* Read through the stack to remove line returns. */
        WHILE (lv_counter < lv_length) LOOP
          /* Increment the counter at the top. */
          lv_counter := lv_counter + 1;

          /* Get the next line return. */
          lv_end := REGEXP_INSTR(lv_trace,CHR(10),lv_begin,1);

          /* Cutout the first substring from the stack trace. */
          lv_trace := REGEXP_REPLACE(lv_trace,CHR(10),lv_break,lv_end,1);
          lv_end := lv_end + LENGTH(lv_break);
          dbms_output.put_line(
            SUBSTR(lv_trace,lv_begin,lv_end - lv_begin));

          /* Assign the substring ending to the beginning. */
          lv_begin := lv_end;
        END LOOP;
      END IF;
    END LOOP;
END;
/