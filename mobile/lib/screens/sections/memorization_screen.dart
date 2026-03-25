import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/memorization_data.dart';
import '../../services/tts_service.dart';

// ============================================
// لون قسم المحفوظات
// ============================================
const Color _memorizationColor = Color(0xFFE84393);

// ============================================
// شاشة قائمة دروس المحفوظات
// ============================================
class MemorizationScreen extends StatefulWidget {
  const MemorizationScreen({super.key});

  @override
  State<MemorizationScreen> createState() => _MemorizationScreenState();
}

class _MemorizationScreenState extends State<MemorizationScreen> {
  // حفظ تقدم النجوم لكل درس (0-3)
  final Map<int, int> _starsProgress = {};

  void _updateStars(int lessonId, int stars) {
    setState(() {
      final current = _starsProgress[lessonId] ?? 0;
      if (stars > current) {
        _starsProgress[lessonId] = stars;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessons = MemorizationData.lessons;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المحفوظات'),
        backgroundColor: _memorizationColor,
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
              color: _memorizationColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_stories_rounded,
                    size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'احفظ وردّد',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'محفوظات كتاب قراءتي للصف الأول',
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
                final stars = _starsProgress[lesson.id] ?? 0;
                return _LessonTile(
                  lesson: lesson,
                  stars: stars,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _LessonStagesScreen(
                          lesson: lesson,
                          currentStars: stars,
                          onStarsUpdate: (s) =>
                              _updateStars(lesson.id, s),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// بطاقة الدرس في القائمة
// ============================================
class _LessonTile extends StatelessWidget {
  final MemorizationLesson lesson;
  final int stars;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _memorizationColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              '${lesson.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _memorizationColor,
              ),
            ),
          ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'ص${lesson.pageNumber}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            // النجوم
            ...List.generate(3, (i) {
              return Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 20,
                color: i < stars
                    ? AppTheme.warningColor
                    : AppTheme.textLight,
              );
            }),
          ],
        ),
        trailing: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _memorizationColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: _memorizationColor,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

// ============================================
// شاشة مراحل الدرس (3 مراحل)
// ============================================
class _LessonStagesScreen extends StatefulWidget {
  final MemorizationLesson lesson;
  final int currentStars;
  final ValueChanged<int> onStarsUpdate;

  const _LessonStagesScreen({
    required this.lesson,
    required this.currentStars,
    required this.onStarsUpdate,
  });

  @override
  State<_LessonStagesScreen> createState() => _LessonStagesScreenState();
}

class _LessonStagesScreenState extends State<_LessonStagesScreen> {
  late int _stars;

  @override
  void initState() {
    super.initState();
    _stars = widget.currentStars;
  }

  void _completeStage(int stage) {
    setState(() {
      if (stage > _stars) {
        _stars = stage;
        widget.onStarsUpdate(_stars);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stages = [
      _StageInfo(
        number: 1,
        title: 'اسمع وتابع',
        subtitle: 'استمع للنص وتابع الكلمات',
        icon: Icons.hearing_rounded,
        color: const Color(0xFF6C63FF),
        isUnlocked: true,
        isCompleted: _stars >= 1,
      ),
      _StageInfo(
        number: 2,
        title: 'أكمل الناقص',
        subtitle: 'املأ الفراغات بالكلمة الصحيحة',
        icon: Icons.edit_rounded,
        color: const Color(0xFFFFC107),
        isUnlocked: _stars >= 1,
        isCompleted: _stars >= 2,
      ),
      _StageInfo(
        number: 3,
        title: 'رتّب الكلمات',
        subtitle: 'أعد ترتيب الكلمات بالشكل الصحيح',
        icon: Icons.swap_horiz_rounded,
        color: const Color(0xFF4CAF50),
        isUnlocked: _stars >= 2,
        isCompleted: _stars >= 3,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: _memorizationColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // هيدر بالنص
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            decoration: const BoxDecoration(
              color: _memorizationColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                // النجوم
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < _stars
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 36,
                        color: i < _stars
                            ? AppTheme.warningColor
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.lesson.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // بطاقات المراحل
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                return _StageCard(
                  stage: stage,
                  onTap: stage.isUnlocked
                      ? () => _openStage(stage.number)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openStage(int stageNumber) {
    Widget screen;
    switch (stageNumber) {
      case 1:
        screen = _ListenFollowScreen(
          lesson: widget.lesson,
          onComplete: () => _completeStage(1),
        );
        break;
      case 2:
        screen = _FillBlanksScreen(
          lesson: widget.lesson,
          onComplete: () => _completeStage(2),
        );
        break;
      case 3:
        screen = _ArrangeWordsScreen(
          lesson: widget.lesson,
          onComplete: () => _completeStage(3),
        );
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

// ============================================
// معلومات المرحلة
// ============================================
class _StageInfo {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final bool isCompleted;

  const _StageInfo({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.isCompleted,
  });
}

// ============================================
// بطاقة المرحلة
// ============================================
class _StageCard extends StatelessWidget {
  final _StageInfo stage;
  final VoidCallback? onTap;

  const _StageCard({required this.stage, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLocked = !stage.isUnlocked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: stage.isCompleted
              ? Border.all(color: AppTheme.successColor, width: 2)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // أيقونة المرحلة
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: stage.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isLocked ? Icons.lock_rounded : stage.icon,
                      color: stage.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // النصوص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المرحلة ${stage.number}: ${stage.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stage.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // حالة الإكمال
                  if (stage.isCompleted)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  else if (!isLocked)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: stage.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: stage.color,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// المرحلة 1: اسمع وتابع
// ============================================
class _ListenFollowScreen extends StatefulWidget {
  final MemorizationLesson lesson;
  final VoidCallback onComplete;

  const _ListenFollowScreen({
    required this.lesson,
    required this.onComplete,
  });

  @override
  State<_ListenFollowScreen> createState() => _ListenFollowScreenState();
}

class _ListenFollowScreenState extends State<_ListenFollowScreen> {
  int _currentWordIndex = -1;
  Timer? _timer;
  bool _isPlaying = false;
  bool _isFinished = false;
  final TtsService _tts = TtsService();

  List<String> get _words => widget.lesson.words;

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }

  void _startPlayback() {
    if (_isPlaying) return;
    setState(() {
      _currentWordIndex = 0;
      _isPlaying = true;
      _isFinished = false;
    });
    // نطق الكلمة الأولى
    _tts.speak(_words[0]);
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_currentWordIndex < _words.length - 1) {
        setState(() => _currentWordIndex++);
        // نطق الكلمة المُظللة الحالية
        _tts.speak(_words[_currentWordIndex]);
      } else {
        timer.cancel();
        setState(() {
          _isPlaying = false;
          _isFinished = true;
        });
        widget.onComplete();
      }
    });
  }

  /// نطق النص بالكامل
  void _speakAll() {
    final fullText = _words.join(' ');
    _tts.speak(fullText);
  }

  void _replay() {
    _timer?.cancel();
    _tts.stop();
    setState(() {
      _currentWordIndex = -1;
      _isPlaying = false;
      _isFinished = false;
    });
    Future.delayed(const Duration(milliseconds: 200), _startPlayback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('اسمع وتابع'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // عنوان الدرس
              Text(
                widget.lesson.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ص${widget.lesson.pageNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // بطاقة النص
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 16,
                      children: List.generate(_words.length, (index) {
                        final isCurrent =
                            _isPlaying && index == _currentWordIndex;
                        final isPast =
                            _isPlaying && index < _currentWordIndex;
                        final isShown = _isFinished;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppTheme.primaryColor
                                : isPast || isShown
                                    ? AppTheme.primaryColor
                                        .withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            _words[index],
                            style: TextStyle(
                              fontSize: isCurrent ? 32 : 24,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? Colors.white
                                  : isPast || isShown
                                      ? AppTheme.primaryColor
                                      : AppTheme.textLight,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // شريط التقدم
              if (_isPlaying)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentWordIndex + 1) / _words.length,
                      backgroundColor:
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor),
                      minHeight: 8,
                    ),
                  ),
                ),

              // أزرار التحكم
              if (_isFinished)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: AppTheme.successColor, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'أحسنت! حصلت على النجمة الأولى',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: _replay,
                              icon: const Icon(Icons.replay_rounded),
                              label: const Text('إعادة'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.primaryColor),
                                foregroundColor: AppTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.successColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'رجوع',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else if (!_isPlaying)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _startPlayback,
                        icon: const Icon(Icons.play_arrow_rounded, size: 28),
                        label: const Text(
                          'ابدأ الاستماع',
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor:
                              AppTheme.primaryColor.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _speakAll,
                        icon: const Icon(Icons.volume_up_rounded, size: 24),
                        label: const Text(
                          'اسمع الكل',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryColor),
                          foregroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// المرحلة 2: أكمل الناقص
// ============================================
class _FillBlanksScreen extends StatefulWidget {
  final MemorizationLesson lesson;
  final VoidCallback onComplete;

  const _FillBlanksScreen({
    required this.lesson,
    required this.onComplete,
  });

  @override
  State<_FillBlanksScreen> createState() => _FillBlanksScreenState();
}

class _FillBlanksScreenState extends State<_FillBlanksScreen> {
  late List<String> _words;
  late Set<int> _blankIndices;
  late Map<int, String?> _userAnswers;
  int? _selectedBlankIndex;
  int _correctCount = 0;
  int _answeredCount = 0;
  bool _isFinished = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _words = List.from(widget.lesson.words);
    _setupBlanks();
  }

  void _setupBlanks() {
    // 30% of words become blanks (minimum 1)
    final blankCount = max(1, (_words.length * 0.3).ceil());
    final indices = List.generate(_words.length, (i) => i)..shuffle(_random);
    _blankIndices = indices.take(blankCount).toSet();
    _userAnswers = {};
    _correctCount = 0;
    _answeredCount = 0;
    _isFinished = false;
    _selectedBlankIndex = null;
  }

  List<String> _getOptionsForBlank(int index) {
    final correctWord = _words[index];
    // Get unique words from the lesson (excluding the correct one)
    final otherWords = _words.toSet().where((w) => w != correctWord).toList()
      ..shuffle(_random);

    final options = <String>[correctWord];
    // Add up to 2 wrong options
    for (final word in otherWords) {
      if (options.length >= 3) break;
      options.add(word);
    }
    // If not enough unique words, add from a fallback pool
    final fallback = ['دار', 'باب', 'نام', 'قمر', 'ورد', 'بابا', 'ماما'];
    for (final word in fallback) {
      if (options.length >= 3) break;
      if (!options.contains(word)) {
        options.add(word);
      }
    }
    options.shuffle(_random);
    return options;
  }

  void _selectAnswer(String answer) {
    if (_selectedBlankIndex == null) return;
    final idx = _selectedBlankIndex!;
    final isCorrect = answer == _words[idx];

    setState(() {
      _userAnswers[idx] = answer;
      _answeredCount++;
      if (isCorrect) _correctCount++;
      _selectedBlankIndex = null;

      // Check if all blanks filled
      if (_answeredCount >= _blankIndices.length) {
        _isFinished = true;
        if (_correctCount == _blankIndices.length) {
          widget.onComplete();
        }
      }
    });
  }

  void _restart() {
    setState(() {
      _setupBlanks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('أكمل الناقص'),
        backgroundColor: AppTheme.warningColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // شريط التقدم
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.lesson.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '$_correctCount / ${_blankIndices.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // بطاقة النص مع الفراغات
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 14,
                      children: List.generate(_words.length, (index) {
                        final isBlank = _blankIndices.contains(index);
                        final userAnswer = _userAnswers[index];
                        final isSelected = _selectedBlankIndex == index;
                        final isAnswered = userAnswer != null;
                        final isCorrect =
                            isAnswered && userAnswer == _words[index];

                        if (!isBlank) {
                          // كلمة عادية
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              _words[index],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          );
                        }

                        // كلمة فارغة
                        return GestureDetector(
                          onTap: isAnswered
                              ? null
                              : () {
                                  setState(
                                      () => _selectedBlankIndex = index);
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isAnswered
                                  ? isCorrect
                                      ? AppTheme.successColor
                                          .withValues(alpha: 0.15)
                                      : Colors.red.withValues(alpha: 0.15)
                                  : isSelected
                                      ? AppTheme.warningColor
                                          .withValues(alpha: 0.2)
                                      : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAnswered
                                    ? isCorrect
                                        ? AppTheme.successColor
                                        : Colors.red
                                    : isSelected
                                        ? AppTheme.warningColor
                                        : Colors.grey.withValues(alpha: 0.3),
                                width: isSelected ? 2.5 : 1.5,
                              ),
                            ),
                            child: Text(
                              isAnswered ? userAnswer! : '_____',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isAnswered
                                    ? isCorrect
                                        ? AppTheme.successColor
                                        : Colors.red
                                    : AppTheme.textLight,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // خيارات الإجابة
              if (_selectedBlankIndex != null && !_isFinished)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'اختر الكلمة الصحيحة:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: _getOptionsForBlank(_selectedBlankIndex!)
                            .map((option) {
                          return ElevatedButton(
                            onPressed: () => _selectAnswer(option),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.warningColor.withValues(alpha: 0.15),
                              foregroundColor: AppTheme.textPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(
                                    color: AppTheme.warningColor, width: 1.5),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

              // نتيجة
              if (_isFinished)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _correctCount == _blankIndices.length
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _correctCount == _blankIndices.length
                            ? Icons.check_circle_rounded
                            : Icons.refresh_rounded,
                        color: _correctCount == _blankIndices.length
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _correctCount == _blankIndices.length
                            ? 'ممتاز! حصلت على النجمة الثانية'
                            : 'حاول مرة أخرى - $_correctCount من ${_blankIndices.length}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _correctCount == _blankIndices.length
                              ? AppTheme.successColor
                              : AppTheme.warningColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: _restart,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppTheme.warningColor),
                                  foregroundColor: AppTheme.warningColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('إعادة',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _correctCount == _blankIndices.length
                                          ? AppTheme.successColor
                                          : AppTheme.warningColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('رجوع',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// المرحلة 3: رتّب الكلمات
// ============================================
class _ArrangeWordsScreen extends StatefulWidget {
  final MemorizationLesson lesson;
  final VoidCallback onComplete;

  const _ArrangeWordsScreen({
    required this.lesson,
    required this.onComplete,
  });

  @override
  State<_ArrangeWordsScreen> createState() => _ArrangeWordsScreenState();
}

class _ArrangeWordsScreenState extends State<_ArrangeWordsScreen> {
  late List<_Sentence> _sentences;
  int _currentSentenceIndex = 0;
  late List<String> _shuffledWords;
  List<String> _userOrder = [];
  bool _isCorrect = false;
  bool _showResult = false;
  bool _isFinished = false;
  int _correctCount = 0;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _buildSentences();
    _setupCurrentSentence();
  }

  void _buildSentences() {
    // Split the text by " - " to get sentence segments
    final text = widget.lesson.text;
    final parts = text.split(' - ');
    _sentences = parts.map((part) {
      final words = part.trim().split(RegExp(r'\s+'));
      return _Sentence(text: part.trim(), words: words);
    }).toList();

    if (_sentences.isEmpty) {
      _sentences = [
        _Sentence(
            text: widget.lesson.text,
            words: widget.lesson.text.split(RegExp(r'\s+')))
      ];
    }
  }

  void _setupCurrentSentence() {
    final sentence = _sentences[_currentSentenceIndex];
    _shuffledWords = List.from(sentence.words)..shuffle(_random);
    // Make sure shuffled is different from original (if possible)
    if (sentence.words.length > 1) {
      int attempts = 0;
      while (_listEquals(_shuffledWords, sentence.words) && attempts < 10) {
        _shuffledWords.shuffle(_random);
        attempts++;
      }
    }
    _userOrder = [];
    _isCorrect = false;
    _showResult = false;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _addWord(String word) {
    setState(() {
      _userOrder.add(word);
      _shuffledWords.remove(word);

      // Check if complete
      if (_shuffledWords.isEmpty) {
        final sentence = _sentences[_currentSentenceIndex];
        _isCorrect = _listEquals(_userOrder, sentence.words);
        _showResult = true;
        if (_isCorrect) _correctCount++;
      }
    });
  }

  void _removeLastWord() {
    if (_userOrder.isEmpty || _showResult) return;
    setState(() {
      final word = _userOrder.removeLast();
      _shuffledWords.add(word);
    });
  }

  void _nextSentence() {
    if (_currentSentenceIndex < _sentences.length - 1) {
      setState(() {
        _currentSentenceIndex++;
        _setupCurrentSentence();
      });
    } else {
      // All sentences done
      setState(() => _isFinished = true);
      if (_correctCount == _sentences.length) {
        widget.onComplete();
      }
    }
  }

  void _retrySentence() {
    setState(() {
      _setupCurrentSentence();
    });
  }

  void _restart() {
    setState(() {
      _currentSentenceIndex = 0;
      _correctCount = 0;
      _isFinished = false;
      _setupCurrentSentence();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultView();

    final sentence = _sentences[_currentSentenceIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('رتّب الكلمات'),
        backgroundColor: AppTheme.successColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // شريط التقدم
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الجملة ${_currentSentenceIndex + 1} من ${_sentences.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          'صح: $_correctCount',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_currentSentenceIndex + 1) /
                            _sentences.length,
                        backgroundColor:
                            AppTheme.successColor.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.successColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // منطقة الترتيب (إجابة المستخدم)
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _showResult
                        ? _isCorrect
                            ? AppTheme.successColor
                            : Colors.red
                        : AppTheme.successColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_userOrder.isEmpty)
                      Text(
                        'اضغط على الكلمات بالترتيب الصحيح',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textLight,
                        ),
                      )
                    else
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 10,
                        children: _userOrder.map((word) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _showResult
                                  ? _isCorrect
                                      ? AppTheme.successColor
                                          .withValues(alpha: 0.15)
                                      : Colors.red.withValues(alpha: 0.1)
                                  : AppTheme.successColor
                                      .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              word,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _showResult
                                    ? _isCorrect
                                        ? AppTheme.successColor
                                        : Colors.red
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              // زر حذف آخر كلمة
              if (_userOrder.isNotEmpty && !_showResult)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    onPressed: _removeLastWord,
                    icon: const Icon(Icons.backspace_rounded, size: 20),
                    label: const Text('تراجع'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // الكلمات المتاحة (مخلوطة)
              if (!_showResult)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 12,
                      children: _shuffledWords.map((word) {
                        return GestureDetector(
                          onTap: () => _addWord(word),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4CAF50),
                                  Color(0xFF388E3C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.successColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              word,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // نتيجة الجملة
              if (_showResult)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 56,
                        color: _isCorrect
                            ? AppTheme.successColor
                            : Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isCorrect ? 'أحسنت!' : 'الترتيب غير صحيح',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _isCorrect
                              ? AppTheme.successColor
                              : Colors.red,
                        ),
                      ),
                      if (!_isCorrect) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            sentence.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isCorrect)
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: _retrySentence,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppTheme.successColor),
                                    foregroundColor: AppTheme.successColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text('إعادة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          if (!_isCorrect) const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _nextSentence,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.successColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  _currentSentenceIndex <
                                          _sentences.length - 1
                                      ? 'التالي'
                                      : 'النتيجة',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final allCorrect = _correctCount == _sentences.length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: allCorrect
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.warningColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    allCorrect
                        ? Icons.emoji_events_rounded
                        : Icons.refresh_rounded,
                    size: 64,
                    color: allCorrect
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  allCorrect ? 'ممتاز!' : 'حاول مرة أخرى',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$_correctCount من ${_sentences.length} جمل صحيحة',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (allCorrect)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_rounded,
                            color: AppTheme.warningColor, size: 36),
                        Icon(Icons.star_rounded,
                            color: AppTheme.warningColor, size: 36),
                        Icon(Icons.star_rounded,
                            color: AppTheme.warningColor, size: 36),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                if (allCorrect)
                  const Text(
                    'حصلت على النجمة الثالثة - حفظ كامل!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successColor,
                    ),
                  ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _restart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppTheme.successColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'رجوع للدرس',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// نموذج جملة مساعد
// ============================================
class _Sentence {
  final String text;
  final List<String> words;

  const _Sentence({required this.text, required this.words});
}
