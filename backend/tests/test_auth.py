"""
Authentication Tests
اختبارات المصادقة
"""

import pytest
from fastapi import status

class TestRegistration:
    """اختبارات التسجيل"""
    
    def test_register_new_child_success(self, client):
        """اختبار تسجيل طفل جديد بنجاح"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": "new-device-789",
            "name": "محمد",
            "age": 7,
            "avatar": "boy1"
        })
        
        assert response.status_code == status.HTTP_201_CREATED
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
        assert data["child"]["name"] == "محمد"
        assert data["child"]["age"] == 7
        assert data["child"]["device_id"] == "new-device-789"
        assert data["child"]["is_premium"] is False
    
    def test_register_duplicate_device_id(self, client, sample_child):
        """اختبار رفض تسجيل device_id مكرر"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": sample_child.device_id,
            "name": "علي",
            "age": 8
        })
        
        assert response.status_code == status.HTTP_400_BAD_REQUEST
        assert "already registered" in response.json()["detail"].lower()
    
    def test_register_invalid_age(self, client):
        """اختبار رفض عمر غير صحيح"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": "device-999",
            "name": "فاطمة",
            "age": 3  # أقل من 6
        })
        
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
    
    def test_register_missing_name(self, client):
        """اختبار رفض التسجيل بدون اسم"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": "device-888",
            "age": 8
        })
        
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
    
    def test_register_name_too_short(self, client):
        """اختبار رفض اسم قصير جداً"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": "device-777",
            "name": "أ",  # حرف واحد فقط
            "age": 8
        })
        
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY
    
    def test_register_without_avatar_uses_default(self, client):
        """اختبار استخدام صورة افتراضية عند عدم تحديدها"""
        response = client.post("/api/v1/auth/register", json={
            "device_id": "device-666",
            "name": "زينب",
            "age": 9
        })
        
        assert response.status_code == status.HTTP_201_CREATED
        data = response.json()
        assert data["child"]["avatar"] == "default"


class TestLogin:
    """اختبارات تسجيل الدخول"""
    
    def test_login_existing_device_success(self, client, sample_child):
        """اختبار تسجيل دخول بجهاز موجود"""
        response = client.post("/api/v1/auth/login", json={
            "device_id": sample_child.device_id
        })
        
        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
        assert data["child"]["id"] == sample_child.id
        assert data["child"]["name"] == sample_child.name
    
    def test_login_non_existing_device(self, client):
        """اختبار رفض تسجيل دخول بجهاز غير موجود"""
        response = client.post("/api/v1/auth/login", json={
            "device_id": "non-existing-device"
        })
        
        assert response.status_code == status.HTTP_404_NOT_FOUND
        assert "not registered" in response.json()["detail"].lower()
    
    def test_login_missing_device_id(self, client):
        """اختبار رفض تسجيل دخول بدون device_id"""
        response = client.post("/api/v1/auth/login", json={})
        
        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


class TestAuthentication:
    """اختبارات المصادقة والصلاحيات"""
    
    def test_protected_endpoint_without_token(self, client):
        """اختبار رفض الوصول لنقطة محمية بدون token"""
        response = client.get("/api/v1/children/me/progress")
        
        assert response.status_code == status.HTTP_403_FORBIDDEN
    
    def test_protected_endpoint_with_invalid_token(self, client):
        """اختبار رفض الوصول مع token غير صحيح"""
        headers = {"Authorization": "Bearer invalid-token-12345"}
        response = client.get("/api/v1/children/me/progress", headers=headers)
        
        assert response.status_code == status.HTTP_401_UNAUTHORIZED
    
    def test_protected_endpoint_with_valid_token(self, client, auth_headers):
        """اختبار السماح بالوصول مع token صحيح"""
        response = client.get("/api/v1/children/me/progress", headers=auth_headers)
        
        # يجب أن ينجح (حتى لو القائمة فارغة)
        assert response.status_code == status.HTTP_200_OK
        assert isinstance(response.json(), list)
    
    def test_token_contains_child_id(self, auth_token, sample_child):
        """اختبار أن الـ token يحتوي على معرف الطفل"""
        from app.utils.auth import verify_token
        
        child_id = verify_token(auth_token)
        assert child_id == str(sample_child.id)
    
    def test_expired_token_rejected(self, client):
        """اختبار رفض token منتهي الصلاحية"""
        from datetime import datetime, timedelta
        from jose import jwt
        from app.config import settings
        
        # إنشاء token منتهي
        expired_data = {
            "sub": "999",
            "exp": datetime.utcnow() - timedelta(hours=1)
        }
        expired_token = jwt.encode(expired_data, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        
        headers = {"Authorization": f"Bearer {expired_token}"}
        response = client.get("/api/v1/children/me/progress", headers=headers)
        
        assert response.status_code == status.HTTP_401_UNAUTHORIZED
