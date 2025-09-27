{{ config(
            materialized='table',
            unique_key=['inspection_id'],
            tags=['reporting', 'inspection_metrics', 'business']
) }}

with source as (
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
  from {{ ref('health_inspections_inter') }}
)

, aggregated as (
  select
    business_name,
    city_tag as city,
    count(distinct inspection_id) as total_inspections,
    count(case when inspection_status = 'PASS' then 1 end) as passing_inspections,
    count(case when inspection_status = 'FAIL' then 1 end) as failing_inspections,
    count(case when inspection_status = 'UNKNOWN' then 1 end) as inconclusive_inspections
  from source
  group by business_name, city
)

, reporting as (
  select
    business_name,
    city,
    total_inspections,
    passing_inspections,
    failing_inspections,
    inconclusive_inspections,
    (passing_inspections / total_inspections) * 100.0 as pass_rate,
    (failing_inspections / total_inspections) * 100.0 as fail_rate,
    (inconclusive_inspections / total_inspections) * 100.0 as inconclusive_rate
  from aggregated
)


, final as (
  select
    business_name,
    city,
    total_inspections,
    passing_inspections,
    failing_inspections,
    inconclusive_inspections,
    pass_rate,
    fail_rate,
    inconclusive_rate
  from reporting
)

select * from final
