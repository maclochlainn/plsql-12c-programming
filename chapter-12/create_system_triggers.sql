/* ================================================================
||   Program Name: create_system_triggers.sql
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

DECLARE

  -- Define an exception.
  wrong_schema EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_schema,-20001);

  -- Define a return variable.
  retval VARCHAR2(1 CHAR);

 /*
  || Define a cursor to identify whether the current user is either the
  || SYSTEM user or a user with the DBA role privilege.
  */
  CURSOR privs IS
    SELECT   DISTINCT null
    FROM     user_role_privs
    WHERE    username = 'SYSTEM'
    OR       granted_role = 'DBA';

BEGIN

  -- Open cursor and conditionally drop table in correct schema.
  OPEN privs;
  LOOP
    FETCH privs INTO retval;
    IF privs%NOTFOUND THEN
      RAISE wrong_schema;
    ELSE
      FOR i IN (SELECT null
                FROM   user_tables
                WHERE  table_name = 'CONNECTION_LOG') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE connection_log CASCADE CONSTRAINTS';
      END LOOP;
      FOR i IN (SELECT null
                FROM   user_sequences
                WHERE  sequence_name = 'CONNECTION_LOG_S1') LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE connection_log_s1';
      END LOOP;
    END IF; 
    EXIT;
  END LOOP;
  CLOSE privs;

EXCEPTION

  -- Handle a defined exception.
  WHEN wrong_schema THEN
    DBMS_OUTPUT.PUT_LINE('The script requires the SYSTEM user and '
    ||                   'you are using the <'||user||'> schema or '
    ||                   'the script requires a user with DBA role '
    ||                   'privileges.');

  -- Handle a generic exception.
  WHEN others THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    RETURN;

END;
/

-- Create connection audit log table.
CREATE TABLE connection_log 
( event_id           NUMBER(10)
, event_user_name    VARCHAR2(30) CONSTRAINT log_event_nn1 NOT NULL
, event_type         VARCHAR2(14) CONSTRAINT log_event_nn2 NOT NULL
, event_date         DATE         CONSTRAINT log_event_nn3 NOT NULL
, CONSTRAINT connection_log_p1    PRIMARY KEY (event_id));

-- Create sequence starting at 1 and incrementing by 1.
CREATE SEQUENCE connection_log_s1;

-- Create a trigger to automate the primary (surrogate) key generation.
CREATE OR REPLACE TRIGGER connection_log_t1
  BEFORE INSERT ON connection_log
  FOR EACH ROW
  WHEN (new.event_id IS NULL)
BEGIN
  SELECT   connection_log_s1.nextval
  INTO     :new.event_id
  FROM     dual;
END;
/

-- Grant access rights to PHP user.
GRANT SELECT ON connection_log TO PHP;

-- Define a package with connecting and disconnecting procedures.
CREATE OR REPLACE PACKAGE user_connection AS

  PROCEDURE Connecting
  (user_name       IN VARCHAR2);

  PROCEDURE Disconnecting
  (user_name       IN VARCHAR2);

END user_connection;
/

-- Define a package body with procedure implementation details.
CREATE OR REPLACE PACKAGE BODY user_connection AS

  PROCEDURE connecting
  (user_name       IN VARCHAR2) IS
  BEGIN
    INSERT INTO connection_log
    (event_user_name, event_type, event_date)
    VALUES
    (user_name,'CONNECT',SYSDATE);
  END connecting;
  
  PROCEDURE disconnecting
  (user_name       IN VARCHAR2) IS
  BEGIN
    INSERT INTO connection_log
    (event_user_name, event_type, event_date)
    VALUES
    (user_name,'DISCONNECT',SYSDATE);
  END disconnecting;
  
END user_connection;
/

-- Define system login trigger.
CREATE OR REPLACE TRIGGER connecting_trigger
  AFTER LOGON ON DATABASE
BEGIN
  user_connection.connecting(sys.login_user);
END;
/

-- Define system logout trigger.
CREATE OR REPLACE TRIGGER disconnecting_trigger
  BEFORE LOGOFF ON DATABASE
BEGIN
  user_connection.disconnecting(sys.login_user);
END;
/