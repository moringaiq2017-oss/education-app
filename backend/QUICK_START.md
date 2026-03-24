# 🚀 Quick Start Guide
**دليل البدء السريع**

---

## Setup في 3 خطوات

### 1. Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your MySQL credentials
```

### 3. Run the API
```bash
uvicorn app.main:app --reload
```

✅ API running at: **http://localhost:8000**  
📖 Docs available at: **http://localhost:8000/docs**

---

## Run Tests

```bash
# All tests
pytest

# Verbose
pytest -v

# Specific test file
pytest tests/test_auth.py

# With coverage
pytest --cov=app
```

---

## Manual Testing

```bash
# Make sure API is running first
python test_api_manual.py
```

---

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` — Register new child
- `POST /api/v1/auth/login` — Login

### Tracks & Lessons
- `GET /api/v1/tracks` — Get all tracks
- `GET /api/v1/tracks/{id}` — Get track details
- `GET /api/v1/tracks/{id}/lessons` — Get track lessons
- `GET /api/v1/lessons/{id}` — Get lesson details

### Progress
- `POST /api/v1/lessons/{id}/attempt` — Record attempt
- `GET /api/v1/children/me/progress` — Get my progress
- `GET /api/v1/children/me/summary` — Get progress summary

---

## Example Usage

### 1. Register
```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "test-123",
    "name": "أحمد",
    "age": 8
  }'
```

Response:
```json
{
  "access_token": "eyJ0eXAiOiJKV1...",
  "token_type": "bearer",
  "child": {
    "id": 1,
    "name": "أحمد",
    "age": 8,
    "is_premium": false
  }
}
```

### 2. Get Tracks
```bash
curl http://localhost:8000/api/v1/tracks
```

### 3. Record Attempt
```bash
curl -X POST http://localhost:8000/api/v1/lessons/1/attempt \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "score": 5,
    "correct_answers": 5,
    "duration_seconds": 120
  }'
```

---

## Test Coverage

**Total Tests:** 56+  
**Test Files:** 4  
**Lines of Test Code:** 936

- ✅ Authentication (13 tests)
- ✅ Tracks & Lessons (18 tests)
- ✅ Progress & Attempts (25+ tests)

---

## Need Help?

- 📖 **Full documentation:** `README.md`
- 📦 **Delivery report:** `DELIVERY_REPORT.md`
- 🔧 **Manual testing:** `test_api_manual.py`
- 📚 **API docs:** http://localhost:8000/docs

---

**Happy Coding! 🚀**
