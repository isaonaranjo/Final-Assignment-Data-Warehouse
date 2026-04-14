WITH source AS (
    SELECT * FROM {{ source('raw', 'raw_weather') }}
)

SELECT
    LPAD(TRIM(zipcode), 5, '0') AS zipcode,
    date,
    CAST(temperature AS DECIMAL(10,4)) AS temperature,
    CAST(relative_humidity AS DECIMAL(10,4)) AS relative_humidity,
    CAST(precipitation_rate AS DECIMAL(10,4)) AS precipitation_rate,
    CAST(wind_speed AS DECIMAL(10,4)) AS wind_speed
FROM source
WHERE zipcode IS NOT NULL
  AND TRIM(zipcode) <> ''
  AND date IS NOT NULL