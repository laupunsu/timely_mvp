import React, {useEffect, useMemo, useState} from 'react';
import {createRoot} from 'react-dom/client';
import {Check, ChevronRight, Clock3, MapPin, Plus, Sparkles, ArrowLeft, ArrowRight, Navigation, CalendarDays, CircleCheck, ListTodo, Route, Users, RefreshCw, Trash2, Lock, Star, ExternalLink} from 'lucide-react';
import './style.css';

const API = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';
const DEMO = [
 {id:9,name:'Gardens By The Bay flower dome',area:'Marina Bay',lat:1.284,lng:103.8648},
 {id:10,name:'Serangoon Library',area:'Serangoon',lat:1.3506,lng:103.8721},
 {id:11,name:'Sentosa, Universal Studios',area:'Sentosa',lat:1.254,lng:103.8238},
 {id:12,name:'Lolas Cafe',area:'Singapore',lat:1.312,lng:103.9}
];
// const sampleTasks=[
//  {id:'a',title:'Pick up prescription',venue:'Serangoon Library',duration:15,priority:'High',deadline:'',completed:false},
//  {id:'b',title:'Pizza lunch',venue:'Lolas Cafe',duration:45,priority:'Normal',deadline:'',completed:false},
//  {id:'c',title:'Gym session',venue:'Gardens By The Bay flower dome',duration:60,priority:'Normal',deadline:'',completed:false}
// ];
const sampleTasks = [];
function App(){
 const [venues,setVenues]=useState(DEMO),[dbStatus,setDbStatus]=useState('connecting');
 const [tasks,setTasks]=useState(sampleTasks),[step,setStep]=useState(0),[plan,setPlan]=useState(null);
 const [busy,setBusy]=useState(false),[error,setError]=useState(''),[active,setActive]=useState(0);
 const [draft,setDraft]=useState({
  title: '',
  venue: '',
  duration: 30,
  priority: 'Normal',
  deadline: ''
});
 const [start,setStart]=useState('1.3521,103.8198');
 const [placesQuery, setPlacesQuery] = useState('');
 const [placeResults, setPlaceResults] = useState([]);
 const [selectedPlace, setSelectedPlace] = useState(null);
 const [searching, setSearching] = useState(false);
 const [registering, setRegistering] = useState(false);
 const [placeError, setPlaceError] = useState('');
 const [venueCategory, setVenueCategory] = useState('attraction');
 const [venueCapacity, setVenueCapacity] = useState(500);
 const [editingTaskId, setEditingTaskId] = useState(null);
 useEffect(()=>{Promise.all([fetch(API+'/api/venues').then(r=>{if(!r.ok)throw Error();return r.json()}),fetch(API+'/api/health').then(r=>r.json()).catch(()=>({ok:false}))]).then(([v,h])=>{if(v.length)setVenues(v);setDbStatus(h.ok?'connected':'offline')}).catch(()=>setDbStatus('offline'));},[]);
 const done=tasks.filter(t=>t.completed).length;
 const pending=tasks.filter(t=>!t.completed);
 const searchPlaces = async () => {
  if (!placesQuery.trim()) return;

  setSearching(true);
  setPlaceError('');
  setPlaceResults([]);
  setSelectedPlace(null);

try {
    const response = await fetch(
      `${API}/api/places/search?q=${encodeURIComponent(placesQuery)}`
    );

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.detail || 'Search failed');
    }

    const results = Array.isArray(data)
      ? data
      : data.results || data.places || [];

    setPlaceResults(results);

    if (results.length === 0) {
      setPlaceError('No venues found. Try another search.');
    }
  } catch (error) {
    setPlaceError(error.message);
  } finally {
    setSearching(false);
  }
};
const registerSelectedPlace = async () => {
  if (!selectedPlace) return;

  setRegistering(true);
  setPlaceError('');

  try {
    const response = await fetch(`${API}/api/venues/register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        place_id: selectedPlace.place_id,
        category: venueCategory,
        capacity: Number(venueCapacity)
      })
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.detail || 'Could not register venue');
    }

    // Refresh the venue list from MySQL
    const venuesResponse = await fetch(`${API}/api/venues`);

    if (!venuesResponse.ok) {
      throw new Error('Venue registered, but could not refresh venue list.');
    }

    const updatedVenues = await venuesResponse.json();

    setVenues(updatedVenues);

    const newVenue = updatedVenues.find(
      v => v.name === selectedPlace.name
    );
    
    if (newVenue) {
      setDraft(d => ({
        ...d,
        venue: newVenue.name
      }));
    
      setPlacesQuery(newVenue.name);
    } else {
      throw new Error('Venue registered, but could not find it in the venue list.');
    }
    
    setSelectedPlace(null);
    setPlaceResults([]);

  } catch (error) {
    setPlaceError(error.message);
  } finally {
    setRegistering(false);
  }
};
// Add Task Function 
const addTask = () => {
  if (!draft.title.trim() || !draft.venue.trim()) {
    setPlaceError('Please enter a task name and location.');
    return;
  }
  
  const isRegistered = venues.some(
    v => v.name.toLowerCase() === draft.venue.trim().toLowerCase()
  );
  
  if (!isRegistered) {
    setPlaceError('Please select a registered venue or search Google Maps to add it.');
    return;
  }
  
  setPlaceError('');

  if (editingTaskId) {
    // Update an existing task
    setTasks(p =>
      p.map(t =>
        t.id === editingTaskId
          ? {
              ...t,
              ...draft,
              title: draft.title.trim(),
              duration: Number(draft.duration)
            }
          : t
      )
    );

    setEditingTaskId(null);
  } else {
    // Add a new task
    setTasks(p => [
      ...p,
      {
        ...draft,
        id: crypto.randomUUID(),
        title: draft.title.trim(),
        duration: Number(draft.duration),
        completed: false
      }
    ]);
  }

  setDraft({
    title: '',
    venue: '',
    duration: 30,
    priority: 'Normal',
    deadline: ''
  });

  setPlacesQuery('');
  setPlaceResults([]);
  setSelectedPlace(null);
};

// Edit Tasks
const editTask = (task) => {
  setDraft({
    title: task.title,
    venue: task.venue,
    duration: task.duration,
    priority: task.priority,
    deadline: task.deadline || ''
  });

  setEditingTaskId(task.id);
  setPlacesQuery(task.venue);
  setPlaceResults([]);
  setSelectedPlace(null);

  setStep(0);

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
};

const cancelEdit = () => {
  setEditingTaskId(null);

  setDraft({
    title: '',
    venue: '',
    duration: 30,
    priority: 'Normal',
    deadline: ''
  });

  setPlacesQuery('');
  setPlaceResults([]);
  setSelectedPlace(null);
};

// Remove Tasks
 const removeTask=id=>setTasks(p=>p.filter(t=>t.id!==id));
 const generate=async()=>{
   if(!pending.length){setError('Add at least one task to build your day.');return}
   setBusy(true);setError('');
   const [lat,lng]=start.split(',').map(Number);
   try{
    const r=await fetch(API+'/api/plan',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({tasks:pending,start_lat:Number.isFinite(lat)?lat:1.3521,start_lng:Number.isFinite(lng)?lng:103.8198})});
    if(!r.ok)throw Error('API unavailable');
    setPlan(await r.json());setDbStatus('connected');
   }catch(e){
    setDbStatus('offline');
    const ordered=pending.map((t,i)=>({...t,lat:venues.find(v=>v.name===t.venue)?.lat||1.35,lng:venues.find(v=>v.name===t.venue)?.lng||103.82,arrival:new Date(Date.now()+i*55*60000).toISOString().slice(0,16),travel_minutes:18,occupancy:{count:42,level:i===1?'Busy':'Moderate',source:'Demo preview'}}));
    setPlan({stops:ordered,travel_minutes:ordered.length*18,task_minutes:ordered.reduce((s,t)=>s+t.duration,0),note:'Preview mode: connect the FastAPI backend and MySQL database to use your occupancy records.'});
   }
   setStep(1);setBusy(false);
 };
 const complete=id=>{setTasks(p=>p.map(t=>t.id===id?{...t,completed:true}:t));setPlan(p=>p?({...p,stops:p.stops.filter(t=>t.id!==id)}):p);};
 const reorder=()=>{setPlan(null);generate()};
 const activeStop=plan?.stops?.[Math.min(active,Math.max(0,(plan?.stops?.length||1)-1))];
 const routeUrl=plan?.stops?.length?'https://www.google.com/maps/dir/'+plan.stops.map(s=>encodeURIComponent(s.venue)).join('/'):null;
 return <div className="app-shell">
  <header className="topbar"><div className="brand"><div className="brandmark"><Check size={19}/></div><span>Timely</span></div><nav><button className={step===0?'nav-active':''} onClick={()=>setStep(0)}>Your list</button><button className={step===1?'nav-active':''} onClick={()=>plan&&setStep(1)}>Your plan</button><button className={step===2?'nav-active':''} onClick={()=>plan&&setStep(2)}>On your way</button></nav><div className="status"><i className={dbStatus==='connected'?'online':''}/>{dbStatus==='connected'?'Database connected':'Preview mode'}</div></header>
  <main>
   <section className="hero"><div><div className="eyebrow"><Sparkles size={14}/> LIST IT, TIME IT, DO IT</div><h1>Your whole day,<br/><em>optimized.</em></h1><p>Less zigzagging. Less waiting. More time for what matters.</p></div><div className="hero-art"><div className="sun"/><div className="route-line"><span/><span/><span/></div><div className="hero-pin"><MapPin size={24}/></div><div className="hero-note"><b>Smart timing</b><small>Quiet moments, better plans.</small></div></div></section>
   <div className="steps"><div className={step===0?'current':''}><span>01</span> List it</div><i/><div className={step===1?'current':''}><span>02</span> Time it</div><i/><div className={step===2?'current':''}><span>03</span> Do it</div></div>
   {step===0&&<section className="workspace">
    <div className="section-heading"><div><div className="eyebrow">START WITH YOUR TO-DO LIST</div><h2>What's on your list?</h2><p>Tell us what you need to get done. We'll take care of the order.</p></div><span className="count-pill">{pending.length} tasks left</span></div>
    <div className="input-panel"><div className="panel-top"><ListTodo size={18}/><b>Add a task</b><span>Build your day, one stop at a time</span></div>
    <div className="form-grid">

{/* TASK NAME */}
<label className="wide">
  Task name
  <input
    value={draft.title}
    onChange={e => setDraft({...draft, title: e.target.value})}
    onKeyDown={e => e.key === 'Enter' && addTask()}
    placeholder="e.g. Pick up my prescription"
  />
</label>

{/* LOCATION */}
<label className="wide">
  Location

  <div style={{ display: 'flex', gap: '8px' }}>
    <input
      list="registered-venues"
      value={placesQuery}
      onChange={e => {
        setPlacesQuery(e.target.value);
        setDraft(d => ({ ...d, venue: e.target.value }));
      }}
      placeholder="Search or select a venue..."
    />

    <datalist id="registered-venues">
      {venues.map(v => (
        <option key={v.id} value={v.name} />
      ))}
    </datalist>

    <button
      type="button"
      className="add-btn"
      onClick={searchPlaces}
      disabled={searching || !placesQuery.trim()}
    >
      {searching ? 'Searching...' : 'Search Google Maps'}
    </button>
  </div>

  <small>
    Select an existing venue from the suggestions, or search Google Maps to add a new one.
  </small>

  {placeResults.length > 0 && (
    <div style={{ marginTop: '12px' }}>
      <b>Google Maps results</b>

      {placeResults.map(place => (
        <button
          type="button"
          key={place.place_id}
          onClick={() => setSelectedPlace(place)}
          style={{
            display: 'block',
            width: '100%',
            padding: '12px',
            marginTop: '8px',
            textAlign: 'left',
            border: '1px solid #ddd',
            borderRadius: '8px',
            background: selectedPlace?.place_id === place.place_id
              ? '#eee8ff'
              : 'white',
            cursor: 'pointer'
          }}
        >
          <strong>{place.name}</strong>
          <br />
          <small>{place.address}</small>
        </button>
      ))}
    </div>
  )}

  {selectedPlace && (
    <div style={{ marginTop: '12px' }}>
      <b>Register this new venue</b>
      <p>{selectedPlace.name}</p>

      <label>
        Venue category
        <select
          value={venueCategory}
          onChange={e => setVenueCategory(e.target.value)}
        >
          <option value="library">Library</option>
          <option value="shopping_mall">Shopping mall</option>
          <option value="attraction">Attraction</option>
          <option value="cafe">Cafe</option>
          <option value="office">Office</option>
          <option value="hospital">Hospital</option>
          <option value="park">Park</option>
          <option value="gym">Gym / Fitness Centre</option>
        </select>
      </label>

      <label>
        Estimated venue capacity
        <input
          type="number"
          min="1"
          value={venueCapacity}
          onChange={e => setVenueCapacity(e.target.value)}
        />
      </label>

      <button
        type="button"
        className="add-btn"
        onClick={registerSelectedPlace}
        disabled={registering || Number(venueCapacity) <= 0}
      >
        {registering ? 'Adding venue...' : 'Register and select venue'}
      </button>
    </div>
  )}

  {placeError && (
    <p className="error">{placeError}</p>
  )}
</label>

      <label>Time needed<select value={draft.duration} onChange={e=>setDraft({...draft,duration:e.target.value})}>{[15,30,45,60,90,120].map(n=><option key={n} value={n}>{n} minutes</option>)}</select></label>
      <label>Priority<select value={draft.priority} onChange={e=>setDraft({...draft,priority:e.target.value})}><option>Normal</option><option>High</option><option>Low</option></select></label>
      <label>Must be done by<input type="time" value={draft.deadline} onChange={e=>setDraft({...draft,deadline:e.target.value})}/></label>
     </div><div style={{ display: 'flex', gap: '8px' }}>
  <button className="add-btn" onClick={addTask}>
    {editingTaskId ? 'Save changes' : <><Plus size={17}/> Add to my list</>}
  </button>

  {editingTaskId && (
    <button
      type="button"
      className="secondary-btn"
      onClick={cancelEdit}
    >
      Cancel
    </button>
  )}
</div>
    </div>
    <div className="list-head"><h3>Here's what I got</h3><span>{tasks.length} total</span></div>
    <div className="task-list">{tasks.map((t,i)=><div className={'task-row '+(t.completed?'is-done':'')} key={t.id}><div className="task-icon">{t.completed?<Check size={17}/>:<MapPin size={17}/>}</div><div className="task-info"><b>{t.title}</b><span>{t.venue}</span></div><div className="task-meta"><span className={'priority '+t.priority.toLowerCase()}>{t.priority} priority</span><small><Clock3 size={13}/>{t.duration} min</small></div>
    <button
  className="text-btn"
  onClick={() => editTask(t)}
>
  Edit
</button>

<button
  className="icon-btn"
  aria-label="Remove task"
  onClick={() => removeTask(t.id)}
>
  <Trash2 size={16}/>
</button>
    </div>)}</div>
    <div className="bottom-action"><div><b>Ready to make the most of your day?</b><span>We'll find a smarter order based on travel and crowd levels.</span></div><button className="primary-btn" onClick={generate} disabled={busy||!pending.length}>{busy?'Finding your best timing…':<>Find my best timing <ArrowRight size={17}/></>}</button></div>
    {error&&<p className="error">{error}</p>}
   </section>}
   {step===1&&plan&&<section className="workspace">
    <div className="section-heading"><div><div className="eyebrow">YOUR DAY, REORDERED</div><h2>Here's your best route.</h2><p>A balanced plan that considers the journey and expected crowd levels.</p></div><button className="text-btn" onClick={()=>setStep(0)}><ArrowLeft size={16}/> Edit tasks</button></div>
    <div className="summary-grid"><div><Route/><b>{plan.travel_minutes} min</b><span>estimated travel</span></div><div><Clock3/><b>{plan.task_minutes} min</b><span>time for your tasks</span></div><div><MapPin/><b>{plan.stops.length}</b><span>stops in your plan</span></div></div>
    <div className="plan-layout"><div className="map-card"><div className="map-head"><b>Your route</b><span><i/> Recommended order</span></div><div className="map-canvas"><div className="map-grid"/><svg viewBox="0 0 600 360" preserveAspectRatio="xMidYMid meet"><path d="M70 275 C145 255 125 170 230 185 S340 245 390 150 S490 95 535 65" fill="none" stroke="#8b65e8" strokeWidth="5" strokeDasharray="9 9" strokeLinecap="round"/>{plan.stops.map((s,i)=><g key={s.id}><circle cx={95+i*118} cy={245-i*43+(i%2)*36} r="19" fill="#fff" stroke="#7a55d5" strokeWidth="4"/><text x={95+i*118} y={250-i*43+(i%2)*36} textAnchor="middle" fontSize="14" fontWeight="700" fill="#5b36b6">{i+1}</text></g>)}</svg><div className="map-caption"><Navigation size={14}/> Route preview · Singapore</div></div><div className="map-foot"><span><b>Start point</b> · Singapore</span><a href={routeUrl} target="_blank" rel="noreferrer">Open in Maps <ExternalLink size={13}/></a></div></div>
     <div className="stops-panel"><div className="stops-title"><b>Recommended order</b><span>{plan.stops.length} stops</span></div>{plan.stops.map((s,i)=><div className="stop-card" key={s.id}><div className="stop-number">{i+1}</div><div className="stop-content"><div className="stop-time">{new Date(s.arrival).toLocaleTimeString([], {hour:'numeric',minute:'2-digit'})} <span>· {s.travel_minutes} min travel</span></div><b>{s.title}</b><small>{s.venue}</small><div className="stop-tags"><span className={'crowd '+(s.occupancy?.level||'unknown').toLowerCase()}><Users size={12}/>{s.occupancy?.level||'Unknown'}</span><span><Clock3 size={12}/>{s.duration} min</span></div></div></div>)}</div></div>
    <p className="data-note"><span>i</span>{plan.note}</p>
    <div className="bottom-action"><div><b>Looks good? Let's get going.</b><span>You can check off each stop as you go.</span></div><button className="primary-btn" onClick={()=>{setActive(0);setStep(2)}}>Start my day <ArrowRight size={17}/></button></div>
   </section>}
   {step===2&&plan&&<section className="workspace"><div className="section-heading"><div><div className="eyebrow">ONE THING AT A TIME</div><h2>You're on your way.</h2><p>Follow your plan and check off each stop as you go.</p></div><button className="text-btn" onClick={()=>setStep(1)}><ArrowLeft size={16}/> View route</button></div>
    {plan.stops.length===0?<div className="finished"><div><CircleCheck size={34}/></div><h2>All done. Nicely planned.</h2><p>You've completed every task on your itinerary.</p><button className="primary-btn" onClick={()=>{setStep(0);setPlan(null)}}>Plan another day</button></div>:<div className="active-card"><div className="active-kicker"><span>UP NEXT · STOP {done+1}</span><span className="live-pill">YOUR ITINERARY</span></div><div className="active-main"><div className="active-icon"><MapPin size={25}/></div><div><h2>{plan.stops[0].title}</h2><p>{plan.stops[0].venue}</p><div className="stop-tags"><span className={'crowd '+(plan.stops[0].occupancy?.level||'unknown').toLowerCase()}><Users size={12}/>{plan.stops[0].occupancy?.level||'Unknown'} crowd</span><span><Clock3 size={12}/>{plan.stops[0].duration} min</span></div></div></div><div className="active-details"><div><small>ESTIMATED ARRIVAL</small><b>{new Date(plan.stops[0].arrival).toLocaleTimeString([], {hour:'numeric',minute:'2-digit'})}</b></div><div><small>TRAVEL TIME</small><b>{plan.stops[0].travel_minutes} min</b></div></div><button className="primary-btn full" onClick={()=>complete(plan.stops[0].id)}><Check size={17}/> Mark task complete</button><a className="map-link" target="_blank" rel="noreferrer" href={'https://www.google.com/maps/search/?api=1&query='+encodeURIComponent(plan.stops[0].venue)}>Get directions <ExternalLink size={14}/></a></div>}
    <div className="bottom-action"><div><b>{done} of {tasks.length} tasks completed</b><span>Your remaining plan updates as you finish each stop.</span></div><button className="secondary-btn" onClick={()=>{setStep(1);generate()}}><RefreshCw size={16}/> Recalculate plan</button></div>
   </section>}
   <footer><div className="brand mini"><div className="brandmark"><Check size={14}/></div>Timely</div><span>Make time for what matters.</span><span className="footer-right">MVP preview · Crowd data may be simulated</span></footer>
  </main>
 </div>
}
createRoot(document.getElementById('root')).render(<App/>);
