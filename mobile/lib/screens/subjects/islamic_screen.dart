import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../config/theme.dart';
import '../../data/islamic_data.dart';
import '../../services/tts_service.dart';
import '../../widgets/fun_widgets.dart';
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
        title: const Text(
          '🕌 التربية الإسلامية 🌙',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: _primaryColor,
        child: Column(
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
                  const AnimatedEmoji(emoji: '📖', size: 56),
                  const SizedBox(height: 8),
                  const Text(
                    'يلّا نتعلم ديننا! 🌟',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${IslamicData.lessons.length} درس ممتع ⭐ الصف الأول',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // فلاتر
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('الكل', IslamicData.lessons.length, '📚'),
                        _buildFilterChip('سور', IslamicData.quranLessons.length, '📖'),
                        _buildFilterChip('أحاديث', IslamicData.hadithLessons.length, '🌙'),
                        _buildFilterChip('آداب', IslamicData.mannersLessons.length, '🤝'),
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
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, String emoji) {
    final isSelected = _selectedFilter == label;
    return BounceButton(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(
              color: isSelected ? _primaryColor : Colors.white,
              fontWeight: FontWeight.w700, fontSize: 15,
            )),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? _primaryColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$count', style: TextStyle(
                color: isSelected ? _primaryColor : Colors.white,
                fontSize: 13, fontWeight: FontWeight.bold,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElearningCard(BuildContext context) {
    return BounceButton(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => const ElearningScreen(subject: 'الإسلامية'),
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)]),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
              child: const Center(child: Text('🎬', style: TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('التعليم الإلكتروني 🌟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  Text('دروس فيديو ممتعة!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Text('◀', style: TextStyle(color: Colors.white70, fontSize: 22)),
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

  String get _typeEmoji {
    switch (lesson.type) {
      case LessonType.quran: return '📖';
      case LessonType.memorization: return '🌟';
      case LessonType.hadith: return '🌙';
      case LessonType.creed: return '⭐';
      case LessonType.seerah: return '🕌';
      case LessonType.manners: return '🤝';
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
    return BounceButton(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _LessonDetailScreen(lesson: lesson))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: _typeColor.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_typeColor, _typeColor.withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(child: Text(lesson.icon, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  if (lesson.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(lesson.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  ],
                  const SizedBox(height: 5),
                  Text('الدرس ${lesson.id} $_typeEmoji صفحة ${lesson.pageNumber}',
                      style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: _typeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
              child: Text('$_typeEmoji $_typeLabel', style: TextStyle(color: _typeColor, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 4),
            const Text('◀', style: TextStyle(color: Colors.grey, fontSize: 18)),
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

  String get _lessonEmoji {
    switch (lesson.type) {
      case LessonType.quran: return '📖';
      case LessonType.memorization: return '🌟';
      case LessonType.hadith: return '🌙';
      case LessonType.creed: return '⭐';
      case LessonType.seerah: return '🕌';
      case LessonType.manners: return '🤝';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          '$_lessonEmoji ${lesson.title}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: _primaryColor,
        child: Column(
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
                  AnimatedEmoji(emoji: lesson.icon, size: 60),
                  const SizedBox(height: 8),
                  Text('الدرس ${lesson.id}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 15, fontWeight: FontWeight.w500)),
                  if (lesson.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(lesson.subtitle, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    'يلّا نحفظ! 🎉',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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

  String get _sectionEmoji {
    switch (section.type) {
      case 'quran': return '📖';
      case 'memorize': return '🌟';
      case 'explanation': return '💡';
      case 'discussion': return '🤔';
      case 'story': return '📚';
      default: return '🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
            ),
            child: Row(
              children: [
                Text(_sectionEmoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(child: Text(section.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color))),
                if (section.type == 'quran' || section.type == 'memorize')
                  BounceButton(
                    onTap: () {
                      if (_isSpeaking) {
                        _tts.stop();
                      } else {
                        _tts.speak(section.content);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isSpeaking ? Colors.red.withValues(alpha: 0.15) : color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _isSpeaking ? '⏹️' : '🔊',
                        style: const TextStyle(fontSize: 20),
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
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF8E1), Color(0xFFFFF3C4)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.3)),
        ),
        child: Text(section.content, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, height: 2.0, fontWeight: FontWeight.w600, color: Color(0xFF2C1810))),
      );
    }
    if (section.type == 'memorize') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(section.content, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, height: 2.0, fontWeight: FontWeight.w700, color: color)),
      );
    }
    return Text(section.content, style: const TextStyle(fontSize: 18, height: 1.8, color: AppTheme.textPrimary));
  }

  Widget _buildPoint(int index, String text) {
    final isQ = section.type == 'discussion';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34, margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isQ ? Colors.orange.withValues(alpha: 0.12) : color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isQ
                  ? const Text('🤔', style: TextStyle(fontSize: 18))
                  : Text('${index + 1}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 17, height: 1.7, color: AppTheme.textPrimary))),
        ],
      ),
    );
  }
}
