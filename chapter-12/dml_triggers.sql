/* ================================================================
||   Program Name: dml_triggers.sql
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

CREATE OR REPLACE TRIGGER contact_insert_t1
  BEFORE INSERT ON contact
  FOR EACH ROW
  WHEN (REGEXP_LIKE(new.last_name,' '))
BEGIN
  /* Enforce hyphenated names. */
  :new.last_name := REGEXP_REPLACE(:new.last_name,' ','-',1,1);
END contact_insert_t1;
/

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, 1001
, 1003
,'Catherine'
,'Zeta Jones'
, 3
, SYSDATE
, 3
, SYSDATE );

CREATE TABLE log_name_changes
( log_name_change  NUMBER  GENERATED ALWAYS AS IDENTITY
, name_submitted   VARCHAR2(20)
, name_modified    VARCHAR2(20));

CREATE OR REPLACE TRIGGER contact_insert_t1
  BEFORE INSERT ON contact
  FOR EACH ROW
  REFERENCING new AS myNew
  WHEN (REGEXP_LIKE(myNew.last_name,' '))
DECLARE
  /* Declare local variables. */
  lv_name_submitted  VARCHAR2(20);
  lv_name_modified   VARCHAR2(20);

  /* Declare trigger as an autonomous transaction. */
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  /* Assign submitted last name. */
  lv_name_submitted := :myNew.last_name;

  /* Enforce hyphenated names. */
  :myNew.last_name := REGEXP_REPLACE(:myNew.last_name,' ','-',1,1);

  /* Assign modified last name. */
  lv_name_modified := :myNew.last_name;

  /* Autonomous transaction writes before and after values. */
  INSERT INTO log_name_change
  ( name_submitted
  , name_modified )
  VALUES
  ( lv_name_submitted
  , lv_name_modified );

  /* Commit the write. */
  COMMIT;
END contact_insert_t1;
/

CREATE TABLE log_name_changes
( log_name_change  NUMBER  GENERATED ALWAYS AS IDENTITY
, name_submitted   VARCHAR2(20)
, name_modified    VARCHAR2(20));

CREATE OR REPLACE TRIGGER contact_insert_t1
  BEFORE INSERT ON contact
  FOR EACH ROW
  REFERENCING new AS myNew
  ENABLE
  WHEN (REGEXP_LIKE(myNew.last_name,' ') OR REGEXP_LIKE(myNew.first_name))
DECLARE
  /* Declare local variables. */
  lv_name_submitted  VARCHAR2(20);
  lv_name_modified   VARCHAR2(20);

  /* Declare trigger as an autonomous transaction. */
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  /* Assign submitted last name. */
  lv_name_submitted := :myNew.last_name;

  /* Enforce hyphenated names. */
  :myNew.last_name := REGEXP_REPLACE(:myNew.last_name,' ','-',1,1);

  /* Assign modified last name. */
  lv_name_modified := :myNew.last_name;

  /* Autonomous transaction writes before and after values. */
  INSERT INTO log_name_change
  ( name_submitted
  , name_modified )
  VALUES
  ( lv_name_submitted
  , lv_name_modified );

  /* Commit the write. */
  COMMIT;
END contact_insert_t1;
/

CREATE OR REPLACE TRIGGER contact_insert_t1
  BEFORE INSERT ON contact
  FOR EACH ROW
  WHEN (REGEXP_LIKE(new.last_name,' '))
BEGIN
  /* Enforce hyphenated names. */
  :new.last_name := REGEXP_REPLACE(:new.last_name,' ','-',1,1);
END contact_insert_t1;
/

CREATE OR REPLACE TRIGGER contact_insert_t2
  BEFORE INSERT ON contact
  FOR EACH ROW
  FOLLOWS contact_insert_t1
  WHEN (REGEXP_LIKE(new.first_name,' '))
BEGIN
  /* Enforce hyphenated names. */
  :new.first_name := 
    SUBSTR(:new.first_name,1,REGEXP_INSTR(:new.first_name,' ',1,1,0,'i')-1);
END contact_insert_t2;
/

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, 1001
, 1003
,'John the Actor'
,'Rhys Davies'
, 3
, SYSDATE
, 3
, SYSDATE );

CREATE OR REPLACE TRIGGER contact_insert_t1
  BEFORE INSERT ON contact
  FOR EACH ROW
  WHEN (REGEXP_LIKE(new.last_name,' ') OR REGEXP_LIKE(new.first_name,' '))
