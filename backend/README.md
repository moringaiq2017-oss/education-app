# Backend API — FastAPI
**تطبيق تعليم الأطفال العراقيين**

---

## Setup

### Requirements
- Python 3.11+
- MySQL 8.0+
- pip / poetry

### Installation

```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/bin/activate  # macOS/Linux
# or
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt
```

### Database Setup

```bash
# Create database
mysql -u root -p < ../database/schema.sql

# Load sample data (optional)
mysql -u root -p education_app_iraq < ../database/sample-data.sql
```

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

Edit `.env`:
```
DATABASE_URL=mysql+pymysql://user:password@localhost:3306/education_app_iraq
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080
```

---

## Run

### Development
```bash
uvicorn app.main:app --reload
```

Server: http://localhost:8000  
API Docs: http://localhost:8000/docs  
ReDoc: http://localhost:8000/redoc

### Production (future)
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

---

## API Endpoints

### Authentication
- `POST /auth/register` — تسجيل طفل جديد
- `POST /auth/login` — تسجيل دخول

### Tracks & Lessons
- `GET /tracks` — قائمة المسارات
- `GET /tracks/{id}` — تفاصيل مسار
- `GET /tracks/{id}/lessons` — دروس المسار
- `GET /lessons/{id}` — تفاصيل درس

### Progress
- `GET /children/{id}/progress` — تقدم الطفل الكلي
- `GET /children/{id}/tracks/{track_id}/progress` — تقدم المسار
- `POST /lessons/{id}/attempt` — تسجيل محاولة درس

### Achievements
- `GET /achievements` — قائمة جميع الإنجازات
- `GET /children/{id}/achievements` — إنجازات الطفل

### Stats
- `GET /children/{id}/stats` — إحصائيات شاملة
- `GET /children/{id}/stats/daily` — إحصائيات يومية

---

## Testing

### Automated Tests (pytest)

```bash
# Run all tests
pytest

# Verbose mode
pytest -v

# With coverage
pytest --cov=app --cov-report=html

# Specific test file
pytest tests/test_auth.py

# Specific test class
pytest tests/test_auth.py::TestRegistration

# Specific test function
pytest tests/test_auth.py::TestRegistration::test_register_new_child_success
```

### Test Files
- **tests/conftest.py** — إعدادات وتجهيزات الاختبار (fixtures)
- **tests/test_auth.py** — اختبارات المصادقة (التسجيل، تسجيل الدخول، الـ tokens)
- **tests/test_lessons.py** — اختبارات المسارات والدروس
- **tests/test_progress.py** — اختبارات التقدم والمحاولات

### Manual API Testing

للاختبار اليدوي السريع:

```bash
python test_api_manual.py
```

هذا السكريبت يختبر:
- ✅ تسجيل طفل جديد
- ✅ تسجيل الدخول
- ✅ جلب المسارات
- ✅ جلب دروس المسار
- ✅ جلب تفاصيل درس
- ✅ تسجيل محاولة
- ✅ جلب التقدم
- ✅ جلب الملخص

### Test Coverage

```bash
# Generate HTML coverage report
pytest --cov=app --cov-report=html

# Open report
open htmlcov/index.html  # macOS
# or
start htmlcov/index.html  # Windows
```

**الهدف:** Coverage > 80%

