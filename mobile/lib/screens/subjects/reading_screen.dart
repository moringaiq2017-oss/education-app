import 'package:flutter/material.dart';
import '../../config/theme.dart';
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
      icon: Icons.menu_book_rounded,
      subtitle: 'كتاب قراءتي - الصف الأول',
      sections: [
        _SectionTile(
          icon: Icons.edit_note_rounded,
          title: 'الإملاء',
          subtitle: 'التطبيق يردد والطالب يكتب',
          color: AppTheme.dictationColor,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DictationScreen())),
        ),
        _SectionTile(
          icon: Icons.music_note_rounded,
          title: 'الأناشيد',
          subtitle: 'أناشيد القراءة بصوت ممتع',
          color: AppTheme.songsColor,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SongsScreen())),
        ),
        _SectionTile(
          icon: Icons.bookmark_rounded,
          title: 'المحفوظات',
          subtitle: 'حفظ النصوص بـ 3 مراحل تفاعلية',
          color: const Color(0xFF00B894),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemorizationScreen())),
        ),
        _SectionTile(
          icon: Icons.abc_rounded,
          title: 'الحروف',
          subtitle: 'تعلم كتابة الحروف',
          color: const Color(0xFFFDAA5E),
          onTap: () {},
        ),
        _SectionTile(
          icon: Icons.play_circle_rounded,
          title: 'التعليم الإلكتروني',
          subtitle: 'دروس فيديو',
          color: const Color(0xFF0984E3),
          isElearning: true,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElearningScreen(subject: 'القراءة'))),
        ),
      ],
    );
  }
}

// ============================================
// Layout مشترك لكل المواد الدراسية
// ============================================
class _SubjectLayout extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final String subtitle;
  final List<_SectionTile> sections;

  const _SubjectLayout({
    required this.title,
    required this.color,
    required this.icon,
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
      body: Column(
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
                Icon(icon, size: 52, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85)),
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
    );
  }
}

class _SectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isElearning;

  const _SectionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isElearning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isElearning ? Border.all(color: color.withValues(alpha: 0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (isElearning) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('فيديو', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        trailing: Icon(Icons.chevron_left_rounded, color: AppTheme.textLight),
        onTap: onTap,
      ),
    );
  }
}
