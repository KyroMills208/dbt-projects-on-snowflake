-- Custom test to ensure customer lifecycle stages are correctly calculated
-- This test validates that customer age and lifecycle stage are consistent

select
    customer_id,
    customer_age_days,
    lifecycle_stage,
    first_order_date,
    last_order_date
from {{ ref('customer_analytics') }}
where 
    (lifecycle_stage = 'New' and customer_age_days >= 30) or
    (lifecycle_stage = 'Developing' and (customer_age_days < 30 or customer_age_days >= 90)) or
    (lifecycle_stage = 'Established' and (customer_age_days < 90 or customer_age_days >= 365)) or
    (lifecycle_stage = 'Mature' and customer_age_days < 365)
