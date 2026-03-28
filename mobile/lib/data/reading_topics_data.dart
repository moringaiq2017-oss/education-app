import 'package:flutter/material.dart';
import 'dictation_data.dart';
import 'songs_data.dart';
import 'memorization_data.dart';

/// موضوع من كتاب قراءتي للصف الأول الابتدائي
class ReadingTopic {
  final int id;
  final String title;
  final String letter;
  final int pageNumber;
  final String illustration; // إيموجي توضيحي
  final Color color;
  final List<int> dictationIds;
  final List<int> songIds;
  final List<int> memorizationIds;

  const ReadingTopic({
    required this.id,
    required this.title,
    required this.letter,
    required this.pageNumber,
    required this.illustration,
    required this.color,
    this.dictationIds = const [],
    this.songIds = const [],
    this.memorizationIds = const [],
  });

  /// عدد الأقسام المتاحة (إملاء + أناشيد + محفوظات + تعليم إلكتروني)
  int get availableSectionsCount {
    int count = 1; // تعليم إلكتروني دائماً
    if (dictationIds.isNotEmpty) count++;
    if (songIds.isNotEmpty) count++;
    if (memorizationIds.isNotEmpty) count++;
    return count;
  }

  /// جلب دروس الإملاء المرتبطة
  List<DictationLesson> get dictationLessons =>
      DictationData.lessons.where((l) => dictationIds.contains(l.id)).toList();

  /// جلب الأناشيد المرتبطة
  List<Song> get songs =>
      SongsData.songs.where((s) => songIds.contains(s.id)).toList();

  /// جلب دروس المحفوظات المرتبطة
  List<MemorizationLesson> get memorizationLessons =>
      MemorizationData.lessons.where((l) => memorizationIds.contains(l.id)).toList();
}

