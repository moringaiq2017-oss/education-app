import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/lesson_list_screen.dart';
import '../screens/lesson_detail_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String lessonList = '/lesson-list';
  static const String lessonDetail = '/lesson-detail';
  static const String progress = '/progress';
  static const String settings = '/settings';
  
  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      lessonList: (context) => const LessonListScreen(),
      lessonDetail: (context) => const LessonDetailScreen(),
      progress: (context) => const ProgressScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
