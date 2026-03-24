import 'package:flutter/material.dart';
import '../models/track.dart';
import '../models/lesson.dart';
import '../services/api_service.dart';

class LessonsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Track> _tracks = [];
  Map<String, List<Lesson>> _lessonsByTrack = {};
  
  bool _isLoadingTracks = false;
  bool _isLoadingLessons = false;
  String? _error;

  Track? _selectedTrack;
  Lesson? _selectedLesson;

  // Getters
  List<Track> get tracks => _tracks;
  Map<String, List<Lesson>> get lessonsByTrack => _lessonsByTrack;
  bool get isLoadingTracks => _isLoadingTracks;
  bool get isLoadingLessons => _isLoadingLessons;
  String? get error => _error;
  Track? get selectedTrack => _selectedTrack;
  Lesson? get selectedLesson => _selectedLesson;

  // الحصول على جميع المسارات
  Future<void> fetchTracks() async {
    _isLoadingTracks = true;
    _error = null;
    notifyListeners();

    try {
      _tracks = await _apiService.getTracks();
      _tracks.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingTracks = false;
      notifyListeners();
    }
  }

  // الحصول على دروس مسار معين
  Future<void> fetchLessons(String trackId) async {
    _isLoadingLessons = true;
    _error = null;
    notifyListeners();

    try {
      final lessons = await _apiService.getLessons(trackId);
      lessons.sort((a, b) => a.order.compareTo(b.order));
      _lessonsByTrack[trackId] = lessons;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingLessons = false;
      notifyListeners();
    }
  }

  // اختيار مسار
  void selectTrack(Track track) {
    _selectedTrack = track;
    notifyListeners();
  }

  // اختيار درس
  void selectLesson(Lesson lesson) {
    _selectedLesson = lesson;
    notifyListeners();
  }

  // الحصول على دروس مسار (من الكاش أو API)
  Future<List<Lesson>> getLessons(String trackId) async {
    if (_lessonsByTrack.containsKey(trackId)) {
      return _lessonsByTrack[trackId]!;
    }
    await fetchLessons(trackId);
    return _lessonsByTrack[trackId] ?? [];
  }

  // الحصول على درس معين
  Future<Lesson?> getLesson(String lessonId) async {
    // البحث في الكاش أولاً
    for (var lessons in _lessonsByTrack.values) {
      final lesson = lessons.firstWhere(
        (l) => l.id == lessonId,
        orElse: () => Lesson(
          id: '',
          trackId: '',
          title: '',
          description: '',
          content: '',
          contentType: 'text',
          order: 0,
        ),
      );
      if (lesson.id.isNotEmpty) return lesson;
    }

    // إذا لم يوجد في الكاش، جلبه من API
    try {
      return await _apiService.getLesson(lessonId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // الحصول على الدرس التالي
  Lesson? getNextLesson(String currentLessonId) {
    for (var lessons in _lessonsByTrack.values) {
      final currentIndex = lessons.indexWhere((l) => l.id == currentLessonId);
      if (currentIndex != -1 && currentIndex < lessons.length - 1) {
        return lessons[currentIndex + 1];
      }
    }
    return null;
  }

  // الحصول على الدرس السابق
  Lesson? getPreviousLesson(String currentLessonId) {
    for (var lessons in _lessonsByTrack.values) {
      final currentIndex = lessons.indexWhere((l) => l.id == currentLessonId);
      if (currentIndex > 0) {
        return lessons[currentIndex - 1];
      }
    }
    return null;
  }

  // تحديث حالة إكمال الدرس محلياً
  void markLessonComplete(String lessonId) {
    for (var trackId in _lessonsByTrack.keys) {
      final lessons = _lessonsByTrack[trackId]!;
      final index = lessons.indexWhere((l) => l.id == lessonId);
      if (index != -1) {
        _lessonsByTrack[trackId]![index] = lessons[index].copyWith(
          isCompleted: true,
        );
        
        // فتح الدرس التالي
        if (index < lessons.length - 1) {
          _lessonsByTrack[trackId]![index + 1] = lessons[index + 1].copyWith(
            isLocked: false,
          );
        }

        // تحديث عداد الدروس المكتملة في المسار
        final track = _tracks.firstWhere((t) => t.id == trackId);
        final trackIndex = _tracks.indexOf(track);
        _tracks[trackIndex] = Track(
          id: track.id,
          title: track.title,
          description: track.description,
          icon: track.icon,
          color: track.color,
          order: track.order,
          totalLessons: track.totalLessons,
          completedLessons: track.completedLessons + 1,
        );

        notifyListeners();
        break;
      }
    }
  }

  // إعادة تحميل كل شيء
  Future<void> refreshAll() async {
    await fetchTracks();
    for (var track in _tracks) {
      await fetchLessons(track.id);
    }
  }

  // مسح الأخطاء
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // إعادة تعيين
  void reset() {
    _tracks = [];
    _lessonsByTrack = {};
    _selectedTrack = null;
    _selectedLesson = null;
    _error = null;
    notifyListeners();
  }
}
