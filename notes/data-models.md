# Data Modeling Strategy

## Bronze Layer

A Bronze layer of DBT data models are used to extract inspections and establishment information from the database.

### Inspections

Inspections are a transactional table that represent specific inspection events conducted at vendors around the city in question.

A composite key strategy is used to create a unique inspection identifier based on the inspection date, inspection type, and establishment id.

Business logic is applied to the inspection details to categorize the inspection as a 'Pass' or 'Fail' - the business logic applied to each city's dataset is different.

Chicago's inspections are clear with whether the result of the inspection is a pass and indicates it as such.

NYC indicates whether violations were found as a result of the inspection and / or whether the result of the inspection 'opened' the business or 'closed' it.

SF similarly does not offer a clear 'Pass' / 'Fail' label but does indicate if the business was closed as a result of the inspection.


### Establishments

Establishments are a dimensional table that represent the businesses upon which the inspections were performed.

Bronze-level modeling of this data is slightly easier to manage than inspections since each record already has a unique `establishment_id` (mapped to `business_id`)

Additionally, names of the businesses and their addresses are also included for each dimension. 

Business address components are transformed into a singular attribute `business_address`


## Silver Layer

### Establishment Inspections

Inspections are joined to the establishments to enrich each inspection fact with the establishment dimension.

For each city, establishment inspections are presented in this silver level format to show the inspection details along with the business name and address.


## Gold Layer

As a final presentation to business stakeholders, each establishment inspection model from each city is unioned together to provide a unified view of inspections across the three metropolitan areas: Chicago, NYC, and SF.

Each record is tagged with the appropriate city for easy filtering.

## Reporting Layer

### Inspection Metrics Calculated
Inspection metrics are calculated along a few different axes for the business stakeholder's analysis.

Total inspections along with percentage of passes are calculated along each of the following dimensions:

* City
* Business
* Date

This reporting layer may be used to develop risk assessment models based on inspection results.
