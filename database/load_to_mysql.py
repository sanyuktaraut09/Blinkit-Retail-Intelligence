import pandas as pd
from sqlalchemy import create_engine

# Load the enriched dataset
df = pd.read_csv("data/cleaned/blinkit_enriched.csv")

# MySQL connection
username = "root"
password = "sanyukta@1609"
host = "localhost"
port = "3306"
database = "blinkit_db"

from urllib.parse import quote_plus

password = quote_plus("sanyukta@1609")

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
)

# Load data into MySQL
df.to_sql(
    name="blinkit_sales",
    con=engine,
    if_exists="replace",
    index=False
)

print("✅ Data loaded successfully into MySQL!")