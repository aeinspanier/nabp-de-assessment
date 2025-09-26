{{ config(
            materialized='table',
            unique_key=['inspection_id'],
            tags=['inspections', 'staging', 'bronze', 'nyc']
) }}

with source as (
    select 
      "INSPECTION DATE" as inspection_date,
      "INSPECTION TYPE" as inspection_type,
      "ESTABLISHMENT ID" as establishment_id,
      "ACTION" as action,
      "CRITICAL FLAG" as critical_flag,
      "SCORE" as score,
      "GRADE" as grade,
      "VIOLATION CODE" as violation_code,
      "VIOLATION DESCRIPTION" as violation_description,
      "RECORD DATE" as record_date,
      "ingestion_time" as ingestion_time
    from {{ source('raw', 'nyc_inspections') }}
),
standardize as (
    select distinct 
      CONCAT(CAST(inspection_date AS VARCHAR), '::', inspection_type, '::', establishment_id) as inspection_id,
      inspection_date,
      inspection_type,
      establishment_id as business_id,
      LOWER(action) as action,
      ingestion_time,
    from source
),
transform as (
    select
      inspection_id,
      inspection_date,
      inspection_type,
      business_id,
      CASE
        WHEN action LIKE '%opened%' OR action LIKE '%no violations%' THEN 'PASS'
        WHEN action LIKE '%violations were cited%' OR action LIKE '%closed%' THEN 'FAIL'
        ELSE 'UNKNOWN'
      END AS inspection_status,
      ingestion_time
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
