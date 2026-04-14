WITH source AS (
    SELECT * FROM {{ source('raw', 'raw_sales_phases') }}
),

cleaned AS (
    SELECT DISTINCT
        TRIM(lead_id) AS lead_id,
        LPAD(TRIM(zipcode), 5, '0') AS zipcode,
        TRIM(current_phase) AS current_phase,
        UPPER(TRIM(financing_type)) AS financing_type,
        TRIM(phase_pre_ko) AS phase_pre_ko,
        is_modified,
        offer_sent_date,
        contract_1_dispatch_date,
        contract_2_dispatch_date,
        contract_1_signature_date,
        contract_2_signature_date,
        visit_date,
        technical_review_date,
        project_validation_date,
        sale_dismissal_date,
        ko_date,
        TRIM(visiting_company) AS visiting_company,
        TRIM(ko_reason) AS ko_reason,
        CAST(installation_peak_power_kw AS DECIMAL(10,2)) AS installation_peak_power_kw,
        CAST(installation_price AS DECIMAL(12,2)) AS installation_price,
        CAST(n_panels AS SIGNED) AS n_panels,
        TRIM(customer_type) AS customer_type
    FROM source
    WHERE lead_id IS NOT NULL
      AND TRIM(lead_id) <> ''
      AND zipcode IS NOT NULL
      AND TRIM(zipcode) <> ''
)

SELECT * FROM cleaned