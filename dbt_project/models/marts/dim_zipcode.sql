{{
    config(
        materialized='table'
    )
}}

SELECT DISTINCT
    zipcode,
    province,
    autonomous_community,
    latitude,
    longitude
FROM {{ ref('stg_zipcode') }}