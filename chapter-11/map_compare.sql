/* ================================================================
||   Program Name: map_compare.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 11
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This builds an object type and body, then a test program.
|| ---------------------------------------------------------------- */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PERSISTENT_OBJECT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE persistent_object CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PERSISTENT_OBJECT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE persistent_object_s1';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE map_comp IS OBJECT
( who VARCHAR2(30)
, CONSTRUCTOR FUNCTION map_comp (who VARCHAR2) RETURN SELF AS RESULT
, MAP MEMBER FUNCTION equals RETURN VARCHAR2 )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY map_comp IS
  CONSTRUCTOR FUNCTION map_comp (who VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    RETURN;
  END map_comp;
  MAP MEMBER FUNCTION equals RETURN VARCHAR2 IS
  BEGIN
    RETURN self.who;
  END equals;
END;
/

DECLARE
  -- Declare a collection of an object type.
  TYPE object_list IS TABLE OF MAP_COMP;
  -- Initialize four objects in mixed alphabetical order.
  object1 MAP_COMP := map_comp('Ron Weasley');
  object2 MAP_COMP := map_comp('Harry Potter');
  object3 MAP_COMP := map_comp('Luna Lovegood');
  object4 MAP_COMP := map_comp('Hermione Granger');
  -- Define a collection of the object type.
  objects OBJECT_LIST := object_list(object1, object2, object3, object4);
  -- Swaps A and B.
  PROCEDURE swap (a IN OUT MAP_COMP, b IN OUT MAP_COMP) IS
    c MAP_COMP;
  BEGIN
    c := b;
    b := a;
    a := c;
  END swap;
BEGIN
  -- A bubble sort.
  FOR i IN 1..objects.COUNT LOOP
    FOR j IN 1..objects.COUNT LOOP
      IF objects(i).equals = LEAST(objects(i).equals,objects(j).equals) THEN
        swap(objects(i),objects(j));
      END IF;
    END LOOP;
  END LOOP;
  -- Print reorderd objects.
  FOR i IN 1..objects.COUNT LOOP
    dbms_output.put_line(objects(i).equals);
  END LOOP;
END;
/

CREATE TABLE persistent_object
( persistent_object_id NUMBER
, mapping_object       MAP_COMP );

CREATE SEQUENCE persistent_object_s1;

-- Insert instances of objects.
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Frodo Baggins'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Sam "Wise" Gamgee'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Meriadoc Brandybuck'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Perigrin Took'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Legolas son of Thranduil'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Aragorn son of Arathorn'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Boromir son of Denthor'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Gandolf the Gray'));
INSERT INTO persistent_object
VALUES (persistent_object_s1.nextval,map_comp('Gimli the Drawf'));

COLUMN primary_key FORMAT 9999999 HEADING "Primary|Key ID"
COLUMN fellowship  FORMAT A30     HEADING "Fellowship Member"

SELECT   persistent_object_id AS primary_key
,        TREAT(mapping_object AS map_comp).equals() AS fellowship
FROM     persistent_object
WHERE    mapping_object IS OF (map_comp)
ORDER BY 2;
