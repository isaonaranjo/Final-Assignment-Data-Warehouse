{{ config(materialized='table') }}

SELECT
    STR_TO_DATE(DATE_FORMAT(offer_sent_date, '%Y-%m-01'), '%Y-%m-%d') AS month,
    COUNT(*) AS total_leads,
    SUM(is_converted) AS total_converted,
    ROUND(SUM(is_converted) / NULLIF(COUNT(*), 0), 4) AS conversion_rate,
    SUM(is_ko) AS total_ko,
    ROUND(SUM(is_ko) / NULLIF(COUNT(*), 0), 4) AS ko_rate,
    SUM(is_dismissed) AS total_dismissed,
    ROUND(SUM(is_dismissed) / NULLIF(COUNT(*), 0), 4) AS dismissal_rate,
    ROUND(AVG(installation_price), 2) AS avg_price
FROM {{ ref('fct_sales_phases') }}
WHERE offer_sent_date IS NOT NULL
GROUP BY 1
ORDER BY 1