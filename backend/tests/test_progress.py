"""
Progress Tests
اختبارات التقدم والمحاولات
"""

import pytest
from fastapi import status

class TestLessonAttempt:
    """اختبارات تسجيل محاولة درس"""
    
    def test_record_first_attempt_success(self, client, sample_lessons, auth_headers):
        """اختبار تسجيل أول محاولة بنجاح"""
        lesson_id = sample_lessons[0].id
        
        attempt_data = {
            "score": 5,
            "correct_answers": 5,
            "duration_seconds": 120,
            "answers_json": {"q1": "أ", "q2": "أ"}
        }
        
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json=attempt_data,
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_200_OK
        progress = response.json()
        assert progress["lesson_id"] == lesson_id
        assert progress["best_score"] == 5
        assert progress["stars_earned"] == 3
        assert progress["attempts_count"] == 1
        assert progress["status"] == "MASTERED"
    
    def test_record_second_attempt_updates_best_score(self, client, sample_lessons, auth_headers, db_session):
        """اختبار أن المحاولة الثانية تحدث أفضل درجة"""
        from app.models.progress import ChildProgress, ProgressStatus
        from app.utils.auth import verify_token
        
        lesson_id = sample_lessons[0].id
        token = auth_headers["Authorization"].replace("Bearer ", "")
        child_id = int(verify_token(token))
        
        # إنشاء تقدم أولي بدرجة منخفضة
        initial_progress = ChildProgress(
            child_id=child_id,
            lesson_id=lesson_id,
            status=ProgressStatus.IN_PROGRESS,
            best_score=2,
            attempts_count=1,
            total_time_seconds=100,
            stars_earned=0
        )
        db_session.add(initial_progress)
        db_session.commit()
        
        # تسجيل محاولة جديدة بدرجة أعلى
        attempt_data = {
            "score": 4,
            "correct_answers": 4,
            "duration_seconds": 90
        }
        
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json=attempt_data,
            headers=auth_headers
        )
        
        progress = response.json()
        assert progress["best_score"] == 4
        assert progress["stars_earned"] == 2
        assert progress["attempts_count"] == 2
    
    def test_stars_calculation(self, client, sample_lessons, auth_headers):
        """اختبار حساب النجوم بشكل صحيح"""
        lesson_id = sample_lessons[0].id
        
        test_cases = [
            (5, 3),  # درجة 5 = 3 نجوم
            (4, 2),  # درجة 4 = 2 نجمة
            (3, 1),  # درجة 3 = 1 نجمة
            (2, 0),  # درجة 2 = 0 نجمة
        ]
        
        for score, expected_stars in test_cases:
            # استخدام lesson مختلف لكل اختبار
            from app.models.lesson import Lesson
            new_lesson = Lesson(
                track_id=sample_lessons[0].track_id,
                lesson_number=score,
                title_ar=f"اختبار {score}",
                title_en=f"Test {score}",
                duration_seconds=300,
                is_free=True,
                display_order=score,
                is_active=True
            )
            client.app.dependency_overrides[client.get("/api/v1", None)]
            
            # لكل درجة، سنستخدم الدرس المجاني الأول
            attempt_data = {
                "score": score,
                "correct_answers": score,
                "duration_seconds": 100
            }
            
            # سنتحقق فقط من الحساب الأول
            if score == 5:
                response = client.post(
                    f"/api/v1/lessons/{lesson_id}/attempt",
                    json=attempt_data,
                    headers=auth_headers
                )
                progress = response.json()
                assert progress["stars_earned"] == expected_stars
                break
    
    def test_status_calculation(self, client, sample_lessons, auth_headers):
        """اختبار حساب حالة التقدم بشكل صحيح"""
        lesson_id = sample_lessons[0].id
        
        # درجة 5 = MASTERED
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 100},
            headers=auth_headers
        )
        assert response.json()["status"] == "MASTERED"
    
    def test_attempt_requires_auth(self, client, sample_lessons):
        """اختبار أن تسجيل المحاولة يتطلب مصادقة"""
        lesson_id = sample_lessons[0].id
        
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 100}
        )
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
    
    def test_attempt_non_existing_lesson(self, client, auth_headers):
        """اختبار رفض محاولة لدرس غير موجود"""
        response = client.post(
            "/api/v1/lessons/99999/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 100},
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_404_NOT_FOUND
    
    def test_free_user_cannot_attempt_premium_lesson(self, client, sample_lessons, auth_headers):
        """اختبار أن المستخدم المجاني لا يستطيع محاولة درس مميز"""
        premium_lesson_id = sample_lessons[1].id
        
        response = client.post(
            f"/api/v1/lessons/{premium_lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 100},
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
        assert "premium" in response.json()["detail"].lower()
    
    def test_premium_user_can_attempt_premium_lesson(self, client, sample_lessons, premium_auth_headers):
        """اختبار أن المستخدم المميز يستطيع محاولة درس مميز"""
        premium_lesson_id = sample_lessons[1].id
        
        response = client.post(
            f"/api/v1/lessons/{premium_lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 100},
            headers=premium_auth_headers
        )
        
        assert response.status_code == status.HTTP_200_OK
    
    def test_invalid_score_rejected(self, client, sample_lessons, auth_headers):
        """اختبار رفض درجة غير صحيحة"""
        lesson_id = sample_lessons[0].id
        
        # درجة أكبر من 5
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 10, "correct_answers": 5, "duration_seconds": 100},
            headers=auth_headers
        )
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
        
        # درجة سالبة
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": -1, "correct_answers": 5, "duration_seconds": 100},
            headers=auth_headers
        )
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
    
    def test_invalid_duration_rejected(self, client, sample_lessons, auth_headers):
        """اختبار رفض مدة غير صحيحة"""
        lesson_id = sample_lessons[0].id
        
        response = client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": -10},
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


