"""
Manual API Testing Script
سكريبت لاختبار API يدوياً
"""

import requests
import json
from typing import Optional

BASE_URL = "http://localhost:8000/api/v1"

class APITester:
    def __init__(self):
        self.token: Optional[str] = None
        self.child_id: Optional[int] = None
    
    def print_response(self, title: str, response):
        """طباعة الاستجابة بشكل منسق"""
        print(f"\n{'='*60}")
        print(f"🔍 {title}")
        print(f"{'='*60}")
        print(f"Status: {response.status_code}")
        try:
            print(f"Response:\n{json.dumps(response.json(), indent=2, ensure_ascii=False)}")
        except:
            print(f"Response: {response.text}")
    
    def test_register(self):
        """اختبار التسجيل"""
        url = f"{BASE_URL}/auth/register"
        data = {
            "device_id": "test-device-001",
            "name": "أحمد",
            "age": 8,
            "avatar": "boy1"
        }
        
        response = requests.post(url, json=data)
        self.print_response("تسجيل طفل جديد", response)
        
        if response.status_code == 201:
            result = response.json()
            self.token = result["access_token"]
            self.child_id = result["child"]["id"]
            print(f"\n✅ Token saved: {self.token[:20]}...")
        
        return response.status_code == 201
    
    def test_login(self):
        """اختبار تسجيل الدخول"""
        url = f"{BASE_URL}/auth/login"
        data = {
            "device_id": "test-device-001"
        }
        
        response = requests.post(url, json=data)
        self.print_response("تسجيل الدخول", response)
        
        if response.status_code == 200:
            result = response.json()
            self.token = result["access_token"]
            self.child_id = result["child"]["id"]
        
        return response.status_code == 200
    
    def test_get_tracks(self):
        """اختبار الحصول على المسارات"""
        url = f"{BASE_URL}/tracks"
        response = requests.get(url)
        self.print_response("قائمة المسارات", response)
        return response.status_code == 200
    
    def test_get_track_lessons(self, track_id: int = 1):
        """اختبار الحصول على دروس المسار"""
        if not self.token:
            print("❌ يجب تسجيل الدخول أولاً")
            return False
        
        url = f"{BASE_URL}/tracks/{track_id}/lessons"
        headers = {"Authorization": f"Bearer {self.token}"}
        
        response = requests.get(url, headers=headers)
        self.print_response(f"دروس المسار {track_id}", response)
        return response.status_code == 200
    
    def test_get_lesson_detail(self, lesson_id: int = 1):
        """اختبار الحصول على تفاصيل الدرس"""
        if not self.token:
            print("❌ يجب تسجيل الدخول أولاً")
            return False
        
        url = f"{BASE_URL}/lessons/{lesson_id}"
        headers = {"Authorization": f"Bearer {self.token}"}
        
        response = requests.get(url, headers=headers)
        self.print_response(f"تفاصيل الدرس {lesson_id}", response)
        return response.status_code == 200
    
    def test_record_attempt(self, lesson_id: int = 1):
        """اختبار تسجيل محاولة"""
        if not self.token:
            print("❌ يجب تسجيل الدخول أولاً")
            return False
        
        url = f"{BASE_URL}/lessons/{lesson_id}/attempt"
        headers = {"Authorization": f"Bearer {self.token}"}
        data = {
            "score": 5,
            "correct_answers": 5,
            "duration_seconds": 120,
            "answers_json": {
                "q1": "أ",
                "q2": "أسد",
                "q3": "أرنب"
            }
        }
        
        response = requests.post(url, json=data, headers=headers)
        self.print_response(f"تسجيل محاولة للدرس {lesson_id}", response)
        return response.status_code == 200
    
    def test_get_my_progress(self):
        """اختبار الحصول على تقدمي"""
        if not self.token:
            print("❌ يجب تسجيل الدخول أولاً")
            return False
        
        url = f"{BASE_URL}/children/me/progress"
        headers = {"Authorization": f"Bearer {self.token}"}
        
        response = requests.get(url, headers=headers)
        self.print_response("تقدمي", response)
        return response.status_code == 200
    
    def test_get_summary(self):
        """اختبار الحصول على الملخص"""
        if not self.token:
            print("❌ يجب تسجيل الدخول أولاً")
            return False
        
        url = f"{BASE_URL}/children/me/summary"
        headers = {"Authorization": f"Bearer {self.token}"}
        
        response = requests.get(url, headers=headers)
        self.print_response("ملخص التقدم", response)
        return response.status_code == 200
    
    def run_all_tests(self):
        """تشغيل جميع الاختبارات"""
        print("\n" + "="*60)
        print("🚀 بدء اختبار API")
        print("="*60)
        
        results = {}
        
        # Authentication
        print("\n📝 اختبارات المصادقة")
        print("-" * 60)
        results["register"] = self.test_register()
        
        # إذا فشل التسجيل، حاول تسجيل الدخول
        if not results["register"]:
            results["login"] = self.test_login()
        
        # Tracks & Lessons
        print("\n📚 اختبارات المسارات والدروس")
        print("-" * 60)
        results["get_tracks"] = self.test_get_tracks()
        results["get_track_lessons"] = self.test_get_track_lessons(1)
        results["get_lesson_detail"] = self.test_get_lesson_detail(1)
        
        # Progress
        print("\n📊 اختبارات التقدم")
        print("-" * 60)
        results["record_attempt"] = self.test_record_attempt(1)
        results["get_my_progress"] = self.test_get_my_progress()
        results["get_summary"] = self.test_get_summary()
        
        # Summary
        print("\n" + "="*60)
        print("📋 ملخص النتائج")
        print("="*60)
        
        passed = sum(1 for v in results.values() if v)
        total = len(results)
        
        for test_name, result in results.items():
            status = "✅ نجح" if result else "❌ فشل"
            print(f"{status} - {test_name}")
        
        print(f"\n{'='*60}")
        print(f"النتيجة النهائية: {passed}/{total} اختبار نجح")
        print(f"{'='*60}")
        
        return passed == total


if __name__ == "__main__":
    print("""
    🔧 سكريبت اختبار API يدوياً
    
    تأكد من:
    1. تشغيل الـ Backend: uvicorn app.main:app --reload
    2. قاعدة البيانات متصلة
    3. توجد بيانات تجريبية (tracks & lessons)
    
    """)
    
    input("اضغط Enter للبدء...")
    
    tester = APITester()
    success = tester.run_all_tests()
    
    if success:
        print("\n🎉 جميع الاختبارات نجحت!")
    else:
        print("\n⚠️  بعض الاختبارات فشلت - راجع الأخطاء أعلاه")
