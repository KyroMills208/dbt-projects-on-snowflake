{{
    config(
        materialized='incremental',
        unique_key='sales_day_truck_item',
        merge_update_columns=['total_items_sold', 'total_revenue', 'total_orders'],
        cluster_by=['sales_date', 'truck_brand_name'],
        on_schema_change='append_new_columns'
    )
}}

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
        m.item_category,
        date_trunc('day', oh.order_ts) as sales_date
    from {{ source('tasty_bytes', 'raw_pos_order_detail') }} od
    inner join {{ source('tasty_bytes', 'raw_pos_order_header') }} oh on od.order_id = oh.order_id
    inner join {{ source('tasty_bytes', 'raw_pos_menu') }} m on od.menu_item_id = m.menu_item_id
    
    {% if is_incremental() %}
    -- Only process new records since last run
    where oh.order_ts > (select max(sales_date) from {{ this }})
    {% endif %}
)

select
    {{ dbt_utils.generate_surrogate_key(['sales_date', 'truck_brand_name', 'item_category']) }} as sales_day_truck_item,
    truck_brand_name,
    menu_type,
    item_category,
    sales_date,
    sum(quantity) as total_items_sold,
    sum(line_total) as total_revenue,
    count(distinct order_id) as total_orders,
    current_timestamp() as updated_at
from order_details
where truck_brand_name is not null
group by 1, 2, 3, 4, 5
