/* ================================================================
||   Program Name: create_insteadof_trigger.sql
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

CREATE OR REPLACE TRIGGER account_list_dml
  INSTEAD OF INSERT OR UPDATE OR DELETE ON account_list
  FOR EACH ROW
DECLARE
  -- Source variable.
  source VARCHAR2(10);
  --source account_list.full_name%TYPE := :new.full_name;
  -- Parsed variables.
  fname  VARCHAR2(43);
  mname  VARCHAR2(1);
  lname  VARCHAR2(43);
  -- Check whether all dependents are gone.
  FUNCTION get_dependents (member_id NUMBER) RETURN BOOLEAN IS
    rows NUMBER := 0;
    CURSOR c (member_id_in NUMBER) IS
      SELECT COUNT(*) FROM contact WHERE member_id = member_id_in;
  BEGIN
    OPEN c (member_id);
    FETCH c INTO rows;
    IF rows > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END get_dependents;
BEGIN
  
  IF INSERTING THEN -- On insert event.
  
    RAISE_APPLICATION_ERROR(-20000,'Not enough data for insert!');
  
  ELSIF UPDATING THEN -- On update event.
  
    -- Assign source variable.
    source := :new.full_name;

    -- Parse full_name for elements.
    fname := LTRIM(REGEXP_SUBSTR(source,'(^|^ +)([[:alpha:]]+)',1));
    mname := REGEXP_SUBSTR(
               REGEXP_SUBSTR(
                 source,'( +)([[:alpha:]]+)(( +|. +))',1),'([[:alpha:]])',1);
    lname := REGEXP_SUBSTR(
               REGEXP_SUBSTR(
                 source,'( +)([[:alpha:]]+)( +$|$)',1),'([[:alpha:]]+)',1);
    
    -- Update name change in base table.
    UPDATE contact
    SET    first_name = fname
    ,      middle_initial = mname
    ,      last_name = lname
    WHERE  contact_id = :old.contact_id;
    
  ELSIF DELETING THEN -- On delete event.
  
    DELETE FROM contact WHERE member_id = :old.member_id;
    
    -- Only delete the parent when there aren't any more children.
    IF get_dependents(:old.member_id) THEN
      DELETE FROM member WHERE member_id = :old.member_id;
    END IF;
    
  END IF;
  
END;
/
