/*
 * transaction_procedure.sql
 * Chapter 6, Oracle Database 11g PL/SQL Programming Workbook
 * by Michael McLaughlin and John Harper
 *
 * ALERTS:
 *
 * This builds and demonstrates the ADD_CONTACT and ADD_MEMBER procedures.
 * The ADD_CONTACT procedure uses syntax reserved for Oracle 11g forward,
 * if you're using an older database please change comment out the Oracle 11g
 * syntax and uncomment the Oracle 10g syntax.
 */

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null
            FROM   user_objects
            WHERE  object_name = 'CONTACT_LIST_TYPE') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE contact_list_type';
  END LOOP;
END;
/

BEGIN
  FOR i IN (SELECT null
            FROM   user_objects
            WHERE  object_name = 'CONTACT_NAME_STRUCT') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE contact_name_struct';
  END LOOP;
END;
/

BEGIN
  FOR i IN (SELECT null
            FROM   user_objects
            WHERE  object_name = 'STREET_ADDRESS_TABLE') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE street_address_table';
  END LOOP;
END;
/

-- Declare object type.
CREATE OR REPLACE TYPE contact_name_struct IS OBJECT
( last_name    VARCHAR2(20)
, first_name   VARCHAR2(20)
, middle_name  VARCHAR2(20));
/

-- Declare collection of object type.
CREATE OR REPLACE TYPE contact_list_type IS TABLE OF contact_name_struct; 
/

-- Declare collection for street address call.
CREATE OR REPLACE TYPE street_address_table IS VARRAY(3) OF VARCHAR2(30);
/

CREATE OR REPLACE PROCEDURE add_contact
( pv_member_id         NUMBER
, pv_contact_type      NUMBER
, pv_last_name         VARCHAR2
, pv_first_name        VARCHAR2
, pv_middle_name       VARCHAR2 := NULL
, pv_address_type      NUMBER   := NULL
, pv_street_address    STREET_ADDRESS_TABLE := street_address_table()
, pv_city              VARCHAR2 := NULL
, pv_state_province    VARCHAR2 := NULL
, pv_postal_code       VARCHAR2 := NULL
, pv_country_code      VARCHAR2 := NULL
, pv_telephone_type    NUMBER   := NULL
, pv_area_code         VARCHAR2 := NULL
, pv_telephone_number  VARCHAR2 := NULL
, pv_created_by        NUMBER
, pv_creation_date     DATE     := SYSDATE
, pv_last_updated_by   NUMBER
, pv_last_update_date  DATE     := SYSDATE) IS

  -- Define a local variable because an address may not be provided.
  lv_address_id     NUMBER;

BEGIN

  -- Set savepoint to guarantee all or nothing happens.
  SAVEPOINT add_contact;

  -- Insert into contact table.
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
  , last_update_date )
  VALUES
  ( contact_s1.NEXTVAL
  , pv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = 'CUSTOMER') -- pv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  -- Check conditions before inserting an address.
  IF pv_address_type IS NOT NULL   AND
     pv_city IS NOT NULL           AND
     pv_state_province IS NOT NULL AND
     pv_postal_code IS NOT NULL    THEN

     INSERT INTO address
     VALUES
     ( address_s1.nextval
     , contact_s1.currval
     , pv_address_type
     , pv_city
     , pv_state_province
     , pv_postal_code
     , pv_created_by
     , pv_creation_date
     , pv_last_updated_by
     , pv_last_update_date);

     -- Preserve primary key for reuse as a foreign key.
     -- -------------------------------------------------------------
     -- Oracle 11g Forward supports this syntax.
     -- -------------------------------------------------------------
     lv_address_id := address_s1.currval;
     
     -- Preserve primary key for reuse as a foreign key.
     -- -------------------------------------------------------------
     -- Oracle 10g Backward Compatibility uses this syntax.
     -- -------------------------------------------------------------
     -- SELECT address_s1.currval INTO lv_address_id FROM dual;

    -- Check conditions before inserting a street address.	 
    IF pv_street_address.COUNT > 0 THEN
      FOR i IN 1..pv_street_address.COUNT LOOP

        INSERT INTO street_address VALUES
        ( street_address_s1.nextval
        , lv_address_id
        , i
        , pv_street_address(i)
        , pv_created_by
        , pv_creation_date
        , pv_last_updated_by
        , pv_last_update_date);

      END LOOP;
    END IF;

  END IF;

  -- Check condidtions before inserting a telephone.
  IF pv_telephone_type IS NOT NULL AND
     pv_country_code IS NOT NULL AND
     pv_area_code IS NOT NULL AND
     pv_telephone_number IS NOT NULL THEN

    INSERT INTO telephone VALUES
    ( telephone_s1.nextval
    , contact_s1.currval
    , lv_address_id           -- Reuse the foreign key if available.
    , pv_telephone_type
    , pv_country_code
    , pv_area_code
    , pv_telephone_number
    , pv_created_by
    , pv_creation_date
    , pv_last_updated_by
    , pv_last_update_date);

  END IF;

EXCEPTION

  WHEN others THEN
    ROLLBACK TO add_contact;
    RAISE_APPLICATION_ERROR(-20001,SQLERRM);

END add_contact;
/

-- Display any errors.
SHOW ERRORS

-- List program to debug errors.
LIST

