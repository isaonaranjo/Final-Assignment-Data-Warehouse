CREATE INDEX idx_spft_zipcode         ON sales_phases_ft(zipcode);
CREATE INDEX idx_spft_validation_date ON sales_phases_ft(project_validation_date);
CREATE INDEX idx_spft_ko_date         ON sales_phases_ft(ko_date);
CREATE INDEX idx_spft_current_phase   ON sales_phases_ft(current_phase);
CREATE INDEX idx_spft_offer_sent      ON sales_phases_ft(offer_sent_date);

CREATE INDEX idx_weather_zipcode ON raw_weather(zipcode);
CREATE INDEX idx_weather_date    ON raw_weather(date);
CREATE INDEX idx_raw_zipcode     ON raw_zipcode(zipcode);
