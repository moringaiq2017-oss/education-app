# 🎓 تطبيق تعليم الأطفال - Education App

تطبيق Flutter تعليمي تفاعلي مصمم خصيصاً للأطفال العراقيين (3-10 سنوات).

## ✨ المميزات

- ✅ **دعم RTL كامل** - واجهة عربية بالكامل
- ✅ **Theme Cairo Font** - خط عربي جميل ومقروء
- ✅ **API Integration** - متصل بالـ Backend بشكل كامل
- ✅ **Local Storage (Hive)** - حفظ التقدم محلياً
- ✅ **Offline Support** - إمكانية العمل بدون إنترنت
- ✅ **Progress Tracking** - متابعة التقدم والإحصائيات
- ✅ **Achievements System** - نظام إنجازات تحفيزي
- ✅ **Responsive UI** - واجهة متجاوبة مع جميع الأحجام

## 🏗️ البنية

```
lib/
├── config/
│   ├── constants.dart      # ثوابت التطبيق والـ API URLs
│   ├── theme.dart          # الألوان والثيم
│   └── routes.dart         # المسارات
├── models/
│   ├── child.dart          # موديل الطفل
│   ├── track.dart          # موديل المسار
│   ├── lesson.dart         # موديل الدرس
│   ├── progress.dart       # موديل التقدم
│   └── achievement.dart    # موديل الإنجازات
├── services/
│   ├── api_service.dart    # خدمة الـ API (Dio)
│   ├── auth_service.dart   # خدمة المصادقة
│   └── storage_service.dart # خدمة التخزين المحلي (Hive)
├── providers/
│   ├── auth_provider.dart     # Provider المصادقة
│   ├── lessons_provider.dart  # Provider الدروس
│   └── progress_provider.dart # Provider التقدم
├── screens/
│   ├── splash_screen.dart        # شاشة البداية والتسجيل
│   ├── home_screen.dart          # الشاشة الرئيسية
│   ├── lesson_list_screen.dart   # قائمة الدروس
│   ├── lesson_detail_screen.dart # تفاصيل الدرس
│   ├── progress_screen.dart      # شاشة التقدم والإحصائيات
│   └── settings_screen.dart      # شاشة الإعدادات
├── widgets/
│   ├── track_card.dart        # بطاقة المسار
│   ├── lesson_card.dart       # بطاقة الدرس
│   ├── progress_bar.dart      # شريط التقدم
│   └── achievement_badge.dart # شارة الإنجاز
└── main.dart
```

## 🚀 التثبيت والتشغيل

### المتطلبات
- Flutter SDK 3.0+
- Android Studio / VS Code
- Android SDK (للأندرويد) أو Xcode (للـ iOS)

### خطوات التشغيل

1. **تثبيت الـ dependencies:**
```bash
cd mobile
flutter pub get
```

2. **تشغيل Backend:**
تأكد من تشغيل الـ Backend أولاً على:
```
http://localhost:8000
```

3. **تحديث API URL:**
في ملف `lib/config/constants.dart`:
```dart
// للأندرويد Emulator:
static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';

// للجهاز الحقيقي:
static const String apiBaseUrl = 'http://192.168.1.X:8000/api/v1';
```

4. **تشغيل التطبيق:**
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Chrome (للتطوير)
flutter run -d chrome
```

## 📱 الشاشات

### 1. Splash Screen
- شاشة البداية مع أنيميشن
- التحقق من وجود مستخدم مسجل
- شاشة تسجيل جديد للمستخدمين الجدد

### 2. Home Screen
- عرض المسارات التعليمية
- إحصائيات سريعة
- التنقل بين الأقسام

### 3. Lesson List Screen
- قائمة الدروس داخل المسار
- شريط تقدم المسار
- نظام القفل للدروس

### 4. Lesson Detail Screen
- محتوى الدرس (نص/فيديو/اختبار)
- أسئلة تفاعلية
- زر إكمال الدرس
- الانتقال للدرس التالي

### 5. Progress Screen
- إحصائيات التقدم
- الإنجازات المفتوحة
- الهدف اليومي

### 6. Settings Screen
- معلومات الحساب
- إعدادات التطبيق
- تسجيل الخروج

## 🔌 API Integration

التطبيق يتصل بالـ Backend عبر:

### Endpoints المستخدمة:
- `POST /api/v1/auth/register` - تسجيل طفل جديد
- `POST /api/v1/auth/login` - تسجيل الدخول
- `GET /api/v1/tracks` - جلب المسارات
- `GET /api/v1/tracks/:id/lessons` - جلب دروس مسار
- `GET /api/v1/lessons/:id` - جلب درس معين
- `GET /api/v1/children/:id/progress` - جلب تقدم الطفل
- `POST /api/v1/progress` - تحديث التقدم
- `GET /api/v1/children/:id/achievements` - جلب الإنجازات
- `GET /api/v1/children/:id/stats` - جلب الإحصائيات

### Error Handling:
- Timeout handling
- Offline mode support
- User-friendly error messages in Arabic

## 💾 Local Storage

استخدام Hive للتخزين المحلي:

### ما يتم حفظه:
- Device ID
- Auth Token
- بيانات الطفل
- التقدم المحلي (للعمل Offline)
- الإعدادات

## 🎨 Theme & RTL

- خط Cairo من Google Fonts
- دعم RTL كامل
- ألوان متناسقة وجذابة للأطفال
- أنيميشنات سلسة

## 🧪 الاختبار

### للاختبار على Android Emulator:
```bash
flutter emulators --launch <emulator_id>
flutter run
```

### للاختبار على جهاز حقيقي:
1. تفعيل USB Debugging
2. توصيل الجهاز
3. `flutter devices`
4. `flutter run`

## 🐛 Troubleshooting

### مشكلة الاتصال بالـ API:
- تأكد من تشغيل Backend
- للـ Emulator استخدم `10.0.2.2` بدلاً من `localhost`
- للجهاز الحقيقي، تأكد أن الجهاز والكمبيوتر على نفس الشبكة

### مشكلة Hive:
```bash
flutter clean
flutter pub get
```

### مشكلة الخطوط:
تأكد من اتصالك بالإنترنت لتحميل Google Fonts، أو قم بإضافة الخطوط محلياً.

## 📝 TODO

- [ ] إضافة video player للفيديوهات
- [ ] إضافة صفحة الإشعارات
- [ ] إضافة نظام المكافآت
- [ ] إضافة مشاركة التقدم
- [ ] إضافة Dark Mode
- [ ] تحسين الأنيميشنات
- [ ] إضافة Unit Tests

## 👨‍💻 المطور

Frontend Developer - Flutter
تطبيق تعليمي للأطفال العراقيين - 2026

## 📄 License

هذا المشروع تعليمي مفتوح المصدر.

---

**ملاحظة:** تأكد من تشغيل Backend قبل تشغيل التطبيق!
