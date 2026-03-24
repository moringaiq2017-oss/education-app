"""
Authentication Routes
مسارات المصادقة
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.child import Child
from app.schemas.child import ChildCreate, ChildLogin, AuthResponse, ChildResponse
from app.utils.auth import create_access_token

router = APIRouter()

@router.post("/register", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
def register(child_data: ChildCreate, db: Session = Depends(get_db)):
    """
    تسجيل طفل جديد
    """
    # التحقق من عدم وجود device_id مسبقاً
    existing = db.query(Child).filter(Child.device_id == child_data.device_id).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Device already registered"
        )
    
    # إنشاء طفل جديد
    child = Child(
        device_id=child_data.device_id,
        name=child_data.name,
        age=child_data.age,
        grade=child_data.grade,
        avatar=child_data.avatar or "default"
    )
    db.add(child)
    db.commit()
    db.refresh(child)
    
    # إنشاء token
    access_token = create_access_token(data={"sub": str(child.id)})
    
    return AuthResponse(
        access_token=access_token,
        child=ChildResponse.from_orm(child)
    )

@router.post("/login", response_model=AuthResponse)
def login(login_data: ChildLogin, db: Session = Depends(get_db)):
    """
    تسجيل دخول بواسطة device_id
    """
    child = db.query(Child).filter(Child.device_id == login_data.device_id).first()
    if not child:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Device not registered"
        )
    
    # تحديث آخر نشاط
    from sqlalchemy import func
    child.last_active_at = func.now()
    db.commit()
    
    # إنشاء token
    access_token = create_access_token(data={"sub": str(child.id)})
    
    return AuthResponse(
        access_token=access_token,
        child=ChildResponse.from_orm(child)
    )
