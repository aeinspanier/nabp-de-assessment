{{ config(materialized='table') }}

with chicago_establishment_inspections as (
  select
    'CHICAGO' as city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    last_updated_at as inspection_last_updated
  from {{ ref('chicago_establishment_inspections_inter') }} 
)


, nyc_establishment_inspections as (
  select
    'NYC' as city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    last_updated_at as inspection_last_updated
  from {{ ref('nyc_establishment_inspections_inter') }} 
)


, sf_establishment_inspections as (
  select
    'SF' as city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    last_updated_at as inspection_last_updated
  from {{ ref('sf_establishment_inspections_inter') }} 
)

, final as (
  select 
    city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    inspection_last_updated
  from chicago_establishment_inspections

  UNION ALL

  select 
    city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    inspection_last_updated
  from nyc_establishment_inspections

  UNION ALL

  select
    city_tag,
    business_id,
    inspection_id,
    business_name,
    inspection_status,
    business_address,
    inspection_date,
    inspection_type,
    inspection_last_updated
  from sf_establishment_inspections
)


select * from final
