-- 1. Monthly total leads
SELECT
    month,
    total_leads
FROM sales_dw.inv_monthly_kpi_ft
ORDER BY month;


-- 2. Monthly conversion rate
SELECT
    month,
    conversion_rate
FROM sales_dw.inv_monthly_kpi_ft
ORDER BY month;


-- 3. Monthly KO rate
SELECT
    month,
    ko_rate
FROM sales_dw.inv_monthly_kpi_ft
ORDER BY month;


-- 4. Conversion rate by province
SELECT
    province,
    total_leads,
    total_converted,
    conversion_rate
FROM sales_dw.inv_province_metrics_ft
ORDER BY conversion_rate DESC;


-- 5. Performance by financing type
SELECT
    financing_type,
    total_leads,
    total_converted,
    conversion_rate,
    avg_price,
    ko_rate
FROM sales_dw.inv_tariff_metrics_ft
ORDER BY conversion_rate DESC;