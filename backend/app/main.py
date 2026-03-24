"""
FastAPI Main Application
تطبيق تعليم الأطفال العراقيين - Backend API
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import auth, tracks, progress, achievements

app = FastAPI(
    title="Education App Iraq API",
    description="REST API لتطبيق تعليم الأطفال العراقيين",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # للتطوير فقط - حدده لاحقاً
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Root endpoint
@app.get("/")
def read_root():
    return {
        "message": "مرحباً بك في API تطبيق تعليم الأطفال العراقيين",
        "status": "running",
        "version": "1.0.0",
        "docs": "/docs"
    }

# Health check
@app.get("/health")
def health_check():
    return {"status": "healthy"}

# Include routers
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
app.include_router(tracks.router, prefix="/api/v1", tags=["Tracks & Lessons"])
app.include_router(progress.router, prefix="/api/v1", tags=["Progress"])
app.include_router(achievements.router, prefix="/api/v1", tags=["Achievements"])

# Startup event
@app.on_event("startup")
async def startup_event():
    print("🚀 Backend API started")
    print(f"📚 Environment: {settings.ENVIRONMENT}")
    print(f"📊 Database: {settings.DATABASE_URL.split('@')[1] if '@' in settings.DATABASE_URL else 'configured'}")
    print(f"📖 Docs: http://localhost:8000/docs")

# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    print("👋 Backend API shutting down")
