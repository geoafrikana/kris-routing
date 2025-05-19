api:
	@echo "Running API server..."
	@cd backend; \
		source .venv/Scripts/activate; \
		Uvicorn app.main:app --host 0.0.0.0

test:
	@echo "Running tests..."
	@cd backend; \
		source .venv/Scripts/activate; \
		export PYTHONPATH=.; \
		pytest -v --disable-warnings --tb=short