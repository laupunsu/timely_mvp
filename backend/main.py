import os, math
import json
import urllib.request
import urllib.error
import urllib.parse
from datetime import datetime, timedelta, time
from typing import Optional
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from occupancy_generator import generate_occupancy

load_dotenv()
print("Google Places API key loaded:", bool(os.getenv("GOOGLE_PLACES_API_KEY")))
class RegisterVenueIn(BaseModel):
    place_id: str
    category: str
    capacity: int = Field(gt=0, le=1000000)

app = FastAPI(title="Timely API", version="0.1.0")
origins = os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",")
app.add_middleware(CORSMiddleware, allow_origins=[x.strip() for x in origins], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

# Coordinates are approximate display/routing anchors for the four locations in the supplied SQL dump.
#VENUE_META = {
#    "Gardens By The Bay flower dome": {"lat": 1.2840, "lng": 103.8648, "area": "Marina Bay"},
#    "Serangoon Library": {"lat": 1.3506, "lng": 103.8721, "area": "Serangoon"},
#    "Sentosa, Universal Studios": {"lat": 1.2540, "lng": 103.8238, "area": "Sentosa"},
#    "Lolas Cafe": {"lat": 1.3120, "lng": 103.9000, "area": "Singapore"},
#}
#DEMO_VENUES = [{"id": i+1, "name": n, **m} for i,(n,m) in enumerate(VENUE_META.items())]

def db():
    try:
        return mysql.connector.connect(
            host=os.getenv("MYSQL_HOST"),
            port=int(os.getenv("MYSQL_PORT", "3306")),
            user=os.getenv("MYSQL_USER"),
            password=os.getenv("MYSQL_PASSWORD"),
            database=os.getenv("MYSQL_DATABASE"),
            connection_timeout=10,
        )
    except Error as e:
         raise HTTPException(status_code=503, detail=f"MySQL connection failed: {e.msg}")
# def db():
#     try:
#         return mysql.connector.connect(
#             host=os.getenv("MYSQL_HOST") or os.getenv("MYSQLHOST") or "127.0.0.1",
#             port=int(os.getenv("MYSQL_PORT") or os.getenv("MYSQLPORT") or "3306"),
#             user=os.getenv("MYSQL_USER") or os.getenv("MYSQLUSER") or "root",
#             password=os.getenv("MYSQL_PASSWORD") or os.getenv("MYSQLPASSWORD") or "",
#             database=os.getenv("MYSQL_DATABASE") or os.getenv("MYSQLDATABASE") or "occupancy_list",
#             connection_timeout=4,
#         )
#     except Error as e:
#         raise HTTPException(status_code=503, detail=f"MySQL connection failed: {e.msg}")

def get_venues():
    conn = db()
    try:
        cur = conn.cursor(dictionary=True)

        cur.execute("""
            SELECT
                location_id AS id,
                location_name AS name,
                address,
                latitude,
                longitude,
                category,
                capacity,
                occupancy_source
            FROM locations_registry
            WHERE is_active = 1
            ORDER BY location_name
        """)

        rows = cur.fetchall()

        venues = []

        for r in rows:
            venues.append({
                "id": r["id"],
                "name": r["name"],
                "address": r["address"],
                "lat": float(r["latitude"]) if r["latitude"] is not None else 1.3521,
                "lng": float(r["longitude"]) if r["longitude"] is not None else 103.8198,
                "category": r["category"],
                "capacity": r["capacity"],
                "occupancy_source": r["occupancy_source"]
            })

        return venues

    finally:
        conn.close()

@app.get("/api/health")
def health():
    try:
        conn = db()
        conn.close()
        return {"ok": True, "database": "connected"}
    except HTTPException as e:
        return {"ok": False, "database": "disconnected", "detail": e.detail}

@app.get("/api/venues")
def venues():
    return get_venues()

# --------------------------------
# REVERSE GEOCODING
# --------------------------------

@app.get("/api/location/reverse")
def reverse_geocode(
    lat: float = Query(ge=-90, le=90),
    lng: float = Query(ge=-180, le=180)
):
    api_key = os.getenv("GOOGLE_PLACES_API_KEY")

    if not api_key:
        raise HTTPException(
            status_code=500,
            detail="Google API key is not configured."
        )

    url = "https://maps.googleapis.com/maps/api/geocode/json"

    params = urllib.parse.urlencode({
        "latlng": f"{lat},{lng}",
        "key": api_key
    })

    request = urllib.request.Request(
        f"{url}?{params}",
        method="GET"
    )

    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            data = json.loads(response.read().decode("utf-8"))

    except urllib.error.URLError:
        raise HTTPException(
            status_code=503,
            detail="Unable to connect to Google Geocoding API."
        )

    status = data.get("status")

    if status != "OK" or not data.get("results"):
        raise HTTPException(
            status_code=502,
            detail=f"Geocoding failed: {status}"
        )

    return {
        "address": data["results"][0]["formatted_address"],
        "latitude": lat,
        "longitude": lng
    }

# --------------------------------
# GOOGLE PLACES SEARCH
# --------------------------------

@app.get("/api/places/search")
def search_places(
    q: str = Query(min_length=2, max_length=150),
    max_results: int = Query(default=5, ge=1, le=10)
):
    api_key = os.getenv("GOOGLE_PLACES_API_KEY")

    if not api_key:
        raise HTTPException(
            status_code=500,
            detail="Google Places API key is not configured."
        )

    url = "https://places.googleapis.com/v1/places:searchText"

    payload = {
        "textQuery": q,
        "maxResultCount": max_results,
        "languageCode": "en",
        "locationBias": {
            "circle": {
                "center": {
                    "latitude": 1.3521,
                    "longitude": 103.8198
                },
                "radius": 50000
            }
        }
    }

    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": api_key,
        "X-Goog-FieldMask": (
            "places.id,"
            "places.displayName,"
            "places.formattedAddress,"
            "places.location,"
            "places.types"
        )
    }

    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST"
    )

    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            data = json.loads(response.read().decode("utf-8"))

    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8", errors="replace")
        raise HTTPException(
            status_code=502,
            detail=f"Google Places API error: {error_body}"
        )

    except urllib.error.URLError:
        raise HTTPException(
            status_code=503,
            detail="Unable to connect to Google Places API."
        )

    results = []

    for place in data.get("places", []):
        location = place.get("location", {})
        display_name = place.get("displayName", {})

        results.append({
            "place_id": place.get("id"),
            "name": display_name.get("text"),
            "address": place.get("formattedAddress"),
            "lat": location.get("latitude"),
            "lng": location.get("longitude"),
            "types": place.get("types", [])
        })

    return {
        "results": results,
        "count": len(results)
    }

