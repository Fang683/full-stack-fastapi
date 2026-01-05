import json
from pathlib import Path
from fastapi.testclient import TestClient
from app.main import app

SMITHY_OPENAPI = Path("../generated/smithy-openapi.json")

def test_smithy_paths_exist_in_fastapi():
    smithy = json.loads(SMITHY_OPENAPI.read_text(encoding="utf-8"))
    smithy_paths = set((smithy.get("paths") or {}).keys())

    client = TestClient(app)
    fastapi = client.get("/api/v1/openapi.json").json()
    fastapi_paths = set((fastapi.get("paths") or {}).keys())

    missing = smithy_paths - fastapi_paths
    assert not missing, f"FastAPI missing paths defined in Smithy: {sorted(missing)}"
