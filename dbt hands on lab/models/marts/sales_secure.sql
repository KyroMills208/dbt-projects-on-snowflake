{{
    config(
        materialized='view',
        secure=true,
        tags=['pii', 'governance']
    )
}}

-- Secure view with data masking for sensitive information
select
    truck_brand_name,
    menu_type,
    item_category,
    sales_month,
    total_items_sold,
    total_revenue,
    total_orders,
    -- Only show detailed revenue to authorized roles
    case 
        when current_role() in ('ACCOUNTADMIN', 'FINANCE_ROLE')
        then total_revenue
        else null
    end as detailed_revenue
from {{ ref('sales_data_by_truck') }}
