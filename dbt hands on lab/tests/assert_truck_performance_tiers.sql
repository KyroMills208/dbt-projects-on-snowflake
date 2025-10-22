-- Custom test to ensure truck performance tiers are correctly assigned
-- This test validates that performance tier assignments match revenue thresholds

select
    truck_id,
    total_revenue,
    performance_tier
from {{ ref('truck_performance') }}
where 
    (performance_tier = 'High Performer' and total_revenue < 50000) or
    (performance_tier = 'Medium Performer' and (total_revenue < 20000 or total_revenue >= 50000)) or
    (performance_tier = 'Low Performer' and (total_revenue < 5000 or total_revenue >= 20000)) or
    (performance_tier = 'Underperforming' and total_revenue >= 5000)
