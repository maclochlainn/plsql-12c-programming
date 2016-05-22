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

  FOR i IN c1 LOOP
  
    FOR j IN c2(i.rental_id) LOOP
      lv_transaction_amount := j.transaction_price;
    END LOOP;
    
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