import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/lessons_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/track_card.dart';
import '../config/theme.dart';
import 'lesson_list_screen.dart';
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
  void initState() {
    super.initState();
    // تأخير تحميل البيانات حتى يتم بناء الـ widget بالكامل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final lessonsProvider = Provider.of<LessonsProvider>(context, listen: false);
      final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

      final child = authProvider.currentChild;
      if (child != null) {
        await Future.wait([
          lessonsProvider.fetchTracks(),
          progressProvider.fetchAllProgress(child.id),
        ]);
      }
    } catch (e) {
      if (mounted) {
        // عرض رسالة الخطأ إذا كان الـ widget ما زال موجوداً
        debugPrint('Error loading data: $e');
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeTab(),
      const ProgressScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'التقدم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final lessonsProvider = Provider.of<LessonsProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);

    final child = authProvider.currentChild;
    final tracks = lessonsProvider.tracks;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // الهيدر
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // صورة البروفايل
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        child?.name.substring(0, 1).toUpperCase() ?? '👤',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // الترحيب
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
                          const SizedBox(height: 4),
                          Text(
                            'لنتعلم شيئاً جديداً اليوم',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // الإشعارات
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: Colors.white,
                      iconSize: 28,
                      onPressed: () {
                        // TODO: صفحة الإشعارات
                      },
                    ),
                  ],
                ),
              ),
              // إحصائيات سريعة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        icon: Icons.book_outlined,
                        value: '${progressProvider.completedLessonsCount}',
                        label: 'دروس مكتملة',
                      ),
                      _buildStat(
                        icon: Icons.schedule,
                        value: progressProvider.totalTimeFormatted.split(' ')[0],
                        label: progressProvider.totalTimeFormatted.split(' ').length > 1
                            ? progressProvider.totalTimeFormatted.split(' ')[1]
                            : 'دقيقة',
                      ),
                      _buildStat(
                        icon: Icons.star_outline,
                        value: '${progressProvider.unlockedAchievementsCount}',
                        label: 'إنجازات',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // قائمة المسارات
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: lessonsProvider.isLoadingTracks
                      ? const Center(child: CircularProgressIndicator())
                      : lessonsProvider.error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    lessonsProvider.error!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => lessonsProvider.fetchTracks(),
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            )
                          : tracks.isEmpty
                              ? const Center(
                                  child: Text('لا توجد مسارات متاحة حالياً'),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await lessonsProvider.fetchTracks();
                                    if (child != null) {
                                      await progressProvider.fetchAllProgress(child.id);
                                    }
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(20),
                                    itemCount: tracks.length,
                                    itemBuilder: (context, index) {
                                      return TrackCard(
                                        track: tracks[index],
                                        onTap: () {
                                          lessonsProvider.selectTrack(tracks[index]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LessonListScreen(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
