with source as (
    select * from {{ source('tasty_bytes', 'raw_customer') }}
),

cleaned as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        city,
        country,
        preferred_language,
        customer_segment,
        signup_date,
        _fivetran_synced as loaded_at,
        -- Add some business logic
        case 
            when customer_segment = 'Platinum' then 'High Value'
            when customer_segment = 'Gold' then 'High Value'
            when customer_segment = 'Silver' then 'Medium Value'
            else 'Standard'
        end as value_tier,
        -- Calculate customer age in days
        datediff('day', signup_date, current_date()) as customer_age_days
    from source
    where customer_id is not null
)

select * from cleaned
