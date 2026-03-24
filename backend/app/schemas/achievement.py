"""
Achievement Schemas
مخططات الإنجازات
"""

from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AchievementResponse(BaseModel):
    id: int
    code: str
    name_ar: str
    name_en: str
    description_ar: Optional[str]
    description_en: Optional[str]
    icon: Optional[str]
    
    class Config:
        from_attributes = True

class ChildAchievementResponse(BaseModel):
    achievement: AchievementResponse
    earned_at: datetime
    
    class Config:
        from_attributes = True
