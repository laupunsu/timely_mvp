import math
import random
from datetime import datetime, timedelta

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
    "food": {
        "base": 0.10,
        "peak": 0.70,
        "peak_time": 12
    },
    "office": {
        "base": 0.20,
        "peak": 0.85,
        "peak_time": 10
    },
    "hospital": {
        "base": 0.25,
        "peak": 0.75,
        "peak_time": 11
    },
    "park": {
        "base": 0.10,
        "peak": 0.65,
        "peak_time": 17
    },
    "gym": {
        "base": 0.10,
        "peak": 0.75,
        "peak_time": 18
    },
    "school": {
        "base": 0.25,
        "peak": 0.8,
        "peak_time": 14
    }
}


def generate_occupancy(capacity, category):
    profile = PROFILES.get(category, PROFILES["shopping_mall"])

    records = []

    start = datetime.strptime("09:00", "%H:%M")
    end = datetime.strptime("22:00", "%H:%M")
    current_time = start

    while current_time <= end:
        hour = current_time.hour + current_time.minute / 60

        peak_intensity = math.exp(
            -((hour - profile["peak_time"]) ** 2) / 8
        )

        occupancy_ratio = (
            profile["base"]
            + (profile["peak"] - profile["base"]) * peak_intensity
        )

        occupancy_ratio += random.uniform(-0.06, 0.06)
        occupancy_ratio = max(0.02, min(0.95, occupancy_ratio))

        number_now = round(capacity * occupancy_ratio)
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