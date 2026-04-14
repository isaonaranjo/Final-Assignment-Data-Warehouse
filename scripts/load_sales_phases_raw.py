"""
load_sales_phases_raw.py
Carga el CSV de fases de venta en la tabla raw_sales_phases.
"""

import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

CSV_PATH = os.getenv("SALES_CSV", "data/sale_phases_funnel.csv")
DATABASE_URL = os.getenv("DATABASE_URL")

CHUNK_SIZE = 50000
INSERT_CHUNK_SIZE = 1000

def clean_zipcode(series: pd.Series) -> pd.Series:
    return series.astype(str).str.extract(r"(\d+)", expand=False).fillna("").str.zfill(5)


def clean_text(series: pd.Series) -> pd.Series:
    return series.astype(str).str.strip().replace({"": None, "nan": None, "None": None})


def transform_chunk(df: pd.DataFrame) -> pd.DataFrame:
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]

    df = df.rename(columns={
        "cusomer_type": "customer_type"
    })

    expected_columns = [
        "lead_id",
        "financing_type",
        "current_phase",
        "phase_pre_ko",
        "is_modified",
        "offer_sent_date",
        "contract_1_dispatch_date",
        "contract_2_dispatch_date",
        "contract_1_signature_date",
        "contract_2_signature_date",
        "visit_date",
        "technical_review_date",
        "project_validation_date",
        "sale_dismissal_date",
        "ko_date",
        "zipcode",
        "visiting_company",
        "ko_reason",
        "installation_peak_power_kw",
        "installation_price",
        "n_panels",
        "customer_type",
    ]

    for col in expected_columns:
        if col not in df.columns:
            df[col] = None

    text_cols = [
        "lead_id",
        "financing_type",
        "current_phase",
        "phase_pre_ko",
        "visiting_company",
        "ko_reason",
        "customer_type",
    ]

    for col in text_cols:
        df[col] = clean_text(df[col])

    df["zipcode"] = clean_zipcode(df["zipcode"])
    df["financing_type"] = df["financing_type"].str.upper()
    df["ko_reason"] = df["ko_reason"].str.title()

    date_cols = [
        "offer_sent_date",
        "contract_1_dispatch_date",
        "contract_2_dispatch_date",
        "contract_1_signature_date",
        "contract_2_signature_date",
        "visit_date",
        "technical_review_date",
        "project_validation_date",
        "sale_dismissal_date",
        "ko_date",
    ]

    for col in date_cols:
        df[col] = pd.to_datetime(df[col], errors="coerce", dayfirst=True)

    numeric_cols = [
        "installation_peak_power_kw",
        "installation_price",
        "n_panels",
    ]

    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    df["is_modified"] = (
        clean_text(df["is_modified"])
        .str.lower()
        .map({
            "yes": 1, "y": 1, "true": 1, "1": 1,
            "no": 0, "n": 0, "false": 0, "0": 0
        })
    )

    df = df[expected_columns]
    df = df.dropna(subset=["lead_id", "zipcode"])

    return df


def load() -> None:
    print(f"Leyendo {CSV_PATH} por bloques de {CHUNK_SIZE:,} filas...")

    engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True
    )

    total_inserted = 0

    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE raw_sales_phases"))

    for i, chunk in enumerate(
        pd.read_csv(CSV_PATH, sep=";", dtype=str, chunksize=CHUNK_SIZE),
        start=1
    ):
        chunk = transform_chunk(chunk)

        with engine.begin() as conn:
            chunk.to_sql(
                "raw_sales_phases",
                conn,
                if_exists="append",
                index=False,
                chunksize=INSERT_CHUNK_SIZE
            )

        total_inserted += len(chunk)
        print(f"Chunk {i}: insertadas {len(chunk):,} filas | total {total_inserted:,}")

    print("✅ raw_sales_phases cargada correctamente.")


if __name__ == "__main__":
    load()