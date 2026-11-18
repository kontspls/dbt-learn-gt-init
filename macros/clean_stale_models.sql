{% macro clean_stale_models(database=target.database, schema=target.schema, days=300, dry_run=True) %}

    {% set get_drop_commands_query %}
        select
            case
                when table_type = 'VIEW' then 'VIEW'
                else 'TABLE'
            end as object_type,
            'DROP ' ||
            case
                when table_type = 'VIEW' then 'VIEW'
                else 'TABLE'
            end ||
            ' `{{ database }}`.`{{ schema }}`.`' || table_name || '`;' as drop_statement
        from {{ adapter.quote(database) }}.information_schema.tables
        where upper(table_schema) = upper('{{ schema }}')
        and date(last_altered) <= date_sub(current_date(), {{ days | int }})
    {% endset %}

    {{ log('\nGenerating cleanup queries...\n', info=True) }}
    {% set drop_queries = run_query(get_drop_commands_query).columns[1].values() %}

    {% for drop_query in drop_queries %}
        {% if execute and not dry_run %}
            {{ log('Dropping table/view with command: ' ~ drop_query, info=True) }}
            {% do run_query(drop_query) %}
        {% else %}
            {{ log(drop_query, info=True) }}
        {% endif %}
    {% endfor %}

{% endmacro %}