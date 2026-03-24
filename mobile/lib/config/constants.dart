class AppConstants {
  // API Base URL
  static const String apiBaseUrl = 'http://127.0.0.1:8000/api/v1';  // Android emulator (localhost)
  // أو للجهاز الحقيقي: 'http://192.168.1.x:8000/api/v1'
  // أو لـ iOS emulator: 'http://localhost:8000/api/v1'
  
  // Local Storage Keys
  static const String deviceIdKey = 'device_id';
  static const String authTokenKey = 'auth_token';
  static const String childDataKey = 'child_data';
  
  // App Settings
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
}
