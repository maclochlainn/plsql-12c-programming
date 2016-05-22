/* ================================================================
||   Program Name: load_blob_from_file.sql
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

-- Create stored procedure to load a BLOB datatype.
CREATE OR REPLACE PROCEDURE load_blob_from_file
( src_file_name     IN VARCHAR2
, table_name        IN VARCHAR2
, column_name       IN VARCHAR2
, primary_key_name  IN VARCHAR2
, primary_key_value IN VARCHAR2 ) IS

  -- Define local variables for DBMS_LOB.LOADCLOBFROMFILE procedure.
  des_blob      BLOB;
  src_blob      BFILE := BFILENAME('GENERIC',src_file_name);
  des_offset    NUMBER := 1;
  src_offset    NUMBER := 1;
  
  -- Define a pre-reading size.
  src_blob_size NUMBER;
  
  -- Define local variable for Native Dynamic SQL.
  stmt VARCHAR2(2000);

BEGIN

  -- Opening source file is a mandatory operation.
  IF dbms_lob.fileexists(src_blob) = 1 AND NOT dbms_lob.isopen(src_blob) = 1 THEN
    src_blob_size := dbms_lob.getlength(src_blob);
    dbms_lob.open(src_blob,DBMS_LOB.LOB_READONLY);
  END IF;
  
  -- Assign dynamic string to statement.
  stmt := 'UPDATE '||table_name||' '
       || 'SET    '||column_name||' = empty_blob() '
       || 'WHERE  '||primary_key_name||' = '||''''||primary_key_value||''' '
       || 'RETURNING '||column_name||' INTO :locator';

  -- Run dynamic statement.       
  EXECUTE IMMEDIATE stmt USING OUT des_blob;
 
  -- Read and write file to BLOB, close source file and commit.
  dbms_lob.loadblobfromfile( dest_lob     => des_blob
                           , src_bfile    => src_blob
                           , amount       => dbms_lob.getlength(src_blob)
                           , dest_offset  => des_offset
                           , src_offset   => src_offset );

  -- Close open source file.
  dbms_lob.close(src_blob);

  -- Commit write and conditionally acknowledge it.
  IF src_blob_size = dbms_lob.getlength(des_blob) THEN
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
  
END load_blob_from_file;
/

SHOW ERRORS

-- Format column for output.
COL item_id    FORMAT 9999
COL item_title FORMAT A50
COL size       FORMAT 9,999,990

-- Check before load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_blob) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_blob) > 0;

-- Insert description in all matching rows.
BEGIN
  FOR i IN (SELECT item_id
            FROM   item
            WHERE  item_title = 'Harry Potter and the Sorcerer''s Stone'
            AND    item_type IN
             (SELECT common_lookup_id
              FROM   common_lookup
              WHERE  common_lookup_table = 'ITEM'
              AND    common_lookup_column = 'ITEM_TYPE'
              AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'))) LOOP
    -- Call procedure for matching rows.
    load_blob_from_file( src_file_name     => 'HarryPotter1.png'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_BLOB'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

-- Check after load.
SELECT item_id
,      item_title
,      dbms_lob.getlength(item_blob) AS "SIZE"
FROM   item
WHERE  dbms_lob.getlength(item_blob) > 0;

-- Insert a record only when one isn't found (rerunnable script).
DECLARE
  -- Declare a row number.
  row NUMBER :=0;

  -- Declare a cursor to check for the BLOB.
  CURSOR c IS
    SELECT item_id
    FROM   item
    WHERE  item_title = 'The Blob - Criterion Collection'
    AND    item_type IN
            (SELECT common_lookup_id
             FROM   common_lookup
             WHERE  common_lookup_table = 'ITEM'
             AND    common_lookup_column = 'ITEM_TYPE'
             AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'));
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO row;
    IF c%NOTFOUND AND c%ROWCOUNT = 1 THEN
      INSERT INTO item VALUES
      ( item_s1.nextval
      ,'ASIN: B00004W3HE'
      ,(SELECT   common_lookup_id
        FROM     common_lookup
        WHERE    common_lookup_type = 'XBOX')
      ,'The Blob - Criterion Collection'
      ,''
      , empty_clob()
      , empty_blob()
      , NULL
      ,'NR'
      ,'MPAA'
      ,'14-NOV-2000'
      , 3, SYSDATE, 3, SYSDATE);
      EXIT;
    ELSE
      EXIT;
    END IF;
  END LOOP;
END;
/

-- Insert description in all matching rows.
BEGIN
  FOR i IN (SELECT item_id
            FROM   item
            WHERE  item_title = 'The Blob - Criterion Collection'
            AND    item_type IN
             (SELECT common_lookup_id
              FROM   common_lookup
              WHERE  common_lookup_table = 'ITEM'
              AND    common_lookup_column = 'ITEM_TYPE'
              AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs)*','i'))) LOOP
    -- Call procedure for matching rows.
    load_blob_from_file( src_file_name     => 'TheBlob.pdf'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_BLOB'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

