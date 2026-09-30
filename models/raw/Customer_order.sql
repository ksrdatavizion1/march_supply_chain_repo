
{{ config(
    materialized='incremental',
    unique_key='order_id',
     tags=['raw'],
    pre_hook=[
        "USE DATABASE {{target.database}};",
        "USE SCHEMA LANDING;",
        "{{ copy_into_customer_order() }}"
    ],
    post_hook=[
        """
        DELETE FROM {{target.database}}.LANDING.RAW_CUSTOMER_ORDER
        WHERE LOAD_TS < DATEADD(DAY, -90, CURRENT_DATE);
        """,
        """
               INSERT INTO {{target.database}}.AUDIT.MODEL_EXECUTION_LOG (
                    model_name,
                    load_date,
                    row_count,
                    file_name,
                    last_modified,
                    status,
                    comments
                )
                SELECT
                    'Customer_order' AS model_name,
                    MAX(LOAD_TS)     AS load_date,
                    COUNT(*)         AS row_count,
                    STG_FILE_NAME    AS file_name,
                    MAX(STG_LAST_MODIFIED) AS last_modified,
                    'SUCCESS'        AS status,
                    'Load completed successfully via COPY INTO + dbt incremental' AS comments
                FROM {{target.database}}.LANDING.RAW_CUSTOMER_ORDER
                WHERE CAST(LOAD_TS AS DATE) = CURRENT_DATE
                AND STG_FILE_NAME IS NOT NULL
                AND STG_FILE_NAME NOT IN (
                    SELECT file_name
                    FROM {{target.database}}.AUDIT.MODEL_EXECUTION_LOG
                    WHERE model_name = 'Customer_order'
                )
                GROUP BY STG_FILE_NAME;

        """
    ]
) }}

 WITH base AS (
    SELECT
        ORDER_ID::VARCHAR(50)        AS ORDER_ID,
        LINE_NUM::NUMBER(5,0)        AS LINE_NUM,
        CUSTOMER_ID::VARCHAR(50)     AS CUSTOMER_ID,
        CUSTOMER_NAME::VARCHAR(100)  AS CUSTOMER_NAME,
        CUSTOMER_EMAIL::VARCHAR(100) AS CUSTOMER_EMAIL,
        CUSTOMER_PHONE::VARCHAR(15)  AS CUSTOMER_PHONE,
        CITY_NAME::VARCHAR(50)       AS CITY_NAME,
        ITEM_ID::VARCHAR(50)         AS ITEM_ID,
        ITEM_NAME::VARCHAR(100)      AS ITEM_NAME,
        VARIANT_NAME::VARCHAR(50)    AS VARIANT_NAME,
        FUEL_TYPE::VARCHAR(20)       AS FUEL_TYPE,
        WAREHOUSE_NAME::VARCHAR(100) AS WAREHOUSE_NAME,
        ORDER_DATE::DATE             AS ORDER_DATE,
        QUANTITY::NUMBER(5,0)        AS QUANTITY,
        UNIT_PRICE::NUMBER(10,2)     AS UNIT_PRICE
    FROM {{ source('orders', 'cust_order') }}
)

SELECT * FROM base

{% if is_incremental() %}
WHERE order_id NOT IN (SELECT order_id FROM {{ this }})
{% endif %}
