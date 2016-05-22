/* ================================================================
||   Program Name: asymmetric_composites.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 6
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates associative arrays.
|| ================================================================*/

DROP TYPE people_table FORCE;
DROP TYPE people_object FORCE;
DROP TYPE prominent_object FORCE;
DROP TYPE prominent_table FORCE;

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

COLUMN EXEMPLAR FORMAT A40
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
