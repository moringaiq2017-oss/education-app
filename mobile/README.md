# Mobile App — Flutter
**تطبيق تعليم الأطفال العراقيين**

---

## Setup

### Requirements
- Flutter 3.19+
- Dart 3.3+
- Android Studio / VS Code
- Android SDK (for Android)
- Xcode (for iOS, macOS only)

### Installation

```bash
# Check Flutter
flutter doctor

# Create project (if not exists)
cd mobile
flutter create --org com.makanstudios education_app_iraq

# Get dependencies
flutter pub get
```

---

## Run

### Development

```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter devices
flutter run -d <device-id>

# Hot reload: r
# Hot restart: R
# Quit: q
```

### Debug Mode
```bash
flutter run --debug
```

### Profile Mode (للـ performance testing)
```bash
flutter run --profile
```

### Release Mode
```bash
flutter run --release
```

---

## Build

### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (للـ Google Play)
```bash
flutter build appbundle --release
```

### iOS (macOS only)
```bash
flutter build ios --release
```

---

## Project Structure

```
mobile/
├── lib/
│   ├── main.dart              # Entry point
│   ├── app.dart               # App widget
│   │
│   ├── config/                # Configuration
│   │   ├── theme.dart         # App theme (colors, fonts)
│   │   ├── routes.dart        # Navigation routes
│   │   └── constants.dart     # Constants
│   │
│   ├── models/                # Data models
│   │   ├── child.dart
│   │   ├── track.dart
│   │   ├── lesson.dart
│   │   ├── progress.dart
│   │   └── achievement.dart
│   │
│   ├── services/              # Services (API, storage, audio)
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart
│   │   └── audio_service.dart
│   │
│   ├── providers/             # State management (Provider/Riverpod/Bloc)
│   │   ├── auth_provider.dart
│   │   ├── lessons_provider.dart
│   │   └── progress_provider.dart
│   │
│   ├── screens/               # App screens
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── lesson_list_screen.dart
│   │   ├── lesson_detail_screen.dart
│   │   ├── progress_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── widgets/               # Reusable widgets
│   │   ├── track_card.dart
│   │   ├── lesson_card.dart
│   │   ├── progress_bar.dart
│   │   └── achievement_badge.dart
│   │
│   └── utils/                 # Utilities
│       ├── helpers.dart
│       └── validators.dart
│
├── assets/                    # Static assets
│   ├── images/
│   │   ├── logo.png
│   │   ├── characters/
│   │   └── icons/
│   ├── fonts/
│   │   └── Cairo/
│   └── audio/
│       ├── lessons/
│       └── effects/
│
├── test/                      # Tests
│   └── widget_test.dart
│
├── android/                   # Android config
├── ios/                       # iOS config
├── pubspec.yaml              # Dependencies
└── README.md
```

---

## Dependencies

### Core (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  # أو: flutter_riverpod: ^2.4.10
  # أو: flutter_bloc: ^8.1.4
  
  # HTTP & API
  dio: ^5.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Audio
  audioplayers: ^5.2.1
  # أو: just_audio: ^0.9.36
  
  # Navigation
  go_router: ^13.0.0
  
  # UI
  google_fonts: ^6.1.0
  
  # Utils
  intl: ^0.18.1
  uuid: ^4.3.3
  path_provider: ^2.1.2
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

### Install
```bash
flutter pub get
```

---

## Configuration

### 1. Theme (config/theme.dart)

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF4A90E2),
      colorScheme: ColorScheme.light(
        primary: Color(0xFF4A90E2),
        secondary: Color(0xFF7ED321),
        error: Color(0xFFF5A623),
      ),
      textTheme: GoogleFonts.cairoTextTheme(),
      useMaterial3: true,
    );
  }
}
```

### 2. RTL Support

في `main.dart`:
```dart
return MaterialApp(
  locale: Locale('ar'),
  supportedLocales: [Locale('ar')],
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...
);
```

### 3. API Base URL

في `services/api_service.dart`:
```dart
class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  // أو للـ Android emulator: 'http://10.0.2.2:8000/api/v1'
}
```

---

## State Management

### اختر واحد:

#### Option 1: Provider (بسيط)
```yaml
dependencies:
  provider: ^6.1.1
