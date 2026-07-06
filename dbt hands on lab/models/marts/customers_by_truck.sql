-- Unique customer counts by truck brand, food type, and month
with order_data as (
    select
        oh.customer_id,
        oh.order_id,
        oh.order_ts,
        m.truck_brand_name,
        m.menu_type,
        date_trunc('month', oh.order_ts) as sales_month
    from {{ ref('stg_order_header') }} oh
    inner join {{ ref('stg_order_details') }} od on oh.order_id = od.order_id
    inner join {{ source('tasty_bytes', 'raw_pos_menu') }} m on od.menu_item_id = m.menu_item_id
),

customers_by_truck as (
    select
        truck_brand_name,
        menu_type,
        sales_month,
        count(distinct customer_id) as unique_customers
    from order_data
    group by 1, 2, 3
)

select * from customers_by_truck
