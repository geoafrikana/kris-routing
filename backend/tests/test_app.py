import pytest
from app.utils import FRONTEND_DIR

def test_frontend_dir():
    assert FRONTEND_DIR.exists()
    assert FRONTEND_DIR.is_dir()
    assert (FRONTEND_DIR / "static").exists()
    assert (FRONTEND_DIR / "template").exists()