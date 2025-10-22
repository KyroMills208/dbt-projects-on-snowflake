{{
    config(
        materialized='ephemeral'
    )
}}

-- Intermediate model that combines order details with menu and order header info
-- This won't be materialized as a table, just used in other models

with order_details as (
    select * from {{ ref('stg_order_details') }}
),

order_headers as (
    select * from {{ ref('stg_order_header') }}
),

menu_items as (
    select * from {{ ref('stg_menu') }}
),

trucks as (
    select * from {{ ref('stg_trucks') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
)

select
    od.order_id,
    od.menu_item_id,
    od.quantity,
    od.price,
    od.line_total,
    od.purchase_type,
    od.price_tier,
    od.line_total_valid,
    
    -- Order context
    oh.order_ts,
    oh.order_date,
    oh.order_hour,
    oh.day_of_week,
    oh.is_weekend,
    oh.fiscal_quarter,
    oh.order_size_category,
    oh.discount_percentage,
    oh.order_amount,
    oh.order_net_total,
    
    -- Menu context
    mi.menu_type,
    mi.truck_brand_name,
    mi.item_category,
    mi.item_name,
    mi.item_type,
    mi.standardized_item_name,
    
    -- Truck context
    t.truck_name,
    t.city as truck_city,
    t.country as truck_country,
    t.region as truck_region,
    t.full_truck_name,
    
    -- Customer context
    c.first_name,
    c.last_name,
    c.customer_segment,
    c.value_tier,
    c.customer_age_days,
    c.city as customer_city,
    c.country as customer_country,
    c.preferred_language,
    
    -- Calculated fields
    case 
        when oh.is_weekend then 'Weekend'
        else 'Weekday'
    end as day_type,
    
    case 
        when hour(oh.order_ts) between 6 and 11 then 'Morning'
        when hour(oh.order_ts) between 12 and 17 then 'Afternoon'
        when hour(oh.order_ts) between 18 and 21 then 'Evening'
        else 'Late Night'
    end as time_of_day

from order_details od
inner join order_headers oh on od.order_id = oh.order_id
inner join menu_items mi on od.menu_item_id = mi.menu_item_id
inner join trucks t on oh.truck_id = t.truck_id
inner join customers c on oh.customer_id = c.customer_id
