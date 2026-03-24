"""
Achievements Routes
مسارات الإنجازات
"""

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app.models.child import Child
from app.models.achievement import Achievement, ChildAchievement
from app.schemas.achievement import AchievementResponse, ChildAchievementResponse
from app.utils.auth import get_current_child

router = APIRouter()

@router.get("/achievements", response_model=List[AchievementResponse])
def get_all_achievements(db: Session = Depends(get_db)):
    """
    الحصول على جميع الإنجازات
    """
    achievements = db.query(Achievement).filter(
        Achievement.is_active == True
    ).order_by(Achievement.display_order).all()
    
    return achievements

@router.get("/children/me/achievements", response_model=List[ChildAchievementResponse])
def get_my_achievements(
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    الحصول على إنجازات الطفل
    """
    child_achievements = db.query(ChildAchievement).join(
        Achievement, ChildAchievement.achievement_id == Achievement.id
    ).filter(
        ChildAchievement.child_id == current_child.id
    ).all()
    
    result = []
    for ca in child_achievements:
        achievement = db.query(Achievement).filter(Achievement.id == ca.achievement_id).first()
        result.append({
            "achievement": achievement,
            "earned_at": ca.earned_at
        })
    
    return result
