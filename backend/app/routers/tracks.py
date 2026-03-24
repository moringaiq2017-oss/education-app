"""
Tracks & Lessons Routes
مسارات المسارات والدروس
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app.models.track import Track
from app.models.lesson import Lesson
from app.models.child import Child
from app.schemas.track import TrackResponse
from app.schemas.lesson import LessonResponse, LessonDetail
from app.utils.auth import get_current_child

router = APIRouter()

@router.get("/tracks", response_model=List[TrackResponse])
def get_tracks(db: Session = Depends(get_db)):
    """
    الحصول على جميع المسارات
    """
    tracks = db.query(Track).filter(Track.is_active == True).order_by(Track.display_order).all()
    return tracks

@router.get("/tracks/{track_id}", response_model=TrackResponse)
def get_track(track_id: int, db: Session = Depends(get_db)):
    """
    الحصول على مسار محدد
    """
    track = db.query(Track).filter(Track.id == track_id, Track.is_active == True).first()
    if not track:
        raise HTTPException(status_code=404, detail="Track not found")
    return track

@router.get("/tracks/{track_id}/lessons", response_model=List[LessonResponse])
def get_track_lessons(
    track_id: int,
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    الحصول على دروس المسار
    """
    # التحقق من وجود المسار
    track = db.query(Track).filter(Track.id == track_id).first()
    if not track:
        raise HTTPException(status_code=404, detail="Track not found")
    
    # جلب الدروس
    lessons = db.query(Lesson).filter(
        Lesson.track_id == track_id,
        Lesson.is_active == True
    ).order_by(Lesson.display_order).all()
    
    # فلترة الدروس حسب Premium
    if not current_child.is_premium:
        lessons = [l for l in lessons if l.is_free]
    
    return lessons

@router.get("/lessons/{lesson_id}", response_model=LessonDetail)
def get_lesson(
    lesson_id: int,
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    الحصول على تفاصيل درس
    """
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    # التحقق من الصلاحية
    if not lesson.is_free and not current_child.is_premium:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Premium subscription required"
        )
    
    return lesson
