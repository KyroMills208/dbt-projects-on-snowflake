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
        _fivetran_synced as loaded_at
    from source
    where order_id is not null
)

select * from cleaned
