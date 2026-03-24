"""
Lesson Model
نموذج الدرس
"""

from sqlalchemy import Column, Integer, String, Text, Boolean, TIMESTAMP, ForeignKey, JSON, func
from sqlalchemy.orm import relationship
from app.database import Base

class Lesson(Base):
    __tablename__ = "lessons"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    track_id = Column(Integer, ForeignKey('tracks.id', ondelete='CASCADE'), nullable=False)
    lesson_number = Column(Integer, nullable=False)
    title_ar = Column(String(200), nullable=False)
    title_en = Column(String(200), nullable=False)
    description = Column(Text)
    duration_seconds = Column(Integer, default=360)
    
    content_json = Column(JSON)
    audio_file = Column(String(255))
    video_file = Column(String(255))
    questions_json = Column(JSON)
    
    is_free = Column(Boolean, default=True)
    requires_lesson_id = Column(Integer, ForeignKey('lessons.id', ondelete='SET NULL'), nullable=True)
    
    display_order = Column(Integer, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
    
    # Relationships
    track = relationship("Track", back_populates="lessons")
