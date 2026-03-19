# توزيع المهام على الفريق | Team Tasks Distribution
**المشروع:** تطبيق تعليم الأطفال العراقيين  
**التاريخ:** 19 مارس 2026  
**الأسبوع:** 1 من 6

---

## 👥 الفريق الحالي

| الدور | المسؤول | الحالة | المهام الحالية |
|-------|---------|--------|-----------------|
| **Architect** | ✅ تم | مكتمل | قاعدة البيانات MySQL |
| **Backend Dev** | 🔄 جاري | يكتب FastAPI | REST API + Auth + Business Logic |
| **Frontend Dev** | 🔄 جاري | يكتب Flutter | UI + State Management + API Integration |
| **Reviewer** | ⏳ انتظار | يراجع | Code review + Quality assurance |

---

## 📋 حالة المهام

### ✅ مكتمل (Architect)
- [x] تصميم قاعدة البيانات (10 جداول)
- [x] Schema SQL
- [x] Sample data
- [x] Documentation
- [x] Views + Stored Procedures

**الملفات:**
- `database/schema.sql`
- `database/README.md`
- `database/sample-data.sql`

---

## 🔧 Backend Developer — FastAPI

### المسؤوليات:
- بناء REST API كامل
- ربط MySQL
- Authentication & Authorization
- Business logic (تسجيل محاولات، حساب النجوم، إلخ)
- Testing
- Documentation (OpenAPI/Swagger)

### المهام — الأسبوع 1:

#### يوم 1-2: Setup + Core Structure
- [ ] إنشاء مجلد `backend/`
- [ ] إعداد FastAPI project structure
- [ ] إعداد requirements.txt
- [ ] ربط MySQL (SQLAlchemy ORM)
- [ ] إعداد CORS للـ Flutter
- [ ] إعداد environment variables (.env)
- [ ] كتابة Dockerfile (اختياري)

#### يوم 3-4: Authentication & Core Models
- [ ] بناء Models (SQLAlchemy) من schema.sql:
  - Child, Track, Lesson, Progress, Attempt, Achievement
- [ ] بناء Schemas (Pydantic) للـ validation
- [ ] Authentication endpoint:
  - `POST /auth/register` (device_id + name)
  - `POST /auth/login` (device_id)
  - Token-based (JWT)

#### يوم 5-7: Core Endpoints
- [ ] **Tracks & Lessons:**
  - `GET /tracks` — قائمة المسارات
  - `GET /tracks/{id}/lessons` — دروس المسار
  - `GET /lessons/{id}` — تفاصيل درس
  
- [ ] **Progress:**
  - `GET /children/{id}/progress` — تقدم الطفل
  - `POST /lessons/{id}/attempt` — تسجيل محاولة
  - `GET /children/{id}/stats` — إحصائيات

- [ ] **Achievements:**
  - `GET /children/{id}/achievements` — إنجازات الطفل
  - `GET /achievements` — قائمة الإنجازات

#### Testing:
- [ ] Unit tests لكل endpoint
- [ ] Integration tests
- [ ] Postman collection

#### Documentation:
- [ ] README.md (setup instructions)
- [ ] API documentation (Swagger auto)
- [ ] Environment variables guide

### الملفات المتوقعة:
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── models/
│   │   ├── __init__.py
│   │   ├── child.py
│   │   ├── lesson.py
│   │   ├── progress.py
│   │   └── ...
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── child.py
│   │   ├── lesson.py
│   │   └── ...
│   ├── routers/
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── lessons.py
│   │   ├── progress.py
│   │   └── achievements.py
│   ├── services/
│   │   ├── __init__.py
│   │   ├── progress_service.py
│   │   └── achievement_service.py
│   └── utils/
│       ├── __init__.py
│       └── auth.py
├── tests/
│   ├── __init__.py
│   ├── test_auth.py
│   ├── test_lessons.py
│   └── ...
├── requirements.txt
├── .env.example
├── Dockerfile
└── README.md
```

### Stack:
- **FastAPI** 0.110+
- **SQLAlchemy** 2.0+ (ORM)
- **MySQL** connector (pymysql / mysqlclient)
- **Pydantic** 2.0+ (validation)
- **python-jose** (JWT)
- **pytest** (testing)
- **uvicorn** (server)

### الأوامر الأساسية:
```bash
# Setup
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run
uvicorn app.main:app --reload

# Test
pytest

