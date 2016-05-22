/* ================================================================
||   Program Name: deterministic.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates various deterministic functions.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION pv
( future_value    NUMBER
, periods         NUMBER
, interest        NUMBER )
RETURN NUMBER DETERMINISTIC IS
BEGIN
  RETURN future_value / ((1 + interest/100)**periods);
END pv;
/

CREATE OR REPLACE FUNCTION fv
( current_value   NUMBER := 0
, periods         NUMBER := 1
, interest        NUMBER)
RETURN NUMBER DETERMINISTIC IS
BEGIN
  -- Compounded Daily Interest.
  RETURN current_value * (1 + ((1 + ((interest/100)/365))**365 -1)*periods);
END fv;
/