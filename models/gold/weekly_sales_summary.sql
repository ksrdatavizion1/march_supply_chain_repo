{{ config(materialized='view', tags=['gold_view']) }}

SELECT
    ORDER_WEEK,
    SUM(TOTAL_PRICE)         AS total_sales,
    SUM(QUANTITY)            AS total_units_sold,
    COUNT(DISTINCT ORDER_ID) AS total_orders
FROM {{ ref('fact_customer_order') }}
GROUP BY ORDER_WEEK
ORDER BY ORDER_WEEK