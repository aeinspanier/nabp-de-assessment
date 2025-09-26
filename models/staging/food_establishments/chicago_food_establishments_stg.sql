{{  config(materialized='table')  }}

with source as (
    select 
      "Establishment ID" as establishment_id,
      "DBA Name" as dba_name,
      "Facility Type" as facility_type,
      "Address" as address,
      "City" as city,
      "State" as state,
      "Zip" as zip,
      "ingestion_time" as ingestion_time      
    from {{ source('raw', 'chicago_food_establishments') }}
),
standardize as (
    select
      CAST(CAST(establishment_id AS BIGINT) AS VARCHAR) as business_id,
      dba_name as business_name,
      address,
      city,
      state,
      CAST(CAST(zip AS INTEGER) AS VARCHAR) as zip,
      ingestion_time
    from source
),
transform as (
    select
      business_id,
      business_name,
      CONCAT(address, ' ', city, ' ', state, ' ', zip) as business_address,
      ingestion_time
    from standardize
),
final as (
    select
      business_id,
      business_name,
      business_address,
      ingestion_time as last_updated_at
    from transform
)

select * from final
