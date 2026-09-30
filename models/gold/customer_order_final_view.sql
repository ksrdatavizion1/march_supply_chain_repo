-- models/gold_views/customer_order_gold_view.sql

{{ config(
    materialized='view',
    alias='CUSTOMER_ORDER_GOLD_VIEW',
    tags=['gold_view']
) }}

WITH fact AS (
    SELECT *
    FROM {{ ref('fact_customer_order') }}
),

dim_customer AS (
    SELECT *
    FROM {{ ref('dim_customer') }}
),

dim_item AS (
    SELECT *
    FROM {{ ref('dim_item') }}
),

dim_warehouse AS (
    SELECT *
    FROM {{ ref('dim_warehouse') }}
),

dim_date AS (
    SELECT *
    FROM {{ ref('dim_date') }}
),

final AS (
    SELECT
        -- Order Info
        f.ORDER_ID,
        f.LINE_NUM,
        f.ORDER_DATE,
        f.ORDER_WEEK,
        f.QUANTITY,
        f.UNIT_PRICE,
        f.TOTAL_PRICE,
        f.SNAPSHOT_TS,

        -- Date Info
        d_order.YEAR AS ORDER_YEAR,
        d_order.MONTH AS ORDER_MONTH,
        d_order.DAY AS ORDER_DAY,
        d_order.DAY_NAME AS ORDER_DAY_NAME,
        d_order.MONTH_NAME AS ORDER_MONTH_NAME,
        d_order.WEEK_START_DATE AS ORDER_WEEK_START,

        -- Customer Info
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.CUSTOMER_EMAIL,
        c.CUSTOMER_PHONE,
        c.CITY_NAME AS CUSTOMER_CITY,

        -- Item Info
        i.ITEM_ID,
        i.ITEM_NAME,
        i.CATEGORY,
        i.VARIANT_NAME,
        i.FUEL_TYPE_CLEANED,
        i.IS_ELECTRIC,
        i.IS_HYBRID,
        i.VEHICLE_TYPE,

        -- Warehouse Info
        w.WAREHOUSE_NAME,
        w.CITY_NAME AS WAREHOUSE_CITY,
        w.STATE_NAME,
        w.REGION

    FROM fact f

    LEFT JOIN dim_customer c
        ON f.CUSTOMER_ID = c.CUSTOMER_ID

    LEFT JOIN dim_item i
        ON f.ITEM_ID = i.ITEM_ID

    LEFT JOIN dim_warehouse w
        ON f.WAREHOUSE_NAME = w.WAREHOUSE_NAME AND f.CITY_NAME = w.CITY_NAME

    LEFT JOIN dim_date d_order
        ON f.ORDER_DATE = d_order.DATE_KEY
)

SELECT * FROM final