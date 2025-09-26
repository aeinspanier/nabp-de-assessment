
{{ config(
            materialized='table',
            unique_key=['business_id'],
            tags=['establishments', 'staging', 'bronze', 'nyc']
) }}

with source as (
    select 
      "ESTABLISHMENT ID" as establishment_id,
      "DBA" as dba,
      "BORO" as boro,
      "BUILDING" as building,
      "STREET" as street,
      "ZIPCODE" as zipcode,
      "CUISINE DESCRIPTION" as cuisine_description,
      "ingestion_time" as ingestion_time
    from {{ source('raw', 'nyc_food_establishments') }}
),
standardize as (
    select distinct
      CAST(establishment_id AS VARCHAR) as business_id,
      dba as business_name,
      boro,
      building,
      street,
      zipcode,
      ingestion_time
    from source
),
transform as (
    select
      business_id,
      business_name,
      CONCAT(street, ' , Bldg ', building, ' ', boro, ' , New York City,  ', zipcode) as business_address,
      ROW_NUMBER() OVER (PARTITION BY business_id ORDER BY ingestion_time DESC) as ingestion_order,
      ingestion_time
    from standardize
),
final as (
    select 
      business_id,
      business_name,
      business_address,
      ROW_NUMBER() OVER (PARTITION BY business_id ORDER BY ingestion_time DESC) as ingestion_order,
      ingestion_time as last_updated_at
    from transform
    where ingestion_order=1
)

select * from final
