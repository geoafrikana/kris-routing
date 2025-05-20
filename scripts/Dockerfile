FROM python:3.12-alpine

WORKDIR /backend

RUN pip install uv

COPY backend/ .

RUN uv venv
RUN uv sync --no-dev

EXPOSE 80

CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

