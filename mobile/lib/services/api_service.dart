import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/child.dart';
import '../models/track.dart';
import '../models/lesson.dart';
import '../models/progress.dart';
import '../models/achievement.dart';

class ApiService {
  late final Dio _dio;
  String? _authToken;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor للـ logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Interceptor للـ auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired - يمكن إضافة refresh logic هنا
          print('⚠️ Authentication error: Token expired or invalid');
        }
        return handler.next(error);
      },
    ));
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  // ============ Auth Endpoints ============

  Future<Map<String, dynamic>> register({
    required String name,
    required int age,
    required String deviceId,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'age': age,
        'device_id': deviceId,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String deviceId) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'device_id': deviceId,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Child> getChildProfile(String childId) async {
    try {
      final response = await _dio.get('/children/$childId');
      return Child.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Tracks Endpoints ============

  Future<List<Track>> getTracks() async {
    try {
      final response = await _dio.get('/tracks');
      final List data = response.data['data'] ?? [];
      return data.map((json) => Track.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Track> getTrack(String trackId) async {
    try {
      final response = await _dio.get('/tracks/$trackId');
      return Track.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Lessons Endpoints ============

  Future<List<Lesson>> getLessons(String trackId) async {
    try {
      final response = await _dio.get('/tracks/$trackId/lessons');
      final List data = response.data['data'] ?? [];
      return data.map((json) => Lesson.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Lesson> getLesson(String lessonId) async {
    try {
      final response = await _dio.get('/lessons/$lessonId');
      return Lesson.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Progress Endpoints ============

  Future<List<Progress>> getChildProgress(String childId) async {
    try {
      final response = await _dio.get('/children/$childId/progress');
      final List data = response.data['data'] ?? [];
      return data.map((json) => Progress.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Progress> updateProgress({
    required String childId,
    required String lessonId,
    required bool isCompleted,
    required int timeSpentSeconds,
    int? score,
  }) async {
    try {
      final response = await _dio.post('/progress', data: {
        'child_id': childId,
        'lesson_id': lessonId,
        'is_completed': isCompleted,
        'time_spent_seconds': timeSpentSeconds,
        'score': score,
      });
      return Progress.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Achievements Endpoints ============

  Future<List<Achievement>> getAchievements(String childId) async {
    try {
      final response = await _dio.get('/children/$childId/achievements');
      final List data = response.data['data'] ?? [];
      return data.map((json) => Achievement.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Stats Endpoints ============

  Future<Map<String, dynamic>> getStats(String childId) async {
    try {
      final response = await _dio.get('/children/$childId/stats');
      return response.data['data'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ============ Error Handling ============

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'انتهت مهلة الاتصال. تحقق من الإنترنت.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'];
          if (statusCode == 404) {
            return message ?? 'البيانات غير موجودة';
          } else if (statusCode == 401) {
            return 'يجب تسجيل الدخول مرة أخرى';
          } else if (statusCode == 500) {
            return 'خطأ في الخادم. حاول مرة أخرى.';
          }
          return message ?? 'حدث خطأ غير متوقع';
        case DioExceptionType.connectionError:
          return 'لا يوجد اتصال بالإنترنت';
        case DioExceptionType.cancel:
          return 'تم إلغاء الطلب';
        default:
          return 'حدث خطأ. حاول مرة أخرى.';
      }
    }
    return error.toString();
  }

  // ============ Health Check ============

  Future<bool> checkConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
