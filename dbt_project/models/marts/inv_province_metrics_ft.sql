-- models/marts/inv_province_metrics_ft.sql
{{
  config(materialized='table')
}}

SELECT
    z.province,
    COUNT(*)                                                                 AS total_leads,
    SUM(s.is_converted)                                                      AS total_converted,
    ROUND(SUM(s.is_converted) * 1.0 / NULLIF(COUNT(*), 0), 4)               AS conversion_rate,
    SUM(s.is_ko)                                                             AS total_ko,
    ROUND(SUM(s.is_ko) * 1.0 / NULLIF(COUNT(*), 0), 4)                      AS ko_rate,
    ROUND(AVG(s.installation_price), 2)                                      AS avg_price
FROM {{ ref('fct_sales_phases') }} s
LEFT JOIN {{ ref('dim_zipcode') }} z ON s.zipcode = z.zipcode
GROUP BY z.province
ORDER BY conversion_rate DESC
