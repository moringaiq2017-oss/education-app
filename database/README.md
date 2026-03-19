# قاعدة البيانات | Database Schema
**تطبيق تعليم الأطفال العراقيين**

---

## نظرة عامة

قاعدة بيانات MySQL مصممة لدعم:
- تتبع تقدم الأطفال (30 درس)
- نظام النجوم والمكافآت
- الإنجازات والأوسمة
- الإحصائيات اليومية
- الاشتراكات المدفوعة (المستقبل)
- Analytics وتتبع الاستخدام

---

## الجداول الرئيسية

### 1. `children` — الأطفال/المستخدمين
- **device_id** (unique) — معرّف الجهاز
- اسم الطفل + عمر + avatar
- حالة الاشتراك (مجاني/مدفوع)
- آخر نشاط

### 2. `tracks` — المسارات التعليمية (3)
- اللغة العربية
- الرياضيات
- العلوم والحياة

### 3. `lessons` — الدروس (30 درس)
- العنوان + الوصف (عربي/إنجليزي)
- المحتوى التفاعلي (JSON)
- ملفات الصوت/الفيديو
- أسئلة الاختبار (JSON)
- هل مجاني؟ (`is_free`)
- يتطلب درس سابق

### 4. `child_progress` — تقدم الطفل
- الحالة: `not_started` / `in_progress` / `completed` / `mastered`
- أفضل درجة (من 5)
- عدد المحاولات
- الوقت المستغرق
- النجوم المكتسبة (0-3)
- تاريخ الإكمال

### 5. `lesson_attempts` — محاولات الدروس
- الدرجة + الإجابات الصحيحة
- المدة
- تفاصيل الإجابات (JSON)
- تاريخ المحاولة

### 6. `achievements` — الإنجازات/الأوسمة
- أول درس، ماهر اللغة، عبقري الرياضيات، إلخ
- الشروط (نوع + قيمة)

### 7. `child_achievements` — إنجازات الطفل
- ربط الطفل بالإنجاز + تاريخ الحصول

### 8. `daily_stats` — إحصائيات يومية
- دروس مكتملة/محاولة
- الوقت المستغرق
- الدرجات + النجوم
- تُحدّث يومياً

### 9. `subscriptions` — الاشتراكات (للمستقبل)
- نوع الخطة (شهري/مرة واحدة)
- المبلغ بالدينار
- تواريخ البداية/الانتهاء
- الحالة

### 10. `analytics_events` — التحليلات
- تتبع الأحداث (فتح التطبيق، بدء درس، إكمال، إلخ)
- معلومات الجهاز + الجلسة

---

## العروض (Views)

### `v_child_overview`
نظرة عامة على طفل: الدروس المكتملة، النجوم، الإنجازات، آخر نشاط

### `v_track_progress`
تقدم كل طفل في كل مسار (نسبة الإكمال)

---

## الإجراءات المخزّنة (Stored Procedures)

### `record_lesson_attempt(...)`
- تسجيل محاولة درس
- تحديث التقدم (أفضل درجة، حالة، نجوم)
- تحديث الإحصائيات اليومية
- **الاستخدام:**
  ```sql
  CALL record_lesson_attempt(
      1,           -- child_id
      5,           -- lesson_id
      5,           -- score (من 5)
      5,           -- correct_answers
      180,         -- duration_seconds
      '{"q1": "correct", "q2": "correct", ...}' -- answers_json
  );
  ```

### `check_achievements(child_id)`
- التحقق من الإنجازات بناءً على التقدم
- إضافة إنجازات جديدة تلقائياً

---

## استعلامات مفيدة

### 1. الحصول على تقدم طفل
```sql
SELECT * FROM v_child_overview WHERE child_id = 1;
```

### 2. الدرس التالي للطفل (غير مكتمل)
```sql
SELECT l.* 
FROM lessons l
LEFT JOIN child_progress cp ON l.id = cp.lesson_id AND cp.child_id = 1
WHERE (l.is_free = TRUE OR (SELECT is_premium FROM children WHERE id = 1))
  AND (cp.status IS NULL OR cp.status NOT IN ('completed', 'mastered'))
ORDER BY l.display_order
LIMIT 1;
```

