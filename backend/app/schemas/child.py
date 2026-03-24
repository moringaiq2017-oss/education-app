"""
Child Schemas
مخططات الطفل
"""

from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class ChildCreate(BaseModel):
    device_id: str = Field(..., description="معرّف الجهاز")
    name: str = Field(..., min_length=2, max_length=100, description="اسم الطفل")
    age: Optional[int] = Field(None, ge=6, le=12, description="العمر")
    grade: Optional[int] = Field(None, ge=1, le=6, description="المرحلة الدراسية (1-6)")
    avatar: Optional[str] = Field("default", description="الصورة الرمزية")

class ChildLogin(BaseModel):
    device_id: str = Field(..., description="معرّف الجهاز")

class ChildResponse(BaseModel):
    id: int
    device_id: str
    name: str
    age: Optional[int]
    grade: Optional[int]
    avatar: str
    is_premium: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    child: ChildResponse