---

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app
│   ├── config.py            # Settings & env vars
│   ├── database.py          # SQLAlchemy setup
│   ├── models/              # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── child.py
│   │   ├── lesson.py
│   │   ├── progress.py
│   │   └── ...
│   ├── schemas/             # Pydantic schemas
│   │   ├── __init__.py
│   │   ├── child.py
│   │   ├── lesson.py
│   │   └── ...
│   ├── routers/             # API routes
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── lessons.py
│   │   ├── progress.py
│   │   └── achievements.py
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   ├── progress_service.py
│   │   └── achievement_service.py
│   └── utils/               # Helpers
│       ├── __init__.py
│       ├── auth.py          # JWT helpers
│       └── helpers.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py          # Pytest fixtures
│   ├── test_auth.py
│   ├── test_lessons.py
│   └── ...
├── requirements.txt
├── .env.example
├── .gitignore
└── README.md
```

---

## Stack

- **FastAPI** 0.110+ — Web framework
- **SQLAlchemy** 2.0+ — ORM
- **Pydantic** 2.0+ — Data validation
- **PyMySQL** — MySQL driver
- **python-jose** — JWT tokens
- **passlib** — Password hashing (future)
- **pytest** — Testing
- **uvicorn** — ASGI server

---

## Development Guidelines

### Code Style
- Follow PEP 8
- Use type hints
- Docstrings for functions/classes

### Models
- One file per table
- Use SQLAlchemy declarative base
- Add relationships

### Schemas
- Request/Response schemas separate
- Use Pydantic validation
- Arabic field names في الـ examples

### Routers
- One file per resource
- Prefix with `/api/v1`
- Use dependencies for auth

### Services
- Business logic here (not in routers)
- Call stored procedures when possible
- Handle errors gracefully

---

## Security

- ✅ JWT tokens (not stored in DB)
- ✅ CORS configured for Flutter app
- ✅ SQL injection prevention (ORM)
- ✅ Input validation (Pydantic)
- ✅ Sensitive data in .env

---

## Performance

- Use indexes (already in schema)
- Pagination for large lists
- Cache frequent queries (future: Redis)
- Compress responses

---

## Deployment (Future)

### Docker
```bash
docker build -t education-api .
docker run -p 8000:8000 education-api
```

### Docker Compose (with MySQL)
```bash
docker-compose up
```

---

## Contributing

1. Create feature branch: `git checkout -b feature/backend-xxx`
2. Make changes
3. Test: `pytest`
4. Commit: `git commit -m "[backend] Description"`
5. Push: `git push origin feature/backend-xxx`
6. Open Pull Request to `develop`

---

## Support

- **Issues:** GitHub Issues
- **Docs:** `/docs` endpoint
- **Team:** WhatsApp group

---

## Recent Updates

### 24 March 2026 ✅
- ✅ **تم إضافة جميع الـ endpoints المطلوبة:**
  - `GET /lessons/{id}` — تفاصيل الدرس (موجود بالفعل)
  - `POST /lessons/{id}/attempt` — تسجيل محاولة (موجود بالفعل ومحسّن)
  
- ✅ **اختبارات شاملة:**
  - `test_auth.py` — 13 اختبار للمصادقة
  - `test_lessons.py` — 18 اختبار للمسارات والدروس
  - `test_progress.py` — 25+ اختبار للتقدم والمحاولات
  - `conftest.py` — تجهيزات شاملة (fixtures)
  
- ✅ **Error Handling:**
  - جميع الـ endpoints تحتوي على معالجة أخطاء
  - رسائل خطأ واضحة بالعربية
  - HTTP status codes صحيحة
  
- ✅ **Validation:**
  - Pydantic schemas محدثة
  - التحقق من القيم (score: 0-5, age: 6-12, etc.)
  - رسائل validation واضحة
  
- ✅ **Response Format:**
  - تنسيق موحد لجميع الاستجابات
  - استخدام Pydantic models
  - from_attributes=True للتوافق مع SQLAlchemy
  
- ✅ **Security:**
  - JWT authentication
  - Premium access control
  - Input sanitization
  
- ✅ **Documentation:**
  - README.md محدّث
  - test_api_manual.py للاختبار اليدوي
  - تعليقات بالعربية في الكود

### Next Steps
- 🔄 تشغيل الاختبارات على بيئة حقيقية مع MySQL
- 🔄 إضافة endpoints الإنجازات (achievements)
- 🔄 إضافة pagination للقوائم الطويلة
- 🔄 إضافة rate limiting
- 🔄 إعداد Docker للنشر

---

**Last Updated:** 24 March 2026  
**Status:** ✅ Backend API Complete — Ready for Testing
