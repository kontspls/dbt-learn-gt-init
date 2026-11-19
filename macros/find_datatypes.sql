{% macro find_datatypes(model) %}
    {% set relation = api.Relation.create(
        database=target.database,
        schema=target.schema,
        identifier=model
    ) %}
    {% set cols=adapter.get_columns_in_relation(relation) %}
    {%- for col in cols %}
        {{ print('      - name: ' ~ (col.name | lower) ~ '\n        data_type: ' ~ (col.dtype | lower)) }}
    {%- endfor %}
{% endmacro %}