-- Monthly aggregated sales data by truck brand, menu type, and item category
with order_items as (
    select * from {{ ref('int_order_items') }}
),

monthly_sales as (
    select
        truck_brand_name,
        menu_type,
        item_category,
        date_trunc('month', order_date) as sales_month,
        sum(quantity) as total_items_sold,
        sum(line_total) as total_revenue,
        count(distinct order_id) as total_orders
    from order_items
    group by 1, 2, 3, 4
)

select * from monthly_sales
