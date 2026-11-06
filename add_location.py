
import os
import math
import random
from datetime import datetime, timedelta

import mysql.connector
from dotenv import load_dotenv
import os

# Explicitly load the backend environment file
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ENV_PATH = os.path.join(BASE_DIR, "backend", ".env")

load_dotenv(ENV_PATH)

# --------------------------------
# 1. DATABASE CONNECTION
# --------------------------------

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        port=int(os.getenv("MYSQL_PORT", "3306")),
        user=os.getenv("MYSQL_USER", "timely_app"),
        password=os.getenv("MYSQL_PASSWORD"),
        database=os.getenv("MYSQL_DATABASE", "occupancy_list")
    )


# --------------------------------
# 2. LOCATIONS TO ADD
# --------------------------------

LOCATIONS = [
    {
        "name": "National Library Building",
        "category": "library",
        "capacity": 500
    },
    {
        "name": "Orchard Central",
        "category": "shopping_mall",
        "capacity": 800
    },
    {
        "name": "Gardens by the Bay",
        "category": "attraction",
        "capacity": 1000
    }
]


# --------------------------------
# 3. OCCUPANCY PATTERNS
# --------------------------------

# Peak periods differ depending on venue type.

PROFILES = {
    "library": {
        "base": 0.15,
        "peak": 0.65,
        "peak_time": 15
    },
    "shopping_mall": {
        "base": 0.20,
        "peak": 0.75,
        "peak_time": 17
    },
    "attraction": {
        "base": 0.15,
        "peak": 0.80,
        "peak_time": 14
    },
    "cafe": {
        "base": 0.10,
        "peak": 0.70,
        "peak_time": 12
    }
}


# --------------------------------
# 4. GENERATE OCCUPANCY RECORDS
# --------------------------------

def generate_occupancy(capacity, category):

    profile = PROFILES.get(
        category,
        PROFILES["shopping_mall"]
    )

    records = []

    # Generate records every 10 minutes.
    start = datetime.strptime("09:00", "%H:%M")
    end = datetime.strptime("22:00", "%H:%M")

    current_time = start

    while current_time <= end:

        hour = (
            current_time.hour
            + current_time.minute / 60
        )

        # Gaussian-shaped daily occupancy peak.
        peak_intensity = math.exp(
            -((hour - profile["peak_time"]) ** 2) / 8
        )

        occupancy_ratio = (
            profile["base"]
            + (profile["peak"] - profile["base"])
            * peak_intensity
        )

        # Add random variation.
        occupancy_ratio += random.uniform(-0.06, 0.06)

        occupancy_ratio = max(
            0.02,
            min(0.95, occupancy_ratio)
        )

        number_now = round(
            capacity * occupancy_ratio
        )

        # Simulated people entering and leaving.
        number_entering = random.randint(0, 15)
        number_leaving = random.randint(0, 15)

        records.append({
            "time": current_time.strftime("%H:%M:%S"),
            "number_now": number_now,
            "number_entering": number_entering,
            "number_leaving": number_leaving
        })

        current_time += timedelta(minutes=10)

    return records


# --------------------------------
# 5. ADD LOCATIONS TO MYSQL
# --------------------------------

def add_locations():

    connection = get_db_connection()
    cursor = connection.cursor()

    try:
        for location in LOCATIONS:

            name = location["name"]
            category = location["category"]
            capacity = location["capacity"]

            # Check whether location already exists.
            cursor.execute(
                """
                SELECT location_id
                FROM locations_registry
                WHERE location_name = %s
                LIMIT 1
                """,
                (name,)
            )

            existing = cursor.fetchone()

            if existing:
                print(f"Already registered: {name}")
            else:
                cursor.execute(
                    """
                    INSERT INTO locations_registry
                    (location_name, is_active)
                    VALUES (%s, 1)
                    """,
                    (name,)
                )

                print(f"Registered: {name}")

            # Generate synthetic occupancy.
            records = generate_occupancy(
                capacity,
                category
            )

            # Insert only time slots not already present.
            inserted = 0

            for record in records:

                cursor.execute(
                    """
                    SELECT id
                    FROM location_information
                    WHERE location_name = %s
                    AND recorded_time = %s
                    LIMIT 1
                    """,
                    (name, record["time"])
                )

                if cursor.fetchone():
                    continue

                cursor.execute(
                    """
                    INSERT INTO location_information
                    (
                        location_name,
                        number_now,
                        number_entering,
                        number_leaving,
                        recorded_time
                    )
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                    (
                        name,
                        record["number_now"],
                        record["number_entering"],
                        record["number_leaving"],
                        record["time"]
                    )
                )

                inserted += 1

            print(
                f"Generated {inserted} occupancy records "
                f"for {name}"
            )

        connection.commit()
        print("\nAll locations processed successfully!")

    except Exception as e:
        connection.rollback()
        print(f"Error: {e}")
        raise

    finally:
        cursor.close()
        connection.close()


# --------------------------------
# 6. RUN SCRIPT
# --------------------------------

if __name__ == "__main__":
    add_locations()
