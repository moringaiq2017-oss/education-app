"""
Progress Schemas
مخططات التقدم
"""

from pydantic import BaseModel, Field
from typing import Optional, List, Any
from datetime import datetime
from app.models.progress import ProgressStatus

class LessonAttemptCreate(BaseModel):
    score: int = Field(..., ge=0, le=5, description="الدرجة من 5")
    correct_answers: int = Field(..., ge=0, le=5)
    duration_seconds: int = Field(..., ge=0)
    answers_json: Optional[Any] = None

class ProgressResponse(BaseModel):
    lesson_id: int
    status: ProgressStatus
    best_score: int
    attempts_count: int
    stars_earned: int
    completed_at: Optional[datetime]
    
    class Config:
        from_attributes = True

class ChildProgressSummary(BaseModel):
    child_id: int
    total_lessons_completed: int
    total_stars: int
    total_achievements: int
    progress_by_track: List[dict]
