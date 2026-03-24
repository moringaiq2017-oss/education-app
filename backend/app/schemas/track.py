"""
Track Schemas
مخططات المسار
"""

from pydantic import BaseModel
from typing import Optional

class TrackResponse(BaseModel):
    id: int
    name_ar: str
    name_en: str
    description: Optional[str]
    icon: Optional[str]
    color: str
    display_order: int
    
    class Config:
        from_attributes = True
