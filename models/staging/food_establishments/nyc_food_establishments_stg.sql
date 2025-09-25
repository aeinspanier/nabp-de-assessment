with source as (
    select *
    from {{ source('raw', 'nyc_food_establishments') }}
),
standardize as (
    select *
    from source
),
transform as (
    select *
    from standardize
),
final as (
    select *
    from transform
)

select * from final
