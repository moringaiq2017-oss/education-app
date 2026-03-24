"""
Child Progress Model
نموذج تقدم الطفل
"""

from sqlalchemy import Column, Integer, String, TIMESTAMP, ForeignKey, Enum, func
from app.database import Base
import enum

class ProgressStatus(str, enum.Enum):
    NOT_STARTED = "not_started"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    MASTERED = "mastered"

class ChildProgress(Base):
    __tablename__ = "child_progress"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    child_id = Column(Integer, ForeignKey('children.id', ondelete='CASCADE'), nullable=False)
    lesson_id = Column(Integer, ForeignKey('lessons.id', ondelete='CASCADE'), nullable=False)
    
    status = Column(Enum(ProgressStatus), default=ProgressStatus.NOT_STARTED)
    best_score = Column(Integer, default=0)
    attempts_count = Column(Integer, default=0)
    total_time_seconds = Column(Integer, default=0)
    stars_earned = Column(Integer, default=0)
    
    started_at = Column(TIMESTAMP, nullable=True)
    completed_at = Column(TIMESTAMP, nullable=True)
    last_attempt_at = Column(TIMESTAMP, nullable=True)
    
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())
