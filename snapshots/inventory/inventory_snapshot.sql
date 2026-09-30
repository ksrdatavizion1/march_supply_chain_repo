-- with post hook:
{% snapshot item_inventory_snapshot  %}
{{
    config(
      unique_key='ITEM_ID',
      strategy='check',
      tags=['silver']  ,
      check_cols=[
        'ITEM_ID',
        'ITEM_NAME',
        'CATEGORY',
        'VARIANT_NAME',
       
      ],
      post_hook=[
             "{{ log_model_execution('item_inventory_snapshot', target.database ~ '.' ~ this.schema ~  '.' ~ this.identifier) }}"]
    )
}}

SELECT
    ITEM_ID,
    ITEM_NAME,
    CATEGORY,
    VARIANT_NAME,

    -- Normalized fuel type
    CASE
        WHEN LOWER(FUEL_TYPE) IN ('petrol', 'pet') THEN 'Petrol'
        WHEN LOWER(FUEL_TYPE) IN ('diesel', 'die') THEN 'Diesel'
        WHEN LOWER(FUEL_TYPE) LIKE '%ele%' THEN 'Electric'
        WHEN LOWER(FUEL_TYPE) LIKE '%hyb%' THEN 'Hybrid'
        ELSE 'Other'
    END AS fuel_type_cleaned,

    -- Extracted variant type (e.g., Deluxe, Eco)
    SPLIT_PART(VARIANT_NAME, '-', 1) AS variant_type,

    -- Unique name formed by combining item details
    ITEM_NAME || '_' || CATEGORY || '_' || VARIANT_NAME AS unique_identifier,

    -- Flags
    CASE WHEN LOWER(FUEL_TYPE) LIKE '%ele%' THEN TRUE ELSE FALSE END AS is_electric,
    CASE WHEN LOWER(FUEL_TYPE) LIKE '%hyb%' THEN TRUE ELSE FALSE END AS is_hybrid,

    -- Derived vehicle type from category
    CASE 
        WHEN UPPER(CATEGORY) IN ('SUV', 'TRUCK') THEN 'Heavy'
        WHEN UPPER(CATEGORY) IN ('SEDAN', 'HATCHBACK') THEN 'Light'
        ELSE 'Other'
    END AS vehicle_type

 

FROM {{ ref('item_inventory') }}

{% endsnapshot %}