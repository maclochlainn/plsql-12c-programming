/* ================================================================
||   Program Name: avatar.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates various procedure examples from the
||   the chapter.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Drop avatar table.
DROP TABLE avatar CASCADE CONSTRAINTS;

-- Create avatar table.
CREATE TABLE avatar
( avatar_id    NUMBER GENERATED AS IDENTITY
, avatar_name  VARCHAR2(30));

-- Create add_avatar function.
CREATE OR REPLACE FUNCTION add_avatar
( pv_avatar_name  VARCHAR2 ) RETURN BOOLEAN IS
  /* Set function to perform in its own transaction scope. */
  PRAGMA AUTONOMOUS_TRANSACTION;
  /* Set default return value. */
  lv_retval  BOOLEAN := FALSE;
BEGIN
  /* Insert row into avatar. */
  INSERT INTO avatar (avatar_name)
  VALUES (pv_avatar_name);
  /* Save change inside its own transaction scope. */
  COMMIT;
  /* Reset return value to true for complete. */
  lv_retval := TRUE;
  RETURN lv_retval;
END;
/

SHOW ERRORS

-- Create an anonymous block program.
DECLARE
  /* Declare local variable. */
  lv_avatar  VARCHAR2(30);
  /* Declare a local cursor. */
  CURSOR capture_result
  (cv_avatar_name  VARCHAR2) IS
    SELECT   avatar_name
    FROM     avatar
    WHERE    avatar_name = cv_avatar_name;
BEGIN
  IF add_avatar('Earthbender') THEN
    dbms_output.put_line('Record Inserted');
    ROLLBACK;
  ELSE
    dbms_output.put_line('No Record Inserted');
  END IF;
  OPEN capture_result('Earthbender');
  FETCH capture_result INTO lv_avatar;
  CLOSE capture_result;
  dbms_output.put_line('Value ['||lv_avatar||']');
END;
/

-- Create an avatar function.
CREATE OR REPLACE FUNCTION add_avatar
( pv_avatar_name  VARCHAR2 ) RETURN NUMBER IS
  /* Set function to perform in its own transaction scope. */
  PRAGMA AUTONOMOUS_TRANSACTION;
  /* Set default return value. */
  lv_retval  NUMBER := 0;
BEGIN
  /* Insert row into avatar. */
  INSERT INTO avatar (avatar_name)
  VALUES (pv_avatar_name);
  /* Save change inside its own transaction scope. */
  COMMIT;
  /* Reset return value to true for complete. */
  lv_retval := 1;
  RETURN lv_retval;
END;
/

SHOW ERRORS

-- Query the results of avatar function.
SELECT   CASE
           WHEN add_avatar('Firebender') <> 0 THEN 'Success' ELSE 'Failure'
         END AS Autonomous
FROM     dual;

SELECT   *
FROM     avatar;

-- Drop table avatar and sequence avatar_s.
DROP TABLE avatar CASCADE CONSTRAINTS;
DROP SEQUENCE avatar_s;

-- Create table avatar table.
CREATE TABLE avatar
( avatar_id    NUMBER CONSTRAINT avatar_pk PRIMARY KEY
, avatar_name  VARCHAR2(30));

-- Drop table episode table.
DROP TABLE episode CASCADE CONSTRAINTS;
DROP SEQUENCE episode_s;

-- Create table episode.
CREATE TABLE episode
( episode_id   NUMBER CONSTRAINT episode_pk PRIMARY KEY
, avatar_id    NUMBER
, episode_name  VARCHAR2(30)
, CONSTRAINT episode_fk1 FOREIGN KEY(avatar_id)
  REFERENCES avatar(avatar_id));

-- Create adding_avatar procedure.
CREATE OR REPLACE PROCEDURE adding_avatar
( pv_avatar_name   VARCHAR2
, pv_episode_name  VARCHAR2 ) IS

  /* Declare local variable to manage surrogate keys. */
  lv_avatar_id  NUMBER;
  lv_episode_id NUMBER;
