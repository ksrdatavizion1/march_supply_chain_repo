{% test column_length_is(model, column_name, expected_length) %}
    SELECT *
    FROM {{ model }}
    WHERE LENGTH({{ column_name }}) != {{ expected_length }}
{% endtest %}