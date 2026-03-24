"""
Achievement Models
نماذج الإنجازات
"""

from sqlalchemy import Column, Integer, String, Text, Boolean, TIMESTAMP, ForeignKey, Enum, func
from app.database import Base
import enum

class ConditionType(str, enum.Enum):
    LESSON_COMPLETE = "lesson_complete"
    TRACK_COMPLETE = "track_complete"
    SCORE_PERFECT = "score_perfect"
    STREAK = "streak"
    TOTAL_LESSONS = "total_lessons"

class Achievement(Base):
    __tablename__ = "achievements"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    code = Column(String(50), unique=True, nullable=False)
    name_ar = Column(String(100), nullable=False)
    name_en = Column(String(100), nullable=False)
    description_ar = Column(Text)
    description_en = Column(Text)
    icon = Column(String(50))
    
    condition_type = Column(Enum(ConditionType), nullable=False)
    condition_value = Column(Integer)
    
    display_order = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())

class ChildAchievement(Base):
    __tablename__ = "child_achievements"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    child_id = Column(Integer, ForeignKey('children.id', ondelete='CASCADE'), nullable=False)
    achievement_id = Column(Integer, ForeignKey('achievements.id', ondelete='CASCADE'), nullable=False)
    earned_at = Column(TIMESTAMP, server_default=func.now())
