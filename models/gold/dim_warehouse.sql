{{ config(
    tags=['gold'],
    alias='DIM_WAREHOUSE'
) }}

SELECT DISTINCT
    WAREHOUSE_NAME,
    CITY_NAME,
    STATE_NAME,
    REGION
FROM {{ ref('silver_warehouse_locations') }}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY WAREHOUSE_NAME, CITY_NAME
    ORDER BY ingestion_ts DESC
) = 1