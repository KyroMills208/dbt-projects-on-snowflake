-- Custom test to ensure revenue calculations are consistent
-- This test will fail if there are any data quality issues with revenue calculations

select
    order_id,
    sum(line_total) as calculated_total,
    order_net_total as expected_total,
    abs(sum(line_total) - order_net_total) as difference
from {{ ref('int_order_items') }}
group by order_id, order_net_total
having abs(sum(line_total) - order_net_total) > 0.01
