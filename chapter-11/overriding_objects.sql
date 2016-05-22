/* ================================================================
||   Program Name: overriding_objects.sql
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
            FROM   user_types
            WHERE  type_name = 'ORDER_SUBCOMP') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE order_subcomp';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ORDER_COMP') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE order_comp';
  END LOOP;
END;
/

CREATE OR REPLACE TYPE order_comp IS OBJECT
( who   VARCHAR2(20)
, movie VARCHAR2(20)
, CONSTRUCTOR FUNCTION order_comp (who VARCHAR2,movie VARCHAR2)
  RETURN SELF AS RESULT
, MEMBER FUNCTION to_string RETURN VARCHAR2
, ORDER MEMBER FUNCTION equals (object order_comp) RETURN NUMBER )
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY order_comp IS
  
  CONSTRUCTOR FUNCTION order_comp
  (who VARCHAR2, movie VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    self.movie := movie;
    RETURN;
  END order_comp;

  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.movie||']['||self.who||']';
  END to_string;
  
  ORDER MEMBER FUNCTION equals (object order_comp) RETURN NUMBER IS
  BEGIN
    IF self.movie < object.movie THEN
      RETURN 1;
    ELSIF self.movie = object.movie AND self.who < object.who THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END equals;
  
END;
/

CREATE OR REPLACE TYPE order_subcomp UNDER order_comp
( subtitle  VARCHAR2(20)
, CONSTRUCTOR FUNCTION order_subcomp
  (who VARCHAR2, movie VARCHAR2, subtitle VARCHAR2)
  RETURN SELF AS RESULT
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY order_subcomp IS
  
  CONSTRUCTOR FUNCTION order_subcomp
  (who VARCHAR2, movie VARCHAR2, subtitle VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    self.movie := movie;
    self.subtitle := subtitle;
    RETURN;
  END order_subcomp;

  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self as order_comp).to_string||'['||self.subtitle||']';
  END to_string;
   
END;
/

DECLARE
  -- Declare a collection of an object type.
  TYPE object_list IS TABLE OF ORDER_COMP;
  
  -- Initialize one subtype.
  object1 ORDER_SUBCOMP := order_subcomp('Ron Weasley','Harry Potter 1'
                                        ,'Socerer''s Stone');
  -- Initialize seven types.
  object2 ORDER_COMP := order_comp('Harry Potter','Harry Potter 1');
  object3 ORDER_COMP := order_comp('Luna Lovegood','Harry Potter 5');
  object4 ORDER_COMP := order_comp('Hermione Granger','Harry Potter 1');
  object5 ORDER_COMP := order_comp('Hermione Granger','Harry Potter 2');
  object6 ORDER_COMP := order_comp('Harry Potter','Harry Potter 5');
  object7 ORDER_COMP := order_comp('Cedric Diggory','Harry Potter 4');
  object8 ORDER_COMP := order_comp('Severus Snape','Harry Potter 1');

  -- Define a collection of the object type.
  objects OBJECT_LIST := object_list(object1, object2, object3, object4
                                    ,object5, object6, object7, object8);

  -- Swaps A and B.
  PROCEDURE swap (a IN OUT ORDER_COMP, b IN OUT ORDER_COMP) IS
    c ORDER_COMP;
  BEGIN
    c := b;
    b := a;
    a := c;
  END swap;
  
BEGIN
  -- A bubble sort.
  FOR i IN 1..objects.COUNT LOOP
    FOR j IN 1..objects.COUNT LOOP
      IF objects(i).equals(objects(j)) = 1 THEN
        swap(objects(i),objects(j));
      END IF;
    END LOOP;
  END LOOP;
  -- Print reorderd objects.
  FOR i IN 1..objects.COUNT LOOP
    dbms_output.put_line(objects(i).to_string);
  END LOOP;
END;
/
