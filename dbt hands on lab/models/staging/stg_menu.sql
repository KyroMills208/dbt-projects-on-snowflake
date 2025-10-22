with source as (
    select * from {{ source('tasty_bytes', 'raw_pos_menu') }}
),

cleaned as (
    select
        menu_item_id,
        menu_type,
        truck_brand_name,
        item_category,
        item_name,
        _fivetran_synced as loaded_at,
        -- Add business categorization
        case 
            when item_category = 'Main' then 'Food'
            when item_category = 'Dessert' then 'Food'
            when item_category = 'Beverages' then 'Drink'
            when item_category = 'Sides' then 'Food'
            when item_category = 'Appetizers' then 'Food'
            else 'Other'
        end as item_type,
        -- Create standardized item name
        upper(trim(item_name)) as standardized_item_name
    from source
    where menu_item_id is not null
)

select * from cleaned
