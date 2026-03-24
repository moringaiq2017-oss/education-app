import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive/hive.dart';
import '../config/constants.dart';
import '../models/child.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  // توليد Device ID فريد
  Future<String> getDeviceId() async {
    // التحقق من وجود device ID محفوظ
    String? savedDeviceId = await _storageService.getDeviceId();
    if (savedDeviceId != null && savedDeviceId.isNotEmpty) {
      return savedDeviceId;
    }

    // توليد device ID جديد
    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? _generateRandomId();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? _generateRandomId();
      } else {
        deviceId = _generateRandomId();
      }
    } catch (e) {
      deviceId = _generateRandomId();
    }

    // حفظ الـ device ID
    await _storageService.saveDeviceId(deviceId);
    return deviceId;
  }

  String _generateRandomId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '-' +
        (DateTime.now().microsecondsSinceEpoch % 100000).toString();
  }

  // تسجيل طفل جديد
  Future<Child> register({
    required String name,
    required int age,
  }) async {
    try {
      final deviceId = await getDeviceId();

      final response = await _apiService.register(
        name: name,
        age: age,
        deviceId: deviceId,
      );

      // حفظ بيانات الطفل والتوكن
      final child = Child.fromJson(response['data']['child']);
      final token = response['data']['token'];

      await _storageService.saveChild(child);
      await _storageService.saveAuthToken(token);
      _apiService.setAuthToken(token);

      return child;
    } catch (e) {
      rethrow;
    }
  }

  // تسجيل الدخول
  Future<Child> login() async {
    try {
      final deviceId = await getDeviceId();

      final response = await _apiService.login(deviceId);

      // حفظ بيانات الطفل والتوكن
      final child = Child.fromJson(response['data']['child']);
      final token = response['data']['token'];

      await _storageService.saveChild(child);
      await _storageService.saveAuthToken(token);
      _apiService.setAuthToken(token);

      return child;
    } catch (e) {
      rethrow;
    }
  }

  // التحقق من وجود مستخدم مسجل
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAuthToken();
    final child = await _storageService.getChild();
    return token != null && child != null;
  }

  // الحصول على المستخدم الحالي
  Future<Child?> getCurrentChild() async {
    return await _storageService.getChild();
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _storageService.clear();
    _apiService.clearAuthToken();
  }

  // تحديث بيانات الطفل
  Future<void> refreshChildData() async {
    try {
      final child = await getCurrentChild();
      if (child == null) return;

      final updatedChild = await _apiService.getChildProfile(child.id);
      await _storageService.saveChild(updatedChild);
    } catch (e) {
      print('Error refreshing child data: $e');
    }
  }

  // استعادة الـ session
  Future<void> restoreSession() async {
    final token = await _storageService.getAuthToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
  }
}
