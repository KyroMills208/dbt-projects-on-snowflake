{{
    config(
        materialized='table',
        cluster_by=['customer_segment', 'value_tier']
    )
}}

-- Customer analytics and segmentation model
with order_items as (
    select * from {{ ref('int_order_items') }}
),

customer_metrics as (
    select
        customer_id,
        first_name,
        last_name,
        customer_segment,
        value_tier,
        customer_age_days,
        customer_city,
        customer_country,
        preferred_language,
        
        -- Order metrics
        count(distinct order_id) as total_orders,
        count(distinct order_date) as active_days,
        sum(quantity) as total_items_purchased,
        sum(line_total) as total_spent,
        avg(line_total) as avg_order_value,
        max(order_ts) as last_order_date,
        min(order_ts) as first_order_date,
        
        -- Product diversity
        count(distinct menu_item_id) as unique_items_purchased,
        count(distinct truck_brand_name) as brands_tried,
        count(distinct menu_type) as menu_types_tried,
        
        -- Time-based metrics
        count(distinct case when is_weekend then order_id end) as weekend_orders,
        count(distinct case when not is_weekend then order_id end) as weekday_orders,
        count(distinct case when time_of_day = 'Morning' then order_id end) as morning_orders,
        count(distinct case when time_of_day = 'Afternoon' then order_id end) as afternoon_orders,
        count(distinct case when time_of_day = 'Evening' then order_id end) as evening_orders,
        
        -- Price sensitivity
        count(distinct case when price_tier = 'Premium' then order_id end) as premium_orders,
        count(distinct case when price_tier = 'Budget' then order_id end) as budget_orders,
        avg(price) as avg_item_price,
        
        -- Purchase patterns
        count(distinct case when purchase_type = 'Bulk Purchase' then order_id end) as bulk_orders,
        count(distinct case when purchase_type = 'Single' then order_id end) as single_item_orders
        
    from order_items
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9
),

customer_segments as (
    select
        *,
        -- Calculate days since last order
        datediff('day', last_order_date, current_date()) as days_since_last_order,
        
        -- Calculate order frequency (orders per day)
        case 
            when customer_age_days > 0 then total_orders / customer_age_days
            else 0
        end as orders_per_day,
        
        -- Calculate spending per day
        case 
            when customer_age_days > 0 then total_spent / customer_age_days
            else 0
        end as spending_per_day,
        
        -- Customer lifecycle stage
        case 
            when customer_age_days < 30 then 'New'
            when customer_age_days < 90 then 'Developing'
            when customer_age_days < 365 then 'Established'
            else 'Mature'
        end as lifecycle_stage,
        
        -- Engagement level
        case 
            when total_orders >= 20 then 'High'
            when total_orders >= 10 then 'Medium'
            when total_orders >= 5 then 'Low'
            else 'Minimal'
        end as engagement_level,
        
        -- Brand loyalty
        case 
            when brands_tried = 1 then 'Loyal'
            when brands_tried <= 3 then 'Moderate'
            else 'Explorer'
        end as brand_loyalty
        
    from customer_metrics
)

select * from customer_segments