```

#### Option 2: Riverpod (حديث، قوي)
```yaml
dependencies:
  flutter_riverpod: ^2.4.10
```

#### Option 3: Bloc (enterprise-level)
```yaml
dependencies:
  flutter_bloc: ^8.1.4
```

**توصية:** ابدأ بـ **Provider** للبساطة، لو احتجت أقوى استخدم **Riverpod**.

---

## Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# With coverage
flutter test --coverage

# Integration tests (future)
flutter drive --target=test_driver/app.dart
```

---

## Code Style

### Follow Official Dart Style Guide
- https://dart.dev/guides/language/effective-dart

### Use Lints
```yaml
dev_dependencies:
  flutter_lints: ^3.0.1
```

### Format Code
```bash
dart format lib/
```

### Analyze
```bash
flutter analyze
```

---

## Common Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Run build_runner (if using code generation)
flutter pub run build_runner build --delete-conflicting-outputs

# Check outdated packages
flutter pub outdated
```

---

## Debugging

### Flutter DevTools
```bash
# Run app
flutter run

# Open DevTools (في browser)
# اتبع الرابط في console
```

### Logs
```bash
# View logs
flutter logs

# Filter logs
flutter logs | grep "MyTag"
```

---

## Performance

### Profile Mode
```bash
flutter run --profile
```

### Performance Overlay
```dart
MaterialApp(
  showPerformanceOverlay: true,
  // ...
)
```

### Check for Jank (dropped frames)
- Use DevTools → Performance tab
- Target: 60 FPS

---

## Assets Management

### pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/characters/
    - assets/audio/
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo/Cairo-Bold.ttf
          weight: 700
```

### Usage
```dart
// Image
Image.asset('assets/images/logo.png')

// Audio
AudioPlayer().play(AssetSource('audio/success.mp3'))

// Font (auto with google_fonts)
Text('مرحباً', style: GoogleFonts.cairo())
```

---

## Android Setup

### Minimum SDK

`android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 24  // Android 7.0+
        targetSdkVersion 34
    }
}
```

### App Name

`android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="تعليم الأطفال"
    android:icon="@mipmap/ic_launcher">
```

### Permissions

```xml
<!-- Internet (already included by default) -->
<uses-permission android:name="android.permission.INTERNET"/>

<!-- Audio (if needed) -->
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
```

---

## iOS Setup (Future)

### Minimum Version

`ios/Podfile`:
```ruby
platform :ios, '12.0'
```

### App Name

`ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>تعليم الأطفال</string>
```

---

## Contributing

1. Create feature branch: `git checkout -b feature/frontend-xxx`
2. Make changes
3. Test: `flutter test`
4. Format: `dart format lib/`
5. Commit: `git commit -m "[frontend] Description"`
6. Push: `git push origin feature/frontend-xxx`
7. Open Pull Request to `develop`

---

## Troubleshooting

### Problem: "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problem: "Unable to load asset"
- تأكد من إضافة الملف في `pubspec.yaml`
- `flutter clean && flutter pub get`

### Problem: "RTL not working"
- تأكد من `locale: Locale('ar')`
- تأكد من `localizationsDelegates`
- Restart app (hot reload لا يكفي)

---

## Resources

- Flutter Docs: https://docs.flutter.dev/
- Dart Docs: https://dart.dev/guides
- Pub.dev: https://pub.dev/
- Flutter Cookbook: https://docs.flutter.dev/cookbook

---

**Last Updated:** 19 March 2026  
**Status:** 🚧 In Development  
**Framework:** Flutter 3.19+
