import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import '../widgets/fun_widgets.dart';
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
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, '🏠', 'الرئيسية'),
                _buildNavItem(1, '📊', 'التقدم'),
                _buildNavItem(2, '⚙️', 'الإعدادات'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String emoji, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
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
// التاب الرئيسي - ستايل أطفال
// ============================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static final List<_SubjectItem> _subjects = [
    _SubjectItem(
      emoji: '📚', title: 'القراءة', subtitle: 'إملاء • أناشيد • حفظ',
      color: const Color(0xFF6C63FF), bgColor: const Color(0xFFEDE7FF),
      screen: const ReadingScreen(),
    ),
    _SubjectItem(
      emoji: '🕌', title: 'الإسلامية', subtitle: 'قرآن • أحاديث • آداب',
      color: const Color(0xFF00B894), bgColor: const Color(0xFFD4EFDF),
      screen: const IslamicScreen(),
    ),
    _SubjectItem(
      emoji: '🔤', title: 'الإنكليزي', subtitle: 'نطق • كتابة • أصوات',
      color: const Color(0xFF0984E3), bgColor: const Color(0xFFDCEEFC),
      screen: const EnglishSubjectScreen(),
    ),
    _SubjectItem(
      emoji: '🔢', title: 'الرياضيات', subtitle: 'جمع • طرح • أرقام',
      color: const Color(0xFFFDAA5E), bgColor: const Color(0xFFFFF3E0),
      screen: const MathScreen(),
    ),
    _SubjectItem(
      emoji: '🔬', title: 'العلوم', subtitle: 'شرح وفهم ممتع',
      color: const Color(0xFFE84393), bgColor: const Color(0xFFFCE4EC),
      screen: const ScienceSubjectScreen(),
    ),
    _SubjectItem(
      emoji: '💝', title: 'الأخلاقية', subtitle: 'قيم وسلوك حلو',
      color: const Color(0xFFFF6B6B), bgColor: const Color(0xFFFFEBEE),
      screen: const EthicsScreen(),
    ),
    _SubjectItem(
      emoji: '🧩', title: 'ألعاب ذهنية', subtitle: 'تركيز وذاكرة',
      color: const Color(0xFF00CEC9), bgColor: const Color(0xFFE0F7FA),
      screen: const BrainGamesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final child = authProvider.currentChild;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // خلفية بنفسجية فاتحة
      body: AnimatedBubbleBackground(
        color: const Color(0xFF6C63FF),
        child: CustomScrollView(
          slivers: [
            // ======== الهيدر - ستايل أطفال ========
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF6C63FF), Color(0xFF5A52E0), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // أنيميشن الطفل
                            SizedBox(
                              width: 70, height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: const LottieStudying(size: 70),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'أهلاً ${child?.name ?? ""}! 🌟',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'يلّا نتعلم شي جديد اليوم! 🚀',
                                    style: TextStyle(fontSize: 13, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            // المنبه
                            BounceButton(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlarmScreen())),
                              child: Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(child: Text('⏰', style: TextStyle(fontSize: 24))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        // إحصائيات بإيموجي
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _KidStatItem(emoji: '🏆', value: '0', label: 'إنجازات'),
                              _KidStatDivider(),
                              _KidStatItem(emoji: '⏱️', value: '0', label: 'دقيقة'),
                              _KidStatDivider(),
                              _KidStatItem(emoji: '✅', value: '0', label: 'دروس'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ======== رسالة تشجيعية مع Lottie ========
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  children: [
                    // أنيميشن القراءة
                    const LottieReading(size: 120),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const AnimatedEmoji(emoji: '📖', size: 28),
                        const SizedBox(width: 10),
                        const Text('موادي الدراسية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${_subjects.length} مواد', style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ======== شبكة المواد - ستايل أطفال ========
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _KidSubjectCard(subject: _subjects[index], index: index),
                  childCount: _subjects.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}

// ============================================
// بطاقة المادة - ستايل أطفال
// ============================================
class _KidSubjectCard extends StatefulWidget {
  final _SubjectItem subject;
  final int index;
  const _KidSubjectCard({required this.subject, required this.index});

  @override
  State<_KidSubjectCard> createState() => _KidSubjectCardState();
}

class _KidSubjectCardState extends State<_KidSubjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400 + (widget.index * 100)));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => SlideTransition(
        position: _slideIn,
        child: ScaleTransition(scale: _scale, child: child),
      ),
      child: BounceButton(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => widget.subject.screen)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: widget.subject.color.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 8)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Stack(
            children: [
              // دائرة خلفية ملونة
              Positioned(
                top: -20, left: -20,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: widget.subject.bgColor.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // نقاط زخرفية
              Positioned(
                bottom: 10, left: 10,
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: widget.subject.bgColor,
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
                    // إيموجي كبير
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: widget.subject.bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(widget.subject.emoji, style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                    const Spacer(),
                    // اسم المادة
                    Text(
                      widget.subject.title,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: widget.subject.color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subject.subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              // سهم
              Positioned(
                bottom: 14, left: 14,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [widget.subject.color, widget.subject.color.withValues(alpha: 0.7)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KidStatItem extends StatelessWidget {
  final String emoji, value, label;
  const _KidStatItem({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _KidStatDivider extends StatelessWidget {
  const _KidStatDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2));
}

class _SubjectItem {
  final String emoji, title, subtitle;
  final Color color, bgColor;
  final Widget screen;
  _SubjectItem({required this.emoji, required this.title, required this.subtitle, required this.color, required this.bgColor, required this.screen});
}