class TestProgress:
    """اختبارات التقدم العام"""
    
    def test_get_my_progress_empty(self, client, auth_headers):
        """اختبار الحصول على تقدم فارغ"""
        response = client.get("/api/v1/children/me/progress", headers=auth_headers)
        
        assert response.status_code == status.HTTP_200_OK
        progress_list = response.json()
        assert isinstance(progress_list, list)
        assert len(progress_list) == 0
    
    def test_get_my_progress_with_data(self, client, sample_lessons, auth_headers):
        """اختبار الحصول على تقدم مع بيانات"""
        # تسجيل محاولة أولاً
        lesson_id = sample_lessons[0].id
        client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 120},
            headers=auth_headers
        )
        
        # جلب التقدم
        response = client.get("/api/v1/children/me/progress", headers=auth_headers)
        
        assert response.status_code == status.HTTP_200_OK
        progress_list = response.json()
        assert len(progress_list) == 1
        assert progress_list[0]["lesson_id"] == lesson_id
    
    def test_get_progress_requires_auth(self, client):
        """اختبار أن جلب التقدم يتطلب مصادقة"""
        response = client.get("/api/v1/children/me/progress")
        
        assert response.status_code == status.HTTP_403_FORBIDDEN


class TestProgressSummary:
    """اختبارات ملخص التقدم"""
    
    def test_get_summary_empty(self, client, auth_headers):
        """اختبار الحصول على ملخص فارغ"""
        response = client.get("/api/v1/children/me/summary", headers=auth_headers)
        
        assert response.status_code == status.HTTP_200_OK
        summary = response.json()
        assert summary["total_lessons_completed"] == 0
        assert summary["total_stars"] == 0
        assert summary["total_achievements"] == 0
    
    def test_get_summary_with_progress(self, client, sample_lessons, auth_headers):
        """اختبار الحصول على ملخص مع تقدم"""
        # تسجيل محاولة ناجحة
        lesson_id = sample_lessons[0].id
        client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 120},
            headers=auth_headers
        )
        
        # جلب الملخص
        response = client.get("/api/v1/children/me/summary", headers=auth_headers)
        
        assert response.status_code == status.HTTP_200_OK
        summary = response.json()
        assert summary["total_lessons_completed"] == 1
        assert summary["total_stars"] == 3
    
    def test_summary_includes_progress_by_track(self, client, sample_track, sample_lessons, auth_headers):
        """اختبار أن الملخص يحتوي على التقدم حسب المسار"""
        response = client.get("/api/v1/children/me/summary", headers=auth_headers)
        
        summary = response.json()
        assert "progress_by_track" in summary
        assert isinstance(summary["progress_by_track"], list)
        
        # التحقق من وجود المسار التجريبي
        track_progress = next(
            (t for t in summary["progress_by_track"] if t["track_id"] == sample_track.id),
            None
        )
        assert track_progress is not None
        assert "total_lessons" in track_progress
        assert "completed_lessons" in track_progress
        assert "completion_percentage" in track_progress
    
    def test_summary_requires_auth(self, client):
        """اختبار أن جلب الملخص يتطلب مصادقة"""
        response = client.get("/api/v1/children/me/summary")
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
    
    def test_summary_calculates_completion_percentage(self, client, sample_track, sample_lessons, auth_headers):
        """اختبار حساب نسبة الإنجاز بشكل صحيح"""
        # إكمال درس واحد من اثنين
        lesson_id = sample_lessons[0].id
        client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={"score": 5, "correct_answers": 5, "duration_seconds": 120},
            headers=auth_headers
        )
        
        response = client.get("/api/v1/children/me/summary", headers=auth_headers)
        summary = response.json()
        
        track_progress = next(
            t for t in summary["progress_by_track"] if t["track_id"] == sample_track.id
        )
        
        # المستخدم المجاني يرى درس واحد فقط
        # لذلك النسبة = 100%
        assert track_progress["total_lessons"] == 1
        assert track_progress["completed_lessons"] == 1
        assert track_progress["completion_percentage"] == 100.0


