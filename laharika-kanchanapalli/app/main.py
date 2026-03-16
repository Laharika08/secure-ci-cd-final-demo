from fastapi import FastAPI
import os
from datetime import datetime

app = FastAPI()

@app.get("/")
def health():
    return {"status": "ok"}

@app.get("/build-info")
def build_info():
    return {
        "commit": os.getenv("COMMIT_SHA", "local"),
        "build_time": os.getenv("BUILD_TIME", str(datetime.utcnow()))
    }


