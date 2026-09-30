{{ config(materialized='view', tags=['gold_view']) }}

SELECT
    d.ITEM_NAME,
    d.CATEGORY,
    d.VARIANT_NAME,
    SUM(f.QUANTITY) AS total_units_sold
FROM {{ ref('fact_customer_order') }} f
JOIN {{ ref('dim_item') }} d
  ON f.ITEM_ID = d.ITEM_ID
GROUP BY
    d.ITEM_NAME,
    d.CATEGORY,
    d.VARIANT_NAME
ORDER BY total_units_sold DESC
LIMIT 20