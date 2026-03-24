import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': 'جسم الإنسان', 'icon': Icons.accessibility_new_rounded, 'lessons': 5},
      {'title': 'النباتات', 'icon': Icons.eco_rounded, 'lessons': 4},
      {'title': 'الحيوانات', 'icon': Icons.pets_rounded, 'lessons': 6},
      {'title': 'الماء والهواء', 'icon': Icons.water_drop_rounded, 'lessons': 3},
      {'title': 'الحواس الخمس', 'icon': Icons.visibility_rounded, 'lessons': 5},
      {'title': 'المواد وخصائصها', 'icon': Icons.science_rounded, 'lessons': 4},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('العلوم'),
        backgroundColor: AppTheme.scienceColor,
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
              color: AppTheme.scienceColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.science_rounded, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'العلوم والحياة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'شرح وفهم بالفيديو والصور - مو بس حفظ!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // المواضيع
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
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
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.scienceColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        topic['icon'] as IconData,
                        color: AppTheme.scienceColor,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      topic['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${topic['lessons']} دروس بالفيديو',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.scienceColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.scienceColor,
                        size: 20,
                      ),
                    ),
                    onTap: () {},
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
