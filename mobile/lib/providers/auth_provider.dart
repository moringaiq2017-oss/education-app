import 'package:flutter/material.dart';
import '../models/child.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  late final AuthService _authService;
  late final StorageService _storageService;

  Child? _currentChild;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  AuthProvider() {
    _storageService = StorageService();
    _authService = AuthService(_apiService, _storageService);
    _init();
  }

  // Getters
  Child? get currentChild => _currentChild;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentChild != null;
  bool get isInitialized => _isInitialized;

  // التهيئة
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.init();
      await _authService.restoreSession();

      // التحقق من وجود مستخدم مسجل
      if (await _authService.isLoggedIn()) {
        _currentChild = await _authService.getCurrentChild();
      }
    } catch (e) {
      _error = 'خطأ في التهيئة: ${e.toString()}';
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // تسجيل طفل جديد
  Future<bool> register(String name, int age, {int? grade}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentChild = await _authService.register(name: name, age: age, grade: grade);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // تسجيل الدخول (باستخدام device ID)
  Future<bool> login() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentChild = await _authService.login();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // تحديث بيانات الطفل
  Future<void> refreshChildData() async {
    try {
      await _authService.refreshChildData();
      _currentChild = await _authService.getCurrentChild();
      notifyListeners();
    } catch (e) {
      print('Error refreshing child data: $e');
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentChild = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // التحقق من الاتصال بالخادم
  Future<bool> checkConnection() async {
    try {
      return await _apiService.checkConnection();
    } catch (e) {
      return false;
    }
  }

  // إعادة تعيين الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
