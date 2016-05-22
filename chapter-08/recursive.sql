/* ================================================================
||   Program Name: merging.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates recursive functions.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 99999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Create a linear recursion program.
CREATE OR REPLACE FUNCTION factorial
( n BINARY_DOUBLE ) RETURN BINARY_DOUBLE IS
BEGIN
  IF n <= 1 THEN
    RETURN 1;
  ELSE
    RETURN n * factorial(n - 1);
  END IF;
END factorial;
/

/* Create a Fibonacci non-linear recursion. */
CREATE OR REPLACE FUNCTION "Fibonacci"
( n BINARY_DOUBLE ) RETURN BINARY_DOUBLE IS
BEGIN
  /* Set the base case. */
  IF n < 2 THEN
    RETURN n;
  ELSE
    RETURN fibonacci(n - 2) + fibonacci(n - 1);
  END IF;
END "Fibonacci";
/

CREATE OR REPLACE FUNCTION "FibonacciSequence"
RETURN VARCHAR2 IS
  /* Declare an output variable. */
  lv_output  VARCHAR2(40);
BEGIN
  /* Loop through enough for the DaVinci Code myth. */
  FOR i IN 1..8 LOOP
    IF lv_output IS NOT NULL THEN
      lv_output := lv_output||', '||LTRIM(TO_CHAR("Fibonacci"(i),'999'));
    ELSE
      lv_output := LTRIM(TO_CHAR("Fibonacci"(i),'999'));
    END IF;
  END LOOP;
  RETURN lv_output;
END;
/

SELECT   "FibonacciSequence"
FROM     dual;