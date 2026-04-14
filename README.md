# Data Warehouse - Sales Funnel (MySQL)

## Team Members
- Maria Isabel Ortiz Naranjo
- Hyerim Hong
- Arnau Oliva

## Prerequisites
- Python 3.9+
- MySQL 8.0
- dbt Core + dbt-mysql
<<<<<<< HEAD

## Quick Setup
=======
## Name: Maria Isabel Ortiz, Hyerim Hong y Arnau Oliva

## Instalation
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Configure environment variables
cp .env.example .env

# 3. Create the database if it does not exist
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS sales_dw;"

# 4. Create tables and indexes
mysql -u root -p sales_dw < sql/create_tables.sql
mysql -u root -p sales_dw < sql/create_indexes.sql

# 5. Load raw data
python scripts/load_sales_phases_raw.py
python scripts/load_weather_raw.py
python scripts/load_zipcode_raw.py

# 6. Run dbt models
cd dbt_project

# Use this profile from the current directory
export DBT_PROFILES_DIR=.

dbt run
dbt test