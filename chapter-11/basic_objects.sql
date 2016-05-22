/* ================================================================
||   Program Name: basic_objects.sql
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

-- Create or replace a generic object type.
CREATE OR REPLACE TYPE hello_there IS OBJECT
( who VARCHAR2(20)
, CONSTRUCTOR FUNCTION hello_there
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION hello_there
  ( who VARCHAR2 )
  RETURN SELF AS RESULT
, MEMBER FUNCTION get_who RETURN VARCHAR2
, MEMBER PROCEDURE set_who (who VARCHAR2)
, MEMBER PROCEDURE to_string )
INSTANTIABLE NOT FINAL;
/

-- Create or replace a generic object body.
CREATE OR REPLACE TYPE BODY hello_there IS
  
  CONSTRUCTOR FUNCTION hello_there RETURN SELF AS RESULT IS
    hello HELLO_THERE := hello_there('Generic Object.');
  BEGIN
    self := hello;
    RETURN;
  END hello_there;
  
  CONSTRUCTOR FUNCTION hello_there (who VARCHAR2) RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    RETURN;
  END hello_there;

  MEMBER FUNCTION get_who RETURN VARCHAR2 IS
  BEGIN
    RETURN self.who;
  END get_who;

  MEMBER PROCEDURE set_who (who VARCHAR2) IS
  BEGIN
    self.who := who;
  END set_who;
  
  MEMBER PROCEDURE to_string IS
  BEGIN
    dbms_output.put_line('Hello '||self.who);
  END to_string;
  
END;
/

-- Create or replace an item object type.
CREATE OR REPLACE TYPE item_object IS OBJECT
( item_title    VARCHAR2(60)
, item_subtitle VARCHAR2(60)
, CONSTRUCTOR FUNCTION item_object
  RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION item_object
  (item_title VARCHAR2, item_subtitle VARCHAR2)
  RETURN SELF AS RESULT
, STATIC FUNCTION get_item_object (item_id NUMBER) RETURN ITEM_OBJECT
, MEMBER FUNCTION to_string RETURN VARCHAR2 )
INSTANTIABLE NOT FINAL;
/

-- Create or replace an item object body.
CREATE OR REPLACE TYPE BODY item_object IS
  
  CONSTRUCTOR FUNCTION item_object RETURN SELF AS RESULT IS
    item ITEM_OBJECT := item_object('Generic Title','Generic Subtitle');
  BEGIN
    self := item;
    RETURN;
  END item_object;
  
  CONSTRUCTOR FUNCTION item_object
  (item_title VARCHAR2, item_subtitle VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.item_title := item_title;
    self.item_subtitle := item_subtitle;
    RETURN;
  END item_object;

  STATIC FUNCTION get_item_object (item_id NUMBER) RETURN ITEM_OBJECT IS
    item ITEM_OBJECT;
    CURSOR c (item_id_in NUMBER) IS
      SELECT item_title, item_subtitle FROM item WHERE item_id = item_id_in;  
  BEGIN
    FOR i IN c (item_id) LOOP
      item := item_object(i.item_title,i.item_subtitle);
    END LOOP;
    RETURN item;
  END get_item_object;

  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.item_title||']['||self.item_subtitle||']';
  END to_string;
  
END;
/

-- Test whether the static constructor works.
BEGIN
  dbms_output.put_line(item_object.get_item_object(1050).to_string);
END;
/

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ITEMS_OBJECT') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE items_object';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_types
            WHERE  type_name = 'ITEM_TABLE') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE item_table';
  END LOOP;
END;
/

-- Create or replace an table collection.
CREATE OR REPLACE TYPE item_table IS TABLE OF item_object;
/

-- Create or replace an object type of a collection.
CREATE OR REPLACE TYPE items_object IS OBJECT
( items_table    ITEM_TABLE
, CONSTRUCTOR FUNCTION items_object
  (items_table ITEM_TABLE) RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION items_object
  RETURN SELF AS RESULT
, MEMBER FUNCTION get_size RETURN NUMBER
, STATIC FUNCTION get_items_table RETURN ITEM_TABLE)
INSTANTIABLE NOT FINAL;
/

-- Create or replace an object body of a table collection.
CREATE OR REPLACE TYPE BODY items_object IS
  
  CONSTRUCTOR FUNCTION items_object
  (items_table ITEM_TABLE) RETURN SELF AS RESULT IS
  BEGIN
    self.items_table := items_table;
    RETURN;
  END items_object;

  CONSTRUCTOR FUNCTION items_object
  RETURN SELF AS RESULT IS
    c           NUMBER := 1; -- Counter for table index.
    item        ITEM_OBJECT;
    CURSOR c1 IS
      SELECT item_title, item_subtitle FROM item;  
  BEGIN
    FOR i IN c1 LOOP
      item := item_object(i.item_title,i.item_subtitle);
      items_table.EXTEND;
      self.items_table(c) := item;
      c := c + 1;
    END LOOP;
    RETURN;
  END items_object;

  MEMBER FUNCTION get_size RETURN NUMBER IS
  BEGIN
    RETURN self.items_table.COUNT;
  END get_size;
  
  STATIC FUNCTION get_items_table RETURN ITEM_TABLE IS
    c           NUMBER := 1; -- Counter for table index.
    item        ITEM_OBJECT;
    items_table ITEM_TABLE := item_table();
    CURSOR c1 IS
      SELECT item_title, item_subtitle FROM item;  
  BEGIN
    FOR i IN c1 LOOP
      item := item_object(i.item_title,i.item_subtitle);
      items_table.EXTEND;
      items_table(c) := item;
      c := c + 1;
    END LOOP;
    RETURN items_table;
  END get_items_table;

END;
/

-- Test whether the collection constructor works.
DECLARE
  items ITEMS_OBJECT;
BEGIN
  items := items_object(items_object.get_items_table);
  dbms_output.put_line(items.get_size);
END;
/

-- Test whether the static factory works.
DECLARE
  items ITEM_TABLE;
BEGIN
  items := items_object.get_items_table;
  FOR i IN 1..items.COUNT LOOP
    dbms_output.put_line(items(i).to_string);
  END LOOP;
END;
/