CREATE OR REPLACE PROCEDURE add_member
( pv_membership_type    VARCHAR2 := 'GROUP'
, pv_account_number     VARCHAR2
, pv_credit_card_number VARCHAR2
, pv_credit_card_type   VARCHAR2 := 'VISA_CARD'
, pv_contact_type       VARCHAR2 := 'CUSTOMER'
, pv_contact_list       CONTACT_LIST_TYPE
, pv_address_type       VARCHAR2 := 'HOME'
, pv_st_addr1           VARCHAR2 := NULL
, pv_st_addr2           VARCHAR2 := NULL
, pv_st_addr3           VARCHAR2 := NULL
, pv_city               VARCHAR2 := NULL
, pv_state_province     VARCHAR2 := NULL
, pv_postal_code        VARCHAR2 := NULL
, pv_country_code       VARCHAR2 := NULL
, pv_telephone_type     VARCHAR2 := 'HOME'
, pv_area_code          VARCHAR2 := NULL
, pv_telephone_number   VARCHAR2 := NULL
, pv_created_by         NUMBER
, pv_creation_date      DATE     := SYSDATE
, pv_last_updated_by    NUMBER
, pv_last_update_date   DATE     := SYSDATE) IS

  -- Declare surrogate key variables.
  lv_member_id         NUMBER;
  lv_member_type       NUMBER;
  lv_credit_card_type  NUMBER;

  -- Declare a null collection until you can evaluate element values.  
  lv_street_address    STREET_ADDRESS_TABLE := street_address_table();

  -- Declare local function to get type.
  FUNCTION get_type
  ( table_name  VARCHAR2
  , column_name VARCHAR2
  , type_name   VARCHAR2) RETURN NUMBER IS
    retval NUMBER;
  BEGIN
    SELECT   common_lookup_id
    INTO     retval
    FROM     common_lookup
    WHERE    common_lookup_table = table_name
    AND      common_lookup_column = column_name
    AND      common_lookup_type = type_name;
    RETURN retval;
  END get_type;

BEGIN

  -- Initialize local street address array for all not null values.
  FOR i IN 1..3 LOOP
    lv_street_address.EXTEND;
    IF    pv_st_addr1 IS NOT NULL THEN
      lv_street_address(i) := pv_st_addr1;
    ELSIF pv_st_addr2 IS NOT NULL THEN
      lv_street_address(i) := pv_st_addr2;
    ELSIF pv_st_addr3 IS NOT NULL THEN
      lv_street_address(i) := pv_st_addr3;
    END IF;
  END LOOP;

  -- Set savepoint to guarantee all or nothing happens.
  SAVEPOINT add_member;

  -- Select sequence by using Oracle 10g and backward methods.
  SELECT  member_s1.nextval
  INTO    lv_member_id
  FROM    dual;

  -- Declare types based on local function that can't run in SQL context.
  lv_member_type := get_type('MEMBER','MEMBER_TYPE',pv_membership_type);
  lv_credit_card_type := get_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type);
  
  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( lv_member_id
  , lv_member_type
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date);

  -- Call contact for as many as exist.
  FOR i IN 1..pv_contact_list.COUNT LOOP
   
    -- Call procedure to insert records in related tables.
    add_contact(
      pv_member_id => lv_member_id
    , pv_contact_type => get_type('CONTACT','CONTACT_TYPE',pv_contact_type)
    , pv_first_name => pv_contact_list(i).first_name
    , pv_middle_name => pv_contact_list(i).middle_name
    , pv_last_name => pv_contact_list(i).last_name
    , pv_address_type => get_type('ADDRESS','ADDRESS_TYPE',pv_address_type)
    , pv_street_address => lv_street_address
    , pv_city => pv_city
    , pv_state_province => pv_state_province
    , pv_postal_code => pv_postal_code
    , pv_telephone_type => get_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type)
    , pv_country_code => pv_country_code
    , pv_area_code => pv_area_code
    , pv_telephone_number => pv_telephone_number
    , pv_created_by => pv_created_by
    , pv_last_updated_by => pv_last_updated_by);
    
  END LOOP;

  -- Write all records from both procedures.
  COMMIT;
  
EXCEPTION
  WHEN others THEN
    ROLLBACK TO add_member;
    RAISE_APPLICATION_ERROR(-20002,SQLERRM);
END add_member;
/

-- Display any errors.
SHOW ERRORS

-- List program to debug errors.
LIST

-- Test procedures.
DECLARE

  -- Declare collection of five contacts.
  potter_family  CONTACT_LIST_TYPE := contact_list_type(
                                        contact_name_struct('Potter','Harry','')
                                      , contact_name_struct('Potter','Ginny','')
                                      , contact_name_struct('Potter','James','Sirius')
                                      , contact_name_struct('Potter','Albus','Severus')
                                      , contact_name_struct('Potter','Lily','Luna'));
                   
BEGIN

  -- Call add_member procedure.
  add_member
  ( pv_membership_type => 'GROUP'
  , pv_account_number => 'TEMP'
  , pv_credit_card_number => '2222-2222-2222-2222'
  , pv_credit_card_type => 'VISA_CARD'
  , pv_contact_type => 'CUSTOMER'
  , pv_contact_list => potter_family
  , pv_address_type => 'HOME'
  , pv_st_addr1 => '1414 Pearse Street'
  , pv_st_addr2 => 'Salisbury Home'
  , pv_city => 'Provo'
  , pv_state_province => 'Utah'
  , pv_postal_code => '84604'
  , pv_country_code => '01'
  , pv_telephone_type => 'HOME'
  , pv_area_code => '801'
  , pv_telephone_number => '444-4444'
  , pv_created_by => 3
  , pv_last_updated_by => 3);

END;
/

-- Display any errors.
SHOW ERRORS

-- List program for debugging.
LIST