### 3. لوحة الصدارة (Top 10)
```sql
SELECT c.name, SUM(cp.stars_earned) AS total_stars
FROM children c
JOIN child_progress cp ON c.id = cp.child_id
GROUP BY c.id
ORDER BY total_stars DESC
LIMIT 10;
```

### 4. إحصائيات اليوم
```sql
SELECT * FROM daily_stats 
WHERE child_id = 1 AND stat_date = CURDATE();
```

### 5. جميع إنجازات طفل
```sql
SELECT a.name_ar, a.icon, ca.earned_at
FROM child_achievements ca
JOIN achievements a ON ca.achievement_id = a.id
WHERE ca.child_id = 1
ORDER BY ca.earned_at DESC;
```

---

## التثبيت

### 1. إنشاء قاعدة البيانات
```bash
mysql -u root -p < schema.sql
```

### 2. للتطوير (Docker)
```bash
docker run --name education-mysql \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=education_app_iraq \
  -e MYSQL_USER=edu_user \
  -e MYSQL_PASSWORD=edu_pass \
  -p 3306:3306 \
  -d mysql:8.0 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_unicode_ci
```

ثم:
```bash
docker exec -i education-mysql mysql -uroot -proot123 education_app_iraq < schema.sql
```

---

## الاتصال من Flutter

```dart
// استخدام: mysql1 package
import 'package:mysql1/mysql1.dart';

final settings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'edu_user',
  password: 'edu_pass',
  db: 'education_app_iraq',
);

final conn = await MySqlConnection.connect(settings);
```

**ملاحظة:** للـ MVP (الـ 4–6 أسابيع الأولى)، نستخدم **تخزين محلي فقط** (Hive/SQLite) بدون MySQL. هذا الـ schema للمرحلة الثانية (Backend سحابي).

---

## Entity Relationship Diagram (نصي)

```
children (1) ──< (N) child_progress >── (1) lessons ──< (1) tracks
    │                                        
    ├──< (N) lesson_attempts
    │
    ├──< (N) child_achievements >── (1) achievements
    │
    ├──< (N) daily_stats
    │
    ├──< (N) subscriptions
    │
    └──< (N) analytics_events
```

---

## الميزات المستقبلية

### Phase 2 (بعد الإطلاق):
- [ ] مزامنة سحابية (Firebase أو API خاص)
- [ ] Multi-device support (نفس الطفل على أجهزة مختلفة)
- [ ] حسابات الأهل (parent accounts)
- [ ] تقارير تفصيلية للأهل

### Phase 3:
- [ ] Leaderboard عام (مع Privacy)
- [ ] تحديات أسبوعية
- [ ] محتوى موسمي (رمضان، عيد، إلخ)
- [ ] Recommendations (دروس مقترحة بناءً على الأداء)

---

## الأمان

### 1. تشفير
- كلمات المرور: **bcrypt** (إذا أضفنا login لاحقاً)
- بيانات الدفع: **لا تُحفظ** (نستخدم payment gateway)

### 2. Privacy
- device_id فقط (لا email/phone بالـ MVP)
- لا مشاركة بيانات شخصية
- Analytics مجهولة

### 3. Backups
- نسخ احتياطي يومي
- Retention: 30 يوم

---

## الأداء

### Indexes:
- ✅ جميع foreign keys
- ✅ (child_id, lesson_id) unique
- ✅ (child_id, status)
- ✅ (stat_date)
- ✅ (event_type, created_at)

### Optimization:
- JSON للبيانات غير المنظمة (content, questions, answers)
- Partitioning على `analytics_events` (بالتاريخ) إذا كبر الحجم

---

**التاريخ:** 19 مارس 2026  
**الحالة:** ✅ جاهز للاستخدام (Phase 2)  
**النسخة:** 1.0
