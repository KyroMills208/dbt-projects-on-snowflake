with source as (
    select * from {{ source('tasty_bytes', 'raw_pos_order_detail') }}
),

cleaned as (
    select
        order_id,
        menu_item_id,
        quantity,
        price,
        line_total,
        _fivetran_synced as loaded_at,
        -- Add business calculations
        case 
            when quantity >= 5 then 'Bulk Purchase'
            when quantity >= 3 then 'Multi-Item'
            when quantity = 2 then 'Pair'
            else 'Single'
        end as purchase_type,
        -- Calculate unit economics
        round(price, 2) as unit_price_rounded,
        round(line_total, 2) as line_total_rounded,
        -- Add validation flags
        case 
            when line_total = (quantity * price) then true
            else false
        end as line_total_valid,
        -- Add price tier
        case 
            when price >= 20 then 'Premium'
            when price >= 10 then 'Standard'
            when price >= 5 then 'Budget'
            else 'Value'
        end as price_tier
    from source
    where order_id is not null
)

select * from cleaned
