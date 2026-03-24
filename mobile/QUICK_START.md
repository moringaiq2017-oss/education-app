# ⚡ دليل البدء السريع - Quick Start Guide

## 🚀 تشغيل التطبيق في 5 دقائق

### المتطلب الوحيد
- Flutter SDK مثبت ✓
- Backend يعمل ✓

---

## الخطوة 1️⃣: تثبيت Dependencies

```bash
cd ~/.openclaw/workspace/education-app/mobile
flutter pub get
```

⏱️ **وقت التثبيت:** 1-2 دقيقة

---

## الخطوة 2️⃣: تشغيل Backend

**في terminal جديد:**
```bash
cd ~/.openclaw/workspace/education-app/backend
python -m venv venv
source venv/bin/activate  # في macOS/Linux
# أو: venv\Scripts\activate  # في Windows
pip install -r requirements.txt
uvicorn app.main:app --reload
```

تأكد من أن Backend يعمل على:
```
http://localhost:8000
```

افتح في المتصفح: `http://localhost:8000/docs` للتأكد

---

## الخطوة 3️⃣: تشغيل التطبيق

### للأندرويد Emulator (الأسهل):

```bash
# تشغيل emulator
flutter emulators --launch <emulator-id>

# أو من Android Studio: Tools > AVD Manager > Play

# تشغيل التطبيق
flutter run
```

### للجهاز الحقيقي:

**أولاً: حدّث API URL**

افتح `lib/config/constants.dart`:
```dart
// احصل على IP جهازك:
// macOS: ifconfig | grep "inet "
// Windows: ipconfig
// Linux: ip addr show

static const String apiBaseUrl = 'http://YOUR_IP:8000/api/v1';
// مثال: 'http://192.168.1.5:8000/api/v1'
```

**ثانياً: وصّل الجهاز:**
```bash
flutter devices  # تحقق من اتصال الجهاز
flutter run      # شغّل التطبيق
```

---

## ✅ اختبار سريع

### 1️⃣ التسجيل
- افتح التطبيق
- أدخل اسم (مثال: "أحمد")
- اختر عمر (مثال: 5)
- اضغط "ابدأ التعلم"

### 2️⃣ تصفح المسارات
- يجب أن تظهر المسارات التعليمية
- اضغط على أي مسار

### 3️⃣ تصفح الدروس
- يجب أن تظهر قائمة الدروس
- الدرس الأول مفتوح 🔓
- باقي الدروس مقفلة 🔒

### 4️⃣ أكمل درس
- اضغط على الدرس الأول
- اقرأ المحتوى
- أجب على الأسئلة (إن وجدت)
- اضغط "إكمال الدرس"
- يجب أن يظهر Dialog النجاح 🎉

### 5️⃣ شاهد التقدم
- اذهب لتبويب "التقدم"
- يجب أن تشاهد:
  - درس واحد مكتمل
  - الوقت المستغرق
  - الإحصائيات

---

## 🐛 حل مشكلة شائعة

### ❌ المشكلة: "Connection refused"

**الحل للـ Emulator:**
```dart
// في lib/config/constants.dart:
static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';
```

**الحل للجهاز الحقيقي:**
```dart
// استخدم IP جهازك (مثال):
static const String apiBaseUrl = 'http://192.168.1.5:8000/api/v1';
```

**تأكد من:**
- ✅ Backend يعمل على `http://localhost:8000`
- ✅ جهازك والكمبيوتر على نفس الشبكة (للجهاز الحقيقي)
- ✅ Firewall لا يمنع الاتصال

---

## 📱 Hot Reload

أثناء التطوير:
- اضغط `r` في Terminal للتحديث السريع
- اضغط `R` لإعادة التشغيل الكامل
- اضغط `q` للخروج

---

## 🎯 توقعات الأداء

| العملية | الوقت المتوقع |
|---------|---------------|
| فتح التطبيق | 2-3 ثواني |
| تحميل المسارات | 1-2 ثانية |
| تحميل الدروس | 1 ثانية |
| حفظ التقدم | فوري |

---

## 📊 ماذا تتوقع أن ترى؟

### Splash Screen
```
🎓
تعليم الأطفال
رحلة التعلم تبدأ هنا
[Loading...]
```

### Welcome Screen (للمستخدمين الجدد)
```
🎓
مرحباً بك!
لنبدأ رحلة التعلم معاً

[حقل الاسم]
[اختيار العمر: 3-10]
[ابدأ التعلم]
```

### Home Screen
```
👋 مرحباً، أحمد!
لنتعلم شيئاً جديداً اليوم

📊 إحصائيات سريعة:
- دروس مكتملة: 0
- الوقت: 0 دقيقة
- إنجازات: 0

📚 المسارات التعليمية:
[بطاقة المسار 1]
[بطاقة المسار 2]
[بطاقة المسار 3]
```

---

## 💡 نصائح

1. **استخدم Hot Reload** بدلاً من إعادة التشغيل الكامل
2. **راقب الـ logs** في Terminal لمتابعة API calls
3. **افتح DevTools** للتطوير: `flutter run --devtools`
4. **استخدم Chrome** للاختبار السريع: `flutter run -d chrome`

---

## 🆘 المساعدة

### إذا واجهت مشكلة:

1. **تحقق من Backend:**
   ```bash
   curl http://localhost:8000/api/v1/health
   ```

2. **تحقق من Flutter:**
   ```bash
   flutter doctor -v
   ```

3. **نظّف المشروع:**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **شاهد الـ logs:**
   ```bash
   flutter logs
   ```

---

## 📞 الدعم

إذا كل شيء فشل:
1. راجع `INSTALLATION.md` للتفاصيل
2. راجع `README.md` للتوثيق الكامل
3. شغّل `flutter doctor -v` وشارك النتيجة

---

**✨ استمتع بالتطوير!**
