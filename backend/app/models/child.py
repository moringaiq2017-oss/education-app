"""
Child Model
نموذج الطفل
"""

from sqlalchemy import Column, Integer, String, TIMESTAMP, Boolean, func
from app.database import Base

class Child(Base):
    __tablename__ = "children"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    device_id = Column(String(255), unique=True, nullable=False, index=True)
    name = Column(String(100), nullable=False)
    age = Column(Integer, nullable=True)
    avatar = Column(String(50), default='default')
    created_at = Column(TIMESTAMP, server_default=func.now())
    last_active_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    is_premium = Column(Boolean, default=False)
    premium_expires_at = Column(TIMESTAMP, nullable=True)
