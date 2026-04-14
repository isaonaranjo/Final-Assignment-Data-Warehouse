import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

CSV_PATH = os.getenv("WEATHER_CSV", "data/meteo_eae.csv")
DATABASE_URL = os.getenv("DATABASE_URL")

def load():
    print(f"Leyendo {CSV_PATH}...")

    df = pd.read_csv(CSV_PATH, sep=";", dtype=str)

    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]

    df["zipcode"] = df["zipcode"].astype(str).str.zfill(5)
    df["date"] = pd.to_datetime(df["date"], errors="coerce")

    numeric_cols = [
        "temperature",
        "relative_humidity",
        "precipitation_rate",
        "wind_speed"
    ]

    for col in numeric_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df = df[[
        "zipcode",
        "date",
        "temperature",
        "relative_humidity",
        "precipitation_rate",
        "wind_speed"
    ]]

    print(f"Filas cargadas: {len(df)}")

    engine = create_engine(DATABASE_URL)
    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE raw_weather"))

        print("🚀 Iniciando inserción en MySQL...")

        df.to_sql(
            "raw_weather",
            conn,
            if_exists="append",
            index=False,
            chunksize=10000,
            method="multi"
        )

    print("✅ raw_weather cargada correctamente.")

if __name__ == "__main__":
    load()