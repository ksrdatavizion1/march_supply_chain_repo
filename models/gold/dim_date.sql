{{ config(
     tags=['gold'],
    alias='DIM_DATE'
) }}



-- Find the minimum order date
WITH min_date AS (
    SELECT MIN(ORDER_DATE) AS start_date
    FROM {{ ref('customer_order_snapshot') }}
    WHERE DBT_VALID_TO IS NULL
),

date_spine AS (
    -- anchor member: start from the minimum date
    SELECT start_date AS date_val
    FROM min_date

    UNION ALL

    -- recursive member: add 1 day until current_date
    SELECT DATEADD(day, 1, date_val)
    FROM date_spine
    WHERE date_val < CURRENT_DATE()
)

SELECT
    date_val AS DATE_KEY,
    EXTRACT(YEAR FROM date_val) AS YEAR,
    EXTRACT(MONTH FROM date_val) AS MONTH,
    EXTRACT(DAY FROM date_val) AS DAY,
    TO_CHAR(date_val, 'Day') AS DAY_NAME,
    TO_CHAR(date_val, 'Month') AS MONTH_NAME,
    DATE_TRUNC('week', date_val) AS WEEK_START_DATE
FROM date_spine