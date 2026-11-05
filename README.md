# Timely MVP

A mobile-first React web app with a FastAPI backend connected to the existing MySQL `occupancy_list` database.

## What's included
- Four-step experience: List it → Time it → Review → Do it.
- Task intake with venue, time constraint, priority and estimated duration.
- Reads active venues and occupancy readings from the existing MySQL tables:
  - `locations_registry`
  - `location_information`
- Recommends an order using a simple weighted travel + occupancy heuristic.
- Active itinerary with task completion and re-planning.
- Responsive purple interface inspired by the supplied Timely reference.

## Important data note
The supplied SQL dump's stored procedures generate random `number_entering` and `number_leaving` values. Treat current occupancy results as **simulated demonstration data**, not real sensor readings. The existing `recorded_time` is a time-of-day only; this MVP reads the most recent matching time slot and does not claim multi-day forecasting.

## Run locally

### 1. Database
Import your existing dump into MySQL (if not already imported):
```bash
mysql -u YOUR_USER -p < occupancy_list.sql
```

Copy `backend/.env.example` to `backend/.env` and fill in your MySQL connection details. Keep `.env` private; do not commit credentials.

### 2. Backend
```bash
cd backend
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```
API docs: http://localhost:8000/docs

### 3. Frontend
In another terminal:
```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```
Open http://localhost:5173

## Configuration
- `VITE_API_BASE_URL`: backend URL, default `http://localhost:8000`
- `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`: database connection.
- `DEMO_MODE=true`: allows the frontend to use clearly labelled demo data if the API/database is unavailable. Set false once connected.

## Current MVP assumptions / next integrations
- Four known venues from the dump are included with approximate Singapore coordinates for route visualization. Confirm/replace these coordinates before relying on navigation.
- Travel time is a lightweight distance-based estimate for the prototype, not live traffic. Google Maps / Mapbox routing can replace it later.
- Occupancy bands are based on observed counts because the current schema has no venue capacity. Add capacities before comparing crowd density across venues.
- No GPS tracking, geofencing, calendar sync, NLP/LLM parsing or learned personalization is enabled yet.
