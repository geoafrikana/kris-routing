from fastapi import FastAPI
from pydantic import BaseModel, BeforeValidator
from typing import Annotated
from dotenv import load_dotenv
import os
import psycopg2
import json

load_dotenv()

PG_HOST = os.getenv("PG_HOST")
PG_PORT = os.getenv("PG_PORT")
if PG_PORT:
    PG_PORT = int(PG_PORT)
PG_DB = os.getenv("PG_DB")
PG_USER = os.getenv("PG_USER")
PG_PASSWORD = os.getenv("PG_PASSWORD")


conn = psycopg2.connect(dbname=PG_DB,
                        password=PG_PASSWORD,
                        host=PG_HOST,
                        port=PG_PORT,
                        user=PG_USER)

cursor = conn.cursor()

query = """
SELECT * FROM get_route(
    %(source_lon)s, %(source_lat)s,
    %(dest_lon)s, %(dest_lat)s
    )"""

class InputCoordinates(BaseModel):
    source_lat: float
    source_lon: float
    dest_lat: float
    dest_lon: float

class Route(BaseModel):
    cost: float
    route: Annotated[dict, BeforeValidator(json.loads)]

app = FastAPI()

@app.post("/items/",
          response_model=Route)
async def create_item(item: InputCoordinates):
    """{
        "source_lat":3.478239,
        "source_lon": 11.515851,
        "dest_lat": 4.242791,
        "dest_lon": 11.399078
        }"""
    try:
        cursor.execute(query, item.model_dump())
        resp = cursor.fetchone()
        if resp:
            cost, route = resp
            return Route(cost=cost, route=route)
        raise ValueError("No route found")
    except Exception as e:
        return {"error": str(e)}
    finally:
        cursor.close()
        conn.close()
