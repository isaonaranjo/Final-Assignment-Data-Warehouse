WITH source AS (
    SELECT * FROM {{ source('raw', 'raw_zipcode') }}
)

SELECT DISTINCT
    LPAD(TRIM(zipcode), 5, '0') AS zipcode,
    TRIM(province) AS province,
    TRIM(autonomous_community) AS autonomous_community,
    CAST(latitude AS DECIMAL(10,6)) AS latitude,
    CAST(longitude AS DECIMAL(10,6)) AS longitude
FROM source
WHERE zipcode IS NOT NULL
  AND TRIM(zipcode) <> ''