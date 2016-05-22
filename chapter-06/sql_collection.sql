/* ================================================================
||   Program Name: sql_collection.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates table and varray collections.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE
  TYPE sql_varray IS VARRAY(3) OF VARCHAR2(20) NOT NULL;
/

CREATE OR REPLACE
  TYPE sql_varying IS VARRAY(3) OF VARCHAR2(20) NOT NULL;
/

SELECT   column_value AS "Three Stooges"
FROM     TABLE(sql_varray('Moe','Larry','Curly'));

DECLARE
  lv_collection  SQL_VARRAY := sql_varray('Moe','Larry');
BEGIN
  /* Print the number and limit of elements. */
  dbms_output.put_line(
    'Count ['||lv_collection.COUNT||']'||
    'Limit ['||lv_collection.LIMIT||']');
    
  /* Extend space and assign to the new index. */ 
  lv_collection.EXTEND;

  /* Print the number and limit of elements. */
  dbms_output.put_line(
    'Count ['||lv_collection.COUNT||'] '||
    'Limit ['||lv_collection.LIMIT||']');
  
  /* Assign a new value. */
  lv_collection(lv_collection.COUNT) := 'Curly';

  /* Iterate across the collection to the total number of elements. */  
  FOR i IN 1..lv_collection.COUNT LOOP
    dbms_output.put_line(lv_collection(i));
  END LOOP;
END;
/

DECLARE
  lv_collection  SQL_VARYING := sql_varying('Moe','Larry','Shemp');
BEGIN
  /* Print the number and limit of elements. */
  dbms_output.put_line(
    'Count ['||lv_collection.COUNT||']'||
    'Limit ['||lv_collection.LIMIT||']');
    
  /* Extend space and assign to the new index. */ 
  lv_collection.EXTEND;

  /* Print the number and limit of elements. */
  dbms_output.put_line(
    'Count ['||lv_collection.COUNT||']'||
    'Limit ['||lv_collection.LIMIT||']');
    
  /* Assign a new value. */
  lv_collection(lv_collection.COUNT) := 'Curly';

  /* Iterate across the collection to the total number of elements. */  
  FOR i IN 1..lv_collection.COUNT LOOP
    dbms_output.put_line(lv_collection(i));
  END LOOP;
END;
/

CREATE OR REPLACE
  TYPE sql_table IS TABLE OF VARCHAR2(20);
/

SELECT   column_value AS "Dúnedain"
FROM     TABLE(sql_table('Aragorn','Faramir','Boromir'))
ORDER BY 1;

CREATE OR REPLACE FUNCTION add_element
( pv_table    SQL_TABLE
, pv_element  VARCHAR2 ) RETURN SQL_TABLE IS

  /* Declare a local table collection. */
  lv_table    SQL_TABLE := sql_table();
BEGIN
  /* Check for an initialized collection parameter. */
  IF pv_table.EXISTS(1) THEN
    lv_table := pv_table;
  END IF;
  
  /* Check for a not null element before adding it. */
  IF pv_element IS NOT NULL THEN
    /* Extend space and add an element. */
    lv_table.EXTEND;
    lv_table(lv_table.COUNT) := pv_element;
  END IF;
  
  /* Return the table collection with its new member. */
  RETURN lv_table;
END;
/

DECLARE
  /* Declare a meaning-ladden variable name and exclude the
     lv_ preface from the variable name. */
  current  INTEGER := 1;
  
  /* Declare a local table collection. */
  lv_table    SQL_TABLE :=
                sql_table('Aragorn','Faramir','Boromir');
BEGIN
  /* Remove the lead element of a table collection. */
  lv_table.DELETE(1);

  /* Set the starting point. */
  current := lv_table.FIRST;
  
  /* Check pseudo index value less than last index value. */  
  WHILE (current <= lv_table.LAST) LOOP
    /* Print current value. */
    dbms_output.put_line(
      'Values ['||current||']['||lv_table(current)||']');

    /* Shift the index to the next value. */
    current := lv_table.NEXT(current);    
  END LOOP;
END;
/

