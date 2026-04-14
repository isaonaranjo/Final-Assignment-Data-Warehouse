import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

CSV_PATH = os.getenv("WEATHER_CSV", "data/meteo_eae.csv")
DATABASE_URL = os.getenv("DATABASE_URL")

CHUNK_SIZE = 50000

def transform_chunk(df: pd.DataFrame) -> pd.DataFrame:
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]

    required_cols = [
        "zipcode",
        "date",
        "temperature",
        "relative_humidity",
        "precipitation_rate",
        "wind_speed",
    ]

    missing = [c for c in required_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Faltan columnas en weather CSV: {missing}")

    df["zipcode"] = df["zipcode"].astype(str).str.zfill(5)
    df["date"] = pd.to_datetime(df["date"], errors="coerce")

    numeric_cols = [
        "temperature",
        "relative_humidity",
        "precipitation_rate",
        "wind_speed",
    ]

    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    df = df[required_cols]

    df = df.dropna(subset=["zipcode", "date"])

    return df


def load() -> None:
    print(f"Leyendo {CSV_PATH} por bloques de {CHUNK_SIZE:,} filas...")

    engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True,
    )

    total_inserted = 0

    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE raw_weather"))

    for i, chunk in enumerate(
        pd.read_csv(CSV_PATH, sep=";", dtype=str, chunksize=CHUNK_SIZE),
        start=1,
    ):
        chunk = transform_chunk(chunk)

        with engine.begin() as conn:
            chunk.to_sql(
                "raw_weather",
                conn,
                if_exists="append",
                index=False,
                chunksize=5000,
                method="multi",
            )

        total_inserted += len(chunk)
        print(f"Chunk {i}: insertadas {len(chunk):,} filas | total {total_inserted:,}")

    print("✅ raw_weather cargada correctamente.")


if __name__ == "__main__":
    load()