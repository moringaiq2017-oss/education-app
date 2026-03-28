import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/reading_topics_data.dart';
import '../../widgets/fun_widgets.dart';
import '../../widgets/apple_decoration.dart';
import '../../widgets/topic_illustration.dart';
import '../sections/dictation_screen.dart';
import '../sections/songs_screen.dart';
import '../sections/memorization_screen.dart';
import 'elearning_screen.dart';

/// شاشة تفاصيل الموضوع - تعرض الأقسام المتاحة
class TopicDetailScreen extends StatelessWidget {
  final ReadingTopic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: topic.color,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: topic.color,
        child: Column(
          children: [
            // === الهيدر ===
            _buildHeader(),
            // === الأقسام المتاحة ===
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: _buildSections(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      decoration: BoxDecoration(
        color: topic.color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // تفاحات ديكور
          const Positioned(
            top: 0,
            left: 0,
            child: AppleCluster(count: 2, appleSize: 20),
          ),
          const Positioned(
            bottom: 5,
            right: 0,
            child: AppleDecoration(size: 28, color: Color(0xFF27AE60)),
          ),
          // المحتوى
          Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                // أيقونة الموضوع أو صورة حقيقية
                if (topic.hasImage)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        topic.imagePath!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  TopicIllustration(
                    emoji: topic.illustration,
                    color: Colors.white.withValues(alpha: 0.25),
                    size: 80,
                  ),
                const SizedBox(height: 12),
                // الحرف
                if (topic.letter.length <= 2)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      topic.letter,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // رقم الصفحة
                if (topic.pageNumber > 0)
                  Text(
                    'صفحة ${topic.pageNumber} من الكتاب',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${topic.availableSectionsCount} أقسام متاحة',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final sections = <Widget>[];

    // === الإملاء ===
    if (topic.dictationIds.isNotEmpty) {
      final lessons = topic.dictationLessons;
      final wordCount = lessons.fold<int>(0, (sum, l) => sum + l.words.length);
      sections.add(_SectionCard(
        emoji: '✏️',
        title: 'الإملاء',
        subtitle: '${lessons.length} درس • $wordCount كلمة',
        color: AppTheme.dictationColor,
        onTap: () {
          if (lessons.length == 1) {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => DictationPracticeScreen(lesson: lessons.first),
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => DictationScreen(lessonIds: topic.dictationIds),
            ));
          }
        },
      ));
    }

    // === الأناشيد ===
    if (topic.songIds.isNotEmpty) {
      final songs = topic.songs;
      sections.add(_SectionCard(
        emoji: '🎵',
        title: 'الأناشيد',
        subtitle: '${songs.length} أنشودة',
        color: AppTheme.songsColor,
        onTap: () {
          if (songs.length == 1) {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => KaraokeScreen(song: songs.first),
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SongsScreen(songIds: topic.songIds),
            ));
          }
        },
      ));
    }

    // === المحفوظات ===
    if (topic.memorizationIds.isNotEmpty) {
      final memLessons = topic.memorizationLessons;
      sections.add(_SectionCard(
        emoji: '📝',
        title: 'المحفوظات',
        subtitle: '${memLessons.length} درس',
        color: const Color(0xFFE84393),
        onTap: () {
          if (memLessons.length == 1) {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => MemorizationLessonScreen(lesson: memLessons.first),
            ));
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => MemorizationScreen(lessonIds: topic.memorizationIds),
            ));
          }
        },
      ));
    }

    // === التعليم الإلكتروني (دائماً يظهر) ===
    sections.add(_SectionCard(
      emoji: '💻',
      title: 'التعليم الإلكتروني',
      subtitle: 'شاهد دروس فيديو ممتعة!',
      color: const Color(0xFF0984E3),
      isElearning: true,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const ElearningScreen(subject: 'القراءة'),
        ));
      },
    ));

    return sections;
  }
}

// ============================================
// بطاقة القسم
// ============================================
class _SectionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isElearning;

  const _SectionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isElearning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: BounceButton(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isElearning ? Border.all(color: color.withValues(alpha: 0.3), width: 2) : null,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                // أيقونة
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          if (isElearning) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                              child: Text('فيديو', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left_rounded, color: AppTheme.textLight, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
