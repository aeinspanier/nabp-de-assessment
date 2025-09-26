{{ config(materialized='table') }}

with source as (
    select
      "Inspection Date" as inspection_date,
      "Inspection Type" as inspection_type,
      "Establishment ID" as establishment_id,
      "Risk" as risk,
      "Results" as results,
      "Violations" as violations,
      "ingestion_time" as ingestion_time
    from {{ source('raw', 'chicago_inspections') }}
),
standardize as (
    select distinct
      CONCAT(CAST(inspection_date AS VARCHAR), '::', inspection_type, '::', establishment_id) as inspection_id,
      inspection_date,
      inspection_type,
      establishment_id as business_id,
      results,
      ingestion_time      
    from source
    where results IS NOT NULL
),
transform as (
    select
      inspection_id,
      inspection_date,
      inspection_type,
      business_id,
      CASE 
        WHEN LOWER(results) LIKE '%pass%' THEN 'PASS'
        ELSE 'FAIL'
      END AS inspection_status,
      ingestion_time,
    from standardize
),
final as (
    select
      inspection_id,
      inspection_date,
      inspection_type,
      business_id,
      inspection_status,
      ingestion_time as last_updated_at
    from transform
)

select * from final
