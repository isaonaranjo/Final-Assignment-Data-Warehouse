SELECT
    ROUND(SUM(CASE WHEN project_validation_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 4) AS conversion_rate
FROM sales_phases_ft;

SELECT
    ROUND(SUM(CASE WHEN ko_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 4) AS ko_rate
FROM sales_phases_ft;

SELECT
    ROUND(SUM(CASE WHEN sale_dismissal_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 4) AS dismissal_rate
FROM sales_phases_ft;

SELECT
    ROUND(AVG(installation_price), 2) AS avg_installation_price
FROM sales_phases_ft
WHERE installation_price IS NOT NULL;

SELECT
    z.province,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN s.project_validation_date IS NOT NULL THEN 1 ELSE 0 END) AS converted,
    ROUND(SUM(CASE WHEN s.project_validation_date IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 4) AS conversion_rate
FROM sales_phases_ft s
JOIN dim_zipcode z ON s.zipcode = z.zipcode
GROUP BY z.province
ORDER BY conversion_rate DESC;
