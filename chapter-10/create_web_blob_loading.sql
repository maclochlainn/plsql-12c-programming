/* ================================================================
||   Program Name: create_web_blob_loading.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 10
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates how to write a procedure to load a
||   BLOB data type through a procedure.
|| ================================================================*/

CREATE OR REPLACE PROCEDURE web_load_blob_from_file  
( item_id_in IN     NUMBER
, descriptor IN OUT BLOB ) IS

BEGIN

  -- A FOR UPDATE makes this a DML transaction.
  UPDATE    item
  SET       item_blob = empty_blob()
  WHERE     item_id = item_id_in
  RETURNING item_blob INTO descriptor;
       
END web_load_blob_from_file;
/

