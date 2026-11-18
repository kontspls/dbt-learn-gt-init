
{% macro grant_select(schema=target.schema, role="troopers", database=target.database) %}
    {% set sql %}
      use catalog {{ database }};
      grant use schema on schema {{ schema }} to {{ role }};
    {% endset %}

    {{ log('Granting select on schema ' ~ schema ~ ' to role' ~ role, info=True) }}
    {% do run_query(sql) %}
    {{ log('Finished granting select on schema' ~ schema ~ 'to role' ~ role, info=True) }}

{% endmacro %}