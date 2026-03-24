import 'package:flutter/material.dart';
import '../../config/theme.dart';

class BrainGamesScreen extends StatelessWidget {
  const BrainGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'title': 'لعبة الذاكرة',
        'subtitle': 'اكشف الأزواج المتشابهة',
        'icon': Icons.grid_view_rounded,
        'color': const Color(0xFF00CEC9),
      },
      {
        'title': 'الأنماط',
        'subtitle': 'أكمل النمط الصحيح',
        'icon': Icons.pattern_rounded,
        'color': const Color(0xFF6C63FF),
      },
      {
        'title': 'الألغاز',
        'subtitle': 'حل الألغاز المسلية',
        'icon': Icons.extension_rounded,
        'color': const Color(0xFFFDAA5E),
      },
      {
        'title': 'التركيز',
        'subtitle': 'ألعاب تقوي التركيز',
        'icon': Icons.center_focus_strong_rounded,
        'color': const Color(0xFFE84393),
      },
      {
        'title': 'الترتيب',
        'subtitle': 'رتّب الأشكال والأرقام',
        'icon': Icons.sort_rounded,
        'color': const Color(0xFF00B894),
      },
      {
        'title': 'السرعة',
        'subtitle': 'اختبر سرعة استجابتك',
        'icon': Icons.flash_on_rounded,
        'color': const Color(0xFFFF6B6B),
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('ألعاب ذهنية'),
        backgroundColor: AppTheme.gamesColor,
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
              color: AppTheme.gamesColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.extension_rounded, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'نمّي ذكاءك!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ألعاب تزيد التركيز والذاكرة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // شبكة الألعاب
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                final color = game['color'] as Color;
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withValues(alpha: 0.75)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              game['icon'] as IconData,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            game['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            game['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
