import 'package:flutter/material.dart';
import '../../data/reading_topics_data.dart';
import '../../widgets/fun_widgets.dart';
import '../sections/dictation_screen.dart';
import '../sections/songs_screen.dart';
import '../sections/memorization_screen.dart';
import 'elearning_screen.dart';

/// شاشة تفاصيل الموضوع - تصميم Gemini
class TopicDetailScreen extends StatelessWidget {
  final ReadingTopic topic;
  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      body: Stack(
        children: [
          const _SubtleDecor(),
          Column(
            children: [
              // الهيدر المنحني
              _buildHeader(context),
              const SizedBox(height: 20),
              // قائمة الأنشطة
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 5),
                      child: Text(
                        'الأنشطة (${topic.availableSectionsCount})',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A)),
                      ),
                    ),
                    ..._buildActivityCards(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topic.color.withValues(alpha: 0.6), topic.color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(color: topic.color.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // حرف كبير شفاف بالخلفية
            if (topic.letter.length <= 2)
              Positioned(
                right: -30,
                top: -10,
                child: Text(
                  topic.letter,
                  style: TextStyle(
                    fontSize: 180,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.12),
                    height: 1.0,
                  ),
                ),
              ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // زر الرجوع + رقم الصفحة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BounceButton(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        ),
                      ),
                      if (topic.pageNumber > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'صفحة ${topic.pageNumber}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // صورة الموضوع
                  _buildIconContainer(),
                  const SizedBox(height: 15),
                  // عنوان الموضوع
                  Text(
                    topic.title,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: topic.hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(topic.imagePath!, fit: BoxFit.cover),
            )
          : Center(
              child: Text(topic.illustration, style: const TextStyle(fontSize: 50)),
            ),
    );
  }

  List<Widget> _buildActivityCards(BuildContext context) {
    final cards = <Widget>[];

    // الإملاء
    if (topic.dictationIds.isNotEmpty) {
      final lessons = topic.dictationLessons;
      final wordCount = lessons.fold<int>(0, (sum, l) => sum + l.words.length);
      cards.add(_ActivityCard(
        title: 'الإملاء',
        subtitle: '$wordCount كلمات للتمرن',
        emoji: '✏️',
        colors: [Colors.purple.shade300, Colors.purple.shade400],
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

    // الأناشيد
    if (topic.songIds.isNotEmpty) {
      final songs = topic.songs;
      cards.add(_ActivityCard(
        title: 'الأناشيد',
        subtitle: '${songs.length} أنشودة ممتعة',
        emoji: '🎵',
        colors: [Colors.orange.shade300, Colors.orange.shade400],
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

    // المحفوظات
    if (topic.memorizationIds.isNotEmpty) {
      final memLessons = topic.memorizationLessons;
      cards.add(_ActivityCard(
        title: 'المحفوظات',
        subtitle: 'استمع واحفظ القصيدة',
        emoji: '📖',
        colors: [Colors.pink.shade300, Colors.pink.shade400],
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

    // التعليم الإلكتروني (دائماً)
    cards.add(_ActivityCard(
      title: 'التعليم الإلكتروني',
      subtitle: 'شاهد فيديو ممتع',
      emoji: '▶️',
      colors: [Colors.teal.shade300, Colors.teal.shade400],
      hasBadge: true,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const ElearningScreen(subject: 'القراءة'),
        ));
      },
    ));

    return cards;
  }
}

// ============================================
// بطاقة النشاط
// ============================================
class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> colors;
  final VoidCallback onTap;
  final bool hasBadge;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.colors,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: BounceButton(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.centerRight, end: Alignment.centerLeft),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: colors[1].withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // أيقونة
                Container(
                  height: 56, width: 56,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 16),
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                          if (hasBadge) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                              child: const Text('فيديو', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9))),
                    ],
                  ),
                ),
                // سهم
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// زخارف خلفية
// ============================================
class _SubtleDecor extends StatelessWidget {
  const _SubtleDecor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 400, left: 20, child: Text('✨', style: TextStyle(fontSize: 22, color: Colors.black.withValues(alpha: 0.06)))),
        Positioned(top: 550, right: 30, child: Text('⭐', style: TextStyle(fontSize: 18, color: Colors.black.withValues(alpha: 0.05)))),
        Positioned(bottom: 150, left: 40, child: Text('☁️', style: TextStyle(fontSize: 26, color: Colors.black.withValues(alpha: 0.05)))),
      ],
    );
  }
}
