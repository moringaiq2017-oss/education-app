import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'subjects/reading_screen.dart';
import 'subjects/islamic_screen.dart';
import 'subjects/english_subject_screen.dart';
import 'subjects/math_screen.dart';
import 'subjects/science_subject_screen.dart';
import 'subjects/ethics_screen.dart';
import 'sections/brain_games_screen.dart';
import 'sections/alarm_screen.dart';
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
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : AppTheme.textLight, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================
// التاب الرئيسي - المواد الدراسية
// ============================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static final List<_SubjectItem> _subjects = [
    _SubjectItem(
      id: 'reading',
      title: 'القراءة',
      subtitle: 'إملاء • أناشيد • حفظ',
      icon: Icons.menu_book_rounded,
      color: AppTheme.dictationColor,
      gradient: const [Color(0xFF6C63FF), Color(0xFF5A52E0)],
      screen: const ReadingScreen(),
    ),
    _SubjectItem(
      id: 'islamic',
      title: 'الإسلامية',
      subtitle: 'تعليم مبسّط وممتع',
      icon: Icons.auto_stories_rounded,
      color: const Color(0xFF00B894),
      gradient: const [Color(0xFF00B894), Color(0xFF00A381)],
      screen: const IslamicScreen(),
    ),
    _SubjectItem(
      id: 'english',
      title: 'الإنكليزي',
      subtitle: 'إملاء • أصوات • نطق',
      icon: Icons.translate_rounded,
      color: AppTheme.englishColor,
      gradient: const [Color(0xFF0984E3), Color(0xFF0873C7)],
      screen: const EnglishSubjectScreen(),
    ),
    _SubjectItem(
      id: 'math',
      title: 'الرياضيات',
      subtitle: 'جمع • طرح • أرقام',
      icon: Icons.calculate_rounded,
      color: AppTheme.mathColor,
      gradient: const [Color(0xFFFDAA5E), Color(0xFFFC9842)],
      screen: const MathScreen(),
    ),
    _SubjectItem(
      id: 'science',
      title: 'العلوم',
      subtitle: 'شرح وفهم بالصور',
      icon: Icons.science_rounded,
      color: AppTheme.scienceColor,
      gradient: const [Color(0xFFE84393), Color(0xFFD63384)],
      screen: const ScienceSubjectScreen(),
    ),
    _SubjectItem(
      id: 'ethics',
      title: 'الأخلاقية',
      subtitle: 'قيم وسلوك',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFFF6B6B),
      gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
      screen: const EthicsScreen(),
    ),
    _SubjectItem(
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
                      Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                            ),
                            child: Center(
                              child: Text(
                                child?.name.substring(0, 1).toUpperCase() ?? '👤',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'الصف الأول الابتدائي',
                                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
                                ),
                              ],
                            ),
                          ),
                          // المنبه
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlarmScreen()));
                            },
                            child: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.alarm_rounded, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      // إحصائيات
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(icon: Icons.emoji_events_rounded, value: '0', label: 'إنجازات'),
                            _StatDivider(),
                            _StatItem(icon: Icons.timer_rounded, value: '0', label: 'دقيقة'),
                            _StatDivider(),
                            _StatItem(icon: Icons.check_circle_rounded, value: '0', label: 'دروس'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ======== عنوان المواد ========
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    width: 4, height: 22,
                    decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'المواد الدراسية',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ),

          // ======== شبكة المواد ========
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
                (context, index) => _SubjectCard(subject: _subjects[index]),
                childCount: _subjects.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ============================================
// بطاقة المادة الدراسية
// ============================================
class _SubjectCard extends StatelessWidget {
  final _SubjectItem subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => subject.screen)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: subject.color.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6)),
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15, left: -15,
              child: Container(width: 70, height: 70, decoration: BoxDecoration(color: subject.color.withValues(alpha: 0.06), shape: BoxShape.circle)),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: subject.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: subject.color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Icon(subject.icon, color: Colors.white, size: 28),
                  ),
                  const Spacer(),
                  Text(subject.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subject.subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            Positioned(
              bottom: 16, left: 16,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(color: subject.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_forward_rounded, color: subject.color, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2));
}

class _SubjectItem {
  final String id, title, subtitle;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final Widget screen;
  _SubjectItem({required this.id, required this.title, required this.subtitle, required this.icon, required this.color, required this.gradient, required this.screen});
}