BEGIN
  /* Set a Savepoint. */
  SAVEPOINT all_or_none;

  /* Get the sequence into a local variable. */
  SELECT   avatar_s.NEXTVAL
  INTO     lv_avatar_id
  FROM     dual;

  /* Insert row into avatar. */
  INSERT INTO avatar (avatar_id, avatar_name)
  VALUES (lv_avatar_id, pv_avatar_name);

  /* Get the sequence into a local variable. */
  SELECT   episode_s.NEXTVAL
  INTO     lv_episode_id
  FROM     dual;

  /* Insert row into avatar. */
  INSERT INTO episode (episode_id, avatar_id, episode_name)
  VALUES (lv_avatar_id, pv_episode_name);

  /* Save change inside its own transaction scope. */
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO all_or_none;
END;
/

-- Creating anonymous block program.
BEGIN
  adding_avatar('Airbender','Episode 1');
END;
/

-- Drop table avatar.
DROP TABLE avatar CASCADE CONSTRAINTS;

-- Create table avatar.
CREATE TABLE avatar
( avatar_id    NUMBER GENERATED AS IDENTITY
               CONSTRAINT avatar_pk PRIMARY KEY
, avatar_name  VARCHAR2(30));

-- Drop table episode.
DROP TABLE episode;

-- Create dependent episode table.
CREATE TABLE episode
( episode_id   NUMBER GENERATED AS IDENTITY
               CONSTRAINT episode_pk PRIMARY KEY
, avatar_id    NUMBER CONSTRAINT episode_nn1 NOT NULL
, episode_name  VARCHAR2(30)
, CONSTRAINT episode_fk1 FOREIGN KEY(avatar_id)
  REFERENCES avatar(avatar_id));

-- Create an adding_avatar procedure.
CREATE OR REPLACE PROCEDURE adding_avatar
( pv_avatar_name   VARCHAR2
, pv_episode_name  VARCHAR2 ) IS

  /* Declare local variable to manage IDENTITY column
     surrogate key. */
  lv_avatar_id  NUMBER;
BEGIN
  /* Set a Savepoint. */
  SAVEPOINT all_or_none;

  /* Insert row into avatar. */
  INSERT INTO avatar (avatar_name)
  VALUES (pv_avatar_name)
  RETURNING avatar_id INTO lv_avatar_id;

  /* Insert row into avatar. */
  INSERT INTO episode (avatar_id, episode_name)
  VALUES (lv_avatar_id, pv_episode_name);

  /* Save change inside its own transaction scope. */
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO all_or_none;
END;
/

-- Creating anonymous block program.
BEGIN
  adding_avatar('Airbender','Episode 1');
END;
/

-- Creating an adding_avatar procedure.
CREATE OR REPLACE PROCEDURE adding_avatar
( pv_avatar_name   IN     VARCHAR2
, pv_episode_name  IN     VARCHAR2
, pv_completion       OUT BOOLEAN) IS

  /* Declare local variable to manage IDENTITY column
     surrogate key. */
  lv_avatar_id  NUMBER;
BEGIN
  /* Set completion variable. */
  pv_completion := FALSE;

  /* Set a Savepoint. */
  SAVEPOINT all_or_none;

  /* Insert row into avatar. */
  INSERT INTO avatar (avatar_name)
  VALUES (pv_avatar_name)
  RETURNING avatar_id INTO lv_avatar_id;

  /* Insert row into avatar. */
  INSERT INTO episode (avatar_id, episode_name)
  VALUES (lv_avatar_id, pv_episode_name);

  /* Save change inside its own transaction scope. */
  COMMIT;

  /* Set completion variable. */
  pv_completion := TRUE;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO all_or_none;
END;
/

-- Creating anonymous block program.
DECLARE
  /* Set control variable. */
  lv_completion_variable  BOOLEAN;
BEGIN
  adding_avatar('Airbender','Episode 1',lv_completion_variable);
  IF lv_completion_variable THEN
    dbms_output.put_line('Successfully completed.');
  ELSE
    dbms_output.put_line('Failed completely.');
  END IF;
END;
/
