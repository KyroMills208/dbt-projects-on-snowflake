{% macro create_row_access_policy(policy_name, table_name, column_name, allowed_values) %}

create or replace row access policy {{ policy_name }}
as ({{ column_name }} varchar) returns boolean ->
    case
        when current_role() in ('ACCOUNTADMIN', 'SYSADMIN') then true
        when '{{ allowed_values }}' = 'ALL' then true
        when {{ column_name }} in (
            select truck_brand_name 
            from user_truck_access 
            where user_name = current_user()
        ) then true
        else false
    end;

alter table {{ table_name }} 
    add row access policy {{ policy_name }} on ({{ column_name }});

{% endmacro %}
