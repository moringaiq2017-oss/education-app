"""
Database Connection & Session
إعداد الاتصال بقاعدة البيانات
"""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.config import settings

# Create engine
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    echo=settings.ENVIRONMENT == "development"
)

# Create session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for models
Base = declarative_base()

# Dependency for routes
def get_db():
    """
    Dependency that creates a new database session for each request
    and closes it when done.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
