import os, math
from datetime import datetime, timedelta, time
from typing import Optional
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

load_dotenv()
app = FastAPI(title="Timely API", version="0.1.0")
origins = os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",")
app.add_middleware(CORSMiddleware, allow_origins=[x.strip() for x in origins], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

# Coordinates are approximate display/routing anchors for the four locations in the supplied SQL dump.
VENUE_META = {
    "Gardens By The Bay flower dome": {"lat": 1.2840, "lng": 103.8648, "area": "Marina Bay"},
    "Serangoon Library": {"lat": 1.3506, "lng": 103.8721, "area": "Serangoon"},
    "Sentosa, Universal Studios": {"lat": 1.2540, "lng": 103.8238, "area": "Sentosa"},
    "Lolas Cafe": {"lat": 1.3120, "lng": 103.9000, "area": "Singapore"},
}
DEMO_VENUES = [{"id": i+1, "name": n, **m} for i,(n,m) in enumerate(VENUE_META.items())]

def db():
    try:
        return mysql.connector.connect(
            host=os.getenv("MYSQL_HOST", "127.0.0.1"),
            port=int(os.getenv("MYSQL_PORT", "3306")),
            user=os.getenv("MYSQL_USER", "root"),
            password=os.getenv("MYSQL_PASSWORD", ""),
            database=os.getenv("MYSQL_DATABASE", "occupancy_list"),
            connection_timeout=4,
        )
    except Error as e:
        raise HTTPException(status_code=503, detail=f"MySQL connection failed: {e.msg}")

def get_venues():
    conn = db()
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT location_id AS id, location_name AS name FROM locations_registry WHERE is_active = 1 ORDER BY location_name")
        rows = cur.fetchall()
        return [{"id": r["id"], "name": r["name"], **VENUE_META.get(r["name"], {"lat": 1.3521, "lng": 103.8198, "area": "Singapore"})} for r in rows]
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
