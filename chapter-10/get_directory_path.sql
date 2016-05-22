/* ================================================================
||   Program Name: get_directory_path.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 10
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   ALERTS:
||  - This script must be run from the SYSTEM account.
||  - SYSTEM must have select privilege directly not by a role.
||  - SYSTEM has default access via SELECT_CATALOG_ROLE role.
||  - Grant the privilege to SYSTEM by:
||
||     SQL> CONNECT / as sysdba
||     Connected.
||     SQL> GRANT SELECT ON dba_directories TO system;
||     Grant succeeded.
||
|| This script defines a stored function that returns a directory
|| path for a known database virtual directory.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION get_directory_path
( virtual_directory IN VARCHAR2 )
RETURN VARCHAR2 IS

  -- Define return variable.
  directory_path VARCHAR2(256) := 'C:\';

  -- Define dynamic cursor.
  CURSOR get_directory (virtual_directory VARCHAR2) IS
    SELECT   directory_path
    FROM     sys.dba_directories
    WHERE    directory_name = virtual_directory;

  -- Define a local exception for name violation.
  directory_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(directory_name,-22284);  

BEGIN

  OPEN  get_directory (virtual_directory);
  FETCH get_directory
  INTO  directory_path;
  CLOSE get_directory;

  -- Return file name.
  RETURN directory_path;

EXCEPTION
  WHEN directory_name THEN
  RETURN NULL;

END get_directory_path;
/

show errors

GRANT EXECUTE ON get_directory_path TO php;

GRANT CREATE ANY SYNONYM TO php;

CONNECT php/php

CREATE SYNONYM get_directory_path FOR system.get_directory_path;