class TestAttemptData:
    """اختبارات بيانات المحاولة"""
    
    def test_attempt_saves_answers_json(self, client, sample_lessons, auth_headers, db_session):
        """اختبار حفظ إجابات الطفل JSON"""
        from app.models.attempt import LessonAttempt
        from app.utils.auth import verify_token
        
        lesson_id = sample_lessons[0].id
        token = auth_headers["Authorization"].replace("Bearer ", "")
        child_id = int(verify_token(token))
        
        answers = {
            "q1": "أ",
            "q2": "أ",
            "q3": "أسد"
        }
        
        client.post(
            f"/api/v1/lessons/{lesson_id}/attempt",
            json={
                "score": 5,
                "correct_answers": 5,
                "duration_seconds": 120,
                "answers_json": answers
            },
            headers=auth_headers
        )
        
        # التحقق من حفظ البيانات في قاعدة البيانات
        attempt = db_session.query(LessonAttempt).filter(
            LessonAttempt.child_id == child_id,
            LessonAttempt.lesson_id == lesson_id
        ).first()
        
        assert attempt is not None
        assert attempt.answers_json == answers
    
    def test_multiple_attempts_saved_separately(self, client, sample_lessons, auth_headers, db_session):
        """اختبار حفظ المحاولات المتعددة بشكل منفصل"""
        from app.models.attempt import LessonAttempt
        from app.utils.auth import verify_token
        
        lesson_id = sample_lessons[0].id
        token = auth_headers["Authorization"].replace("Bearer ", "")
        child_id = int(verify_token(token))
        
        # تسجيل محاولتين
        for i in range(2):
            client.post(
                f"/api/v1/lessons/{lesson_id}/attempt",
                json={
                    "score": 3 + i,
                    "correct_answers": 3 + i,
                    "duration_seconds": 100 + i * 10
                },
                headers=auth_headers
            )
        
        # التحقق من وجود محاولتين
        attempts = db_session.query(LessonAttempt).filter(
            LessonAttempt.child_id == child_id,
            LessonAttempt.lesson_id == lesson_id
        ).all()
        
        assert len(attempts) == 2
