from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from app.utils import Route, InputCoordinates, get_route_from_db, FRONTEND_DIR
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles



app = FastAPI()

app.mount("/static", StaticFiles(directory=FRONTEND_DIR/ "static"), name="static")
templates = Jinja2Templates(directory= FRONTEND_DIR/ "template")
origins = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["POST"],
    allow_headers=["*"],
)

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse(name="index.html", request=request)

@app.post("/route/",
          response_model=Route)
async def create_item(item: InputCoordinates):
    """{
        "source_lat":3.478239,
        "source_lon": 11.515851,
        "dest_lat": 4.242791,
        "dest_lon": 11.399078
        }"""
    try:
        duration_seconds, route = get_route_from_db(item)
        return Route(duration_seconds=duration_seconds, route=route)
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0")