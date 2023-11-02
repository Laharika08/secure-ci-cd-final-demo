from fastapi import FastAPI, Request
from mangum import Mangum
import logging
logging.getLogger().setLevel(logging.INFO)
app = FastAPI()

@app.get("/")
async def handler(request: Request):
    route = request.url.path  # Get the requested route
    print("Requested Route:", route)  # Log the requested route
    return {"message": "Hello BiModal!"}

handler = Mangum(app)
