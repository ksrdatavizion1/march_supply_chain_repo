WITH customer_order AS (
  /* Transformed customer order data with enriched and cleaned columns. */
  SELECT
    *
  FROM {{ ref('my_new_project', 'Customer_order') }}
), new_custmer_sql AS (
  SELECT
    *
  FROM customer_order
)
SELECT
  *
FROM new_custmer_sql