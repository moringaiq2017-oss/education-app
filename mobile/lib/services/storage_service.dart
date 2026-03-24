import 'dart:convert';
import 'package:hive/hive.dart';
import '../config/constants.dart';
import '../models/child.dart';
import '../models/progress.dart';

class StorageService {
  late Box _settingsBox;
  late Box _progressBox;

  Future<void> init() async {
    _settingsBox = await Hive.openBox('settings');
    _progressBox = await Hive.openBox('progress');
  }

  // ============ Device ID ============

  Future<void> saveDeviceId(String deviceId) async {
    await _settingsBox.put(AppConstants.deviceIdKey, deviceId);
  }

  Future<String?> getDeviceId() async {
    return _settingsBox.get(AppConstants.deviceIdKey);
  }

  // ============ Auth Token ============

  Future<void> saveAuthToken(String token) async {
    await _settingsBox.put(AppConstants.authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    return _settingsBox.get(AppConstants.authTokenKey);
  }

  // ============ Child Data ============

  Future<void> saveChild(Child child) async {
    await _settingsBox.put(AppConstants.childDataKey, jsonEncode(child.toJson()));
  }

  Future<Child?> getChild() async {
    final data = _settingsBox.get(AppConstants.childDataKey);
    if (data == null) return null;
    return Child.fromJson(jsonDecode(data));
  }

  // ============ Local Progress Cache ============

  Future<void> saveLocalProgress(Progress progress) async {
    await _progressBox.put(
      'progress_${progress.lessonId}',
      jsonEncode(progress.toJson()),
    );
  }

  Future<Progress?> getLocalProgress(String lessonId) async {
    final data = _progressBox.get('progress_$lessonId');
    if (data == null) return null;
    return Progress.fromJson(jsonDecode(data));
  }

  Future<List<Progress>> getAllLocalProgress() async {
    final List<Progress> progressList = [];
    for (var key in _progressBox.keys) {
      if (key.toString().startsWith('progress_')) {
        final data = _progressBox.get(key);
        if (data != null) {
          progressList.add(Progress.fromJson(jsonDecode(data)));
        }
      }
    }
    return progressList;
  }

  // ============ Settings ============

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  // مثال: حفظ إعدادات الصوت والإشعارات
  Future<void> saveSoundEnabled(bool enabled) async {
    await saveSetting('sound_enabled', enabled);
  }

  bool getSoundEnabled() {
    return getSetting('sound_enabled', defaultValue: true);
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    await saveSetting('notifications_enabled', enabled);
  }

  bool getNotificationsEnabled() {
    return getSetting('notifications_enabled', defaultValue: true);
  }

  // ============ Offline Mode ============

  Future<void> saveOfflineData(String key, dynamic data) async {
    await _settingsBox.put('offline_$key', jsonEncode(data));
  }

  Future<dynamic> getOfflineData(String key) async {
    final data = _settingsBox.get('offline_$key');
    if (data == null) return null;
    return jsonDecode(data);
  }

  // ============ Clear All ============

  Future<void> clear() async {
    await _settingsBox.clear();
    await _progressBox.clear();
  }

  Future<void> clearProgress() async {
    await _progressBox.clear();
  }

  // ============ Debug ============

  Future<void> printAllData() async {
    print('=== Settings Box ===');
    for (var key in _settingsBox.keys) {
      print('$key: ${_settingsBox.get(key)}');
    }
    print('=== Progress Box ===');
    for (var key in _progressBox.keys) {
      print('$key: ${_progressBox.get(key)}');
    }
  }
}
