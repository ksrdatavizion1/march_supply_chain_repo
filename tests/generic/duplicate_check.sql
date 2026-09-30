{% test duplicate_check(model, column_names) %}

SELECT 
  {% for col in column_names %}
    {{ col }}{% if not loop.last %}, {% endif %}
  {% endfor %},
  COUNT(*) AS occurrences
FROM {{ model }}
GROUP BY 
  {% for col in column_names %}
    {{ col }}{% if not loop.last %}, {% endif %}
  {% endfor %}
HAVING COUNT(*) > 1

{% endtest %}