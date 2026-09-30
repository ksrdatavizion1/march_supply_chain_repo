--- add this to add the deafult schema and given schema 

{% macro generate_schema_name(custom_schema_name, node) %}
    {% if custom_schema_name is none %}
        {{ target.schema }}
    {% elif custom_schema_name | lower == 'landing' %}
        {{ custom_schema_name }}
    {% else %}
        {{ target.schema }}_{{ custom_schema_name }}
    {% endif %}
{% endmacro %}



{% macro log_model_execution(model_name, table_name) %}
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
        '{{ model_name }}',
        CURRENT_TIMESTAMP,
        COUNT(*),
        '{{table_name}}',
        NULL,
        'SUCCESS',
        'Snapshot completed successfully for {{ model_name }}'
    FROM {{ table_name }}
    WHERE NOT EXISTS (
        SELECT 1
        FROM {{target.database}}.AUDIT.MODEL_EXECUTION_LOG
        WHERE model_name = '{{ model_name }}'
          AND CAST(load_date AS DATE) = CURRENT_DATE
    )
{% endmacro %}
