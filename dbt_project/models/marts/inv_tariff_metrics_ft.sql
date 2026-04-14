-- models/marts/inv_tariff_metrics_ft.sql
{{
  config(materialized='table')
}}

SELECT
    financing_type,
    COUNT(*)                                                                 AS total_leads,
    SUM(is_converted)                                                        AS total_converted,
    ROUND(SUM(is_converted) * 1.0 / NULLIF(COUNT(*), 0), 4)                 AS conversion_rate,
    ROUND(AVG(installation_price), 2)                                        AS avg_price,
    ROUND(SUM(is_ko) * 1.0 / NULLIF(COUNT(*), 0), 4)                        AS ko_rate
FROM {{ ref('fct_sales_phases') }}
GROUP BY financing_type