DECLARE
  /* Declare a local counter variable. */
  lv_counter  INTEGER := 0;
  
  /* Declare a local table collection. */
  lv_table    SQL_TABLE :=
                sql_table('Aragorn','Faramir','Boromir');
BEGIN
  /* Remove the lead element of a table collection. */
  lv_table.DELETE(1);

  /* Check pseudo index value less than last index value. */  
  WHILE (lv_counter <= lv_table.LAST) LOOP
    /* Increment the index counter. */
    lv_counter := lv_counter + 1;    

    /* Check whether the index returns a value. */
    IF lv_table.EXISTS(lv_counter) THEN
      dbms_output.put_line(
        'Values ['||lv_counter||']['||lv_table(lv_counter)||']');
    END IF; 
  END LOOP;
END;
/
  
SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(sql_table('Faramir','Boromir')
                          ,'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(sql_table(),'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(null,'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(null,null))
ORDER BY 1;

CREATE OR REPLACE FUNCTION add_element
( pv_table    SQL_TABLE
, pv_element  VARCHAR2 ) RETURN SQL_TABLE IS

  /* Declare a local table collection. */
  lv_table    SQL_TABLE := sql_table();
BEGIN

  /* Check for an initialized collection parameter. */
  IF pv_table IS NOT EMPTY THEN
    lv_table := pv_table;
  END IF;
  
  /* Check for a not null element before adding it. */
  IF pv_element IS NOT NULL THEN
    /* Extend space and add an element. */
    lv_table.EXTEND;
    lv_table(lv_table.COUNT) := pv_element;
  END IF;
  
  /* Return the table collection with its new member. */
  RETURN lv_table;
END;
/

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(sql_table('Faramir','Boromir')
                          ,'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(sql_table(),'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(null,'Aragorn'))
ORDER BY 1;

SELECT   column_value AS "Dúnedain"
FROM     TABLE(add_element(null,null))
ORDER BY 1;

DECLARE
  /* Define a local table collection. */
  TYPE plsql_table IS TABLE OF VARCHAR2(20);

  /* Declare a local table collection. */
  lv_table    PLSQL_TABLE :=
                plsql_table('Aragorn','Faramir','Boromir');
BEGIN
  /* Loop through the collection and print the results. */
  FOR i IN lv_table.FIRST..lv_table.LAST LOOP
    dbms_output.put_line(lv_table(i));
  END LOOP;
END;
/

CREATE OR REPLACE PACKAGE type_library IS
  /* Define a local table collection. */
  TYPE plsql_table IS TABLE OF VARCHAR2(20);
END;
/

DECLARE
  /* Declare a local table collection. */
  lv_table  TYPE_LIBRARY.PLSQL_TABLE :=
              type_library.plsql_table('Aragorn','Faramir','Boromir');
BEGIN
  /* Loop through the collection and print the results. */
  FOR i IN lv_table.FIRST..lv_table.LAST LOOP
    dbms_output.put_line(lv_table(i));
  END LOOP;
END;
/

DROP TYPE people_table FORCE;
DROP TYPE people_object FORCE;
DROP TYPE prominent_table FORCE;
DROP TYPE prominent_object FORCE;

CREATE OR REPLACE
  TYPE prominent_object IS OBJECT
  ( name     VARCHAR2(20)
  , age      VARCHAR2(10));
/

CREATE OR REPLACE
  TYPE prominent_table IS TABLE OF prominent_object;
/

CREATE OR REPLACE
  TYPE people_object IS OBJECT
  ( race      VARCHAR2(10)
  , exemplar  PROMINENT_OBJECT);
/

CREATE OR REPLACE
  TYPE people_table IS TABLE OF people_object;
/

COLUMN EXEMPLAR FORMAT A40
SELECT  *
FROM    TABLE(
          SELECT CAST(COLLECT(
              people_object(
                 'Men'
                , prominent_object('Aragorn','3rd Age')
              )
            ) AS people_table
          )
          FROM  dual);

COLUMN EXEMPLAR FORMAT A40
SELECT  o.race, n.name, n.age
FROM    TABLE(
          SELECT CAST(COLLECT(
              people_object(
                 'Men'
                , prominent_object('Aragorn','3rd Age')
              )
            ) AS people_table
          )
          FROM  dual) o CROSS JOIN
        TABLE(
          SELECT CAST(COLLECT(exemplar) AS prominent_table)
          FROM dual) n;

          
SELECT  *
FROM    TABLE(
          people_table(
              people_object(
                 'Men'
                , prominent_object('Aragorn','3rd Age'))
            , people_object(
                 'Elf'
                , prominent_object('Legolas','3rd Age'))
            )) o CROSS JOIN
        TABLE(
          SELECT CAST(COLLECT(exemplar) AS prominent_table)
          FROM dual) n;

DECLARE
  /* Declare a record. */
  TYPE tolkien_record IS RECORD
  ( race      VARCHAR2(10)
  , name      VARCHAR2(20)
  , age       VARCHAR2(10));

  /* Declare a table of the record. */
  TYPE tolkien_plsql_table IS TABLE OF TOLKIEN_RECORD;
  
  /* Declare record and table collection variables. */
  lv_tolkien_record       TOLKIEN_RECORD;
  lv_tolkien_plsql_table  TOLKIEN_PLSQL_TABLE;
  
  /* Declare a table collection. */
  lv_tolkien_table  PEOPLE_TABLE :=
                      people_table(
                        people_object(
                           'Men'
                          , prominent_object('Aragorn','3rd Age'))
                      , people_object(
                           'Elf'
                           , prominent_object('Legolas','3rd Age'))); 
BEGIN

  SELECT   o.race, n.name, n.age
  INTO     lv_tolkien_record
  FROM     TABLE(lv_tolkien_table) o CROSS JOIN
           TABLE(
             SELECT CAST(COLLECT(exemplar) AS prominent_table)
             FROM   dual) n
  WHERE    ROWNUM < 2;

  dbms_output.put_line(
    '['||lv_tolkien_record.race||'] '||
    '['||lv_tolkien_record.name||'] '||
    '['||lv_tolkien_record.age ||']');
END;
/

DECLARE
  /* Declare a record. */
  TYPE tolkien_record IS RECORD
  ( race      VARCHAR2(10)
  , name      VARCHAR2(20)
  , age       VARCHAR2(10));

  /* Declare a table of the record. */
  TYPE tolkien_plsql_table IS TABLE OF TOLKIEN_RECORD;
  
  /* Declare record and table collection variables. */
  lv_tolkien_record       TOLKIEN_RECORD;
  lv_tolkien_plsql_table  TOLKIEN_PLSQL_TABLE;
  
  /* Declare a table collection. */
  lv_tolkien_table  PEOPLE_TABLE :=
                      people_table(
                        people_object(
                           'Men'
                          , prominent_object('Aragorn','3rd Age'))
                      , people_object(
                           'Elf'
                           , prominent_object('Legolas','3rd Age'))); 
BEGIN

  SELECT   o.race, n.name, n.age
  INTO     lv_tolkien_record
  FROM     TABLE(lv_tolkien_table) o CROSS JOIN
           TABLE(
             SELECT CAST(COLLECT(exemplar) AS prominent_table)
             FROM   dual) n
  FETCH    FIRST 1 ROWS ONLY;

  dbms_output.put_line(
    '['||lv_tolkien_record.race||'] '||
    '['||lv_tolkien_record.name||'] '||
    '['||lv_tolkien_record.age ||']');
END;
/


DECLARE
  /* Declare a record. */
  TYPE tolkien_record IS RECORD
  ( race      VARCHAR2(10)
  , name      VARCHAR2(20)
  , age       VARCHAR2(10));
  
  /* Declare a table of the record. */
  TYPE tolkien_plsql_table IS TABLE OF TOLKIEN_RECORD;
  
  /* Declare record and table collection variables. */
  lv_tolkien_record       TOLKIEN_RECORD;
  lv_tolkien_plsql_table  TOLKIEN_PLSQL_TABLE;
  
  /* Declare a table collection. */
  lv_tolkien_table  PEOPLE_TABLE :=
                      people_table(
                        people_object(
                           'Men'
                          , prominent_object('Aragorn','3rd Age'))
                      , people_object(
                           'Elf'
                           , prominent_object('Legolas','3rd Age'))); 
BEGIN
  /* Perform a bulk collect into a local PL//SQL collection. */
  SELECT   o.race, n.name, n.age
  BULK COLLECT INTO     lv_tolkien_plsql_table
  FROM     TABLE(lv_tolkien_table) o CROSS JOIN
           TABLE(
             SELECT CAST(COLLECT(exemplar) AS prominent_table)
             FROM   dual) n;
             
  /* Loop through the result set and print the results. */           
  FOR i IN 1..lv_tolkien_plsql_table.COUNT LOOP
  dbms_output.put_line(
    '['||lv_tolkien_plsql_table(i).race||'] '||
    '['||lv_tolkien_plsql_table(i).name||'] '||
    '['||lv_tolkien_plsql_table(i).age ||']');
  END LOOP;
END;
/

 
DECLARE
  /* Declare a table collection. */
  lv_tolkien  PEOPLE_TABLE :=
                 people_table(
                     people_object(
                        'Men'
                       , prominent_object('Aragorn','3rd Age'))
                   , people_object(
                        'Elf'
                       , prominent_object('Legolas','3rd Age'))); 
BEGIN
  /* Add a new record to collection. */
  lv_tolkien.EXTEND;
  lv_tolkien(lv_tolkien.COUNT) := 
     people_object('Drawf'
                  , prominent_object('Gimili','3rd Age'));

  /* Read and print values in table collection. */
  FOR i IN lv_tolkien.FIRST..lv_tolkien.LAST LOOP
    dbms_output.put_line(
      lv_tolkien(i).race||': '||lv_tolkien(i).exemplar.name);
  END LOOP;  
END;
/

DROP TYPE people_table FORCE;
DROP TYPE people_object FORCE;
DROP TYPE prominent_table FORCE;
DROP TYPE prominent_object FORCE;

CREATE OR REPLACE
  TYPE prominent_object IS OBJECT
  ( name     VARCHAR2(20)
  , age      VARCHAR2(10));
/

CREATE OR REPLACE
  TYPE prominent_table IS TABLE OF prominent_object;
/

CREATE OR REPLACE
  TYPE people_object IS OBJECT
  ( race      VARCHAR2(10)
  , exemplar  PROMINENT_TABLE);
/

CREATE OR REPLACE
  TYPE people_table IS TABLE OF people_object;
/

DECLARE
  /* Declare a table collection. */
  lv_tolkien  PEOPLE_TABLE :=
                 people_table(
                     people_object(
                        'Men'
                       , prominent_table(
                             prominent_object('Aragorn','3rd Age')
                           , prominent_object('Boromir','3rd Age')
                           , prominent_object('Faramir','3rd Age')
                           , prominent_object('Eowyn','3rd Age')))
                   , people_object(
                        'Elf'
                       , prominent_table(
                             prominent_object('Legolas','3rd Age')
                           , prominent_object('Arwen','3rd Age')))); 
BEGIN
  /* Add a new record to collection. */
  lv_tolkien.EXTEND;
  lv_tolkien(lv_tolkien.COUNT) := 
     people_object('Drawf'
                  , prominent_table(
                        prominent_object('Gimili','3rd Age')
                      , prominent_object('Gloin','3rd Age')));

  /* Read and print values in table collection. */
  FOR i IN lv_tolkien.FIRST..lv_tolkien.LAST LOOP
    FOR j IN lv_tolkien(i).exemplar.FIRST..lv_tolkien(i).exemplar.LAST LOOP
      dbms_output.put_line(
        lv_tolkien(i).race||': '||lv_tolkien(i).exemplar(j).name);
    END LOOP;
  END LOOP;  
END;
/

COLUMN EXEMPLAR FORMAT A40
SELECT  *
FROM    TABLE(
          SELECT
            CAST(
              COLLECT(
                people_object(
                   'Men'
                  , prominent_object('Aragorn','3rd Age')
                )
              ) AS people_table
            )
          FROM  dual) o
CROSS JOIN TABLE(CAST(COLLECT(exemplar) AS prominent_table)) n;



          
          