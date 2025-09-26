{{ config(materialized='table') }}


with inspections as (
  select
    inspection_id,
    inspection_date,
    inspection_type,
    business_id,
    inspection_status,
    last_updated_at as inspections_last_updated_at
  from {{ ref('chicago_inspections_stg') }}
)

, establishments as (
  select
    business_id,
    business_name,
    business_address,
    last_updated_at as establishments_last_updated_at
  from {{ ref('chicago_food_establishments_stg') }}
)

, final as (
  select
    e.business_id,
    i.inspection_id,
    e.business_name,
    i.inspection_status,
    e.business_address,
    i.inspection_date,
    i.inspection_type,
    i.inspections_last_updated_at,
    e.establishments_last_updated_at,
    CURRENT_TIMESTAMP as last_updated_at
  from establishments e 
  join inspections i 
    on e.business_id = i.business_id
)

select * from final
