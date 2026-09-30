{{ config(
    materialized='incremental',
    unique_key='warehouse_name',
	incremental_strategy='delete+insert',
    tags=['silver']     
) }}

{% set src = source('warehouse_loc', 'warehouse') %}  -- jinja

SELECT
    CITY_NAME,
    STATE_NAME,
    REGION,
    WAREHOUSE_NAME,
    CURRENT_TIMESTAMP AS INGESTION_TS
    from {{ src.database}}.{{target.schema}}_{{src.schema}}.{{src.identifier}}