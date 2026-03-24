import 'package:flutter/material.dart';
import '../../config/theme.dart';

class EnglishScreen extends StatelessWidget {
  const EnglishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الإنكليزي'),
        backgroundColor: AppTheme.englishColor,
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
              color: AppTheme.englishColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.translate_rounded, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'English',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'نطق صحيح وكتابة الكلمات',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // الأوضاع
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildModeCard(
                    icon: Icons.volume_up_rounded,
                    title: 'استماع ونطق',
                    subtitle: 'اسمع الكلمة وكررها بصوتك',
                    color: const Color(0xFF0984E3),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _buildModeCard(
                    icon: Icons.keyboard_rounded,
                    title: 'كتابة الكلمات',
                    subtitle: 'اسمع الكلمة واكتبها صح',
                    color: const Color(0xFF6C5CE7),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _buildModeCard(
                    icon: Icons.abc_rounded,
                    title: 'الحروف الأبجدية',
                    subtitle: 'تعلم الحروف A-Z بالنطق',
                    color: const Color(0xFF00B894),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _buildModeCard(
                    icon: Icons.quiz_rounded,
                    title: 'امتحان',
                    subtitle: 'اختبر نفسك بالكلمات',
                    color: const Color(0xFFFDAA5E),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}
