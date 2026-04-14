CREATE TABLE IF NOT EXISTS raw_sales_phases (
    lead_id                     VARCHAR(50),
    zipcode                     VARCHAR(10),
    current_phase               VARCHAR(100),
    financing_type              VARCHAR(100),
    installation_price          DECIMAL(12,2),
    offer_sent_date             VARCHAR(20),
    project_validation_date     VARCHAR(20),
    ko_date                     VARCHAR(20),
    ko_reason                   VARCHAR(255),
    sale_dismissal_date         VARCHAR(20),
    created_at                  VARCHAR(20),
    _loaded_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw_zipcode (
    zipcode VARCHAR(5) PRIMARY KEY,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    autonomous_community VARCHAR(100),
    autonomous_community_nk VARCHAR(20),
    province VARCHAR(100)
);

CREATE TABLE raw_weather (
    zipcode VARCHAR(5),
    date DATETIME,
    temperature DECIMAL(10,4),
    relative_humidity DECIMAL(10,4),
    precipitation_rate DECIMAL(10,4),
    wind_speed DECIMAL(10,4),
    PRIMARY KEY (zipcode, date)
);

CREATE TABLE IF NOT EXISTS dim_zipcode (
    zipcode                     VARCHAR(10) PRIMARY KEY,
    province                    VARCHAR(100),
    city                        VARCHAR(100),
    region                      VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS sales_phases_ft (
    lead_id                     VARCHAR(50) PRIMARY KEY,
    zipcode                     VARCHAR(10),
    current_phase               VARCHAR(100),
    financing_type              VARCHAR(100),
    installation_price          DECIMAL(12,2),
    offer_sent_date             DATE,
    project_validation_date     DATE,
    ko_date                     DATE,
    ko_reason                   VARCHAR(255),
    sale_dismissal_date         DATE,
    created_at                  DATE,
    CONSTRAINT fk_sales_zipcode FOREIGN KEY (zipcode)
        REFERENCES dim_zipcode(zipcode)
);