# Register venues and create randomized occupancy

@app.post("/api/venues/register")
def register_venue(body: RegisterVenueIn):

    api_key = os.getenv("GOOGLE_PLACES_API_KEY")

    if not api_key:
        raise HTTPException(
            status_code=500,
            detail="Google Places API key is not configured."
        )

    # 1. Retrieve selected venue details from Google Places
    url = f"https://places.googleapis.com/v1/places/{body.place_id}"

    headers = {
        "X-Goog-Api-Key": api_key,
        "X-Goog-FieldMask": (
            "id,"
            "displayName,"
            "formattedAddress,"
            "location"
        )
    }

    request = urllib.request.Request(url, headers=headers, method="GET")

    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            place = json.loads(response.read().decode("utf-8"))

    except urllib.error.HTTPError:
        raise HTTPException(
            status_code=502,
            detail="Unable to retrieve venue details from Google Places."
        )

    except urllib.error.URLError:
        raise HTTPException(
            status_code=503,
            detail="Unable to connect to Google Places API."
        )

    name = place.get("displayName", {}).get("text")
    address = place.get("formattedAddress")
    location = place.get("location", {})

    latitude = location.get("latitude")
    longitude = location.get("longitude")

    if not all([name, address, latitude is not None, longitude is not None]):
        raise HTTPException(
            status_code=502,
            detail="Google Places returned incomplete venue information."
        )

    if len(name) > 100:
        raise HTTPException(
            status_code=400,
            detail="Venue name exceeds the database's 100-character limit."
        )

    # 2. Check if venue already exists
    conn = db()

    try:
        cur = conn.cursor(dictionary=True)

        cur.execute("""
            SELECT location_id, location_name
            FROM locations_registry
            WHERE google_place_id = %s
            LIMIT 1
        """, (body.place_id,))

        existing = cur.fetchone()

        if existing:
            return {
                "success": True,
                "message": "Venue is already registered.",
                "venue_id": existing["location_id"],
                "venue_name": existing["location_name"]
            }

        # 3. Register venue
        cur.execute("""
            INSERT INTO locations_registry
            (
                location_name,
                google_place_id,
                address,
                latitude,
                longitude,
                category,
                capacity,
                occupancy_source,
                is_active
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, 'simulated', 1)
        """, (
            name,
            body.place_id,
            address,
            latitude,
            longitude,
            body.category,
            body.capacity
        ))

        venue_id = cur.lastrowid

        # 4. Generate occupancy records
        records = generate_occupancy(
            body.capacity,
            body.category
        )

        # 5. Insert generated records
        values = [
            (
                name,
                record["number_now"],
                record["number_entering"],
                record["number_leaving"],
                record["time"]
            )
            for record in records
        ]

        cur.executemany("""
            INSERT INTO location_information
            (
                location_name,
                number_now,
                number_entering,
                number_leaving,
                recorded_time
            )
            VALUES (%s, %s, %s, %s, %s)
        """, values)

        conn.commit()

        return {
            "success": True,
            "message": "Venue registered and occupancy generated successfully.",
            "venue_id": venue_id,
            "venue_name": name,
            "records_generated": len(records),
            "occupancy_source": "simulated"
        }

    except mysql.connector.IntegrityError:
        conn.rollback()
        raise HTTPException(
            status_code=409,
            detail="A venue with this name or Google Place ID already exists."
        )

    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        conn.close()


