-- Truck Performance Analysis
-- This analysis shows detailed truck performance metrics and trends
-- Run with: dbt compile --select truck_performance_analysis

with truck_metrics as (
    select * from {{ ref('truck_performance') }}
),

truck_rankings as (
    select
        truck_id,
        truck_brand_name,
        truck_name,
        truck_region,
        total_revenue,
        total_orders,
        unique_customers,
        orders_per_day,
        revenue_per_day,
        revenue_per_customer,
        performance_tier,
        days_in_operation,
        
        -- Rankings within region
        rank() over (partition by truck_region order by total_revenue desc) as revenue_rank_in_region,
        rank() over (partition by truck_region order by orders_per_day desc) as efficiency_rank_in_region,
        rank() over (partition by truck_region order by unique_customers desc) as customer_rank_in_region,
        
        -- Rankings within brand
        rank() over (partition by truck_brand_name order by total_revenue desc) as revenue_rank_in_brand,
        rank() over (partition by truck_brand_name order by orders_per_day desc) as efficiency_rank_in_brand,
        
        -- Overall rankings
        rank() over (order by total_revenue desc) as overall_revenue_rank,
        rank() over (order by orders_per_day desc) as overall_efficiency_rank,
        rank() over (order by unique_customers desc) as overall_customer_rank
        
    from truck_metrics
),

performance_insights as (
    select
        *,
        case 
            when revenue_rank_in_region = 1 then 'Top Performer in Region'
            when revenue_rank_in_region <= 3 then 'Top 3 in Region'
            when revenue_rank_in_region <= 5 then 'Top 5 in Region'
            else 'Below Top 5 in Region'
        end as regional_performance_status,
        
        case 
            when efficiency_rank_in_region = 1 then 'Most Efficient in Region'
            when efficiency_rank_in_region <= 3 then 'Top 3 Efficiency in Region'
            when efficiency_rank_in_region <= 5 then 'Top 5 Efficiency in Region'
            else 'Below Top 5 Efficiency in Region'
        end as regional_efficiency_status,
        
        case 
            when overall_revenue_rank <= 5 then 'Top 5 Overall'
            when overall_revenue_rank <= 10 then 'Top 10 Overall'
            when overall_revenue_rank <= 20 then 'Top 20 Overall'
            else 'Below Top 20 Overall'
        end as overall_performance_status
        
    from truck_rankings
)

select
    truck_id,
    truck_brand_name,
    truck_name,
    truck_region,
    performance_tier,
    total_revenue,
    total_orders,
    unique_customers,
    orders_per_day,
    revenue_per_day,
    revenue_per_customer,
    days_in_operation,
    revenue_rank_in_region,
    efficiency_rank_in_region,
    customer_rank_in_region,
    revenue_rank_in_brand,
    efficiency_rank_in_brand,
    overall_revenue_rank,
    overall_efficiency_rank,
    overall_customer_rank,
    regional_performance_status,
    regional_efficiency_status,
    overall_performance_status
from performance_insights
order by total_revenue desc
