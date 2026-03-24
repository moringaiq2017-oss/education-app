import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'sections/alarm_screen.dart';
import 'sections/dictation_screen.dart';
import 'sections/multiplication_screen.dart';
import 'sections/english_screen.dart';
import 'sections/science_screen.dart';
import 'sections/songs_screen.dart';
import 'sections/brain_games_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeTab(),
      const ProgressScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'الرئيسية'),
                _buildNavItem(1, Icons.bar_chart_rounded, 'التقدم'),
                _buildNavItem(2, Icons.settings_rounded, 'الإعدادات'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textLight,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================
// التاب الرئيسي - الأقسام السبعة
// ============================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static final List<_SectionItem> _sections = [
    _SectionItem(
      id: 'alarm',
      title: 'كعده الصبح',
      subtitle: 'منبه ذكي بصوت الأم',
      icon: Icons.alarm_rounded,
      color: AppTheme.alarmColor,
      gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
      screen: const AlarmScreen(),
    ),
    _SectionItem(
      id: 'dictation',
      title: 'الإملاء',
      subtitle: 'إملاء تفاعلي بالصوت',
      icon: Icons.edit_note_rounded,
      color: AppTheme.dictationColor,
      gradient: const [Color(0xFF6C63FF), Color(0xFF5A52E0)],
      screen: const DictationScreen(),
    ),
    _SectionItem(
      id: 'math',
      title: 'جدول الضرب',
      subtitle: 'حفظ بطرق ممتعة',
      icon: Icons.calculate_rounded,
      color: AppTheme.mathColor,
      gradient: const [Color(0xFF00B894), Color(0xFF00A381)],
      screen: const MultiplicationScreen(),
    ),
    _SectionItem(
      id: 'english',
      title: 'الإنكليزي',
      subtitle: 'نطق وكتابة الكلمات',
      icon: Icons.translate_rounded,
      color: AppTheme.englishColor,
      gradient: const [Color(0xFF0984E3), Color(0xFF0873C7)],
      screen: const EnglishScreen(),
    ),
    _SectionItem(
      id: 'science',
      title: 'العلوم',
      subtitle: 'شرح وفهم بالفيديو',
      icon: Icons.science_rounded,
      color: AppTheme.scienceColor,
      gradient: const [Color(0xFFFDAA5E), Color(0xFFFC9842)],
      screen: const ScienceScreen(),
    ),
    _SectionItem(
      id: 'songs',
      title: 'الأناشيد',
      subtitle: 'أغاني تعليمية ممتعة',
      icon: Icons.music_note_rounded,
      color: AppTheme.songsColor,
      gradient: const [Color(0xFFE84393), Color(0xFFD63384)],
      screen: const SongsScreen(),
    ),
    _SectionItem(
      id: 'games',
      title: 'ألعاب ذهنية',
      subtitle: 'تركيز وذاكرة',
      icon: Icons.extension_rounded,
      color: AppTheme.gamesColor,
      gradient: const [Color(0xFF00CEC9), Color(0xFF00B5B0)],
      screen: const BrainGamesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final child = authProvider.currentChild;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // ======== الهيدر ========
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    children: [
                      // الصف العلوي
                      Row(
                        children: [
                          // صورة البروفايل
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                child?.name.substring(0, 1).toUpperCase() ?? '👤',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً، ${child?.name ?? ""}! 👋',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'لنتعلم شيئاً جديداً اليوم',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // إشعارات
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.notifications_outlined),
                              color: Colors.white,
                              iconSize: 22,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // بطاقة الإحصائيات
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              icon: Icons.emoji_events_rounded,
                              value: '0',
                              label: 'إنجازات',
                            ),
                            _StatDivider(),
                            _StatItem(
                              icon: Icons.timer_rounded,
                              value: '0',
                              label: 'دقيقة',
                            ),
                            _StatDivider(),
                            _StatItem(
                              icon: Icons.check_circle_rounded,
                              value: '0',
                              label: 'دروس',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ======== عنوان الأقسام ========
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'الأقسام التعليمية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======== شبكة الأقسام ========
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _sections.length) {
                    return _SectionCard(section: _sections[index]);
                  }
                  return null;
                },
                childCount: _sections.length,
              ),
            ),
          ),

          // مسافة سفلية
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}

// ============================================
// بطاقة القسم
// ============================================
class _SectionCard extends StatelessWidget {
  final _SectionItem section;

  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => section.screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: section.color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // خلفية مزخرفة
            Positioned(
              top: -15,
              left: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: section.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: section.color.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      section.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  // العنوان
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    section.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // سهم
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: section.color,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// عنصر الإحصائية
// ============================================
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

// ============================================
// نموذج القسم
// ============================================
class _SectionItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final Widget screen;

  _SectionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.screen,
  });
}
