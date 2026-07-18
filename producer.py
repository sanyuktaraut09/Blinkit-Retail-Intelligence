from kafka import KafkaProducer
import pandas as pd
import json
import time

# Connect to Kafka
producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

# Read the cleaned dataset
df = pd.read_csv("data/cleaned/blinkit_cleaned.csv")

print("🚀 Streaming Blinkit sales data...\n")

# Stream one row every second
for _, row in df.iterrows():
    producer.send("blinkit-sales", row.to_dict())
    producer.flush()

    print(f"Sent: {row['Item Identifier']}")

    time.sleep(1)

print("\n✅ Streaming completed!")