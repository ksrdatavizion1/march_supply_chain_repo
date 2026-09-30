{% test valid_email_format(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} NOT LIKE '%@%.%'

{% endtest %}