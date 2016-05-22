-- create_store.sql
-- Introcution, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- This demonstrates building a DVD, Game Cartridge and VHS tape store.
-- It also highlights constraints and compound check constraints and
-- seeds the tables with data.


SPOOL create_store.log

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'SYSTEM_USER') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE system_user CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'SYSTEM_USER_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE system_user_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE system_user
( system_user_id              NUMBER        CONSTRAINT pk_system_user   PRIMARY KEY
, system_user_name            VARCHAR2(20)  CONSTRAINT nn_system_user_1 NOT NULL
, system_user_group_id        NUMBER        CONSTRAINT nn_system_user_2 NOT NULL
, system_user_type            NUMBER        CONSTRAINT nn_system_user_3 NOT NULL
, last_name                   VARCHAR2(20)
, first_name                  VARCHAR2(20)
, middle_initial              VARCHAR2(1)
, created_by                  NUMBER        CONSTRAINT nn_system_user_4 NOT NULL
, creation_date               DATE          CONSTRAINT nn_system_user_5 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_system_user_6 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_system_user_7 NOT NULL);

CREATE SEQUENCE system_user_s1 START WITH 1001;

INSERT INTO system_user
VALUES ( 1,'SYSADMIN',1,1,1,NULL,NULL,1,SYSDATE,1,SYSDATE);

ALTER TABLE system_user ADD CONSTRAINT fk_system_user_1 FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id);

