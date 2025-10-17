with source as (
    select * from {{ source('tasty_bytes', 'raw_pos_order_header') }}
),

cleaned as (
    select
        order_id,
        truck_id,
        order_ts,
        customer_id,
        order_amount,
        order_discount,
        order_tax,
        order_net_total,
        _fivetran_synced as loaded_at,
        -- Add business logic
        case 
            when order_amount >= 100 then 'Large Order'
            when order_amount >= 50 then 'Medium Order'
            when order_amount >= 20 then 'Small Order'
            else 'Micro Order'
        end as order_size_category,
        -- Calculate discount percentage
        case 
            when order_amount > 0 then round((order_discount / order_amount) * 100, 2)
            else 0
        end as discount_percentage,
        -- Add time-based fields
        date_trunc('day', order_ts) as order_date,
        date_trunc('hour', order_ts) as order_hour,
        dayname(order_ts) as day_of_week,
        case 
            when dayofweek(order_ts) in (0, 6) then true 
            else false 
        end as is_weekend,
        -- Add fiscal quarter
        case 
            when month(order_ts) in (1, 2, 3) then 'Q1'
            when month(order_ts) in (4, 5, 6) then 'Q2'
            when month(order_ts) in (7, 8, 9) then 'Q3'
            else 'Q4'
        end as fiscal_quarter
    from source
    where order_id is not null
)

select * from cleaned
