# Data Warehouse - Sales Funnel (MySQL)

## Requisitos previos
- Python 3.9+
- MySQL 8.0
- dbt Core + dbt-mysql
## Nombres: Maria Isabel Ortiz, Hyerim Hong y Arnau Oliva


## Instalación rápida
```bash
# 1. Instalar dependencias
pip install -r requirements.txt

# 2. Configurar base de datos
cp .env.example .env

# 3. Crear la base si no existe
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS sales_dw;"

# 4. Crear tablas e índices
mysql -u root -p sales_dw < sql/create_tables.sql
mysql -u root -p sales_dw < sql/create_indexes.sql

# 5. Cargar datos crudos
python scripts/load_sales_phases_raw.py
python scripts/load_weather_raw.py
python scripts/load_zipcode_raw.py

# 6. Correr modelos dbt
cd dbt_project
# usa este perfil desde la carpeta actual
export DBT_PROFILES_DIR=.
dbt run
dbt test
```

## Notas importantes para MySQL
- Usa `DATABASE_URL=mysql+pymysql://...`
- El adapter de dbt para MySQL es `dbt-mysql`.
- En dbt-mysql, el campo `schema` del profile corresponde a la base de datos destino.
- Este proyecto asume MySQL 8.0 para evitar limitaciones antiguas del adapter.

## Estructura del proyecto
```text
data_warehouse_mysql/
├── data/                    ← Pon aquí tus CSVs
├── scripts/                 ← Ingesta de datos
├── dbt_project/             ← Transformaciones dbt
│   └── models/
│       ├── staging/         ← stg_*
│       └── marts/           ← fct_*, dim_*, inv_*
├── sql/                     ← DDL tablas e índices
└── README.md
```