ALTER TABLE system_user ADD CONSTRAINT fk_system_user_2 FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id);

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'COMMON_LOOKUP') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE common_lookup CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'COMMON_LOOKUP_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE common_lookup_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE common_lookup
( common_lookup_id            NUMBER        CONSTRAINT pk_common_lookup   PRIMARY KEY
, common_lookup_table         VARCHAR2(30)  CONSTRAINT nn_common_lookup_1 NOT NULL
, common_lookup_column        VARCHAR2(30)  CONSTRAINT nn_common_lookup_2 NOT NULL
, common_lookup_type          VARCHAR2(30)  CONSTRAINT nn_common_lookup_3 NOT NULL
, common_lookup_code          VARCHAR2(8)
, common_lookup_meaning       VARCHAR2(255) CONSTRAINT nn_common_lookup_4 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_common_lookup_5 NOT NULL
, creation_date               DATE          CONSTRAINT nn_common_lookup_6 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_common_lookup_7 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_common_lookup_8 NOT NULL
, CONSTRAINT fk_common_lookup_1             FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_common_lookup_2             FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE INDEX common_lookup_n1
  ON common_lookup(common_lookup_table);

CREATE UNIQUE INDEX common_lookup_u2
  ON common_lookup(common_lookup_table,common_lookup_column,common_lookup_type);

CREATE SEQUENCE common_lookup_s1 START WITH 1001;

-- ------------------------------------------------------------------
--   Insert Common Lookups.
-- ------------------------------------------------------------------
SELECT 'INSERT COMMON_LOOKUP' AS "Section Header" FROM dual;

INSERT INTO common_lookup VALUES
( 1,'SYSTEM_USER','SYSTEM_USER_TYPE','SYSTEM_ADMIN',NULL,'System Administrator'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'SYSTEM_USER','SYSTEM_USER_TYPE','DBA',NULL,'Database Administrator'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'CONTACT','CONTACT_TYPE','EMPLOYEE',NULL,'Employee'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'CONTACT','CONTACT_TYPE','CUSTOMER',NULL,'Customer'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'MEMBER','MEMBER_TYPE','INDIVIDUAL',NULL,'Individual Membership'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'MEMBER','MEMBER_TYPE','GROUP',NULL,'Group Membership'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'MEMBER','CREDIT_CARD_TYPE','DISCOVER_CARD',NULL,'Discover Card'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'MEMBER','CREDIT_CARD_TYPE','MASTER_CARD',NULL,'Master Card'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'MEMBER','CREDIT_CARD_TYPE','VISA_CARD',NULL,'VISA Card'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ADDRESS','ADDRESS_TYPE','HOME',NULL,'Home'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ADDRESS','ADDRESS_TYPE','WORK',NULL,'Work'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'TELEPHONE','TELEPHONE_TYPE','HOME',NULL,'Home'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'TELEPHONE','TELEPHONE_TYPE','WORK',NULL,'Work'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','DVD_FULL_SCREEN',NULL,'DVD: Full Screen'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','DVD_WIDE_SCREEN',NULL,'DVD: Wide Screen'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','GAMECUBE',NULL,'Nintendo GameCube'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','PLAYSTATION2',NULL,'PlayStation2'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','XBOX',NULL,'XBOX'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','VHS_SINGLE_TAPE',NULL,'VHS: Single Tape'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_TYPE','VHS_DOUBLE_TAPE',NULL,'VHS: Double Tape'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING_AGENCY','MPAA','MPAA','Motion Picture Association of America'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING_AGENCY','ESRB','ESRB','Entertainment Software Rating Board'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA G','G','G - General Audiences: All ages admitted.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA PG','PG','PG - Parental guidance suggested: Some material may not be suitable for children.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA PG-13','PG-13','PG-13 - Parents strongly cautioned: Some material may be inappropriate for children under 13.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA R','R','R - Restricted: Under 17 requires accompanying parent or adult guardian.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA NC-17','NC-17','NC-17 - No one 17 and under admitted.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','MPAA NR','NR','NR - Not Rated.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB EC','ED','EC - Early Childhood: Contains content that may be suitable for ages 3 and older. Contains no material that parents would find inappropriate.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB E','E','E - Everyone: Contains content that may be suitable for ages 6 and older. Titles in this category may contain minimal cartoon, fantasy or mild violence and/or infrequent use of mild language.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB E10+','E10+','E10+ - Everyone 10+: Contains content that may be suitable for ages 10 and older. Titles in this category may contain more cartoon, fantasy or mild violence, mild language, minimal and/or infrequent blood and/or minimal suggestive themes.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB T','T','T - Teen: Contains content that may be suitable for ages 13 and older. Titles in this category may contain violence, suggestive themes, crude humor, minimal blood, simulated gambling, and/or infrequent use of strong language.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB M','M','M - Mature: Contains content that may be suitable for ages 17 and older. Titles in this category may contain intense violence, blood and gore, sexual content and/or strong language.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB AO','AO','AO - Adult Only: Contains content that is suitable only for adults. Titles in this category may include prolonged scenes of intense violence and/or graphic sexual content and nudity.'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval,'ITEM','ITEM_RATING','ESRB RP','RP','RP - Rating Pending: Product has been submitted to the ESRB and is awaiting final rating (prior to product release).'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'TRANSACTION_TYPE', 'DEBIT', 'DB', 'Debit', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'TRANSACTION_TYPE', 'CREDIT', 'CR', 'Credit', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', 'DISCOVER_CARD', '', 'Discover Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', 'VISA_CARD', '', 'Visa Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', 'MASTER_CARD', '', 'Master Card', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'TRANSACTION', 'PAYMENT_METHOD_TYPE', 'CASH', '', 'Cash', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', '1-DAY RENTAL', '', '1-Day Rental', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', '3-DAY RENTAL', '', '3-Day Rental', 1, SYSDATE, 1, SYSDATE);

INSERT INTO COMMON_LOOKUP VALUES
( common_lookup_s1.nextval, 'RENTAL_ITEM', 'RENTAL_ITEM_TYPE', '5-DAY RENTAL', '', '5-Day Rental', 1, SYSDATE, 1, SYSDATE);

-- Format and query output.
COLUMN common_lookup_id     FORMAT 9999 HEADING "Lookup|ID #"
COLUMN common_lookup_table  FORMAT A18  HEADING "Lookup|Table"
COLUMN common_lookup_column FORMAT A20  HEADING "Lookup|Column"
COLUMN common_lookup_type   FORMAT A18  HEADING "Lookup|Type"
COLUMN common_lookup_code   FORMAT A8   HEADING "Lookup|Code"

SELECT common_lookup_id
,      common_lookup_table
,      common_lookup_column
,      common_lookup_type
,      common_lookup_code
FROM   common_lookup;

ALTER TABLE system_user ADD CONSTRAINT fk_system_user_3 FOREIGN KEY(system_user_type)
  REFERENCES common_lookup(common_lookup_id);

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'MEMBER') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE member CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'MEMBER_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE member_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create MEMBER table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE member
( member_id                   NUMBER        CONSTRAINT pk_member   PRIMARY KEY
, member_type                 NUMBER        CONSTRAINT nn_member_1 NOT NULL
, account_number              VARCHAR2(10)  CONSTRAINT nn_member_2 NOT NULL
, credit_card_number          VARCHAR2(19)  CONSTRAINT nn_member_3 NOT NULL
, credit_card_type            NUMBER        CONSTRAINT nn_member_4 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_member_5 NOT NULL
, creation_date               DATE          CONSTRAINT nn_member_6 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_member_7 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_member_8 NOT NULL
, CONSTRAINT fk_member_1                    FOREIGN KEY(member_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_member_2                    FOREIGN KEY(credit_card_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_member_3                    FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_member_4                    FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE member_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE contact CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'CONTACT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE contact_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create CONTACT table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE contact
( contact_id                  NUMBER        CONSTRAINT pk_contact   PRIMARY KEY
, member_id                   NUMBER        CONSTRAINT nn_contact_1 NOT NULL
, contact_type                NUMBER        CONSTRAINT nn_contact_2 NOT NULL
, last_name                   VARCHAR2(20)  CONSTRAINT nn_contact_3 NOT NULL
, first_name                  VARCHAR2(20)  CONSTRAINT nn_contact_4 NOT NULL
, middle_name                 VARCHAR2(20)
, created_by                  NUMBER        CONSTRAINT nn_contact_5 NOT NULL
, creation_date               DATE          CONSTRAINT nn_contact_6 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_contact_7 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_contact_8 NOT NULL
, CONSTRAINT fk_contact_1                   FOREIGN KEY(member_id)
  REFERENCES member(member_id)
, CONSTRAINT fk_contact_2                   FOREIGN KEY(contact_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_contact_3                   FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_contact_4                   FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE INDEX contact_n1 ON contact(member_id);

CREATE SEQUENCE contact_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ADDRESS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE address CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ADDRESS_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE address_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create ADDRESS table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE address
( address_id                  NUMBER        CONSTRAINT pk_address   PRIMARY KEY
, contact_id                  NUMBER        CONSTRAINT nn_address_1 NOT NULL
, address_type                NUMBER        CONSTRAINT nn_address_2 NOT NULL
, city                        VARCHAR2(30)  CONSTRAINT nn_address_3 NOT NULL
, state_province              VARCHAR2(30)  CONSTRAINT nn_address_4 NOT NULL
, postal_code                 VARCHAR2(20)  CONSTRAINT nn_address_5 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_address_6 NOT NULL
, creation_date               DATE          CONSTRAINT nn_address_7 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_address_8 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_address_9 NOT NULL
, CONSTRAINT fk_address_1                   FOREIGN KEY(contact_id)
  REFERENCES contact(contact_id)
, CONSTRAINT fk_address_2                   FOREIGN KEY(address_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_address_3                   FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_address_4                   FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE INDEX address_n1 ON address(contact_id);

CREATE SEQUENCE address_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'STREET_ADDRESS') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE street_address CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'STREET_ADDRESS_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE street_address_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create STREET_ADDRESS table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE street_address
( street_address_id           NUMBER        CONSTRAINT pk_st_address   PRIMARY KEY
, address_id                  NUMBER        CONSTRAINT nn_st_address_1 NOT NULL
, line_number                 NUMBER        CONSTRAINT nn_st_address_2 NOT NULL
, street_address              VARCHAR2(30)  CONSTRAINT nn_st_address_3 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_st_address_4 NOT NULL
, creation_date               DATE          CONSTRAINT nn_st_address_5 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_st_address_6 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_st_address_7 NOT NULL
, CONSTRAINT fk_st_address_1                FOREIGN KEY(address_id)
  REFERENCES address(address_id)
, CONSTRAINT fk_st_address_2                FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_st_address_3                FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE street_address_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'TELEPHONE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE telephone CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'TELEPHONE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE telephone_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create TELEPHONE table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE telephone
( telephone_id                NUMBER        CONSTRAINT pk_telephone    PRIMARY KEY
, contact_id                  NUMBER        CONSTRAINT nn_telephone_1  NOT NULL
, address_id                  NUMBER        CONSTRAINT nn_telephone_2  NOT NULL
, telephone_type              NUMBER        CONSTRAINT nn_telephone_3  NOT NULL
, country_code                VARCHAR2(3)   CONSTRAINT nn_telephone_4  NOT NULL
, area_code                   VARCHAR2(6)   CONSTRAINT nn_telephone_5  NOT NULL
, telephone_number            VARCHAR2(10)  CONSTRAINT nn_telephone_6  NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_telephone_7  NOT NULL
, creation_date               DATE          CONSTRAINT nn_telephone_8  NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_telephone_9  NOT NULL
, last_update_date            DATE          CONSTRAINT nn_telephone_10 NOT NULL
, CONSTRAINT fk_telephone_1                 FOREIGN KEY(contact_id)
  REFERENCES contact(contact_id)
, CONSTRAINT fk_telephone_2                 FOREIGN KEY(telephone_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_telephone_3                 FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_telephone_4                 FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE INDEX telephone_n1 ON telephone(contact_id,address_id);

CREATE INDEX telephone_n2 ON telephone(address_id);

CREATE SEQUENCE telephone_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'RENTAL') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'RENTAL_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create RENTAL table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE rental
( rental_id                   NUMBER        CONSTRAINT pk_rental   PRIMARY KEY
, customer_id                 NUMBER        CONSTRAINT nn_rental_1 NOT NULL
, check_out_date              DATE          CONSTRAINT nn_rental_2 NOT NULL
, return_date                 DATE          CONSTRAINT nn_rental_3 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_rental_4 NOT NULL
, creation_date               DATE          CONSTRAINT nn_rental_5 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_rental_6 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_rental_7 NOT NULL
, CONSTRAINT fk_rental_1                    FOREIGN KEY(customer_id)
  REFERENCES contact(contact_id)
, CONSTRAINT fk_rental_2                    FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_rental_3                    FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE rental_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'ITEM') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE item CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'ITEM_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE item_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create ITEM table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE item
( item_id                     NUMBER        CONSTRAINT pk_item    PRIMARY KEY
, item_barcode                VARCHAR2(20)  CONSTRAINT nn_item_1  NOT NULL
, item_type                   NUMBER        CONSTRAINT nn_item_2  NOT NULL
, item_title                  VARCHAR2(60)  CONSTRAINT nn_item_3  NOT NULL
, item_subtitle               VARCHAR2(60) 
, item_desc                   CLOB          CONSTRAINT nn_item_4  NOT NULL
, item_photo                  BFILE
, item_rating                 VARCHAR2(8)   CONSTRAINT nn_item_5  NOT NULL
, item_rating_agency          VARCHAR2(4)   CONSTRAINT nn_item_6  NOT NULL
, item_release_date           DATE          CONSTRAINT nn_item_7  NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_item_8  NOT NULL
, creation_date               DATE          CONSTRAINT nn_item_9  NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_item_10 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_item_11 NOT NULL
, CONSTRAINT fk_item_1                      FOREIGN KEY(item_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_item_2                      FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_item_3                      FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE item_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Create ITEM table triggers for content reference column.
-- ------------------------------------------------------------------

-- Check for valid rating in COMMON_LOOKUP table.
CREATE OR REPLACE TRIGGER item_t1 
  BEFORE INSERT OR UPDATE OF item_rating ON item
  FOR EACH ROW
  
DECLARE

  -- Declare guard variable.
  found BOOLEAN := FALSE;
  
  -- Declare dynamic cursor.
  CURSOR get_ratings
  ( code VARCHAR2 ) IS
    SELECT   common_lookup_code
    FROM     common_lookup
    WHERE    common_lookup_table = 'ITEM'
    AND      common_lookup_column = 'ITEM_RATING'
    AND      common_lookup_code = code;
  
    -- Define and set user-defined error.
    bad_rating EXCEPTION;
    PRAGMA EXCEPTION_INIT(bad_rating,-20101);

BEGIN

  -- Check for valid rating.  
  FOR i IN get_ratings(:new.item_rating) LOOP
    found := TRUE;
  END LOOP;

  -- Raise exception for invalid rating.  
  IF NOT found THEN
    RAISE_APPLICATION_ERROR(-20101,'Rating Value not defined in COMMON_LOOKUP table.');
  END IF;
  
END item_t1;
/

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'RENTAL_ITEM') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_item CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'RENTAL_ITEM_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_item_s1';
  END LOOP;
END;
/

-- Check for valid rating agency in COMMON_LOOKUP table.
CREATE OR REPLACE TRIGGER item_t1 
  BEFORE INSERT OR UPDATE OF item_rating_agency ON item
  FOR EACH ROW
  
DECLARE

  -- Declare guard variable.
  found BOOLEAN := FALSE;
  
  -- Declare dynamic cursor.
  CURSOR get_ratings
  ( agency VARCHAR2 ) IS
    SELECT   common_lookup_code
    FROM     common_lookup
    WHERE    common_lookup_table = 'ITEM'
    AND      common_lookup_column = 'ITEM_RATING_AGENCY'
    AND      common_lookup_code = agency;
  
    -- Define and set user-defined error.
    bad_rating EXCEPTION;
    PRAGMA EXCEPTION_INIT(bad_rating,-20102);

BEGIN

  -- Check for valid rating.  
  FOR i IN get_ratings(:new.item_rating_agency) LOOP
    found := TRUE;
  END LOOP;

  -- Raise exception for invalid rating.  
  IF NOT found THEN
    RAISE_APPLICATION_ERROR(-20102,'Rating Agency Value not defined in COMMON_LOOKUP table.');
  END IF;
  
END item_t1;
/

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'RENTAL_ITEM') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_item CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'RENTAL_ITEM_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_item_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create RENTAL_ITEM table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE rental_item
( rental_item_id              NUMBER        CONSTRAINT pk_rental_item   PRIMARY KEY
, rental_id                   NUMBER        CONSTRAINT nn_rental_item_1 NOT NULL
, item_id                     NUMBER        CONSTRAINT nn_rental_item_2 NOT NULL
, rental_item_price           NUMBER        CONSTRAINT nn_rental_item_3 NOT NULL
, rental_item_type            NUMBER        CONSTRAINT nn_rental_item_4 NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_rental_item_5 NOT NULL
, creation_date               DATE          CONSTRAINT nn_rental_item_6 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_rental_item_7 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_rental_item_8 NOT NULL
, CONSTRAINT fk_rental_item_1               FOREIGN KEY(rental_id)
  REFERENCES rental(rental_id)
, CONSTRAINT fk_rental_item_2               FOREIGN KEY(item_id)
  REFERENCES item(item_id)
, CONSTRAINT fk_rental_item_3               FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_rental_item_4               FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE rental_item_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create PRICE table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE price
( price_id                    NUMBER        CONSTRAINT pk_price   PRIMARY KEY
, item_id                     NUMBER        CONSTRAINT nn_price_1 NOT NULL
, price_type                  NUMBER        CONSTRAINT nn_price_2 NOT NULL
, active_flag                 VARCHAR2(1)   CONSTRAINT nn_price_3 NOT NULL
, amount                      NUMBER        CONSTRAINT nn_price_4 NOT NULL
, start_date                  DATE          CONSTRAINT nn_price_5 NOT NULL
, end_date                    DATE
, created_by                  NUMBER        CONSTRAINT nn_price_6 NOT NULL
, creation_date               DATE          CONSTRAINT nn_price_7 NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_price_8 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_price_9 NOT NULL
, CONSTRAINT fk_price_1                     FOREIGN KEY(item_id)
  REFERENCES item(item_id)
, CONSTRAINT fk_price_2                     FOREIGN KEY(price_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3                     FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4                     FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE price_s1 START WITH 1001;

-- ------------------------------------------------------------------
-- Seed PRICE data in COMMON_LOOKUP table.
-- ------------------------------------------------------------------

INSERT INTO common_lookup
VALUES
( common_lookup_s1.nextval,'PRICE','ACTIVE_FLAG','YES','Y','Yes'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup
VALUES
( common_lookup_s1.nextval,'PRICE','ACTIVE_FLAG','NO','N','Yes'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO common_lookup
( common_lookup_id                                           --  1
, common_lookup_table                                        --  2
, common_lookup_column                                       --  3
, common_lookup_type                                         --  4
, common_lookup_code                                         --  5
, common_lookup_meaning                                      --  6
, created_by                                                 --  7
, creation_date                                              --  8
, last_updated_by                                            --  9
, last_update_date)                                          -- 10
  SELECT   common_lookup_s1.nextval                          --  1 (id)
  ,        'PRICE'                                           --  2 (table)
  ,        'AMOUNT'                                          --  3 (column)
  ,        il.type                                           --  4 (type)
  ,        TO_CHAR(il.fabricated)                            --  5 (code)
  ,        il.meaning                                        --  6 (meaning)
  ,        1                                                 --  7 (c_id)
  ,        SYSDATE                                           --  8 (c_date)
  ,        1                                                 --  9 (u_id)
  ,        SYSDATE                                           -- 10 (u_date)
  FROM     dual CROSS JOIN (SELECT  'New' AS status
                            ,        1 AS fabricated
                            ,       '1-DAY RENTAL' type
                            ,       '1-Day Rental' meaning FROM dual
                            UNION ALL
                            SELECT  'New' AS type
                            ,        3 AS fabricated
                            ,       '3-DAY RENTAL' type
                            ,       '3-Day Rental' meaning FROM dual
                            UNION ALL
                            SELECT  'New' AS type
                            ,        5 AS fabricated 
                            ,       '5-DAY RENTAL' type
                            ,       '5-Day Rental' meaning FROM dual) il;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'TRANSACTION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'TRANSACTION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create TRANSACTION table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE transaction
( transaction_id              NUMBER        CONSTRAINT pk_transaction    PRIMARY KEY
, transaction_account         VARCHAR2(20)  CONSTRAINT nn_transaction_1  NOT NULL
, transaction_type            NUMBER        CONSTRAINT nn_transaction_2  NOT NULL
, transaction_date            DATE          CONSTRAINT nn_transaction_3  NOT NULL
, transaction_amount          NUMBER        CONSTRAINT nn_transaction_4  NOT NULL
, rental_id                   NUMBER        CONSTRAINT nn_transaction_5  NOT NULL
, payment_method              NUMBER        CONSTRAINT nn_transaction_6  NOT NULL
, payment_account_number      VARCHAR2(20)  CONSTRAINT nn_transaction_7  NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_transaction_8  NOT NULL
, creation_date               DATE          CONSTRAINT nn_transaction_9  NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_transaction_10 NOT NULL
, last_update_date            DATE          CONSTRAINT nn_transaction_11 NOT NULL
, CONSTRAINT fk_transaction_1               FOREIGN KEY(rental_id)
  REFERENCES rental(rental_id)
, CONSTRAINT fk_transaction_2               FOREIGN KEY(transaction_type)
  REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_3               FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_transaction_4               FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE transaction_s1 START WITH 1001;

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_tables
            WHERE  table_name = 'CALENDAR') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE calendar CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null
            FROM   user_sequences
            WHERE  sequence_name = 'CALENDAR_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE calendar_s1';
  END LOOP;
END;
/

-- ------------------------------------------------------------------
-- Create CALENDAR table and sequence and seed data.
-- ------------------------------------------------------------------

CREATE TABLE calendar
( calendar_id                 NUMBER        CONSTRAINT pk_calendar    PRIMARY KEY
, calendar_month_name         VARCHAR2(3)   CONSTRAINT nn_calendar_1  NOT NULL
, calendar_full_month_name    VARCHAR2(9)   CONSTRAINT nn_calendar_2  NOT NULL
, start_date                  DATE          CONSTRAINT nn_calendar_3  NOT NULL
, end_date                    DATE          CONSTRAINT nn_calendar_4  NOT NULL
, created_by                  NUMBER        CONSTRAINT nn_calendar_5  NOT NULL
, creation_date               DATE          CONSTRAINT nn_calendar_6  NOT NULL
, last_updated_by             NUMBER        CONSTRAINT nn_calendar_7  NOT NULL
, last_update_date            DATE          CONSTRAINT nn_calendar_8  NOT NULL
, CONSTRAINT fk_calendar_1                  FOREIGN KEY(created_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_calendar_2                  FOREIGN KEY(last_updated_by)
  REFERENCES system_user(system_user_id));

CREATE SEQUENCE calendar_s1 START WITH 1001;

-- Seed the Calendar table.
DECLARE

  -- Define local variables.
  start_date  DATE;
  end_date    DATE;

  -- Define local array types.
  TYPE number_list IS TABLE OF NUMBER;
  TYPE month_list  IS TABLE OF VARCHAR2(3);  
  TYPE name_list   IS TABLE OF VARCHAR2(9);  

  -- Define and initialize array for month ending date.
  end_day     NUMBER_LIST := number_list(31,28,31
                                        ,30,31,30
                                        ,31,31,30
                                        ,31,30,31);
  
  -- Define and initial short and long month names.
  months      MONTH_LIST := month_list('JAN','FEB','MAR'
                                      ,'APR','MAY','JUN'
                                      ,'JUL','AUG','SEP'
                                      ,'OCT','NOV','DEC');
  month_names NAME_LIST := name_list('January','February','March'
                                    ,'April','May','June'
                                    ,'July','August','September'
                                    ,'October','November','December');

  -- Define and initialize years.
  years       NUMBER_LIST := number_list(1996,1997,1998,1999,2000
                                        ,2001,2002,2003,2004,2005
                                        ,2006,2007,2008,2009,2010
                                        ,2011,2012,2013,2014,2015
                                        ,2016,2017,2018,2019,2020);

BEGIN

  -- Loop through years and then months.
  FOR i IN 1..years.COUNT LOOP

    FOR j IN 1..months.COUNT LOOP

      -- Set month starting date.
      start_date := TO_DATE('01'||months(j)||years(i),'DD-MON-YYYY');

      -- Check, modify leap year February, and set month ending date.
      IF ((MOD(years(i) , 4) = 0) AND (j = 2)) THEN
        end_date := TO_DATE((end_day(j) + 1)||'-'||months(j)||'-'||years(i),'DD-MON-YYYY');
      ELSE
        end_date := TO_DATE((end_day(j))||'-'||months(j)||'-'||years(i),'DD-MON-YYYY');
      END IF;

      -- Insert month into calendar.
      INSERT INTO calendar
      VALUES
      ( calendar_s1.nextval
      , months(j)
      , month_names(j)
      , start_date
      , end_date
      , 1,SYSDATE,1,SYSDATE);

    END LOOP;  

  END LOOP;
  
END;
/

/*
-- ------------------------------------------------------------------
--  Insert DBA values in SYSTEM_USER table.
-- ------------------------------------------------------------------ */
SELECT 'INSERT DBAs IN SYSTEM_USER' AS "Section Header" FROM dual;

INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 2,'DBA', 2, 1,'Adams','Samuel', 1, SYSDATE, 1, SYSDATE);

INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 3,'DBA', 2, 1,'Henry','Patrick', 1, SYSDATE, 1, SYSDATE);

INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 4,'DBA', 2, 1,'Puri','Manmohan', 1, SYSDATE, 1, SYSDATE);

INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 5,'DBA', 2, 1,'Fullerton','Gail', 1, SYSDATE, 1, SYSDATE);

-- ------------------------------------------------------------------
-- This seeds rows in a dependency chain, including the MEMBER, CONTACT
-- ADDRESS, and TELEPHONE tables.
-- ------------------------------------------------------------------
-- Insert record set #1.
-- ------------------------------------------------------------------
SELECT 'INSERT MEMBER, CONTACT, ADDRESS, ETC' AS "Section Header" FROM dual;

INSERT INTO member VALUES
( member_s1.nextval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'MEMBER_TYPE'
  AND      common_lookup_type = 'GROUP')
,'B293-71445'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'CREDIT_CARD_TYPE'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Randi','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Brian','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #2.
-- ------------------------------------------------------------------
INSERT INTO member VALUES
( member_s1.nextval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'MEMBER_TYPE'
  AND      common_lookup_type = 'GROUP')
,'B293-71446'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'CREDIT_CARD_TYPE'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact 
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Oscar','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact 
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Doreen','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #3.
-- ------------------------------------------------------------------

INSERT INTO member VALUES
( member_s1.nextval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'MEMBER_TYPE'
  AND      common_lookup_type = 'GROUP')
,'B293-71447'
,'3333-4444-5555-6666'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'MEMBER'
  AND      common_lookup_column = 'CREDIT_CARD_TYPE'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact 
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Meaghan','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact 
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Matthew','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact 
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'CONTACT'
  AND      common_lookup_column = 'CONTACT_TYPE'
  AND      common_lookup_type = 'CUSTOMER')
,'Ian','M','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'ADDRESS'
  AND      common_lookup_column = 'ADDRESS_TYPE'
  AND      common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
, 1
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'TELEPHONE'
  AND      common_lookup_column = 'TELEPHONE_TYPE'
  AND      common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

/*
-- ------------------------------------------------------------------
-- Insert values in ITEM table.
-- ------------------------------------------------------------------ */
SELECT 'INSERT ITEM' AS "Section Header" FROM dual;

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0001US8F8'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Around the World in 80 Days'
,'Two-Disc Special Edition'
, empty_clob()
, NULL
,'NR'
,'MPAA'
,'18-MAY-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002S64TQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Around the World in 80 Days'
,''
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'02-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000MNP2KI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Casino Royale'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'13-MAR-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000MNP2K8'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Casino Royale'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'13-MAR-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JLBE'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Die Another Day'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'03-JUN-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000LY9CMC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Die Another Day'
,'2-Disc Ultimate Version'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'03-JUN-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008S2SF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Die Another Day'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'03-JUN-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00000K0E5'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Golden Eye'
,'Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'22-OCT-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000M53GM2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Golden Eye'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'06-FEB-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6304916558'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tomorrow Never Dies'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'13-MAY-1998'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00000K0EA'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tomorrow Never Dies'
,'Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'22-OCT-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6305784922'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The World Is Not Enough'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'16-MAY-2000'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000NIBURQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The World Is Not Enough'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'22-MAY-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00003CX95'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Brave Heart'
,''
, empty_clob()
, NULL
,'R'
,'MPAA'
,'29-AUG-2000'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6304712944'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Camelot'
,''
, empty_clob()
, NULL
,'G'
,'MPAA'
,'29-JUL-1998'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000B5XOZ2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Christmas Carol'
,''
, empty_clob()
, NULL
,'NR'
,'MPAA'
,'08-NOV-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00000K3CJ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Christmas Carol'
,''
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'05-OCT-1999'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0000AQS5D'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Scrooge'
,''
, empty_clob()
, NULL
,'G'
,'MPAA'
,'23-SEP-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6305127719'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Clear and Present Danger'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'21-OCT-1998'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008K76V'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Clear and Present Danger'
,'Special Collector''s Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'06-MAY-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00003CXI1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Sorcer''s Stone'
,'Two-Disc Special Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'28-MAY-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000062TU1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Sorcer''s Stone'
,'Full Screen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'28-MAY-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008DDXC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Chamber of Secrets'
,'Two-Disc Special Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'11-APR-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008DDXL'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Chamber of Secrets'
,'Full Screen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'11-APR-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JMAH'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Prisoner of Azkaban'
,'Two-Disc Special Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'23-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002TT0NW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Prisoner of Azkaban'
,'2-Disc Full Screen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'23-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002VB24K'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Chamber of Secrets'
,''
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'23-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000E6EK2Y'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Goblet of Fire'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'07-MAR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000E6EK38'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Goblet of Fire'
,'Full Screen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'07-MAR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000E6EK3S'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Goblet of Fire'
,'Two-Disc Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'07-MAR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000E6EZ3Z'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Order of the Phoenix'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'11-DEC-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6305182043'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October'
,''
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'01-DEC-1998'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008K76U'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October'
,'Special Collector''s Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'06-MAY-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002YLCG0'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'King Arthur - The Director''s Cut'
,'Wide Screen Edition'
, empty_clob()
, NULL
,'R'
,'MPAA'
,'21-DEC-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002YLCFQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'King Arthur'
,'PG-13 Full Screen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'21-DEC-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002YLCG0'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'King Arthur - The Director''s Cut'
,'Wide Screen Edition'
, empty_clob()
, NULL
,'R'
,'MPAA'
,'21-DEC-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00003CWT6'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - Fellowship of the Ring'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'06-AUG-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000065U3Q'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'The Lord of the Rings - Fellowship of the Ring'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'06-AUG-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000067DNF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - Fellowship of the Ring'
,'Platinum Series Special Extended Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'12-NOV-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JKZV'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - Two Towers'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'26-AUG-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00009APK1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'The Lord of the Rings - Two Towers'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'26-AUG-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00009TB5G'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - Two Towers'
,'Platinum Series Special Extended Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'18-NOV-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JKZY'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - The Return of the King'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'25-MAY-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0001US8E4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'The Lord of the Rings - The Return of the King'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'25-MAY-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000634DCW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Lord of the Rings - The Return of the King'
,'Platinum Series Special Extended Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'14-DEC-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: 6305222878'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Patriot Games'
,''
, empty_clob()
, NULL
,'R'
,'MPAA'
,'15-DEC-1998'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008K76W'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Patriot Games'
,'Special Collector''s Edition'
, empty_clob()
, NULL
,'R'
,'MPAA'
,'06-MAY-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JM5E'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - The Curse of the Black Pearl'
,'Two-Disc Collector''s Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'02-DEC-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002XL342'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - The Curse of the Black Pearl'
,'Three-Disc Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'02-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0000C6DWS'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Pirates of the Caribbean - The Curse of the Black Pearl'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'02-DEC-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000I0RQVI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - Dead Man''s Chest'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'05-DEC-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JP0F'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - Dead Man''s Chest'
,'Two-Disc Collector''s Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'05-DEC-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0R0I0RDEI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - At World''s End'
,''
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'05-DEC-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0R0I0RRES'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Pirates of the Caribbean - At World''s End'
,'Two-Disc Collector''s Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'05-DEC-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00009Q98M'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Indiana Jones and the Raiders of the Lost Ark'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000F21K66'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Indiana Jones and the Raiders of the Lost Ark'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000F7OMZ2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Indiana Jones and the Temple of Doom'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000F7OMZ3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Indiana Jones and the Temple of Doom'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000F7OPCC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Indiana Jones and the Last Crusade'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000F7OPCR'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Indiana Jones and the Last Crusade'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'20-FEB-2003'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JKCH'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Spider-Man'
,'Widescreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'01-NOV-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00006F2TV'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Spider-Man'
,'Fullscreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'01-NOV-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JMQW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Spider-Man 2'
,'Widescreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'30-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0002XK186'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Spider-Man 2'
,'Fullscreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'30-NOV-2004'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: C00005JMQW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Spider-Man 3'
,'Widescreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'30-NOV-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: CB0002XK186'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Spider-Man 3'
,'Fullscreen Special Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'30-NOV-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00003CX5P'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode I'
,'The Phantom Menace'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'22-MAR-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00006HBUJ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode II'
,'Attack of the Clones'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'22-MAR-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00006HBUI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars - Episode II'
,'Attack of the Clones'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'22-MAR-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JLXH'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode III'
,'Revenge of the Sith'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'01-NOV-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00006HBUI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars - Episode III'
,'Revenge of the Sith'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'01-NOV-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0006VIE4C'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode IV'
,'A New Hope'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0236VIE4D'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars - Episode IV'
,'A New Hope'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0006VIXGQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode V'
,'The Empire Strikes Back'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0026VJLGD'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars - Episode V'
,'The Empire Strikes Back'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00076SCPW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars - Episode VI'
,'Return of the Jedi'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00276LJKZ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars - Episode VI'
,'Return of the Jedi'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'12-AUG-2005'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JL8F'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Sum of All Fears'
,'Special Collector''s Edition'
, empty_clob()
, NULL
,'PG-13'
,'MPAA'
,'29-OCT-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00004XPPG'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Patriot'
,'Special Edition'
, empty_clob()
, NULL
,'R'
,'MPAA'
,'24-OCT-2000'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000ELL1S0'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Patriot'
,'Unrated Extended Cut'
, empty_clob()
, NULL
,'NR'
,'MPAA'
,'25-APR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000068TPN'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'We Were Soldiers'
,''
, empty_clob()
, NULL
,'R'
,'MPAA'
,'20-AUG-2002'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000E8M0VA'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Chronicles of Narnia - The Lion, the Witch and the Wardrobe'
,'Widescreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'04-APR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00005JO1X'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Chronicles of Narnia - The Lion, the Witch and the Wardrobe'
,'Fullscreen Edition'
, empty_clob()
, NULL
,'PG'
,'MPAA'
,'04-APR-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0009EK534'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'GAMECUBE')
,'Chronicles of Narnia - The Lion, the Witch and the Wardrobe'
,''
, empty_clob()
, NULL
,'T'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0009ELZXI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Chronicles of Narnia - The Lion, the Witch and the Wardrobe'
,''
, empty_clob()
, NULL
,'T'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B0009EP9DU'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Chronicles of Narnia - The Lion, the Witch and the Wardrobe'
,''
, empty_clob()
, NULL
,'T'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000930DPU'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'GAMECUBE')
,'Harry Potter: Goblet of Fire'
,''
, empty_clob()
, NULL
,'E10+'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000930DQ4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Harry Potter: Goblet of Fire'
,''
, empty_clob()
, NULL
,'E10+'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000930DQE'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Harry Potter: Goblet of Fire'
,''
, empty_clob()
, NULL
,'E10+'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000930DPU'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'GAMECUBE')
,'Pirates of the Caribbean'
,''
, empty_clob()
, NULL
,'T'
,'ESRB'
,'15-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000FWAGNY'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Pirates of the Caribbean'
,'The Legend of Jack Sparrow'
, empty_clob()
, NULL
,'T'
,'ESRB'
,'27-JUN-2006'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B00008V6TF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean'
,''
, empty_clob()
, NULL
,'T'
,'ESRB'
,'22-MAY-2007'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'ASIN: B000MK4G1M'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean'
,'At Worlds End'
, empty_clob()
, NULL
,'T'
,'ESRB'
,'22-MAY-2007'
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Inserts 5 rentals with 9 dependent rental items.  This section inserts
-- 5 rows in the RENTAL table, then 9 rows in the RENTAL_ITEM table. The
-- inserts into the RENTAL_ITEM tables use scalar subqueries to find the
-- proper foreign key values by querying the RENTAL table primary keys. 
-- ------------------------------------------------------------------
-- Insert 5 records in the RENTAL table.
-- ------------------------------------------------------------------ 
SELECT 'INSERT RENTAL' AS "Section Header" FROM dual;

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

/*
-- ------------------------------------------------------------------
-- Insert 9 records in the RENTAL_ITEM table.
-- ------------------------------------------------------------------ */
SELECT 'INSERT RENTAL_ITEM' AS "Section Header" FROM dual;

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Star Wars - Episode I'
  AND      i.item_subtitle = 'The Phantom Menace'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r inner join contact c
  ON       r.customer_id = c.contact_id
  WHERE    c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item d join common_lookup cl
  ON       d.item_title = 'Star Wars - Episode II'
  WHERE    d.item_subtitle = 'Attack of the Clones'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Star Wars - Episode III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Tomorrow Never Dies'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Around the World in 80 Days'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Meaghan')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'The Patriot'
  AND      d.item_subtitle = 'Special Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Ian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Spider-Man'
  AND      d.item_subtitle = 'Fullscreen Special Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_FULL_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'We Were Soldiers'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'The Hunt for Red October'
  AND      d.item_subtitle = 'Special Collector''s Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 5
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_table = 'RENTAL_ITEM'
  AND      common_lookup_column = 'RENTAL_ITEM_TYPE'
  AND      common_lookup_type = '5-DAY RENTAL')
, 3, SYSDATE, 3, SYSDATE);

-- Write all prior to program units.
COMMIT;

-- ----------------------------------------------
--  Create update_price_function.
-- ----------------------------------------------
SELECT 'CREATE PRICE UPDATE FUNCTION' AS "Section Header" FROM dual;

@@update_price_function.sql

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_count INTEGER;
BEGIN
  IF update_price = 0 THEN
    SELECT COUNT(*) INTO lv_count FROM price;
    dbms_output.put_line('Inserted Prices ['||lv_count||'] records.');
  ELSE
    dbms_output.put_line('No Prices Inserted.');
  END IF;
END;
/

BEGIN
  FOR i IN (SELECT product
            FROM   product_component_version
            WHERE  REGEXP_LIKE(product,'.+11g.+')) LOOP
    dbms_output.put_line('Valid ['||i.product||'].');
  END LOOP;
END;
/

-- This creates a transactionally safe individual member insert
-- into the MEMBER, CONTACT, ADDRESS, STREET_ADDRESS, and
-- TELEPHONE tables for Oracle 11g; it won't run in Oracle 10g
-- and you should use the contact_insert_10g.sql script in the
-- create_store.sql when working on Oracle 10g XE.
@@contact_insert.sql
@@contact_insert_10g.sql

-- Insert complete contact information using stored procedure.
-- If you're running on Oracle 10g XE, switch contact_insert to contact_insert_10g as
-- a procedure call in the following statements.
EXECUTE contact_insert('INDIVIDUAL','R11-514-34','1111-1111-1111-1111','VISA_CARD','Clinton','Goeffrey','Ward','CUSTOMER','HOME','Provo','Utah','84606','118 South 9th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-35','1111-1111-1111-1111','VISA_CARD','Brandt','Henry','Ward','CUSTOMER','HOME','Provo','Utah','84606','118 South 9th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-36','1111-2222-1111-1111','VISA_CARD','Moss','Wendy','Jane','CUSTOMER','HOME','Provo','Utah','84606','1218 South 10th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-37','1111-1111-2222-1111','VISA_CARD','Gretelz','Simon','Jonah','CUSTOMER','HOME','Provo','Utah','84606','2118 South 7th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-38','1111-1111-1111-2222','MASTER_CARD','Royal','Elizabeth','Jane','CUSTOMER','HOME','Provo','Utah','84606','2228 South 14th East','HOME','011','801','423-1234');
EXECUTE contact_insert_10g('INDIVIDUAL','R11-514-39','1111-1111-3333-1111','VISA_CARD','Smith','Brian','Nathan','CUSTOMER','HOME','Spanish Fork','Utah','84606','333 North 2nd East','HOME','011','801','423-1234');

-- Place Chapter 6 Procedure in database.
@@transaction_procedure.sql

-- Update the address table.
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

-- Conditionally drop table.
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'AIRPORT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'AIRPORT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- Create table.
CREATE TABLE airport
( airport_id        NUMBER       CONSTRAINT pk_airport  PRIMARY KEY
, airport_code      VARCHAR2(3)  CONSTRAINT nn_airport1 NOT NULL
, airport_city      VARCHAR2(30) CONSTRAINT nn_airport2 NOT NULL
, city              VARCHAR2(30) CONSTRAINT nn_airport3 NOT NULL
, state_province    VARCHAR2(30) CONSTRAINT nn_airport4 NOT NULL
, created_by        NUMBER
, creation_date     DATE
, last_updated_by   NUMBER
, last_update_date  DATE
, CONSTRAINT fk_airport1 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, CONSTRAINT fk_airport2 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE airport_s1;

-- Create unique index.
CREATE INDEX airport_u1 ON airport(airport_code, airport_city, city, state_province);

-- Seed table.
INSERT INTO airport VALUES
( airport_s1.nextval, 'LAX', 'Los Angeles', 'Los Angeles', 'California', 2, SYSDATE, 2, SYSDATE);
INSERT INTO airport VALUES
( airport_s1.nextval, 'SLC', 'Salt Lake City', 'Provo', 'Utah', 2, SYSDATE, 2, SYSDATE);
INSERT INTO airport VALUES
( airport_s1.nextval, 'SLC', 'Salt Lake City','Spanish Fork', 'Utah', 2, SYSDATE, 2, SYSDATE);
INSERT INTO airport VALUES
( airport_s1.nextval, 'SFO', 'San Francisco', 'San Francisco', 'California', 2, SYSDATE, 2, SYSDATE);
INSERT INTO airport VALUES
( airport_s1.nextval, 'SJC', 'San Jose', 'San Carlos', 'California', 2, SYSDATE, 2, SYSDATE);
INSERT INTO airport VALUES
( airport_s1.nextval, 'SJC', 'San Jose', 'San Jose', 'California', 2, SYSDATE, 2, SYSDATE);

COLUMN airport_id      FORMAT 9999
COLUMN airport_code    FORMAT A3
COLUMN airport_city    FORMAT A20
COLUMN city            FORMAT A14
COLUMN state_province  FORMAT A10

-- Query table.
SELECT  airport_id
,       airport_code
,       airport_city
,       city
,       state_province
FROM airport;

-- Conditionally drop table.
BEGIN
  FOR i IN (SELECT table_name
            FROM   user_tables
            WHERE  table_name = 'ACCOUNT_LIST') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||i.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT sequence_name
            FROM   user_sequences
            WHERE  sequence_name = 'ACCOUNT_LIST_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE '||i.sequence_name;
  END LOOP;
END;
/

-- Create a account number table.
CREATE TABLE account_list
( account_list_id   NUMBER        CONSTRAINT pk_account_list  PRIMARY KEY
, account_number    VARCHAR2(10)  CONSTRAINT nn_account_list1 NOT NULL
, consumed_date     DATE    
, consumed_by       NUMBER
, created_by        NUMBER
, creation_date     DATE
, last_updated_by   NUMBER
, last_update_date  DATE
, CONSTRAINT fk_account_list1 FOREIGN KEY (consumed_by)
  REFERENCES system_user(system_user_id)
, CONSTRAINT fk_account_list2 FOREIGN KEY (created_by)
  REFERENCES system_user (system_user_id)
, CONSTRAINT fk_account_list3 FOREIGN KEY (last_updated_by)
  REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE account_list_s1;

-- Create or replace seeding procedure.
CREATE OR REPLACE PROCEDURE seed_account_list IS
BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;
 
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
 
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , NULL
      , NULL
      , 2
      , SYSDATE
      , 2
      , SYSDATE);
      
    END LOOP;
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

-- Execute seed_account_list procedure.
EXECUTE seed_account_list();

-- Create UPDATE_MEMBER_ACCOUNT procedure.
CREATE OR REPLACE PROCEDURE update_member_account IS
 
  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);
 
  /* Declare a SQL cursor fabricated from local variables. */  
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
BEGIN
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  FOR i IN member_cursor LOOP
 
      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;
 
      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;
 
      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;
 
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
    
END;
/

-- Update member accounts.
SET SERVEROUTPUT ON SIZE UNLIMITED
EXECUTE update_member_account();

-- Format column for query results.
COLUMN member_id           FORMAT 9999 HEADING "Member|ID #"
COLUMN members             FORMAT 9999 HEADING "Contact|#'s"
COLUMN last_name           FORMAT A14  HEADING "Last Name"
COLUMN member_type         FORMAT 9999 HEADING "Member|Type"
COLUMN common_lookup_id    FORMAT 9999 HEADING "Lookup|ID #"
COLUMN common_lookup_type  FORMAT A12  HEADING "Lookup|Type"

-- Verify MEMBER_TYPE values.
SELECT   m.member_id
,        COUNT(contact_id) AS MEMBERS
,        m.account_number
,        c.last_name
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN common_lookup cl
ON       m.member_type = cl.common_lookup_id
GROUP BY m.member_id
,        m.account_number
,        c.last_name
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
ORDER BY m.member_id;

-- Create a transaction view.
CREATE OR REPLACE VIEW current_rental AS
  SELECT   m.account_number
  ,        c.first_name
  ||       DECODE(c.middle_name,NULL,' ',' '||c.middle_name||' ')
  ||       c.last_name FULL_NAME
  ,        i.item_title TITLE
  ,        i.item_subtitle SUBTITLE
  ,        SUBSTR(cl.common_lookup_meaning,1,3) PRODUCT
  ,        r.check_out_date
  ,        r.return_date
  FROM     common_lookup cl
  ,        contact c
  ,        item i
  ,        member m
  ,        rental r
  ,        rental_item ri
  WHERE    r.customer_id = c.contact_id
  AND      r.rental_id = ri.rental_id
  AND      ri.item_id = i.item_id
  AND      i.item_type = cl.common_lookup_id
  AND      c.member_id = m.member_id
  ORDER BY 1,2,3;

COL full_name FORMAT A16
COL title     FORMAT A30
COL subtitle  FORMAT A4

SELECT   cr.full_name
,        cr.title
,        cr.product
,        cr.check_out_date
,        cr.return_date
FROM     current_rental cr;

@@insert_rental.sql
@@insert_rental_items.sql

-- Seed transaction table.
DECLARE

  -- Declare local variables.
  lv_transaction_account     VARCHAR2(20) := '222-22-22222';
  lv_transaction_type        NUMBER;
  lv_transaction_date        DATE;
  lv_transaction_amount      NUMBER;
  lv_payment_method          NUMBER;
  lv_payment_account_number  VARCHAR2(20) := '1000-10-43-20001';

  -- Declare cursor to read rentals.
  CURSOR c1 IS
    SELECT   rental_id
    ,        return_date
    FROM     rental;
    
  -- Declare cursor to read rentals.
  CURSOR c2 (cv_rental_id NUMBER) IS
    SELECT   SUM(ri.rental_item_price) AS transaction_price
    FROM     rental_item ri
    WHERE    ri.rental_id = cv_rental_id;

BEGIN

  -- Get foreign key for column value.
  SELECT   common_lookup_id
  INTO     lv_transaction_type
  FROM     common_lookup
  WHERE    common_lookup_table = 'TRANSACTION'
  AND      common_lookup_column = 'TRANSACTION_TYPE'
  AND      common_lookup_type = 'DEBIT';

  -- Get foreign key for column value.
  SELECT   common_lookup_id
  INTO     lv_payment_method
  FROM     common_lookup
  WHERE    common_lookup_table = 'TRANSACTION'
  AND      common_lookup_column = 'PAYMENT_METHOD_TYPE'
  AND      common_lookup_type = 'VISA_CARD';

  -- Read rental table entries.
  FOR i IN c1 LOOP

    -- Aggregate prices.  
    FOR j IN c2(i.rental_id) LOOP
      lv_transaction_amount := j.transaction_price;
    END LOOP;
    
    -- Insert transaction records.
    INSERT INTO transaction
    ( transaction_id
    , transaction_account
    , transaction_type
    , transaction_date
    , transaction_amount
    , rental_id
    , payment_method
    , payment_account_number
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES
    ( transaction_s1.NEXTVAL
    , lv_transaction_account
    , lv_transaction_type
    , i.return_date
    , lv_transaction_amount
    , i.rental_id
    , lv_payment_method
    , lv_payment_account_number
    , 3
    , SYSDATE
    , 3
    , SYSDATE );  
  
  END LOOP;

END;
/

COMMIT;

SPOOL OFF