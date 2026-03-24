"""
Track Model
نموذج المسار
"""

from sqlalchemy import Column, Integer, String, Text, Boolean, TIMESTAMP, func
from sqlalchemy.orm import relationship
from app.database import Base

class Track(Base):
    __tablename__ = "tracks"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name_ar = Column(String(100), nullable=False)
    name_en = Column(String(100), nullable=False)
    description = Column(Text)
    icon = Column(String(50))
    color = Column(String(7), default='#4A90E2')
    display_order = Column(Integer, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    
    # Relationships
    lessons = relationship("Lesson", back_populates="track")
