/* ================================================================
||   Program Name: load_clob_from_file.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 10
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   ALERTS:
||
||   You must put the HarryPotter1.png file in the /tmp directory on
||   Linux or Unix; or in the C:\WINDOWS\TEMP directory on Windows.
||   Alternatively, you can define the GENERIC virtual directory to
||   point to a directory of your own choosing but make sure that 
||   Oracle enjoys read permissions to that directory.
||
||   This script defines a procedure to load a character large file
||   to a BLOB datatype.
||
||   DEBUG MODE:
||   ==========
||   Alter the session with the following command.
||
||   ALTER SESSION SET PLSQL_CCFLAGS = 'debug:1';
|| ================================================================*/

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

-- Create stored procedure to load a CLOB datatype.
CREATE OR REPLACE PROCEDURE load_clob_from_file
( src_file_name     IN VARCHAR2
, table_name        IN VARCHAR2
, column_name       IN VARCHAR2
, primary_key_name  IN VARCHAR2
, primary_key_value IN VARCHAR2 ) IS

  -- Define local variables for DBMS_LOB.LOADCLOBFROMFILE procedure.
  des_clob   CLOB;
  src_clob   BFILE := BFILENAME('GENERIC',src_file_name);
  des_offset NUMBER := 1;
  src_offset NUMBER := 1;
  ctx_lang   NUMBER := dbms_lob.default_lang_ctx;
  warning    NUMBER;
  
  -- Define a pre-reading size.
  src_clob_size NUMBER;
  
  -- Define local variable for Native Dynamic SQL.
  stmt VARCHAR2(2000);

BEGIN

  -- Opening source file is a mandatory operation.
  IF dbms_lob.fileexists(src_clob) = 1 AND NOT dbms_lob.isopen(src_clob) = 1 THEN
    src_clob_size := dbms_lob.getlength(src_clob);
    dbms_lob.open(src_clob,DBMS_LOB.LOB_READONLY);
  END IF;
  
  -- Assign dynamic string to statement.
  stmt := 'UPDATE '||table_name||' '
       || 'SET    '||column_name||' = empty_clob() '
       || 'WHERE  '||primary_key_name||' = '||''''||primary_key_value||''' '
       || 'RETURNING '||column_name||' INTO :locator';

  -- Run dynamic statement.       
  EXECUTE IMMEDIATE stmt USING OUT des_clob;
 
  -- Read and write file to CLOB, close source file and commit.
  dbms_lob.loadclobfromfile( dest_lob     => des_clob
                           , src_bfile    => src_clob
                           , amount       => dbms_lob.getlength(src_clob)
                           , dest_offset  => des_offset
                           , src_offset   => src_offset
                           , bfile_csid   => dbms_lob.default_csid
                           , lang_context => ctx_lang
                           , warning      => warning );

  -- Close open source file.
  dbms_lob.close(src_clob);

  -- Commit write and conditionally acknowledge it.
  IF src_clob_size = dbms_lob.getlength(des_clob) THEN
    $IF $$DEBUG = 1 $THEN
      dbms_output.put_line('Success!');
    $END
    COMMIT;
  ELSE
    $IF $$DEBUG = 1 $THEN
      dbms_output.put_line('Failure.');
    $END
    RAISE dbms_lob.operation_failed;
  END IF;
  
END load_clob_from_file;
/

SHOW ERRORS

-- Format column for output.
COL item_id    FORMAT 9999
COL item_title FORMAT A50
COL size       FORMAT 9,999,990

-- Check before load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_desc) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_desc) > 0;

-- Insert description in all matching rows.
BEGIN
  FOR i IN (SELECT item_id
            FROM   item
            WHERE  item_title = 'The Lord of the Rings - Fellowship of the Ring'
            AND    item_type IN (SELECT common_lookup_id
                                 FROM   common_lookup
                                 WHERE  common_lookup_table = 'ITEM'
                                 AND    common_lookup_column = 'ITEM_TYPE'
                                 AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'))) LOOP
    -- Call procedure for matching rows.
    load_clob_from_file( src_file_name     => 'LOTRFellowship.txt'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

-- Check after load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_desc) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_desc) > 0;