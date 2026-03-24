# 🚀 دليل التثبيت والتشغيل السريع

## المتطلبات الأساسية

### 1. تثبيت Flutter
```bash
# macOS
brew install flutter

# أو تحميل مباشر من:
https://docs.flutter.dev/get-started/install

# التحقق من التثبيت:
flutter doctor
```

### 2. إعداد Android Studio (للأندرويد)
- تثبيت Android Studio
- تثبيت Android SDK
- إنشاء Emulator

### 3. إعداد Xcode (للـ iOS - macOS فقط)
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## خطوات التشغيل

### الخطوة 1: تثبيت Dependencies
```bash
cd mobile
flutter pub get
```

### الخطوة 2: تشغيل Backend
تأكد من تشغيل Backend أولاً:
```bash
cd ../backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Backend سيعمل على: `http://localhost:8000`

### الخطوة 3: تحديث API URL

**للأندرويد Emulator:**
الكود الحالي جاهز، لا حاجة للتغيير.

**للجهاز الحقيقي:**
افتح `lib/config/constants.dart` وغيّر:
```dart
// احصل على IP الخاص بك:
// macOS/Linux: ifconfig | grep "inet "
// Windows: ipconfig

static const String apiBaseUrl = 'http://192.168.1.X:8000/api/v1';
```

### الخطوة 4: تشغيل التطبيق

#### على Android Emulator:
```bash
# عرض الـ emulators المتاحة
flutter emulators

# تشغيل emulator
flutter emulators --launch <emulator-id>

# تشغيل التطبيق
flutter run
```

#### على جهاز Android حقيقي:
```bash
# 1. فعّل USB Debugging على الجهاز
# 2. وصّل الجهاز بالكمبيوتر
# 3. تحقق من اتصال الجهاز:
flutter devices

# 4. شغّل التطبيق:
flutter run
```

#### على iOS Simulator (macOS فقط):
```bash
open -a Simulator
flutter run -d ios
```

#### على Chrome (للتطوير السريع):
```bash
flutter run -d chrome
```

## التحقق من صحة الإعداد

### 1. اختبار الاتصال بالـ Backend:
افتح المتصفح: `http://localhost:8000/docs`
يجب أن تظهر صفحة Swagger UI.

### 2. اختبار التطبيق:
1. شغّل التطبيق
2. يجب أن تظهر شاشة الترحيب
3. سجّل اسم جديد
4. يجب أن تظهر الشاشة الرئيسية مع المسارات

## حل المشاكل الشائعة

### مشكلة 1: "Connection refused"
**الحل:**
- تأكد من تشغيل Backend
- للـ emulator، استخدم `10.0.2.2` بدلاً من `localhost`
- للجهاز الحقيقي، استخدم IP الكمبيوتر

### مشكلة 2: "No devices found"
**الحل:**
```bash
flutter devices
# إذا لم يظهر شيء:
flutter doctor
```

### مشكلة 3: خطأ في Gradle (أندرويد)
**الحل:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### مشكلة 4: خطأ في Hive
**الحل:**
```bash
flutter clean
flutter pub get
```

### مشكلة 5: خطأ في Google Fonts
**الحل:**
- تأكد من اتصالك بالإنترنت
- أو أضف الخطوط محلياً في `pubspec.yaml`

## الاختبار على أجهزة مختلفة

### Android:
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 33 (Android 13)

### iOS:
- Minimum iOS: 12.0
- Xcode 14+

## بناء APK للإنتاج

```bash
# Debug APK (للاختبار)
flutter build apk --debug

# Release APK (للنشر)
flutter build apk --release

# APK split (أصغر حجماً)
flutter build apk --split-per-abi
```

الملف سيكون في: `build/app/outputs/flutter-apk/`

## بناء IPA للـ iOS

```bash
flutter build ios --release
# ثم افتح Xcode لرفعه على App Store
```

## نصائح للتطوير

### Hot Reload:
اضغط `r` في Terminal لتحديث التطبيق بسرعة بدون إعادة تشغيل.

### Hot Restart:
اضغط `R` لإعادة تشغيل التطبيق بالكامل.

### تفعيل التطوير:
```bash
# عرض أدوات التطوير
flutter run --debug
```

### مراقبة الـ logs:
```bash
flutter logs
```

## موارد مفيدة

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language](https://dart.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Hive Database](https://docs.hivedb.dev)

---

**ملاحظة:** عند مواجهة أي مشكلة، شغّل `flutter doctor -v` وشارك النتيجة.
