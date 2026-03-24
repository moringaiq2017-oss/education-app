"""
Lesson Schemas
مخططات الدرس
"""

from pydantic import BaseModel
from typing import Optional, Any
from datetime import datetime

class LessonResponse(BaseModel):
    id: int
    track_id: int
    lesson_number: int
    title_ar: str
    title_en: str
    description: Optional[str]
    duration_seconds: int
    is_free: bool
    display_order: int
    
    class Config:
        from_attributes = True

class LessonDetail(LessonResponse):
    content_json: Optional[Any]
    audio_file: Optional[str]
    video_file: Optional[str]
    questions_json: Optional[Any]
    requires_lesson_id: Optional[int]
    
    class Config:
        from_attributes = True
