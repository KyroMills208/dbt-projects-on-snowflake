{{
    config(
        materialized='dynamic_table',
        snowflake_warehouse='dbt_dev_wh',
        target_lag='1 hour',
        refresh_mode='AUTO'
    )
}}

-- Dynamic table for real-time hourly metrics
with order_details as (
    select 
        od.order_id,
        od.menu_item_id,
        od.quantity,
        od.price,
        od.line_total,
        oh.truck_id,
        oh.order_ts,
        m.menu_type,
        m.truck_brand_name,
        m.item_category
    from {{ source('tasty_bytes', 'raw_pos_order_detail') }} od
    inner join {{ source('tasty_bytes', 'raw_pos_order_header') }} oh on od.order_id = oh.order_id
    inner join {{ source('tasty_bytes', 'raw_pos_menu') }} m on od.menu_item_id = m.menu_item_id
)

select
    truck_brand_name,
    menu_type,
    item_category,
    date_trunc('hour', order_ts) as sales_hour,
    count(distinct order_id) as orders_count,
    sum(quantity) as items_sold,
    sum(line_total) as revenue,
    avg(line_total) as avg_order_value,
    current_timestamp() as last_updated
from order_details
where truck_brand_name is not null
group by 1, 2, 3, 4
