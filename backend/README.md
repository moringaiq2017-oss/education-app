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

```bash
# Run all tests
pytest

# With coverage
pytest --cov=app --cov-report=html

# Specific test
pytest tests/test_auth.py
```

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

**Last Updated:** 19 March 2026  
**Status:** 🚧 In Development
