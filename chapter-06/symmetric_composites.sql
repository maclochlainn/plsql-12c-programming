/* ================================================================
||   Program Name: symmetric_composites.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates table and varray collections.
|| ================================================================*/

DROP TYPE prominent_table;
DROP TYPE people_table;
DROP TYPE prominent_object;
DROP TYPE prominent_table;

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
SELECT *
FROM   TABLE(
         SELECT CAST(COLLECT(
                  people_object(
                     'Men'
                    , prominent_object('Aragorn','3rd Age')
                    )
                  ) AS people_table
                )
         FROM dual);


SELECT o.race, n.name, n.age
FROM   TABLE(
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

SELECT  o.race, n.name, n.age
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
  /* Add a new record to collection. */
  lv_tolkien_table.EXTEND;
  lv_tolkien_table(lv_tolkien_table.COUNT) :=
     people_object('Dwarf'
                  , prominent_object('Gimili','3rd Age'));

  /* Read and print values in table collection. */
  FOR i IN lv_tolkien_table.FIRST..lv_tolkien_table.LAST LOOP
    dbms_output.put_line(
      lv_tolkien_table(i).race||': '||lv_tolkien_table(i).exemplar.name);
  END LOOP;
END;
/


DECLARE
  /* Declare a PL/SQL record. */
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
  /* Single-row implicit subquery. */
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
  /* Declare a PL/SQL record. */
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
  /* Single-row implicit subquery. */
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
  /* Declare a PL/SQL record. */
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
  /* Single-row implicit subquery. */
  SELECT   o.race, n.name, n.age
  BULK COLLECT INTO lv_tolkien_plsql_table
  FROM     TABLE(lv_tolkien_table) o CROSS JOIN
             TABLE(
               SELECT CAST(COLLECT(exemplar) AS prominent_table)
               FROM   dual) n
  FETCH    FIRST 1 ROWS ONLY;

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
  /* Declare a PL/SQL record. */
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
  /* Single-row implicit subquery. */
  SELECT   o.race, n.name, n.age
  BULK COLLECT INTO lv_tolkien_plsql_table
  FROM     TABLE(lv_tolkien_table) o CROSS JOIN
             TABLE(
               SELECT CAST(COLLECT(exemplar) AS prominent_table)
               FROM   dual) n
  FETCH    FIRST 10 ROWS ONLY;

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
  /* Declare a PL/SQL record. */
  TYPE tolkien_record IS RECORD
  ( race      VARCHAR2(10)
  , name      VARCHAR2(20)
  , age       VARCHAR2(10));

  /* Declare a table of the record. */
  TYPE tolkien_plsql_table IS TABLE OF TOLKIEN_RECORD;

  /* Declare record and table collection variables. */
  lv_tolkien_record       TOLKIEN_RECORD;
  lv_tolkien_plsql_table  TOLKIEN_PLSQL_TABLE := tolkien_plsql_table();

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
  /* Loop through transferring elements one-by-one. */
  FOR i IN 1..lv_tolkien_table.COUNT LOOP
    lv_tolkien_plsql_table.EXTEND;
    lv_tolkien_plsql_table(i) := lv_tolkien_table(i);
  END LOOP;

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
  /* Declare a PL/SQL record. */
  TYPE tolkien_record IS RECORD
  ( race      VARCHAR2(10)
  , name      VARCHAR2(20)
  , age       VARCHAR2(10));

  /* Declare a table of the record. */
  TYPE tolkien_plsql_table IS TABLE OF TOLKIEN_RECORD;

  /* Declare record and table collection variables. */
  lv_tolkien_record       TOLKIEN_RECORD;
  lv_tolkien_plsql_table  TOLKIEN_PLSQL_TABLE := tolkien_plsql_table();

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
  /* Loop through transferring elements one-by-one. */
  FOR i IN 1..lv_tolkien_table.COUNT LOOP
    lv_tolkien_plsql_table.EXTEND;
    lv_tolkien_plsql_table(i).race := lv_tolkien_table(i).race;
    lv_tolkien_plsql_table(i).name := lv_tolkien_table(i).exemplar.name;
    lv_tolkien_plsql_table(i).age := lv_tolkien_table(i).exemplar.age;
  END LOOP;

  /* Loop through the result set and print the results. */
  FOR i IN 1..lv_tolkien_plsql_table.COUNT LOOP
    dbms_output.put_line(
      '['||lv_tolkien_plsql_table(i).race||'] '||
      '['||lv_tolkien_plsql_table(i).name||'] '||
      '['||lv_tolkien_plsql_table(i).age ||']');
  END LOOP;
END;
/