BEGIN
  /* Enforce hyphenated names. */
  :new.last_name := REGEXP_REPLACE(:new.last_name,' ','-',1,1);

  /* Enforce one name only. */
  :new.first_name := 
    SUBSTR(:new.first_name,1,REGEXP_INSTR(:new.first_name,' ',1,1,0,'i')-1);
END contact_insert_t1;
/


CREATE OR REPLACE TRIGGER contact_insert_t
  BEFORE INSERT OR UPDATE OF first_name, last_name ON contact
  FOR EACH ROW
  WHEN (REGEXP_LIKE(new.last_name,' ') OR REGEXP_LIKE(new.first_name,' '))
BEGIN
  /* Enforce hyphenated names. */
  :new.last_name := REGEXP_REPLACE(:new.last_name,' ','-',1,1);

  /* Selectively evaluate only insert or update actions. */
  IF INSERTING THEN
    :new.first_name := 
      SUBSTR(:new.first_name
            ,1
            ,REGEXP_INSTR(:new.first_name,' ',1,1,0,'i')-1);
  ELSIF UPDATING THEN
    IF REGEXP_LIKE(:new.first_name,' ') THEN
      RAISE_APPLICATION_ERROR(-20099,'Updates can''t use multiple names.'); 
    ELSIF REGEXP_LIKE(:new.last_name,' ') THEN
      RAISE_APPLICATION_ERROR(-20100,'Inserts non-hyphenated last name..'); 
    END IF;
  END IF;
END contact_insert_t;
/


CREATE OR REPLACE VIEW account_list AS
  SELECT c.member_id
  ,      c.contact_id
  ,      m.account_number
  ,      c.first_name
  ||     DECODE(c.middle_name,NULL,' ',' '||c.middle_name||' ')
  ||     c.last_name FULL_NAME
  FROM contact c JOIN member m ON c.member_id = m.member_id;


CREATE OR REPLACE TRIGGER account_list_dml
  INSTEAD OF INSERT OR UPDATE OR DELETE ON account_list
  FOR EACH ROW
DECLARE
  /* Anchor variable declaration. */
  lv_source  account_list.full_name%TYPE := :new.full_name;

  /* Declare variables. */
  lv_fname  VARCHAR2(43);
  lv_mname  VARCHAR2(1);
  lv_lname  VARCHAR2(43);

  /* Check whether all dependents are gone. */
  FUNCTION get_dependents
  (pv_member_id NUMBER) RETURN BOOLEAN IS
    /* Declare a local variable. */
    lv_rows  NUMBER := 0;

    /* Declare a dynamic cursor. */
    CURSOR c
    (cv_member_id NUMBER) IS
      SELECT   COUNT(*)
      FROM     contact
      WHERE    member_id = pv_member_id;
  BEGIN
    /* Open the cursor with the function input. */
    OPEN c (pv_member_id);
    FETCH c INTO lv_rows;

    /* Return false when there's more than one row. */
    IF lv_rows > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END get_dependents;

BEGIN
  /* Take action inline with scope of DML statement. */
  IF INSERTING THEN    -- On insert event.
    RAISE_APPLICATION_ERROR(-20000,'Not enough data for insert!');
  ELSIF UPDATING THEN  -- On update event.
    /* Assign source variable. */
    lv_source := :new.full_name;

    -- Parse full_name for elements.
    lv_fname := LTRIM(REGEXP_SUBSTR(lv_source,'(^|^ +)([[:alpha:]]+)',1));
    lv_mname := REGEXP_SUBSTR(
                  REGEXP_SUBSTR(
                      lv_source
                    ,'( +)([[:alpha:]]+)(( +|. +))',1),'([[:alpha:]])',1);
    lv_lname := REGEXP_SUBSTR(
                  REGEXP_SUBSTR(
                      lv_source
                    ,'( +)([[:alpha:]]+)( +$|$)',1),'([[:alpha:]]+)',1);

    /* Update name change in base table. */
    UPDATE contact
    SET    first_name = lv_fname
    ,      middle_name = lv_mname
    ,      last_name = lv_lname
    WHERE  contact_id = :old.contact_id;
  ELSIF DELETING THEN  -- On delete event.
    /* Remove a row. */
    DELETE FROM contact
    WHERE member_id = :old.member_id;

    /* Only delete the parent when there aren't any more children. */
    IF get_dependents(:old.member_id) THEN
      DELETE FROM member WHERE member_id = :old.member_id;
    END IF;
  END IF;
END;
