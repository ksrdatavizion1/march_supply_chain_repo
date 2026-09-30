
{{ config(
     tags=['gold'],
    alias='DIM_ITEM'
) }}

SELECT
    ITEM_ID,
    ITEM_NAME,
    CATEGORY,
    VARIANT_NAME,
    FUEL_TYPE_CLEANED,
    VARIANT_TYPE,
    UNIQUE_IDENTIFIER,
    IS_ELECTRIC,
    IS_HYBRID,
    VEHICLE_TYPE
FROM {{ ref('item_inventory_snapshot') }}
WHERE DBT_VALID_TO IS NULL