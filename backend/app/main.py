from fastapi import FastAPI

from app.api.v1.router import v1_router

app = FastAPI(
    title="Durga Safety API",
    description="Backend for the Durga Women Safety Application",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.include_router(v1_router)


@app.get("/health", tags=["health"])
def health_check():
    return {"status": "ok"}
