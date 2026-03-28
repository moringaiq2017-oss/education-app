import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/reading_topics_data.dart';
import '../../widgets/fun_widgets.dart';
import '../../widgets/apple_decoration.dart';
import '../../widgets/topic_illustration.dart';
import '../sections/dictation_screen.dart';
import '../sections/songs_screen.dart';
import '../sections/memorization_screen.dart';
import 'elearning_screen.dart';

/// شاشة تفاصيل الموضوع - تصميم طفولي ملون
class TopicDetailScreen extends StatelessWidget {
  final ReadingTopic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF9F2),
        body: Stack(
          children: [
            // نجوم وزخارف خلفية
            _buildBackgroundDecorations(),

            Column(
              children: [
                // الهيدر المنحني
                _buildHeader(context),

                // بطاقات الأقسام
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    physics: const BouncingScrollPhysics(),
                    children: _buildSections(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // ألوان التدرج حسب لون الموضوع
    final baseColor = topic.color;
    final secondColor = Color.lerp(baseColor, const Color(0xFFFF8B8B), 0.5)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, secondColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(45),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // شريط العنوان: زر الرجوع + العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // العنوان بالوسط (مع spacer)
                  const SizedBox(width: 40),
                  Text(
                    topic.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // زر الرجوع
                  BounceButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // الصورة التوضيحية + الحرف
            Stack(
              alignment: Alignment.center,
              children: [
                // تفاحات ديكور
                Positioned(
                  top: 0,
                  right: 20,
                  child: AppleDecoration(size: 28, color: Colors.red.withValues(alpha: 0.6)),
                ),
                const Positioned(
                  top: 10,
                  left: 30,
                  child: AppleDecoration(size: 22, color: Color(0xFF27AE60)),
                ),
                // الصورة الرئيسية
                if (topic.hasImage)
                  Image.asset(
                    topic.imagePath!,
                    height: 150,
                    fit: BoxFit.contain,
                  )
                else
                  TopicIllustration(
                    emoji: topic.illustration,
                    color: Colors.white.withValues(alpha: 0.25),
                    size: 120,
                  ),
                // الحرف الكبير
                if (topic.letter.length <= 2)
                  Positioned(
                    right: 30,
                    bottom: 0,
                    child: Text(
                      topic.letter,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withValues(alpha: 0.3),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // رقم الصفحة
            if (topic.pageNumber > 0)
              Text(
                'صفحة ${topic.pageNumber} من كتاب القراءة',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              '${topic.availableSectionsCount} أقسام متاحة',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final sections = <Widget>[];

    // === الإملاء ===
    if (topic.dictationIds.isNotEmpty) {
      final lessons = topic.dictationLessons;
      final wordCount = lessons.fold<int>(0, (sum, l) => sum + l.words.length);
      sections.add(_ActivityCard(
        title: 'الإملاء',
        subtitle: '$wordCount كلمات للتمرن',
        emoji: '✏️',
        gradientColors: const [Color(0xFF9867C5), Color(0xFFB185DB)],
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
      sections.add(const SizedBox(height: 14));
    }

    // === الأناشيد ===
    if (topic.songIds.isNotEmpty) {
      final songs = topic.songs;
      sections.add(_ActivityCard(
        title: 'الأناشيد',
        subtitle: '${songs.length} أنشودة ممتعة',
        emoji: '🎵',
        gradientColors: const [Color(0xFFF6A623), Color(0xFFFFBF5F)],
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
      sections.add(const SizedBox(height: 14));
    }

    // === المحفوظات ===
    if (topic.memorizationIds.isNotEmpty) {
      final memLessons = topic.memorizationLessons;
      sections.add(_ActivityCard(
        title: 'المحفوظات',
        subtitle: 'استمع واحفظ القصيدة',
        emoji: '📖',
        gradientColors: const [Color(0xFFFF7E95), Color(0xFFFFA3B5)],
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
      sections.add(const SizedBox(height: 14));
    }

    // === التعليم الإلكتروني (دائماً) ===
    sections.add(_ActivityCard(
      title: 'التعليم الإلكتروني',
      subtitle: 'شاهد فيديو الممتع',
      emoji: '▶️',
      gradientColors: const [Color(0xFF45B3A9), Color(0xFF66C7BE)],
      badgeText: 'فيديو',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const ElearningScreen(subject: 'القراءة'),
        ));
      },
    ));

    return sections;
  }

  Widget _buildBackgroundDecorations() {
    final random = Random(topic.id);
    final decorations = <Widget>[];
    final icons = [Icons.star_rounded, Icons.favorite_rounded, Icons.auto_awesome];
    final colors = [Colors.amber, Colors.pinkAccent, Colors.purpleAccent, Colors.tealAccent, Colors.orangeAccent];

    for (int i = 0; i < 8; i++) {
      decorations.add(Positioned(
        top: 380 + random.nextDouble() * 450,
        left: random.nextDouble() * 350,
        child: Icon(
          icons[random.nextInt(icons.length)],
          color: colors[random.nextInt(colors.length)].withValues(alpha: 0.15),
          size: 12 + random.nextDouble() * 16,
        ),
      ));
    }
    return Stack(children: decorations);
  }
}

// ============================================
// بطاقة النشاط - ملونة وطفولية
// ============================================
class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final String? badgeText;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
    required this.onTap,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // بادج فيديو
            if (badgeText != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // أيقونة
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // سهم
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
