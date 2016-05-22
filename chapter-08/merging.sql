/* ================================================================
||   Program Name: merging.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates Java library and a PL/SQL wrapper to
||   the Java library.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION merge
( last_name     VARCHAR2
, first_name    VARCHAR2
, middle_initial VARCHAR2 )
RETURN VARCHAR2 PARALLEL_ENABLE IS
BEGIN
  RETURN last_name ||', '||first_name||' '||middle_initial;
END;
/
