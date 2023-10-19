from fastapi import FastAPI


app = FastAPI()

@app.get("/")
async def mm():
    data = [0] * 1000000
    data2 = [0] * 1000000
    return {"message": "Hello World"}
