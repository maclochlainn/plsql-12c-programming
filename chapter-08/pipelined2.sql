/* ================================================================
||   Program Name: pipelined.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates pipelined functions.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

-- Unremark for debugging script.
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

CREATE OR REPLACE FUNCTION pipelined_numbers
RETURN NUMBERS
PIPELINED IS
  list NUMBERS := numbers(0,1,2,3,4,5,6,7,8,9);
BEGIN
  FOR i IN 1..list.LAST LOOP
    PIPE ROW(list(i));
  END LOOP;
  RETURN;
END;
/

CREATE OR REPLACE PACKAGE pipelined IS
  /* Declare a PL/SQL record and collection type. */
  TYPE account_record IS RECORD
  ( account     VARCHAR2(10)
  , full_name   VARCHAR2(42));
  TYPE account_table IS TABLE OF account_record;
  
  /* Declare a pipelined function. */
  FUNCTION pf RETURN account_table PIPELINED;
END pipelined;
/

CREATE OR REPLACE PACKAGE BODY pipelined IS
  -- Implement a pipelined function.
  FUNCTION pf
  RETURN account_table
  PIPELINED IS
    /* Declare a collection control and collection variable. */
    counter NUMBER := 1;
    account ACCOUNT_TABLE := account_table();
    
    /* Define a cursor. */
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name;
  BEGIN
    FOR i IN c LOOP
      /* Allot space and add values to collection. */
      account.EXTEND;
      account(counter).account   := i.account_number;
      account(counter).full_name := i.full_name;
      
      /* Assign the collection element to the PIPE. */
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
END pipelined;
/

SELECT * FROM TABLE(pipelined.pf);

CREATE OR REPLACE PACKAGE BODY pipelined IS
  -- Implement a pipelined function.
  FUNCTION pf
  RETURN pipelined.account_table
  PIPELINED IS
    /* Declare a collection control and collection variable. */
    counter NUMBER := 1;
    account ACCOUNT_TABLE := account_table();
    
    /* Define a cursor. */
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name;
  BEGIN
    FOR i IN c LOOP
      /* Allot space and add values to collection. */
      account.EXTEND;
      account(counter) := i;
      
      /* Assign the collection element to the PIPE. */
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
END pipelined;
/

CREATE OR REPLACE PACKAGE BODY pipelined IS
  -- Implement a pipelined function.
  FUNCTION pf
  RETURN account_table
  PIPELINED IS
    /* Declare a collection control and collection variable. */
    counter NUMBER := 1;
    account ACCOUNT_TABLE := account_table();
    
    /* Define a cursor. */
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name;
  BEGIN
    FOR i IN c LOOP
      /* Allot space and add values to collection. */
      account.EXTEND;
      account(counter).account   := i.account_number;
      account(counter).full_name := i.full_name;
      
      /* Assign the collection element to the PIPE. */
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
END pipelined;
/

CREATE OR REPLACE FUNCTION pf
RETURN pipelined.account_table
PIPELINED IS
    -- Declare a collection control variable and collection variable.
    counter NUMBER := 1;
    account PIPELINED.ACCOUNT_TABLE := pipelined.account_table();
    
    -- Define a cursor.
    CURSOR c IS
      SELECT   m.account_number
      ,        c.last_name || ', '||c.first_name full_name
      FROM     member m JOIN contact c ON m.member_id = c.member_id
      ORDER BY c.last_name, c.first_name;
  BEGIN
    FOR i IN c LOOP
      account.EXTEND;
      account(counter).account   := i.account_number;
      account(counter).full_name := i.full_name;
      PIPE ROW(account(counter));
      counter := counter + 1;
    END LOOP;
    RETURN;
  END pf;
/

SELECT * FROM TABLE(pf);

CREATE OR REPLACE PROCEDURE read_pipe
( pipe_in pipelined.account_table ) IS
BEGIN
  FOR i IN 1..pipe_in.LAST LOOP
    dbms_output.put(pipe_in(i).account);
    dbms_output.put(pipe_in(i).full_name);
  END LOOP;
END read_pipe;
/

EXECUTE read_pipe(pf);

BEGIN
  FOR i IN (SELECT * FROM TABLE(pf) ORDER BY 1) LOOP
    dbms_output.put_line(i.account||' '||i.full_name);
  END LOOP;
END;
/
