import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // إخفاء شريط الحالة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // إعداد الأنيميشن
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // الانتقال للشاشة التالية
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // انتظار الأنيميشن
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // انتظار التهيئة
    while (!authProvider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;

    // إظهار شريط الحالة
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // الانتقال للشاشة المناسبة
    if (authProvider.isLoggedIn) {
      // المستخدم مسجل - اذهب للشاشة الرئيسية
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      // المستخدم غير مسجل - اذهب لشاشة التسجيل
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الأيقونة
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 80,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                // العنوان
                const Text(
                  'تعليم الأطفال',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'رحلة التعلم تبدأ هنا',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 50),
                // مؤشر التحميل
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// شاشة الترحيب (للتسجيل)
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _selectedGrade = 1;

  // بيانات المراحل الدراسية
  static const List<Map<String, dynamic>> _grades = [
    {'grade': 1, 'name': 'الأول', 'icon': '🎒', 'color': 0xFF4A90E2},
    {'grade': 2, 'name': 'الثاني', 'icon': '📚', 'color': 0xFF7ED321},
    {'grade': 3, 'name': 'الثالث', 'icon': '✏️', 'color': 0xFFF5A623},
    {'grade': 4, 'name': 'الرابع', 'icon': '🔬', 'color': 0xFFE74C3C},
    {'grade': 5, 'name': 'الخامس', 'icon': '🌟', 'color': 0xFF9B59B6},
    {'grade': 6, 'name': 'السادس', 'icon': '🎓', 'color': 0xFF1ABC9C},
  ];

  // تحويل المرحلة الدراسية إلى عمر
  int _gradeToAge(int grade) => grade + 5;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (!authProvider.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final success = await authProvider.register(
        _nameController.text.trim(),
        _gradeToAge(_selectedGrade),
      );

      if (!mounted) return;

      if (success && authProvider.currentChild != null) {
        await Future.delayed(const Duration(milliseconds: 300));

        if (!mounted) return;

        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'حدث خطأ في التسجيل'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Widget _buildGradeCard(Map<String, dynamic> gradeData) {
    final grade = gradeData['grade'] as int;
    final name = gradeData['name'] as String;
    final icon = gradeData['icon'] as String;
    final color = Color(gradeData['color'] as int);
    final isSelected = _selectedGrade == grade;

    return GestureDetector(
      onTap: () => setState(() => _selectedGrade = grade),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // علامة الاختيار
            if (isSelected)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            // المحتوى
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : Colors.black87,
                      ),
                    ),
                    Text(
                      'ابتدائي',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? color.withValues(alpha: 0.8)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الأيقونة
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Text('🎓', style: TextStyle(fontSize: 52)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'مرحباً بك!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'لنبدأ رحلة التعلم معاً',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // حقل الاسم
                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'شنو اسمك الحلو؟',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // اختيار المرحلة الدراسية
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                color: AppTheme.primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'شنو مرحلتك الدراسية؟',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: _grades.length,
                            itemBuilder: (context, index) {
                              return _buildGradeCard(_grades[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          elevation: 4,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ابدأ التعلم',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.rocket_launch_rounded, size: 22),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