# Docs (auto)
# http://localhost:8000/docs
```

---

## 📱 Frontend Developer — Flutter

### المسؤوليات:
- بناء تطبيق Flutter كامل
- UI/UX implementation
- State management
- API integration
- Local storage (Hive)
- Audio/Video playback
- Animations

### المهام — الأسبوع 1:

#### يوم 1-2: Setup + Project Structure
- [ ] إنشاء مجلد `mobile/`
- [ ] إنشاء Flutter project:
  ```bash
  flutter create --org com.makanstudios education_app_iraq
  ```
- [ ] إعداد pubspec.yaml (dependencies)
- [ ] إعداد folder structure
- [ ] إعداد themes (colors, fonts)
- [ ] RTL support

#### يوم 3-4: Core Screens (UI Only)
- [ ] Splash Screen
- [ ] Home Screen (3 مسارات)
- [ ] Lesson List Screen
- [ ] Lesson Detail Screen
- [ ] Progress Screen
- [ ] Settings Screen

#### يوم 5-7: State Management + API Integration
- [ ] إعداد Provider/Riverpod/Bloc (اختر واحد)
- [ ] بناء API service:
  - HTTP client (dio)
  - Auth interceptor
  - Error handling
- [ ] ربط Home screen بـ API:
  - جلب المسارات
  - جلب الدروس
- [ ] Local storage (Hive):
  - حفظ device_id
  - حفظ التقدم محلياً (للـ offline)

#### Testing:
- [ ] Widget tests للشاشات الرئيسية
- [ ] Integration tests (اختياري)

#### Documentation:
- [ ] README.md (setup + run instructions)
- [ ] Architecture overview

### الملفات المتوقعة:
```
mobile/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── theme.dart
│   │   ├── routes.dart
│   │   └── constants.dart
│   ├── models/
│   │   ├── child.dart
│   │   ├── track.dart
│   │   ├── lesson.dart
│   │   ├── progress.dart
│   │   └── achievement.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   └── audio_service.dart
│   ├── providers/ (أو blocs/)
│   │   ├── auth_provider.dart
│   │   ├── lessons_provider.dart
│   │   └── progress_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── lesson_list_screen.dart
│   │   ├── lesson_detail_screen.dart
│   │   ├── progress_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── track_card.dart
│   │   ├── lesson_card.dart
│   │   ├── progress_bar.dart
│   │   └── achievement_badge.dart
│   └── utils/
│       ├── helpers.dart
│       └── validators.dart
├── assets/
│   ├── images/
│   ├── fonts/
│   └── audio/
├── test/
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

### Stack:
- **Flutter** 3.19+
- **Dart** 3.3+
- **State Management:** Provider / Riverpod / Bloc (اختر واحد)
- **HTTP:** dio
- **Local Storage:** hive / sqflite
- **Audio:** audioplayers / just_audio
- **Fonts:** google_fonts (Cairo)
- **Navigation:** go_router

### Dependencies (pubspec.yaml):
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1  # أو riverpod / flutter_bloc
  
  # HTTP & API
  dio: ^5.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Audio
  audioplayers: ^5.2.1
  
  # Fonts
  google_fonts: ^6.1.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Utils
  intl: ^0.18.1
  uuid: ^4.3.3
```

### الأوامر الأساسية:
```bash
# Setup
cd mobile
flutter pub get

# Run
flutter run

# Build APK
flutter build apk --release

# Test
flutter test
```

---

## 🔍 Reviewer — Code Review & QA

### المسؤوليات:
- مراجعة كل الكود (Backend + Frontend)
- التأكد من الجودة والمعايير
- اختبار يدوي
- كتابة تقارير
- اقتراح تحسينات

### المهام — الأسبوع 1:

#### يوم 1-2: Setup + Understanding
- [ ] قراءة كامل التوثيق:
  - MVP Spec
  - Database schema
  - Team tasks (هذا الملف)
- [ ] Setup بيئة الاختبار:
  - MySQL local
  - Backend (FastAPI)
  - Flutter emulator/device
- [ ] إنشاء checklist للمراجعة

#### يوم 3-5: Backend Review
- [ ] مراجعة Backend code:
  - Project structure منطقي؟
  - Models صحيحة؟
  - Endpoints تعمل؟
  - Error handling موجود؟
  - Security (SQL injection, validation)
  - Performance (queries محسّنة؟)
  - Documentation كافية؟
- [ ] اختبار Manual للـ API:
  - جميع الـ endpoints
  - Edge cases
  - Error responses
- [ ] كتابة تقرير (backend-review.md)

#### يوم 6-7: Frontend Review (مبدئي)
- [ ] مراجعة Flutter code:
  - Project structure
  - UI clean؟
  - RTL يعمل؟
  - State management صحيح؟
  - API integration تعمل؟
- [ ] اختبار Manual:
  - Navigation
  - UI responsive
  - Performance
- [ ] كتابة تقرير (frontend-review.md)

#### أسبوعياً:
- [ ] مراجعة كل Pull Request
- [ ] تقرير أسبوعي (issues + recommendations)

### الأدوات:
- **Code Review:** GitHub PR reviews
- **Testing:** Postman (Backend), Flutter DevTools
- **Bug Tracking:** GitHub Issues
- **Documentation:** Markdown files

### Checklist (Backend):
```markdown
## Backend Review Checklist

### Structure
- [ ] Folders منظمة (models, schemas, routers, services)
- [ ] __init__.py موجود
- [ ] Naming conventions واضحة

### Database
- [ ] Models تطابق schema.sql
- [ ] Foreign keys صحيحة
- [ ] Migrations موجودة (إذا استخدم Alembic)

### API Endpoints
- [ ] جميع الـ endpoints المطلوبة موجودة
- [ ] Request validation (Pydantic schemas)
- [ ] Response format متناسق
- [ ] HTTP status codes صحيحة (200, 201, 400, 404, 500)
- [ ] Error messages واضحة

