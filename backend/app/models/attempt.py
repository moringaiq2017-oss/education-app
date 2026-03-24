"""
Lesson Attempt Model
نموذج محاولة الدرس
"""

from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP, JSON, func
from app.database import Base

class LessonAttempt(Base):
    __tablename__ = "lesson_attempts"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    child_id = Column(Integer, ForeignKey('children.id', ondelete='CASCADE'), nullable=False)
    lesson_id = Column(Integer, ForeignKey('lessons.id', ondelete='CASCADE'), nullable=False)
    
    score = Column(Integer, nullable=False)
    correct_answers = Column(Integer, nullable=False)
    total_questions = Column(Integer, default=5)
    duration_seconds = Column(Integer)
    
    answers_json = Column(JSON)
    
    attempted_at = Column(TIMESTAMP, server_default=func.now())
