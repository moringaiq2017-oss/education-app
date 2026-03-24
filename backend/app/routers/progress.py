"""
Progress Routes
مسارات التقدم
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func, case
from typing import List
from app.database import get_db
from app.models.child import Child
from app.models.lesson import Lesson
from app.models.progress import ChildProgress, ProgressStatus
from app.models.attempt import LessonAttempt
from app.models.track import Track
from app.schemas.progress import LessonAttemptCreate, ProgressResponse, ChildProgressSummary
from app.utils.auth import get_current_child
from datetime import datetime

router = APIRouter()

@router.post("/lessons/{lesson_id}/attempt", response_model=ProgressResponse)
def record_attempt(
    lesson_id: int,
    attempt_data: LessonAttemptCreate,
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    تسجيل محاولة درس
    """
    # التحقق من وجود الدرس
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    # التحقق من الصلاحية
    if not lesson.is_free and not current_child.is_premium:
        raise HTTPException(status_code=403, detail="Premium required")
    
    # حساب النجوم
    stars = 0
    if attempt_data.score >= 5:
        stars = 3
    elif attempt_data.score >= 4:
        stars = 2
    elif attempt_data.score >= 3:
        stars = 1
    
    # تحديد الحالة
    new_status = ProgressStatus.IN_PROGRESS
    if attempt_data.score >= 5:
        new_status = ProgressStatus.MASTERED
    elif attempt_data.score >= 3:
        new_status = ProgressStatus.COMPLETED
    
    # تسجيل المحاولة
    attempt = LessonAttempt(
        child_id=current_child.id,
        lesson_id=lesson_id,
        score=attempt_data.score,
        correct_answers=attempt_data.correct_answers,
        duration_seconds=attempt_data.duration_seconds,
        answers_json=attempt_data.answers_json
    )
    db.add(attempt)
    
    # تحديث أو إنشاء التقدم
    progress = db.query(ChildProgress).filter(
        ChildProgress.child_id == current_child.id,
        ChildProgress.lesson_id == lesson_id
    ).first()
    
    if progress:
        # تحديث
        if attempt_data.score > progress.best_score:
            progress.best_score = attempt_data.score
            progress.status = new_status
            progress.stars_earned = stars
        
        progress.attempts_count += 1
        progress.total_time_seconds += attempt_data.duration_seconds
        progress.last_attempt_at = func.now()
        
        if attempt_data.score >= 3 and not progress.completed_at:
            progress.completed_at = func.now()
    else:
        # إنشاء جديد
        progress = ChildProgress(
            child_id=current_child.id,
            lesson_id=lesson_id,
            status=new_status,
            best_score=attempt_data.score,
            attempts_count=1,
            total_time_seconds=attempt_data.duration_seconds,
            stars_earned=stars,
            started_at=func.now(),
            completed_at=func.now() if attempt_data.score >= 3 else None,
            last_attempt_at=func.now()
        )
        db.add(progress)
    
    db.commit()
    db.refresh(progress)
    
    return progress

@router.get("/children/me/progress", response_model=List[ProgressResponse])
def get_my_progress(
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    الحصول على تقدم الطفل الحالي
    """
    progress_list = db.query(ChildProgress).filter(
        ChildProgress.child_id == current_child.id
    ).all()
    
    return progress_list

@router.get("/children/me/summary", response_model=ChildProgressSummary)
def get_progress_summary(
    db: Session = Depends(get_db),
    current_child: Child = Depends(get_current_child)
):
    """
    ملخص تقدم الطفل
    """
    # إجمالي الدروس المكتملة
    total_completed = db.query(func.count(ChildProgress.id)).filter(
        ChildProgress.child_id == current_child.id,
        ChildProgress.status.in_([ProgressStatus.COMPLETED, ProgressStatus.MASTERED])
    ).scalar() or 0
    
    # إجمالي النجوم
    total_stars = db.query(func.sum(ChildProgress.stars_earned)).filter(
        ChildProgress.child_id == current_child.id
    ).scalar() or 0
    
    # عدد الإنجازات (placeholder)
    total_achievements = 0
    
    # التقدم حسب المسار
    tracks = db.query(Track).filter(Track.is_active == True).all()
    progress_by_track = []
    
    for track in tracks:
        # عدد دروس المسار
        total_lessons = db.query(func.count(Lesson.id)).filter(
            Lesson.track_id == track.id,
            Lesson.is_active == True
        ).scalar() or 0
        
        # عدد الدروس المكتملة
        completed_lessons = db.query(func.count(ChildProgress.id)).join(
            Lesson, ChildProgress.lesson_id == Lesson.id
        ).filter(
            ChildProgress.child_id == current_child.id,
            Lesson.track_id == track.id,
            ChildProgress.status.in_([ProgressStatus.COMPLETED, ProgressStatus.MASTERED])
        ).scalar() or 0
        
        progress_by_track.append({
            "track_id": track.id,
            "track_name_ar": track.name_ar,
            "total_lessons": total_lessons,
            "completed_lessons": completed_lessons,
            "completion_percentage": round((completed_lessons / total_lessons * 100), 2) if total_lessons > 0 else 0
        })
    
    return ChildProgressSummary(
        child_id=current_child.id,
        total_lessons_completed=total_completed,
        total_stars=int(total_stars),
        total_achievements=total_achievements,
        progress_by_track=progress_by_track
    )
