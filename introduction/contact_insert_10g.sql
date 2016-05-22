-- create_store.sql
-- Introcution, Oracle Database 11g PL/SQL Programming Workbook
-- by Michael McLaughlin and John Harper
--
-- This creates a transactionally safe individual member insert
-- into the MEMBER, CONTACT, ADDRESS, STREET_ADDRESS, and
-- TELEPHONE tables for Oracle 11g; it won't run in Oracle 10g
-- and you should use the contact_insert_10g.sql script in the
-- create_store.sql when working on Oracle 10g XE.

-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_insert_10g
( pv_member_type         VARCHAR2
, pv_account_number      VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_created_by          NUMBER   := 1
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1
, pv_last_update_date    DATE     := SYSDATE) IS

  -- Required when working in Oracle 10g or older releases.
  -- Local variables to manage sequence values in DML statements.
  lv_member_id           NUMBER;
  lv_contact_id          NUMBER;
  lv_address_id          NUMBER;
  lv_street_address_id   NUMBER;
  lv_telephone_id        NUMBER;

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  member_s1.NEXTVAL
  INTO    lv_member_id
  FROM    dual;
  
  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( lv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'MEMBER'
    AND      common_lookup_column = 'MEMBER_TYPE'
    AND      common_lookup_type = lv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'MEMBER'
    AND      common_lookup_column = 'CREDIT_CARD_TYPE'
    AND      common_lookup_type = lv_credit_card_type)
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  contact_s1.NEXTVAL
  INTO    lv_contact_id
  FROM    dual;

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( lv_contact_id
  , lv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  address_s1.NEXTVAL
  INTO    lv_address_id
  FROM    dual;

  INSERT INTO address
  VALUES
  ( lv_address_id
  , lv_contact_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  street_address_s1.NEXTVAL
  INTO    lv_street_address_id
  FROM    dual;

  INSERT INTO street_address
  VALUES
  ( lv_street_address_id
  , lv_address_id
  , 1                                                  -- Required for only one line address.
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  -- Fetch the .NEXTVAL pseudo column for use as a local variable in a DML.
  SELECT  telephone_s1.NEXTVAL
  INTO    lv_telephone_id
  FROM    dual;

  INSERT INTO telephone
  VALUES
  ( lv_telephone_id                                   -- TELEPHONE_ID
  , lv_contact_id                                     -- CONTACT_ID
  , lv_address_id                                     -- ADDRESS_ID
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END contact_insert_10g;
/

-- Display any compilation errors.
SHOW ERRORS
