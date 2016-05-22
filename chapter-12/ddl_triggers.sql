/* ================================================================
||   Program Name: ddl_triggers.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 12
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates associative arrays.
|| ================================================================*/

CREATE OR REPLACE TRIGGER dropping_column
  BEFORE ALTER ON SCHEMA
BEGIN
 NULL;
END;
/

DROP TABLE change_column_t1;

DROP TABLE logging_table;
DROP TABLE sample1;
DROP TABLE sample2;
DROP TYPE who_audit_key_table FORCE;
DROP TYPE who_audit_key_table FORCE;
DROP TYPE who_audit_key FORCE;
DROP TYPE who_audit_value FORCE;


CREATE OR REPLACE
  TYPE who_audit_key IS OBJECT
  ( row_id     CHAR(18)
  , row_value  NUMBER );
/

CREATE OR REPLACE
  TYPE who_audit_key_table IS TABLE OF who_audit_key;
/

SHOW ERRORS

CREATE OR REPLACE
  TYPE who_audit_value IS OBJECT
  ( row_id     CHAR(18)
  , row_value  DATE );
/

CREATE OR REPLACE
  TYPE who_audit_value_table IS TABLE OF who_audit_value;
/

SHOW ERRORS

CREATE TABLE logging
( logging_id       NUMBER GENERATED ALWAYS AS IDENTITY
, message          VARCHAR2(265)
, user_ids         WHO_AUDIT_KEY_TABLE
, user_timestamps  WHO_AUDIT_VALUE_TABLE
, CONSTRAINT logging_pk PRIMARY KEY (logging_id))
  NESTED TABLE user_ids STORE AS who_audit_id
, NESTED TABLE user_timestamps STORE AS who_audit_timestamp;

CREATE TABLE sample1
( sample_id         NUMBER
, created_by        NUMBER
, creation_date     DATE
, last_updated_by   NUMBER
, last_update_date  DATE);

DECLARE
  TYPE column_table IS TABLE OF VARCHAR2(128);
  lv_column_table COLUMN_TABLE := column_table('CREATED_BY','LAST_UPDATED_BY');
BEGIN
  IF ora_sysevent = 'DROP' AND
     ora_dict_obj_type = 'TABLE' THEN
     FOR i IN 1..lv_column_table.COUNT LOOP
       IF ora_is_drop_column(lv_column_table(i)) THEN
         INSERT INTO logging
         ( message )
         VALUES
         (ora_dict_obj_name||'.'||lv_column_table(i)||' changed.');
       END IF;
    END LOOP;
  END IF;
END;
/

SELECT * FROM logging;

CREATE OR REPLACE TRIGGER dropping_column
  BEFORE ALTER ON SCHEMA
DECLARE
  /* Column length has grown in Oracle 12c to 128. */
  TYPE column_table IS TABLE OF VARCHAR2(128);

  /* Identify the list of columns to monitor. */
  lv_column_table COLUMN_TABLE := column_table('CREATED_BY'
                                              ,'CREATION_DATE'
                                              ,'LAST_UPDATED_BY'
                                              ,'LAST_UPDATE_DATE');
BEGIN
  /* Check for altering a table when you want to capture
     dropping a column. */
  IF ORA_SYSEVENT = 'ALTER' AND ORA_DICT_OBJ_TYPE = 'TABLE' THEN
     /* Read through the list of monitored columns. */
     FOR i IN 1..lv_column_table.COUNT LOOP
       /* Check for a drop of a monitored column and record it. */
       IF ORA_IS_DROP_COLUMN(lv_column_table(i)) THEN
         INSERT INTO logging
         (message)
         VALUES
         (ora_dict_obj_owner||'.'||
          ora_dict_obj_name||'.'||         
          lv_column_table(i)||' column dropped.');
       END IF;
    END LOOP;
  END IF;
END;
/

SHOW ERRORS

ALTER TABLE sample1
  DROP COLUMN last_updated_by;

SELECT   message
FROM     logging;


CREATE TABLE logon_ip
( logon_ip_id       NUMBER GENERATED ALWAYS AS IDENTITY
, logon_ip_address  VARCHAR2(15));

CREATE OR REPLACE TRIGGER connecting_trigger
  AFTER LOGON ON DATABASE
DECLARE
  ip_address VARCHAR2(15);
BEGIN
  IF ora_sysevent = 'LOGON' THEN
    /* Capture the IP address to a local variable. */
    ip_address := ora_client_ip_address;

    /* Write the logon ip address to a table. */
    INSERT INTO logon_ip
    (logon_ip_address)
    VALUES
    (ip_address);
  END IF;
END;
/
