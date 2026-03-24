"""
Test Configuration & Fixtures
إعدادات وتجهيزات الاختبار
"""

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
from app.main import app
from app.database import get_db, Base
from app.models.child import Child
from app.models.track import Track
from app.models.lesson import Lesson
from app.utils.auth import create_access_token

# إنشاء قاعدة بيانات اختبار في الذاكرة
SQLALCHEMY_TEST_DATABASE_URL = "sqlite:///:memory:"

@pytest.fixture(scope="function")
def db_engine():
    """إنشاء محرك قاعدة بيانات للاختبار"""
    engine = create_engine(
        SQLALCHEMY_TEST_DATABASE_URL,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def db_session(db_engine):
    """إنشاء جلسة قاعدة بيانات للاختبار"""
    TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=db_engine)
    session = TestingSessionLocal()
    yield session
    session.close()

@pytest.fixture(scope="function")
def client(db_session):
    """إنشاء عميل اختبار FastAPI"""
    def override_get_db():
        try:
            yield db_session
        finally:
            pass
    
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()

@pytest.fixture
def sample_child(db_session):
    """إنشاء طفل تجريبي"""
    child = Child(
        device_id="test-device-123",
        name="أحمد",
        age=8,
        avatar="default",
        is_premium=False
    )
    db_session.add(child)
    db_session.commit()
    db_session.refresh(child)
    return child

@pytest.fixture
def premium_child(db_session):
    """إنشاء طفل مميز (Premium)"""
    child = Child(
        device_id="premium-device-456",
        name="سارة",
        age=9,
        avatar="premium",
        is_premium=True
    )
    db_session.add(child)
    db_session.commit()
    db_session.refresh(child)
    return child

@pytest.fixture
def auth_token(sample_child):
    """إنشاء token مصادقة للطفل التجريبي"""
    return create_access_token(data={"sub": str(sample_child.id)})

@pytest.fixture
def premium_auth_token(premium_child):
    """إنشاء token مصادقة للطفل المميز"""
    return create_access_token(data={"sub": str(premium_child.id)})

@pytest.fixture
def auth_headers(auth_token):
    """رؤوس HTTP مع token المصادقة"""
    return {"Authorization": f"Bearer {auth_token}"}

@pytest.fixture
def premium_auth_headers(premium_auth_token):
    """رؤوس HTTP مع token المصادقة للمميز"""
    return {"Authorization": f"Bearer {premium_auth_token}"}

@pytest.fixture
def sample_track(db_session):
    """إنشاء مسار تجريبي"""
    track = Track(
        name_ar="الحروف العربية",
        name_en="Arabic Letters",
        description="تعلم الحروف العربية",
        icon="letters",
        color="#4CAF50",
        display_order=1,
        is_active=True
    )
    db_session.add(track)
    db_session.commit()
    db_session.refresh(track)
    return track

@pytest.fixture
def sample_lessons(db_session, sample_track):
    """إنشاء دروس تجريبية"""
    lessons = [
        Lesson(
            track_id=sample_track.id,
            lesson_number=1,
            title_ar="حرف الألف",
            title_en="Letter Alif",
            description="تعلم حرف الألف",
            duration_seconds=300,
            is_free=True,
            display_order=1,
            is_active=True,
            content_json={"letter": "أ", "examples": ["أسد", "أرنب"]},
            questions_json=[
                {"question": "ما هو الحرف؟", "answer": "أ"}
            ]
        ),
        Lesson(
            track_id=sample_track.id,
            lesson_number=2,
            title_ar="حرف الباء",
            title_en="Letter Ba",
            description="تعلم حرف الباء",
            duration_seconds=300,
            is_free=False,
            display_order=2,
            is_active=True,
            content_json={"letter": "ب", "examples": ["بطة", "بيت"]},
            questions_json=[
                {"question": "ما هو الحرف؟", "answer": "ب"}
            ]
        )
    ]
    
    for lesson in lessons:
        db_session.add(lesson)
    
    db_session.commit()
    for lesson in lessons:
        db_session.refresh(lesson)
    
    return lessons
