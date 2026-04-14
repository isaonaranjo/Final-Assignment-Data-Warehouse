{{
    config(
        materialized='table'
    )
}}

SELECT
    s.lead_id,
    s.zipcode,
    s.current_phase,
    s.financing_type,
    s.phase_pre_ko,
    s.is_modified,
    s.offer_sent_date,
    s.contract_1_dispatch_date,
    s.contract_2_dispatch_date,
    s.contract_1_signature_date,
    s.contract_2_signature_date,
    s.visit_date,
    s.technical_review_date,
    s.project_validation_date,
    s.sale_dismissal_date,
    s.ko_date,
    s.visiting_company,
    s.ko_reason,
    s.installation_peak_power_kw,
    s.installation_price,
    s.n_panels,
    s.customer_type,
    CASE WHEN s.project_validation_date IS NOT NULL THEN 1 ELSE 0 END AS is_converted,
    CASE WHEN s.ko_date IS NOT NULL THEN 1 ELSE 0 END AS is_ko,
    CASE WHEN s.sale_dismissal_date IS NOT NULL THEN 1 ELSE 0 END AS is_dismissed
FROM {{ ref('stg_sales_phases') }} s
LEFT JOIN {{ ref('dim_zipcode') }} z
    ON s.zipcode = z.zipcode