-- Customer Retention Analysis
-- This analysis shows customer retention patterns and cohort analysis
-- Run with: dbt compile --select customer_retention_analysis

with customer_orders as (
    select 
        customer_id,
        first_name,
        last_name,
        customer_segment,
        value_tier,
        order_date,
        order_id,
        total_spent,
        row_number() over (partition by customer_id order by order_date) as order_sequence
    from {{ ref('int_order_items') }}
),

customer_cohorts as (
    select
        customer_id,
        first_name,
        last_name,
        customer_segment,
        value_tier,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(distinct order_id) as total_orders,
        sum(total_spent) as total_spent,
        datediff('day', min(order_date), max(order_date)) as customer_lifespan_days
    from customer_orders
    group by 1, 2, 3, 4, 5
),

monthly_cohorts as (
    select
        customer_id,
        first_name,
        last_name,
        customer_segment,
        value_tier,
        first_order_date,
        last_order_date,
        total_orders,
        total_spent,
        customer_lifespan_days,
        date_trunc('month', first_order_date) as cohort_month,
        datediff('month', first_order_date, current_date()) as months_since_first_order
    from customer_cohorts
),

retention_analysis as (
    select
        cohort_month,
        customer_segment,
        value_tier,
        count(distinct customer_id) as cohort_size,
        count(distinct case when months_since_first_order >= 1 then customer_id end) as month_1_retained,
        count(distinct case when months_since_first_order >= 3 then customer_id end) as month_3_retained,
        count(distinct case when months_since_first_order >= 6 then customer_id end) as month_6_retained,
        count(distinct case when months_since_first_order >= 12 then customer_id end) as month_12_retained,
        avg(total_orders) as avg_orders_per_customer,
        avg(total_spent) as avg_spent_per_customer,
        avg(customer_lifespan_days) as avg_customer_lifespan_days
    from monthly_cohorts
    group by 1, 2, 3
)

select
    cohort_month,
    customer_segment,
    value_tier,
    cohort_size,
    month_1_retained,
    month_3_retained,
    month_6_retained,
    month_12_retained,
    round((month_1_retained::float / cohort_size) * 100, 2) as month_1_retention_rate,
    round((month_3_retained::float / cohort_size) * 100, 2) as month_3_retention_rate,
    round((month_6_retained::float / cohort_size) * 100, 2) as month_6_retention_rate,
    round((month_12_retained::float / cohort_size) * 100, 2) as month_12_retention_rate,
    round(avg_orders_per_customer, 2) as avg_orders_per_customer,
    round(avg_spent_per_customer, 2) as avg_spent_per_customer,
    round(avg_customer_lifespan_days, 0) as avg_customer_lifespan_days
from retention_analysis
order by cohort_month desc, customer_segment, value_tier
