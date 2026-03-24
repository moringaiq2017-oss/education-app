import 'package:flutter/material.dart';
import '../models/progress.dart';
import '../models/achievement.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ProgressProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Progress> _progressList = [];
  List<Achievement> _achievements = [];
  Map<String, dynamic>? _stats;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Progress> get progressList => _progressList;
  List<Achievement> get achievements => _achievements;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // الحصول على التقدم من التخزين المحلي أولاً
  Future<void> loadLocalProgress() async {
    try {
      await _storageService.init();
      _progressList = await _storageService.getAllLocalProgress();
      notifyListeners();
    } catch (e) {
      print('Error loading local progress: $e');
    }
  }

  // جلب تقدم الطفل من الخادم
  Future<void> fetchProgress(String childId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _progressList = await _apiService.getChildProgress(childId);
      
      // حفظ التقدم محلياً
      for (var progress in _progressList) {
        await _storageService.saveLocalProgress(progress);
      }
    } catch (e) {
      _error = e.toString();
      // في حالة الخطأ، استخدم البيانات المحلية
      await loadLocalProgress();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب الإنجازات
  Future<void> fetchAchievements(String childId) async {
    try {
      _achievements = await _apiService.getAchievements(childId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // جلب الإحصائيات
  Future<void> fetchStats(String childId) async {
    try {
      _stats = await _apiService.getStats(childId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // تحديث التقدم لدرس معين
  Future<bool> updateLessonProgress({
    required String childId,
    required String lessonId,
    required bool isCompleted,
    required int timeSpentSeconds,
    int? score,
  }) async {
    try {
      final progress = await _apiService.updateProgress(
        childId: childId,
        lessonId: lessonId,
        isCompleted: isCompleted,
        timeSpentSeconds: timeSpentSeconds,
        score: score,
      );

      // تحديث القائمة المحلية
      final index = _progressList.indexWhere((p) => p.lessonId == lessonId);
      if (index != -1) {
        _progressList[index] = progress;
      } else {
        _progressList.add(progress);
      }

      // حفظ محلياً
      await _storageService.saveLocalProgress(progress);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // الحصول على تقدم درس معين
  Progress? getLessonProgress(String lessonId) {
    try {
      return _progressList.firstWhere((p) => p.lessonId == lessonId);
    } catch (e) {
      return null;
    }
  }

  // التحقق من إكمال درس
  bool isLessonCompleted(String lessonId) {
    final progress = getLessonProgress(lessonId);
    return progress?.isCompleted ?? false;
  }

  // الحصول على عدد الدروس المكتملة
  int get completedLessonsCount {
    return _progressList.where((p) => p.isCompleted).length;
  }

  // الحصول على إجمالي الوقت المستغرق
  int get totalTimeSpent {
    return _progressList.fold(0, (sum, p) => sum + p.timeSpentSeconds);
  }

  // الحصول على إجمالي الوقت بصيغة مقروءة
  String get totalTimeFormatted {
    final hours = totalTimeSpent ~/ 3600;
    final minutes = (totalTimeSpent % 3600) ~/ 60;
    
    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    }
    return '$minutes دقيقة';
  }

  // الحصول على متوسط الدرجات
  double? get averageScore {
    final scoresProgress = _progressList.where((p) => p.score != null).toList();
    if (scoresProgress.isEmpty) return null;
    
    final totalScore = scoresProgress.fold(0, (sum, p) => sum + (p.score ?? 0));
    return totalScore / scoresProgress.length;
  }

  // الحصول على عدد الإنجازات المفتوحة
  int get unlockedAchievementsCount {
    return _achievements.where((a) => a.isUnlocked).length;
  }

  // جلب كل البيانات
  Future<void> fetchAllProgress(String childId) async {
    await Future.wait([
      fetchProgress(childId),
      fetchAchievements(childId),
      fetchStats(childId),
    ]);
  }

  // إعادة تحميل
  Future<void> refresh(String childId) async {
    await fetchAllProgress(childId);
  }

  // مسح الأخطاء
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // إعادة تعيين
  void reset() {
    _progressList = [];
    _achievements = [];
    _stats = null;
    _error = null;
    notifyListeners();
  }
}
