{% macro copy_into_customer_order() %}
    COPY INTO {{target.database}}.landing.raw_customer_order
    FROM (
        SELECT
            $1  ::STRING         AS order_id,
            $2  ::INT            AS line_num,
            $3  ::STRING         AS customer_id,
            $4  ::STRING         AS customer_name,
            $5  ::STRING         AS customer_email,
            $6  ::STRING         AS customer_phone,
            $7  ::STRING         AS city_name,
            $8  ::STRING         AS item_id,
            $9  ::STRING         AS item_name,
            $10 ::STRING         AS variant_name,
            $11 ::STRING         AS fuel_type,
            $12 ::STRING         AS warehouse_name,
            $13 ::DATE           AS order_date,
            $14 ::INT            AS quantity,
            $15 ::NUMBER(10,2)   AS unit_price,
            METADATA$FILENAME,
            METADATA$FILE_ROW_NUMBER,
            METADATA$FILE_LAST_MODIFIED,
            CURRENT_TIMESTAMP  -- as load_ts
        FROM @ext_stage_storage_int/customer_order/
            (FILE_FORMAT => '{{target.database}}.LANDING.MY_CSV_FORMAT'))
             ON_ERROR = 'CONTINUE';
      
{% endmacro %}