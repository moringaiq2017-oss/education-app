import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/fun_widgets.dart';
import '../sections/dictation_screen.dart';
import '../sections/memorization_screen.dart';
import '../sections/songs_screen.dart';
import 'elearning_screen.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SubjectLayout(
      title: 'القراءة',
      color: AppTheme.dictationColor,
      emoji: '📖',
      subtitle: 'هيا نقرأ سوا يا بطل!',
      sections: [
        _SectionTile(
          emoji: '✏️',
          title: 'الإملاء',
          subtitle: 'اسمع واكتب يا شاطر!',
          color: AppTheme.dictationColor,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DictationScreen())),
        ),
        _SectionTile(
          emoji: '🎵',
          title: 'الأناشيد',
          subtitle: 'غنّي وتعلّم معنا!',
          color: AppTheme.songsColor,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SongsScreen())),
        ),
        _SectionTile(
          emoji: '📝',
          title: 'المحفوظات',
          subtitle: 'احفظ وردّد يا نجم!',
          color: const Color(0xFF00B894),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemorizationScreen())),
        ),
        _SectionTile(
          emoji: '🔤',
          title: 'الحروف',
          subtitle: 'تعال نتعلم الحروف!',
          color: const Color(0xFFFDAA5E),
          onTap: () {},
        ),
        _SectionTile(
          emoji: '💻',
          title: 'التعليم الإلكتروني',
          subtitle: 'شاهد دروس فيديو ممتعة!',
          color: const Color(0xFF0984E3),
          isElearning: true,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElearningScreen(subject: 'القراءة'))),
        ),
      ],
    );
  }
}

// ============================================
// Layout مشترك لكل المواد الدراسية - ستايل أطفال
// ============================================
class _SubjectLayout extends StatelessWidget {
  final String title;
  final Color color;
  final String emoji;
  final String subtitle;
  final List<_SectionTile> sections;

  const _SubjectLayout({
    required this.title,
    required this.color,
    required this.emoji,
    required this.subtitle,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: color,
        child: Column(
          children: [
            // هيدر
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  AnimatedEmoji(emoji: emoji, size: 52),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.95)),
                  ),
                ],
              ),
            ),
            // الأقسام
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: sections.length,
                itemBuilder: (context, index) => sections[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isElearning;

  const _SectionTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isElearning = false,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
              // أيقونة إيموجي
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
              // العنوان والوصف
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
              Icon(Icons.chevron_left_rounded, color: AppTheme.textLight, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
