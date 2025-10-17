with source as (
    select * from {{ source('tasty_bytes', 'raw_pos_truck') }}
),

cleaned as (
    select
        truck_id,
        truck_brand_name,
        truck_name,
        city,
        country,
        latitude,
        longitude,
        _fivetran_synced as loaded_at,
        -- Add geographic region logic
        case 
            when country = 'United States' then 'North America'
            when country in ('Canada', 'Mexico') then 'North America'
            when country in ('United Kingdom', 'France', 'Germany', 'Spain', 'Italy') then 'Europe'
            else 'Other'
        end as region,
        -- Create full truck identifier
        concat(truck_brand_name, ' - ', truck_name) as full_truck_name
    from source
    where truck_id is not null
)

select * from cleaned
