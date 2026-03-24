import 'package:flutter/material.dart';
import '../../config/theme.dart';

class DictationScreen extends StatelessWidget {
  const DictationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      {'title': 'الدرس الأول', 'words': 8, 'done': true},
      {'title': 'الدرس الثاني', 'words': 10, 'done': true},
      {'title': 'الدرس الثالث', 'words': 12, 'done': false},
      {'title': 'الدرس الرابع', 'words': 10, 'done': false},
      {'title': 'الدرس الخامس', 'words': 14, 'done': false},
      {'title': 'الدرس السادس', 'words': 10, 'done': false},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الإملاء'),
        backgroundColor: AppTheme.dictationColor,
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
            decoration: const BoxDecoration(
              color: AppTheme.dictationColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.edit_note_rounded, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'اختاري الدرس',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'التطبيق يردد الكلمات والطالب يكتب',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // قائمة الدروس
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final isDone = lesson['done'] as bool;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.successColor.withValues(alpha: 0.1)
                            : AppTheme.dictationColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : Icons.play_circle_rounded,
                        color: isDone
                            ? AppTheme.successColor
                            : AppTheme.dictationColor,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      lesson['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${lesson['words']} كلمات',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_left_rounded,
                      color: AppTheme.textLight,
                    ),
                    onTap: () {
                      // TODO: فتح شاشة الإملاء التفاعلي
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
