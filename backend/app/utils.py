import os
import psycopg2
import json
from pydantic import BaseModel, BeforeValidator
from typing import Annotated
from dotenv import load_dotenv
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
FRONTEND_DIR = BASE_DIR / "frontend"

load_dotenv()

PG_HOST = os.getenv("PG_HOST")
PG_PORT = os.getenv("PG_PORT")
if PG_PORT:
    PG_PORT = int(PG_PORT)
PG_DB = os.getenv("PG_DB")
PG_USER = os.getenv("PG_USER")
PG_PASSWORD = os.getenv("PG_PASSWORD")

class InputCoordinates(BaseModel):
    source_lat: float
    source_lon: float
    dest_lat: float
    dest_lon: float

class Route(BaseModel):
    duration_seconds: float
    route: Annotated[dict, BeforeValidator(json.loads)]

def get_route_from_db(item: InputCoordinates):
    query = """
        SELECT * FROM get_route(
        %(source_lon)s, %(source_lat)s,
        %(dest_lon)s, %(dest_lat)s
        )"""
    with psycopg2.connect(dbname=PG_DB,
                        password=PG_PASSWORD,
                        host=PG_HOST,
                        port=PG_PORT,
                        user=PG_USER) as conn:
        with conn.cursor() as cursor:
            cursor.execute(query, item.model_dump())
            resp = cursor.fetchone()
            if not resp:
                raise ValueError("No route found")
            return resp