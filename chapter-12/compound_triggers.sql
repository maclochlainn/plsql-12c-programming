/* ================================================================
||   Program Name: compound_triggers.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 12
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates associative arrays.
|| ================================================================*/

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PRICE_EVENT_LOG') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price_event_log CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PRICE_EVENT_LOG_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_event_log_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE price_event_log
( price_log_id     NUMBER
, price_id         NUMBER
, created_by       NUMBER
, creation_date    DATE
, last_updated_by  NUMBER
, last_update_date DATE );

-- Create sequence.
CREATE SEQUENCE price_event_log_s1;

-- Set V$SESSION CLIENT_INFO value consistent with values in SYSTEM_USER table.
EXEC dbms_application_info.set_client_info('3');

-- Create compound trigger on the price table.
CREATE OR REPLACE TRIGGER compound_price_update_t1
  FOR UPDATE ON price
  COMPOUND TRIGGER
    -- Declare a global record type.
    TYPE price_record IS RECORD
    ( price_log_id     price_event_log.price_log_id%TYPE
    , price_id         price_event_log.price_id%TYPE
    , created_by       price_event_log.created_by%TYPE
    , creation_date    price_event_log.creation_date%TYPE
    , last_updated_by  price_event_log.last_updated_by%TYPE
    , last_update_date price_event_log.last_update_date%TYPE );
    -- Declare a global collection type.    
    TYPE price_list IS TABLE OF PRICE_RECORD;
    -- Declare a global collection and initialize it.
    price_updates  PRICE_LIST := price_list();
  
  BEFORE EACH ROW IS
    -- Declare or define local timing point variables.
    c       NUMBER;
    user_id NUMBER := NVL(TO_NUMBER(SYS_CONTEXT('userenv','client_info')),-1);
  BEGIN
    -- Extend space and assign dynamic index value.
    price_updates.EXTEND;
    c := price_updates.LAST;
    price_updates(c).price_log_id := price_event_log_s1.nextval;
    price_updates(c).price_id := :old.price_id;
    price_updates(c).created_by := user_id;
    price_updates(c).creation_date := SYSDATE;
    price_updates(c).last_updated_by := user_id;
    price_updates(c).last_update_date := SYSDATE;
  END BEFORE EACH ROW;
  
  AFTER STATEMENT IS
  BEGIN
    FORALL i IN price_updates.FIRST..price_updates.LAST
      INSERT INTO price_event_log
      VALUES
      ( price_updates(i).price_log_id
      , price_updates(i).price_id
      , price_updates(i).created_by
      , price_updates(i).creation_date
      , price_updates(i).last_updated_by
      , price_updates(i).last_update_date );
  END AFTER STATEMENT;
END;
/

-- Update PRICE table.
UPDATE price
SET    last_updated_by = NVL(TO_NUMBER(SYS_CONTEXT('userenv','client_info')),-1);

-- Query PRICE_EVENT_LOG table.
SELECT * FROM price_event_log;