{{ config(
            materialized='table',
            unique_key=['inspection_id'],
            tags=['inspections', 'staging', 'bronze', 'sf']
) }}


with source as (
    select 
      "inspection_date" as inspection_date,
      "inspection_type" as inspection_type,
      "inspection_frequency_type" as inspection_frequency_type,
      "permit_id" as permit_id,
      "permit_type" as permit_type,
      "violation_count" as violation_count,
      "facility_rating_status" as facility_rating_status,
      "data_as_of" as data_as_of,
      "ingestion_time" as ingestion_time
    from {{ source('raw', 'sf_inspections') }}
),
standardize as (
    select distinct
      CAST(inspection_date AS VARCHAR) as inspection_date,
      inspection_date,
      inspection_type,
      SPLIT_PART(permit_type, ' - ', 1) as permit_code,
      permit_id as business_id,
      LOWER(facility_rating_status) as facility_rating_status,
      ingestion_time
    from source
    where violation_count is not null
),
transform as (
    select distinct
      CONCAT(CAST(inspection_date AS VARCHAR), '::', inspection_type, '::', business_id, '::', permit_code) as inspection_id,
      inspection_id,
      inspection_date,
      inspection_type,
      business_id,
      CASE
        WHEN facility_rating_status LIKE '%pass%' THEN 'PASS'
        WHEN facility_rating_status LIKE '%closure%' THEN 'FAIL'
        ELSE 'UNKNOWN'
      END AS inspection_status,
      ingestion_time as last_updated_at
    from standardize
    where permit_code is not null
  
),
final as (
    select
      inspection_id,
      inspection_date,
      inspection_type,
      business_id,
      inspection_status,
      last_updated_at
    from transform
)

select * from final
