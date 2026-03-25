import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../config/theme.dart';
import '../../data/islamic_data.dart';
import '../../services/tts_service.dart';
import 'elearning_screen.dart';

class IslamicScreen extends StatefulWidget {
  const IslamicScreen({super.key});

  @override
  State<IslamicScreen> createState() => _IslamicScreenState();
}

class _IslamicScreenState extends State<IslamicScreen> {
  static const Color _primaryColor = Color(0xFF1B8A6B);
  String _selectedFilter = 'الكل';

  List<IslamicLesson> get _filteredLessons {
    switch (_selectedFilter) {
      case 'سور': return IslamicData.quranLessons;
      case 'أحاديث': return IslamicData.hadithLessons;
      case 'آداب': return IslamicData.mannersLessons;
      default: return IslamicData.lessons;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('التربية الإسلامية'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // هيدر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: const BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text('📖', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                const Text('القرآن الكريم والتربية الإسلامية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${IslamicData.lessons.length} درساً • الصف الأول الابتدائي',
                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 16),
                // فلاتر
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', IslamicData.lessons.length),
                      _buildFilterChip('سور', IslamicData.quranLessons.length),
                      _buildFilterChip('أحاديث', IslamicData.hadithLessons.length),
                      _buildFilterChip('آداب', IslamicData.mannersLessons.length),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // قائمة الدروس
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredLessons.length + 1, // +1 للتعليم الإلكتروني
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildElearningCard(context);
                }
                final lesson = _filteredLessons[index - 1];
                return _LessonCard(lesson: lesson);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(
              color: isSelected ? _primaryColor : Colors.white,
              fontWeight: FontWeight.w600, fontSize: 13,
            )),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? _primaryColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count', style: TextStyle(
                color: isSelected ? _primaryColor : Colors.white,
                fontSize: 11, fontWeight: FontWeight.bold,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElearningCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => const ElearningScreen(subject: 'الإسلامية'),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.play_circle_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('التعليم الإلكتروني', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 2),
                  Text('دروس فيديو تفاعلية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: Colors.white70, size: 24),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// كارد الدرس
// ==========================================

class _LessonCard extends StatelessWidget {
  final IslamicLesson lesson;
  const _LessonCard({required this.lesson});

  Color get _typeColor {
    switch (lesson.type) {
      case LessonType.quran: return const Color(0xFF1B8A6B);
      case LessonType.memorization: return const Color(0xFF6C63FF);
      case LessonType.hadith: return const Color(0xFFE67E22);
      case LessonType.creed: return const Color(0xFF3498DB);
      case LessonType.seerah: return const Color(0xFF9B59B6);
      case LessonType.manners: return const Color(0xFFE91E63);
    }
  }

  String get _typeLabel {
    switch (lesson.type) {
      case LessonType.quran: return 'سورة';
      case LessonType.memorization: return 'حفظ';
      case LessonType.hadith: return 'حديث';
      case LessonType.creed: return 'عقيدة';
      case LessonType.seerah: return 'سيرة';
      case LessonType.manners: return 'آداب';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _LessonDetailScreen(lesson: lesson))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: _typeColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_typeColor, _typeColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(lesson.icon, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  if (lesson.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(lesson.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                  const SizedBox(height: 4),
                  Text('الدرس ${lesson.id} • صفحة ${lesson.pageNumber}',
                      style: const TextStyle(color: AppTheme.textLight, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(_typeLabel, style: TextStyle(color: _typeColor, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_left_rounded, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة تفاصيل الدرس
// ==========================================

class _LessonDetailScreen extends StatelessWidget {
  final IslamicLesson lesson;
  const _LessonDetailScreen({required this.lesson});

  Color get _primaryColor {
    switch (lesson.type) {
      case LessonType.quran: return const Color(0xFF1B8A6B);
      case LessonType.memorization: return const Color(0xFF6C63FF);
      case LessonType.hadith: return const Color(0xFFE67E22);
      case LessonType.creed: return const Color(0xFF3498DB);
      case LessonType.seerah: return const Color(0xFF9B59B6);
      case LessonType.manners: return const Color(0xFFE91E63);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Text(lesson.icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text('الدرس ${lesson.id}', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                if (lesson.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(lesson.subtitle, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lesson.sections.length,
              itemBuilder: (context, index) => _SectionCard(section: lesson.sections[index], color: _primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// كارد القسم
// ==========================================

class _SectionCard extends StatefulWidget {
  final LessonSection section;
  final Color color;
  const _SectionCard({required this.section, required this.color});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  final TtsService _tts = TtsService();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _tts.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isSpeaking = state == PlayerState.playing);
      }
    });
  }

  LessonSection get section => widget.section;
  Color get color => widget.color;

  IconData get _icon {
    switch (section.type) {
      case 'quran': return Icons.menu_book_rounded;
      case 'memorize': return Icons.bookmark_rounded;
      case 'explanation': return Icons.lightbulb_rounded;
      case 'discussion': return Icons.question_answer_rounded;
      case 'story': return Icons.auto_stories_rounded;
      default: return Icons.article_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(_icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(section.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color))),
                if (section.type == 'quran' || section.type == 'memorize')
                  GestureDetector(
                    onTap: () {
                      if (_isSpeaking) {
                        _tts.stop();
                      } else {
                        _tts.speak(section.content);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isSpeaking ? Colors.red.withValues(alpha: 0.15) : color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                        color: _isSpeaking ? Colors.red : color,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.content.isNotEmpty) _buildContent(),
                if (section.points != null && section.points!.isNotEmpty) ...[
                  if (section.content.isNotEmpty) const SizedBox(height: 12),
                  ...section.points!.asMap().entries.map((e) => _buildPoint(e.key, e.value)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (section.type == 'quran') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF8E1), Color(0xFFFFF3C4)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
        ),
        child: Text(section.content, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, height: 2.0, fontWeight: FontWeight.w600, color: Color(0xFF2C1810))),
      );
    }
    if (section.type == 'memorize') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(section.content, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 2.0, fontWeight: FontWeight.w700, color: color)),
      );
    }
    return Text(section.content, style: const TextStyle(fontSize: 16, height: 1.8, color: AppTheme.textPrimary));
  }

  Widget _buildPoint(int index, String text) {
    final isQ = section.type == 'discussion';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28, margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isQ ? Colors.orange.withValues(alpha: 0.1) : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isQ
                  ? const Icon(Icons.help_outline_rounded, color: Colors.orange, size: 16)
                  : Text('${index + 1}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.6, color: AppTheme.textPrimary))),
        ],
      ),
    );
  }
}
