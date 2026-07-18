from kafka import KafkaConsumer
from sqlalchemy import create_engine, text
from urllib.parse import quote_plus
import json
import math

# -------------------------------
# MySQL Connection
# -------------------------------
username = "root"
password = quote_plus("sanyukta@1609")
host = "localhost"
port = "3306"
database = "blinkit_db"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
)

# -------------------------------
# Kafka Consumer
# -------------------------------
consumer = KafkaConsumer(
    "blinkit-sales",
    bootstrap_servers="localhost:9092",
    auto_offset_reset="latest",
    value_deserializer=lambda x: json.loads(x.decode("utf-8"))
)

print("🎧 Waiting for Blinkit streaming data...\n")

# -------------------------------
# Consume & Insert
# -------------------------------
conn = engine.connect()

for message in consumer:

    data = message.value

    # Convert NaN to None
    for key, value in data.items():
        if isinstance(value, float) and math.isnan(value):
            data[key] = None

    conn.execute(
        text("""
        INSERT INTO blinkit_sales_stream
        (`Item Fat Content`,
         `Item Identifier`,
         `Item Type`,
         `Outlet Establishment Year`,
         `Outlet Identifier`,
         `Outlet Location Type`,
         `Outlet Size`,
         `Outlet Type`,
         `Item Visibility`,
         `Item Weight`,
         `Sales`,
         `Rating`)
        VALUES
        (:fat,
         :id,
         :type,
         :year,
         :outlet_id,
         :location,
         :size,
         :outlet_type,
         :visibility,
         :weight,
         :sales,
         :rating)
        """),
        {
            "fat": data["Item Fat Content"],
            "id": data["Item Identifier"],
            "type": data["Item Type"],
            "year": data["Outlet Establishment Year"],
            "outlet_id": data["Outlet Identifier"],
            "location": data["Outlet Location Type"],
            "size": data["Outlet Size"],
            "outlet_type": data["Outlet Type"],
            "visibility": data["Item Visibility"],
            "weight": data["Item Weight"],
            "sales": data["Sales"],
            "rating": data["Rating"],
        }
    )

    conn.commit()

    print(f"✅ Inserted: {data['Item Identifier']}")