def occupancy_for(name: str, arrival: datetime):
    # Existing table stores TIME only. Match the nearest 10-minute time-of-day sample.
    slot_minute = round(arrival.minute / 10) * 10
    slot_hour = arrival.hour
    if slot_minute == 60:
        slot_minute, slot_hour = 0, (slot_hour + 1) % 24
    slot = time(slot_hour, slot_minute)
    conn = db()
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute("""
            SELECT number_now, number_entering, number_leaving, recorded_time
            FROM location_information
            WHERE location_name = %s
            ORDER BY ABS(TIME_TO_SEC(TIMEDIFF(recorded_time, %s))) ASC, id DESC
            LIMIT 1
        """, (name, slot))
        row = cur.fetchone()
        if not row:
            return {"count": 0, "entering": 0, "leaving": 0, "level": "Unknown", "source": "No reading"}
        count = int(row["number_now"])
        # Counts only: no capacity is present in the source schema, so avoid false density claims.
        level = "Quiet" if count < 35 else ("Moderate" if count < 65 else "Busy")
        return {"count": count, "entering": int(row["number_entering"]), "leaving": int(row["number_leaving"]), "level": level, "source": "Simulated occupancy sample", "sample_time": str(row["recorded_time"])}
    finally:
        conn.close()

class TaskIn(BaseModel):
    id: str
    title: str = Field(min_length=1, max_length=120)
    venue: str
    duration: int = Field(default=30, ge=5, le=480)
    priority: str = "Normal"
    deadline: Optional[str] = None
    completed: bool = False

class PlanIn(BaseModel):
    tasks: list[TaskIn]
    start_lat: float = 1.3521
    start_lng: float = 103.8198
    start_time: Optional[str] = None

