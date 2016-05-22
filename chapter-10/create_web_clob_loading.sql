/* ================================================================
||   Program Name: create_web_clob_loading.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 10
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates how to write a procedure to load a
||   CLOB data type through a procedure.
|| ================================================================*/

CREATE OR REPLACE PROCEDURE web_load_clob_from_file  
( item_id_in IN     NUMBER
, descriptor IN OUT CLOB ) IS

BEGIN

  -- A FOR UPDATE makes this a DML transaction.
  UPDATE    item
  SET       item_desc = empty_clob()
  WHERE     item_id = item_id_in
  RETURNING item_desc INTO descriptor;
       
END web_load_clob_from_file;
/

