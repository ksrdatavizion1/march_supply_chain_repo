{% snapshot customer_order_snapshot %}
{{
    config(
      tags = ['silver'],
      unique_key='order_id',
      strategy='check',
      check_cols=[
        'line_num',
        'customer_id',
        'customer_name',
        'customer_email',
        'customer_phone',
        'city_name',
        'item_id',
        'item_name',
        'variant_name',
        'fuel_type',
        'warehouse_name',
        'order_date',
        'quantity',
        'unit_price'
      ],
     post_hook=[
            "{{ log_model_execution('customer_order_snapshot', target.database ~ '.' ~ this.schema ~  '.' ~ this.identifier) }}"]
    )
}}
   SELECT
    order_id,
    line_num,
    customer_id,
    INITCAP(customer_name) AS customer_name,
    LOWER(customer_email)  AS customer_email,
    customer_phone,
    INITCAP(city_name)     AS city_name,
    item_id,
    INITCAP(item_name)     AS item_name,
    INITCAP(variant_name)  AS variant_name,
    INITCAP(fuel_type)     AS fuel_type,
    warehouse_name,
    order_date,
    quantity,
    unit_price,
    
    --  Derived fields
    quantity * unit_price AS total_price,
    DATE_TRUNC('WEEK', order_date) AS order_week,
    CURRENT_TIMESTAMP AS snapshot_ts

FROM {{ ref('Customer_order') }}
 {% endsnapshot %}