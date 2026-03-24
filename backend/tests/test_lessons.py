"""
Lessons & Tracks Tests
اختبارات الدروس والمسارات
"""

import pytest
from fastapi import status

class TestTracks:
    """اختبارات المسارات"""
    
    def test_get_all_tracks(self, client, sample_track):
        """اختبار الحصول على جميع المسارات"""
        response = client.get("/api/v1/tracks")
        
        assert response.status_code == status.HTTP_200_OK
        tracks = response.json()
        assert isinstance(tracks, list)
        assert len(tracks) >= 1
        assert tracks[0]["name_ar"] == sample_track.name_ar
    
    def test_get_specific_track(self, client, sample_track):
        """اختبار الحصول على مسار محدد"""
        response = client.get(f"/api/v1/tracks/{sample_track.id}")
        
        assert response.status_code == status.HTTP_200_OK
        track = response.json()
        assert track["id"] == sample_track.id
        assert track["name_ar"] == sample_track.name_ar
        assert track["name_en"] == sample_track.name_en
    
    def test_get_non_existing_track(self, client):
        """اختبار رفض الحصول على مسار غير موجود"""
        response = client.get("/api/v1/tracks/99999")
        
        assert response.status_code == status.HTTP_404_NOT_FOUND
    
    def test_tracks_ordered_by_display_order(self, client, db_session):
        """اختبار أن المسارات مرتبة حسب display_order"""
        from app.models.track import Track
        
        # إنشاء مسارات بترتيب مختلف
        tracks_data = [
            ("المسار الثالث", 3),
            ("المسار الأول", 1),
            ("المسار الثاني", 2)
        ]
        
        for name, order in tracks_data:
            track = Track(
                name_ar=name,
                name_en=name,
                description=f"وصف {name}",
                icon="icon",
                color="#000000",
                display_order=order,
                is_active=True
            )
            db_session.add(track)
        
        db_session.commit()
        
        response = client.get("/api/v1/tracks")
        tracks = response.json()
        
        assert tracks[0]["name_ar"] == "المسار الأول"
        assert tracks[1]["name_ar"] == "المسار الثاني"
        assert tracks[2]["name_ar"] == "المسار الثالث"


class TestLessons:
    """اختبارات الدروس"""
    
    def test_get_track_lessons(self, client, sample_track, sample_lessons, auth_headers):
        """اختبار الحصول على دروس المسار"""
        response = client.get(
            f"/api/v1/tracks/{sample_track.id}/lessons",
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_200_OK
        lessons = response.json()
        assert isinstance(lessons, list)
        assert len(lessons) >= 1
    
    def test_free_user_sees_only_free_lessons(self, client, sample_track, sample_lessons, auth_headers):
        """اختبار أن المستخدم المجاني يرى الدروس المجانية فقط"""
        response = client.get(
            f"/api/v1/tracks/{sample_track.id}/lessons",
            headers=auth_headers
        )
        
        lessons = response.json()
        # يجب أن يرى درس واحد فقط (المجاني)
        assert len(lessons) == 1
        assert lessons[0]["is_free"] is True
    
    def test_premium_user_sees_all_lessons(self, client, sample_track, sample_lessons, premium_auth_headers):
        """اختبار أن المستخدم المميز يرى جميع الدروس"""
        response = client.get(
            f"/api/v1/tracks/{sample_track.id}/lessons",
            headers=premium_auth_headers
        )
        
        lessons = response.json()
        # يجب أن يرى جميع الدروس
        assert len(lessons) == 2
    
    def test_get_track_lessons_requires_auth(self, client, sample_track):
        """اختبار أن جلب دروس المسار يتطلب مصادقة"""
        response = client.get(f"/api/v1/tracks/{sample_track.id}/lessons")
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
    
    def test_get_lessons_for_non_existing_track(self, client, auth_headers):
        """اختبار رفض جلب دروس لمسار غير موجود"""
        response = client.get("/api/v1/tracks/99999/lessons", headers=auth_headers)
        
        assert response.status_code == status.HTTP_404_NOT_FOUND


class TestLessonDetails:
    """اختبارات تفاصيل الدرس"""
    
    def test_get_free_lesson_details(self, client, sample_lessons, auth_headers):
        """اختبار الحصول على تفاصيل درس مجاني"""
        free_lesson = sample_lessons[0]
        response = client.get(
            f"/api/v1/lessons/{free_lesson.id}",
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_200_OK
        lesson = response.json()
        assert lesson["id"] == free_lesson.id
        assert lesson["title_ar"] == free_lesson.title_ar
        assert "content_json" in lesson
        assert "questions_json" in lesson
    
    def test_free_user_cannot_access_premium_lesson(self, client, sample_lessons, auth_headers):
        """اختبار أن المستخدم المجاني لا يستطيع الوصول لدرس مميز"""
        premium_lesson = sample_lessons[1]
        response = client.get(
            f"/api/v1/lessons/{premium_lesson.id}",
            headers=auth_headers
        )
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
        assert "premium" in response.json()["detail"].lower()
    
    def test_premium_user_can_access_premium_lesson(self, client, sample_lessons, premium_auth_headers):
        """اختبار أن المستخدم المميز يستطيع الوصول لدرس مميز"""
        premium_lesson = sample_lessons[1]
        response = client.get(
            f"/api/v1/lessons/{premium_lesson.id}",
            headers=premium_auth_headers
        )
        
        assert response.status_code == status.HTTP_200_OK
        lesson = response.json()
        assert lesson["id"] == premium_lesson.id
    
    def test_get_non_existing_lesson(self, client, auth_headers):
        """اختبار رفض الحصول على درس غير موجود"""
        response = client.get("/api/v1/lessons/99999", headers=auth_headers)
        
        assert response.status_code == status.HTTP_404_NOT_FOUND
    
    def test_get_lesson_requires_auth(self, client, sample_lessons):
        """اختبار أن جلب تفاصيل الدرس يتطلب مصادقة"""
        response = client.get(f"/api/v1/lessons/{sample_lessons[0].id}")
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
    
    def test_lesson_details_include_all_fields(self, client, sample_lessons, auth_headers):
        """اختبار أن تفاصيل الدرس تحتوي على جميع الحقول"""
        lesson_id = sample_lessons[0].id
        response = client.get(f"/api/v1/lessons/{lesson_id}", headers=auth_headers)
        
        lesson = response.json()
        required_fields = [
            "id", "track_id", "lesson_number", "title_ar", "title_en",
            "description", "duration_seconds", "is_free", "display_order",
            "content_json", "questions_json"
        ]
        
        for field in required_fields:
            assert field in lesson, f"الحقل {field} مفقود"


class TestLessonContent:
    """اختبارات محتوى الدرس"""
    
    def test_lesson_content_json_structure(self, client, sample_lessons, auth_headers):
        """اختبار بنية محتوى الدرس JSON"""
        lesson_id = sample_lessons[0].id
        response = client.get(f"/api/v1/lessons/{lesson_id}", headers=auth_headers)
        
        lesson = response.json()
        assert lesson["content_json"] is not None
        assert "letter" in lesson["content_json"]
        assert "examples" in lesson["content_json"]
    
    def test_lesson_questions_json_structure(self, client, sample_lessons, auth_headers):
        """اختبار بنية أسئلة الدرس JSON"""
        lesson_id = sample_lessons[0].id
        response = client.get(f"/api/v1/lessons/{lesson_id}", headers=auth_headers)
        
        lesson = response.json()
        assert lesson["questions_json"] is not None
        assert isinstance(lesson["questions_json"], list)
        assert len(lesson["questions_json"]) > 0
