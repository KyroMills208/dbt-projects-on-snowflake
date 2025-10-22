{{
    config(
        materialized='table',
        cluster_by=['truck_region', 'truck_brand_name']
    )
}}

-- Truck performance and operational analytics
with order_items as (
    select * from {{ ref('int_order_items') }}
),

truck_metrics as (
    select
        truck_id,
        truck_brand_name,
        truck_name,
        truck_city,
        truck_country,
        truck_region,
        full_truck_name,
        
        -- Order metrics
        count(distinct order_id) as total_orders,
        count(distinct order_date) as active_days,
        sum(quantity) as total_items_sold,
        sum(line_total) as total_revenue,
        avg(line_total) as avg_order_value,
        max(order_ts) as last_order_date,
        min(order_ts) as first_order_date,
        
        -- Customer metrics
        count(distinct customer_id) as unique_customers,
        count(distinct case when value_tier = 'High Value' then customer_id end) as high_value_customers,
        
        -- Product metrics
        count(distinct menu_item_id) as menu_items_offered,
        count(distinct menu_type) as menu_types_offered,
        count(distinct item_category) as categories_offered,
        
        -- Time-based performance
        count(distinct case when is_weekend then order_id end) as weekend_orders,
        count(distinct case when not is_weekend then order_id end) as weekday_orders,
        count(distinct case when time_of_day = 'Morning' then order_id end) as morning_orders,
        count(distinct case when time_of_day = 'Afternoon' then order_id end) as afternoon_orders,
        count(distinct case when time_of_day = 'Evening' then order_id end) as evening_orders,
        
        -- Price analysis
        avg(price) as avg_item_price,
        min(price) as min_item_price,
        max(price) as max_item_price,
        count(distinct case when price_tier = 'Premium' then order_id end) as premium_orders,
        count(distinct case when price_tier = 'Budget' then order_id end) as budget_orders,
        
        -- Purchase patterns
        avg(quantity) as avg_items_per_order,
        count(distinct case when purchase_type = 'Bulk Purchase' then order_id end) as bulk_orders
        
    from order_items
    group by 1, 2, 3, 4, 5, 6, 7
),

truck_performance as (
    select
        *,
        -- Calculate operational metrics
        case 
            when active_days > 0 then total_orders / active_days
            else 0
        end as orders_per_day,
        
        case 
            when active_days > 0 then total_revenue / active_days
            else 0
        end as revenue_per_day,
        
        case 
            when unique_customers > 0 then total_orders / unique_customers
            else 0
        end as orders_per_customer,
        
        case 
            when unique_customers > 0 then total_revenue / unique_customers
            else 0
        end as revenue_per_customer,
        
        -- Calculate days in operation
        datediff('day', first_order_date, current_date()) as days_in_operation,
        
        -- Performance tiers
        case 
            when total_revenue >= 50000 then 'High Performer'
            when total_revenue >= 20000 then 'Medium Performer'
            when total_revenue >= 5000 then 'Low Performer'
            else 'Underperforming'
        end as performance_tier,
        
        -- Customer acquisition efficiency
        case 
            when days_in_operation > 0 then unique_customers / days_in_operation
            else 0
        end as customers_per_day,
        
        -- Revenue consistency
        case 
            when active_days > 7 then total_revenue / active_days
            else 0
        end as daily_revenue_avg
        
    from truck_metrics
)

select * from truck_performance