class DayFeedbackIn(BaseModel):
    rating: int = Field(ge=1, le=5)
    feedback: Optional[str] = Field(default=None, max_length=1000)
    completed_tasks: int = Field(default=0, ge=0, le=8)

def haversine(a,b):
    R=6371
    p1,p2=math.radians(a["lat"]),math.radians(b["lat"])
    dp=math.radians(b["lat"]-a["lat"]); dl=math.radians(b["lng"]-a["lng"])
    x=math.sin(dp/2)**2+math.cos(p1)*math.cos(p2)*math.sin(dl/2)**2
    return 2*R*math.asin(math.sqrt(x))

def plan_tasks(tasks, start_lat, start_lng, start_time):
    venues = {v["name"]:v for v in get_venues()}
    pending = [t.model_dump() for t in tasks if not t.completed]
    now = datetime.fromisoformat(start_time) if start_time else datetime.now()
    current = {"lat": start_lat, "lng": start_lng}
    ordered=[]
    total_travel=0
    while pending:
        scored=[]
        for t in pending:
            v=venues.get(t["venue"])
            if not v: continue
            km=haversine(current,v)
            travel=max(4, round(km/0.30)) # approx 18 km/h city travel proxy; replace with routing API
            arrival=now+timedelta(minutes=travel)
            occ=occupancy_for(t["venue"], arrival)
            crowd_penalty={"Quiet":0,"Moderate":9,"Busy":24,"Unknown":12}.get(occ["level"],12)
            priority_bonus={"High":-12,"Normal":0,"Low":5}.get(t["priority"],0)
            deadline_penalty=0
            if t.get("deadline"):
                try:
                    due=datetime.fromisoformat(t["deadline"])
                    if arrival > due: deadline_penalty=1000
                    else: deadline_penalty=max(0, (due-arrival).total_seconds()/3600)*-0.15
                except ValueError: pass
            score=travel + crowd_penalty + priority_bonus + deadline_penalty
            scored.append((score,t,v,travel,arrival,occ,km))
        if not scored:
            break
        _,t,v,travel,arrival,occ,km=min(scored,key=lambda x:x[0])
        ordered.append({
            **t, "lat":v["lat"],"lng":v["lng"],"area":v.get("area",""),
            "travel_minutes":travel,"arrival":arrival.isoformat(timespec="minutes"),
            "distance_km":round(km,1),"occupancy":occ
        })
        total_travel += travel
        now=arrival+timedelta(minutes=t["duration"])
        current=v
        pending.remove(t)
    return {"stops":ordered,"travel_minutes":total_travel,"task_minutes":sum(x["duration"] for x in ordered),
            "generated_at":datetime.now().isoformat(timespec="minutes"),
            "note":"Crowd levels are estimates from the supplied occupancy table. Current readings are simulated; travel times are prototype estimates."}

@app.post("/api/plan")
def create_plan(body: PlanIn):
    if len(body.tasks)>8:
        raise HTTPException(status_code=400, detail="The MVP supports up to 8 tasks per plan.")
    return plan_tasks(body.tasks, body.start_lat, body.start_lng, body.start_time)

@app.get("/api/occupancy")
def occupancy():
    results=[]
    for v in get_venues():
        # A current snapshot uses the current time-of-day slot.
        results.append({"venue":v["name"], **occupancy_for(v["name"],datetime.now())})
    return results

@app.post("/api/feedback")
def submit_feedback(body: DayFeedbackIn):
    conn = db()

    try:
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO day_feedback
            (rating, feedback, completed_tasks)
            VALUES (%s, %s, %s)
        """, (
            body.rating,
            body.feedback,
            body.completed_tasks
        ))

        feedback_id = cur.lastrowid
        conn.commit()

        return {
            "success": True,
            "message": "Thank you for sharing your experience!",
            "feedback_id": feedback_id
        }

    except Exception:
        conn.rollback()
        raise HTTPException(
            status_code=500,
            detail="Unable to save feedback."
        )

    finally:
        conn.close()