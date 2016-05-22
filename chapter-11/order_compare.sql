/* ================================================================
||   Program Name: order_compare.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 11
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This builds an object type and body, then a test program.
|| ---------------------------------------------------------------- */

DECLARE
  -- Declare a collection of an object type.
  TYPE object_list IS TABLE OF ORDER_COMP;
  
  -- Initialize four objects in mixed alphabetical order.
  lv_obj1 ORDER_COMP := order_comp('Ron Weasley','Harry Potter 1');
  lv_obj2 ORDER_COMP := order_comp('Harry Potter','Harry Potter 1');
  lv_obj3 ORDER_COMP := order_comp('Luna Lovegood','Harry Potter 5');
  lv_obj4 ORDER_COMP := order_comp('Hermione Granger','Harry Potter 1');
  lv_obj5 ORDER_COMP := order_comp('Hermione Granger','Harry Potter 2');
  lv_obj6 ORDER_COMP := order_comp('Harry Potter','Harry Potter 5');
  lv_obj7 ORDER_COMP := order_comp('Cedric Diggory','Harry Potter 4');
  lv_obj8 ORDER_COMP := order_comp('Severus Snape','Harry Potter 1');

  -- Define a collection of the object type.
  lv_objs OBJECT_LIST := object_list(lv_obj1,lv_obj2,lv_obj3,lv_obj4
                                    ,lv_obj5,lv_obj6,lv_obj7,lv_obj8);

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
  FOR i IN 1..lv_objs.COUNT LOOP
    FOR j IN 1..lv_objs.COUNT LOOP
      IF lv_objs(i).equals(lv_objs(j)) = 0 THEN
        swap(lv_objs(i),lv_objs(j));
      END IF;
    END LOOP;
  END LOOP;
  -- Print reorderd objects.
  FOR i IN 1..lv_objs.COUNT LOOP
    dbms_output.put_line(lv_objs(i).to_string);
  END LOOP;
END;
/
