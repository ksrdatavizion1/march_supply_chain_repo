{% test no_special_chars(model, column_names) %}
{%- set cols = column_names if column_names is iterable and column_names is not string else [column_names] -%}

SELECT *
FROM {{ model }}
WHERE
  {% for col in cols %}
    REGEXP_LIKE({{ col }}, '[^a-zA-Z0-9 ]')
    {%- if not loop.last %} OR {% endif %}
  {% endfor %}

{% endtest %}