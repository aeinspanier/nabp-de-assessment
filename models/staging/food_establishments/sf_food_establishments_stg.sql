{{ config(materialized='table') }}

with source as (
    select 
      "permit_id" as permit_id,
      "permit_type" as permit_type,
      "dba" as dba,
      "street_address" as street_address,
      "data_as_of" as data_as_of,
      "ingestion_time" as ingestion_time
    from {{ source('raw', 'sf_food_establishments') }}
),
standardize as (
    select
      CAST(permit_id AS VARCHAR) as business_id,
      dba as business_name,
      street_address as business_address,
      ingestion_time
    from source
),
transform as (
    select
      business_id,
      business_name,
      business_address,
      ingestion_time
    from standardize
),
final as (
    select
      business_id,
      business_name,
      business_address,
      ingestion_time
    from transform
)

select * from final