### Authentication
- [ ] JWT token صحيح
- [ ] Token expiration
- [ ] Secure password handling (إذا استخدم)

### Security
- [ ] No SQL injection (استخدام ORM)
- [ ] Input validation
- [ ] CORS configured
- [ ] Sensitive data في .env

### Performance
- [ ] Queries محسّنة (no N+1)
- [ ] Indexes مستخدمة
- [ ] Pagination للقوائم الطويلة

### Testing
- [ ] Unit tests موجودة
- [ ] Coverage > 70%
- [ ] Tests تمر

### Documentation
- [ ] README.md واضح
- [ ] API docs (Swagger)
- [ ] Environment variables موثقة
```

### Checklist (Frontend):
```markdown
## Frontend Review Checklist

### Structure
- [ ] Folders منظمة (screens, widgets, services, models)
- [ ] Separation of concerns

### UI/UX
- [ ] RTL يعمل
- [ ] Fonts (Cairo) واضحة
- [ ] Colors متناسقة
- [ ] Responsive (different screen sizes)
- [ ] Animations smooth

### State Management
- [ ] Provider/Riverpod/Bloc مستخدم بشكل صحيح
- [ ] No unnecessary rebuilds
- [ ] State واضح ومنظم

### API Integration
- [ ] HTTP client (dio) configured
- [ ] Auth token في headers
- [ ] Error handling (network errors, timeouts)
- [ ] Loading states

### Local Storage
- [ ] Hive initialized
- [ ] Data saved/loaded صحيح
- [ ] Offline support يعمل

### Performance
- [ ] No jank (60 FPS)
- [ ] Images optimized
- [ ] Audio preloaded (إذا ممكن)

### Testing
- [ ] Widget tests موجودة
- [ ] Tests تمر

### Documentation
- [ ] README.md واضح
- [ ] Setup instructions
```

---

## 📝 GitHub Workflow

### Branch Strategy:
```
main (protected)
  └── develop
       ├── feature/backend-auth
       ├── feature/backend-lessons
       ├── feature/frontend-home
       └── feature/frontend-lesson-detail
```

### Commit Message Format:
```
[backend] Add authentication endpoints
[frontend] Implement home screen UI
[database] Add indexes for performance
[review] Fix security issue in auth
[docs] Update API documentation
```

### Pull Request Process:

1. **Developer** يفتح PR من `feature/xxx` → `develop`
2. **Reviewer** يراجع خلال 24 ساعة:
   - Code review
   - Test locally
   - Comment أو Approve
3. **Developer** يعدل حسب الـ feedback
4. **Reviewer** يوافق نهائياً
5. **Merge** إلى `develop`
6. نهاية الأسبوع: merge `develop` → `main`

### PR Template:
```markdown
## Description
<!-- وصف مختصر للتغييرات -->

## Type of Change
- [ ] Backend
- [ ] Frontend
- [ ] Database
- [ ] Documentation

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Tested locally

## Screenshots (للـ Frontend)
<!-- إذا في UI changes -->
```

---

## 🎯 الأهداف — الأسبوع 1

### Backend:
- ✅ Project setup
- ✅ Database connection
- ✅ Auth endpoints
- ✅ Core endpoints (tracks, lessons, progress)
- ✅ Testing
- ✅ Documentation

### Frontend:
- ✅ Project setup
- ✅ Core screens (UI)
- ✅ State management
- ✅ API integration (basic)
- ✅ Local storage

### Reviewer:
- ✅ Environment setup
- ✅ Backend review
- ✅ Frontend review (مبدئي)
- ✅ أول تقرير

---

## 📞 التواصل

### يومي (WhatsApp Group):
- صباحاً: "شنو خطة اليوم؟"
- مساءً: "شنو خلصت اليوم؟" + "أي عوائق؟"

### أسبوعي (Google Meet):
- **كل اثنين 9 AM** (60 دقيقة)
- الأجندة:
  1. مراجعة الأسبوع الماضي
  2. Demo (عرض الشغل الجديد)
  3. مراجعة تقرير الـ Reviewer
  4. تخطيط الأسبوع القادم
  5. أسئلة ومشاكل

### Code Review:
- **GitHub PR comments**
- رد خلال 24 ساعة
- بدون Approve → لا merge

---

## 🔥 القواعد الذهبية

1. **Commit مرتين باليوم على الأقل** (صباح/مساء)
2. **لا merge بدون review**
3. **Tests لازم تمر** (GitHub Actions لاحقاً)
4. **Documentation مع الكود** (README + comments)
5. **اسأل لو ما فهمت** (لا تخمن)

---

**التاريخ:** 19 مارس 2026  
**الأسبوع:** 1 من 6  
**الحالة:** 🔥 يلا نبدأ!

**ملاحظة:** هذا أول أسبوع (Setup + Foundation)، الأسابيع القادمة راح نضيف:
- UI/UX Designer (الرسوم والأصول)
- Content Writer (السكريبتات)
- Voice Over (التسجيلات)
- QA Tester (اختبار شامل)
