{{ config(
   tags=['gold'],
    alias='FACT_CUSTOMER_ORDER'
) }}

SELECT
    ORDER_ID,
    LINE_NUM,
    CUSTOMER_ID,
    ITEM_ID,
    WAREHOUSE_NAME,
    CITY_NAME,
    ORDER_DATE,
    ORDER_WEEK,
    QUANTITY,
    UNIT_PRICE,
    TOTAL_PRICE,
    SNAPSHOT_TS
FROM {{ ref('customer_order_snapshot') }}
WHERE DBT_VALID_TO IS NULL