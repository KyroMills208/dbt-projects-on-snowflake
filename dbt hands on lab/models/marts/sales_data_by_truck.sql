-- Monthly aggregated sales data by truck brand, menu type, and item category
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
        date_trunc('month', oh.order_ts) as sales_month
    from {{ ref('stg_order_details') }} od
    inner join {{ ref('stg_order_header') }} oh on od.order_id = oh.order_id
    inner join {{ source('tasty_bytes', 'raw_pos_menu') }} m on od.menu_item_id = m.menu_item_id
),

monthly_sales as (
    select
        truck_brand_name,
        menu_type,
        item_category,
        sales_month,
        sum(quantity) as total_items_sold,
        sum(line_total) as total_revenue,
        count(distinct order_id) as total_orders
    from order_details
    group by 1, 2, 3, 4
)

select * from monthly_sales
