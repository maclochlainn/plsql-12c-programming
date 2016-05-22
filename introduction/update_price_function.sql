CREATE OR REPLACE FUNCTION update_price RETURN INTEGER IS

  -- Local processing variables.
  lv_price_id    NUMBER;
  lv_start_date  DATE;
  lv_end_date    DATE;
  
  -- Declare a collection.
  TYPE flags IS TABLE OF VARCHAR2(1);
  
  -- Declare array.
  flag FLAGS := flags('Y','N');

  -- Declare ITEM cursor.
  CURSOR item IS
    SELECT   i.item_id
    ,        i.item_release_date
    FROM     item i;

  -- Declare COMMON_LOOKUP cursor.
  CURSOR common_lookup IS
    SELECT common_lookup_id AS price_type
    ,      common_lookup_code AS amount
    FROM   common_lookup
    WHERE  common_lookup_table = 'PRICE'
    AND    common_lookup_column = 'AMOUNT'
    AND    common_lookup_type LIKE '%-DAY RENTAL';

BEGIN

  -- Set SAVEPOINT.
  SAVEPOINT all_or_none;

  -- Loop through YES and NO table.
  FOR i IN 1..flag.COUNT LOOP
  
    -- Loop through COMMON_LOOKUP table.
    FOR j IN common_lookup LOOP
    
      -- Loop through ITEM table.
      FOR k IN item LOOP

        -- Compliant with Oracle 10g mechanics.
        SELECT   price_s1.NEXTVAL
        INTO     lv_price_id
        FROM     dual;

        -- Set price start and end date basis.
        IF TRUNC(SYSDATE) - 30 = k.item_release_date AND flag(i) = 'N' THEN
          lv_start_date := TRUNC(k.item_release_date);
          lv_end_date := TRUNC(k.item_release_date) + 30;
        ELSIF TRUNC(SYSDATE) - 30 > k.item_release_date AND flag(i) = 'Y' THEN
          lv_start_date := TRUNC(k.item_release_date) + 31;
        END IF;
        
        -- Insert into price table.
        INSERT INTO price
        ( price_id
        , item_id
        , price_type
        , active_flag
        , start_date
        , end_date
        , amount
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( lv_price_id
        , k.item_id
        , j.price_type
        , flag(i)
        , lv_start_date
        , lv_end_date
        , j.amount
        , 1
        , SYSDATE
        , 1
        , SYSDATE );

    
      END LOOP;
    END LOOP;
  END LOOP;
  
  -- Commit records.
  COMMIT;
  
  -- Return integer.
  RETURN 0;
  
EXCEPTION

  -- Return others.
  WHEN OTHERS THEN
    ROLLBACK TO all_or_none;
    RETURN 1;
  
END update_price;
/