/* ================================================================
||   Program Name: get_canonical_bfilename.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 10
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   ALERTS:
||   - This script depends on a valid GET_DIRECTORY_PATH function
||     in the SYSTEM schema.
||   - The get_directory_path.sql script creates the required
||     GET_DIRECTORY_PATH function, grants and synonyms.
||
||   This script defines a stored function that returns a canonical
||   path, which is a fully qualified path and file name for a BFILENAME
||   column for a file name in only the PRESIDENT table.
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION get_canonical_bfilename
( table_name        IN     VARCHAR2
, bfile_column_name IN     VARCHAR2
, primary_key       IN     VARCHAR2
, primary_key_value IN     VARCHAR2
, operating_system  IN     VARCHAR2 := 'WINDOWS')
RETURN VARCHAR2 IS

  -- Declare default delimiter.
  delimiter         VARCHAR2(1) := '\';
  
  -- Define statement variable.
  stmt              VARCHAR2(200);

  -- Define a locator.
  locator           BFILE;

  -- Define alias and file name.
  dir_alias         VARCHAR2(255);
  directory         VARCHAR2(255);
  file_name         VARCHAR2(255);

  -- Define a local exception for size violation.
  directory_num EXCEPTION;
  PRAGMA EXCEPTION_INIT(directory_num,-22285);  

BEGIN

  -- Assign dynamic string to statement.
  stmt := 'BEGIN '
       || ' SELECT '||bfile_column_name||' '
       || ' INTO :column_value '
       || ' FROM  '||table_name||' '
       || ' WHERE '||primary_key||'='||''''||primary_key_value||''''||';'
       || 'END;';

  -- Run dynamic statement.       
  EXECUTE IMMEDIATE stmt USING OUT locator;
 
  -- Check for available locator.
  IF locator IS NOT NULL THEN     
    dbms_lob.filegetname(locator,dir_alias,file_name);
  END IF;

  -- Check operating system and swap delimiter when necessary.
  IF operating_system <> 'WINDOWS' THEN
    delimiter := '/';
  END IF;
  
  -- Create a canonical file name.
  file_name := get_directory_path(dir_alias) || delimiter || file_name;

  -- Return file name.
  RETURN file_name;

EXCEPTION
  WHEN directory_num THEN
  RETURN NULL;

END get_canonical_bfilename;
/
