from fastapi import FastAPI
from miflow.common import greet
from miflow.util import with_emoji

app = FastAPI()


@app.get("/")
async def root():
    message = with_emoji(greet('World'))
    return {"message": message}