class ReadingTopicsData {
  static const List<ReadingTopic> topics = [
    // === المرحلة الأولى: الحروف الأساسية ===

    ReadingTopic(
      id: 1,
      title: 'حرف الدال',
      letter: 'د',
      pageNumber: 21,
      illustration: '🏠', // دار
      color: Color(0xFF6C63FF),
      dictationIds: [1],
      memorizationIds: [1],
    ),
    ReadingTopic(
      id: 2,
      title: 'حرف الباء',
      letter: 'ب',
      pageNumber: 26,
      illustration: '🚪', // باب
      color: Color(0xFF00B894),
      dictationIds: [2],
      memorizationIds: [2],
    ),
    ReadingTopic(
      id: 3,
      title: 'حرف النون',
      letter: 'ن',
      pageNumber: 27,
      illustration: '💡', // نور
      color: Color(0xFF0984E3),
      dictationIds: [3],
    ),
    ReadingTopic(
      id: 4,
      title: 'حرف الميم',
      letter: 'م',
      pageNumber: 28,
      illustration: '👩', // ماما
      color: Color(0xFFE84393),
      dictationIds: [4],
      memorizationIds: [3],
      songIds: [1], // أنشودة دعاء - صفحة 30
    ),
    ReadingTopic(
      id: 5,
      title: 'حرف الياء',
      letter: 'ي',
      pageNumber: 31,
      illustration: '🌹', // ريم
      color: Color(0xFFFDAA5E),
      dictationIds: [5],
      memorizationIds: [4, 5],
    ),
    ReadingTopic(
      id: 6,
      title: 'حرف القاف',
      letter: 'ق',
      pageNumber: 37,
      illustration: '🐄', // بقر
      color: Color(0xFF00CEC9),
      dictationIds: [6],
      memorizationIds: [6],
    ),
    ReadingTopic(
      id: 7,
      title: 'حرف الزاي',
      letter: 'ز',
      pageNumber: 38,
      illustration: '🦆', // وز
      color: Color(0xFFA66CFF),
      dictationIds: [7],
      memorizationIds: [7],
    ),
    ReadingTopic(
      id: 8,
      title: 'مراجعة ١',
      letter: '📝',
      pageNumber: 41,
      illustration: '🎵', // مزمار
      color: Color(0xFFFF6B6B),
      dictationIds: [8],
      memorizationIds: [8],
      songIds: [2], // أنشودة مدرستي - صفحة 40
    ),

    // === المرحلة الثانية: حروف متوسطة ===

    ReadingTopic(
      id: 9,
      title: 'حرف اللام',
      letter: 'ل',
      pageNumber: 46,
      illustration: '🥛', // لبن
      color: Color(0xFF6C63FF),
      dictationIds: [9],
      memorizationIds: [9, 12],
    ),
    ReadingTopic(
      id: 10,
      title: 'حرف الفاء',
      letter: 'ف',
      pageNumber: 48,
      illustration: '🌿', // ريف
      color: Color(0xFF00B894),
      dictationIds: [10],
      memorizationIds: [10],
    ),
    ReadingTopic(
      id: 11,
      title: 'حرف الهمزة',
      letter: 'ء',
      pageNumber: 49,
      illustration: '👷', // بناء
      color: Color(0xFF0984E3),
      dictationIds: [11],
      memorizationIds: [11],
      songIds: [3], // أصحابي - صفحة 51
    ),
    ReadingTopic(
      id: 12,
      title: 'مراجعة ٢',
      letter: '📝',
      pageNumber: 50,
      illustration: '📖',
      color: Color(0xFFFF6B6B),
      dictationIds: [12],
    ),

    // === المرحلة الثالثة: حروف متقدمة ===

    ReadingTopic(
      id: 13,
      title: 'حرف الطاء',
      letter: 'ط',
      pageNumber: 55,
      illustration: '🐥', // بط
      color: Color(0xFFFDAA5E),
      dictationIds: [13],
    ),
    ReadingTopic(
      id: 14,
      title: 'أنشودة البط',
      letter: '🦆',
      pageNumber: 56,
      illustration: '🦆',
      color: Color(0xFF00CEC9),
      dictationIds: [14],
      songIds: [4], // أنشودة البط
    ),
    ReadingTopic(
      id: 15,
      title: 'التنوين',
      letter: 'ـًـ',
      pageNumber: 59,
      illustration: '🌸', // ورداً
      color: Color(0xFFE84393),
      dictationIds: [15],
    ),
    ReadingTopic(
      id: 16,
      title: 'ال التعريف',
      letter: 'ال',
      pageNumber: 61,
      illustration: '🌧️', // المطر
      color: Color(0xFF0984E3),
      dictationIds: [16],
    ),
    ReadingTopic(
      id: 17,
      title: 'حرف التاء',
      letter: 'ت',
      pageNumber: 63,
      illustration: '🌴', // تمر
      color: Color(0xFF00B894),
      dictationIds: [17],
    ),
    ReadingTopic(
      id: 18,
      title: 'حرف لا',
      letter: 'لا',
      pageNumber: 65,
      illustration: '✋',
      color: Color(0xFFA66CFF),
      dictationIds: [18],
    ),
    ReadingTopic(
      id: 19,
      title: 'حرف السين',
      letter: 'س',
      pageNumber: 67,
      illustration: '🌳', // بستان
      color: Color(0xFF6C63FF),
      dictationIds: [19],
      songIds: [5], // حروفنا الجميلة - صفحة 70
    ),
    ReadingTopic(
      id: 20,
      title: 'حرف العين',
      letter: 'ع',
      pageNumber: 68,
      illustration: '🧑‍🌾', // مزارع
      color: Color(0xFFFDAA5E),
      dictationIds: [20],
      songIds: [6], // نشيد النور - صفحة 73
    ),
    ReadingTopic(
      id: 21,
      title: 'حرف الشين',
      letter: 'ش',
      pageNumber: 75,
      illustration: '☀️', // شمس
      color: Color(0xFFFF6B6B),
      dictationIds: [21],
    ),
    ReadingTopic(
      id: 22,
      title: 'حرف الذال',
      letter: 'ذ',
      pageNumber: 80,
      illustration: '👨‍🏫', // أستاذ
      color: Color(0xFF00CEC9),
      dictationIds: [22],
    ),
    ReadingTopic(
      id: 23,
      title: 'حرف الكاف',
      letter: 'ك',
      pageNumber: 82,
      illustration: '📕', // كتاب
      color: Color(0xFFE84393),
      dictationIds: [23],
    ),
    ReadingTopic(
      id: 24,
      title: 'حرف الهاء',
      letter: 'هـ',
      pageNumber: 84,
      illustration: '🌙', // هلال
      color: Color(0xFF0984E3),
      dictationIds: [24],
    ),
    ReadingTopic(
      id: 25,
      title: 'التاء المربوطة',
      letter: 'ة',
      pageNumber: 87,
      illustration: '🏫', // مدرسة
      color: Color(0xFF00B894),
      dictationIds: [25],
    ),
    ReadingTopic(
      id: 26,
      title: 'حرف الصاد',
      letter: 'ص',
      pageNumber: 90,
      illustration: '✂️', // مقص
      color: Color(0xFFA66CFF),
      dictationIds: [26],
      songIds: [7], // طيارتي - صفحة 91
    ),
    ReadingTopic(
      id: 27,
      title: 'حرف الحاء والغين',
      letter: 'ح/غ',
      pageNumber: 92,
      illustration: '🦌', // غزال
      color: Color(0xFFFDAA5E),
      dictationIds: [27],
    ),
    ReadingTopic(
      id: 28,
      title: 'حرف الضاد',
      letter: 'ض',
      pageNumber: 98,
      illustration: '🏊', // سباحة
      color: Color(0xFF6C63FF),
      dictationIds: [28],
    ),
    ReadingTopic(
      id: 29,
      title: 'حرف الجيم',
      letter: 'ج',
      pageNumber: 100,
      illustration: '🧶', // نساج
      color: Color(0xFFFF6B6B),
      dictationIds: [29],
    ),
    ReadingTopic(
      id: 30,
      title: 'حرف الثاء',
      letter: 'ث',
      pageNumber: 101,
      illustration: '🐂', // محراث
      color: Color(0xFF00CEC9),
      dictationIds: [30],
    ),
    ReadingTopic(
      id: 31,
      title: 'حرف الخاء',
      letter: 'خ',
      pageNumber: 102,
      illustration: '🐔', // دجاج
      color: Color(0xFFE84393),
      dictationIds: [31],
      songIds: [8], // أنا فتى - صفحة 106
    ),
    ReadingTopic(
      id: 32,
      title: 'حرف الظاء',
      letter: 'ظ',
      pageNumber: 105,
      illustration: '🧹', // نظافة
      color: Color(0xFF0984E3),
      dictationIds: [32],
      songIds: [9], // شكراً لله - صفحة 110
    ),
    ReadingTopic(
      id: 33,
      title: 'مراجعة شاملة',
      letter: '⭐',
      pageNumber: 0,
      illustration: '🏆',
      color: Color(0xFFFF6B6B),
      dictationIds: [33],
    ),
  ];
}
