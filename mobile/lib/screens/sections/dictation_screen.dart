import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/dictation_data.dart';
import '../../services/tts_service.dart';
import '../../widgets/fun_widgets.dart';

// رسائل تشجيعية عشوائية للإجابة الصحيحة
const List<String> _encourageMessages = [
  'أحسنت! 🎉',
  'شاطر! ⭐',
  'برافو! 👏',
  'ممتاز! 🌟',
  'يا بطل! 🏆',
];

String _randomEncouragement() {
  return _encourageMessages[Random().nextInt(_encourageMessages.length)];
}

class DictationScreen extends StatelessWidget {
  const DictationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = DictationData.lessons;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الإملاء ✏️'),
        backgroundColor: AppTheme.dictationColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBubbleBackground(
        color: AppTheme.dictationColor,
        child: Column(
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
                  const AnimatedEmoji(emoji: '✏️📝', size: 48),
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
                    'من كتاب قراءتي للصف الأول',
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BounceButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DictationPracticeScreen(lesson: lesson),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
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
                              color:
                                  AppTheme.dictationColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                lesson.letter.length <= 2
                                    ? lesson.letter
                                    : '${index + 1}',
                                style: TextStyle(
                                  fontSize:
                                      lesson.letter.length <= 2 ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.dictationColor,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            lesson.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${lesson.words.length} كلمات 📝',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.dictationColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('▶️',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// شاشة تمرين الإملاء التفاعلي
// ============================================
class DictationPracticeScreen extends StatefulWidget {
  final DictationLesson lesson;

  const DictationPracticeScreen({super.key, required this.lesson});

  @override
  State<DictationPracticeScreen> createState() =>
      _DictationPracticeScreenState();
}

class _DictationPracticeScreenState extends State<DictationPracticeScreen> {
  int _currentWordIndex = 0;
  final TextEditingController _controller = TextEditingController();
  bool? _isCorrect;
  int _correctCount = 0;
  bool _showWord = false;
  bool _isFinished = false;
  String _encourageMessage = '';
  final TtsService _tts = TtsService();
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  String get _currentWord => widget.lesson.words[_currentWordIndex];

  @override
  void initState() {
    super.initState();
    // نطق الكلمة الأولى تلقائياً عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tts.speak(_currentWord);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final answer = _controller.text.trim();
    if (answer.isEmpty) return;

    setState(() {
      // مقارنة مرنة - نزيل التشكيل والمسافات
      final cleanAnswer = _removeHarakat(answer);
      final cleanWord = _removeHarakat(_currentWord);
      _isCorrect = cleanAnswer == cleanWord;
      if (_isCorrect!) {
        _correctCount++;
        _encourageMessage = _randomEncouragement();
        // 🎉 كونفيتي!
        _confettiKey.currentState?.fire();
      }
    });
  }

  String _removeHarakat(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '') // تشكيل
        .replaceAll(' ', '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .trim();
  }

  void _nextWord() {
    if (_currentWordIndex < widget.lesson.words.length - 1) {
      setState(() {
        _currentWordIndex++;
        _controller.clear();
        _isCorrect = null;
        _showWord = false;
        _encourageMessage = '';
      });
      // نطق الكلمة الجديدة تلقائياً
      _tts.speak(_currentWord);
    } else {
      setState(() => _isFinished = true);
    }
  }

  void _showCurrentWord() {
    setState(() => _showWord = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showWord = false);
    });
  }

  void _restart() {
    setState(() {
      _currentWordIndex = 0;
      _correctCount = 0;
      _isCorrect = null;
      _showWord = false;
      _isFinished = false;
      _encourageMessage = '';
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultScreen();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: AppTheme.dictationColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ConfettiOverlay(
        key: _confettiKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // شريط التقدم
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                          'الكلمة ${_currentWordIndex + 1} من ${widget.lesson.words.length} ✏️',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          'صح: $_correctCount ⭐',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AnimatedProgressBar(
                      progress: (_currentWordIndex + 1) /
                          widget.lesson.words.length,
                      color: AppTheme.dictationColor,
                      height: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // بطاقة الكلمة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.dictationColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_showWord)
                      Text(
                        _currentWord,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    else
                      Column(
                        children: [
                          const AnimatedEmoji(
                            emoji: '🔊',
                            size: 72,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'اضغط لسماع الكلمة 👂',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    // أزرار السماع وإظهار الكلمة
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        BounceButton(
                          onTap: () => _tts.speak(_currentWord),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🔊',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 8),
                                Text(
                                  'اسمع',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BounceButton(
                          onTap: _showCurrentWord,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('👀',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(width: 8),
                                Text(
                                  'أظهر',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // حقل الكتابة
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: _isCorrect == null
                      ? null
                      : Border.all(
                          color: _isCorrect!
                              ? AppTheme.successColor
                              : AppTheme.alarmColor,
                          width: 2.5,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  enabled: _isCorrect == null,
                  decoration: InputDecoration(
                    hintText: 'اكتب الكلمة هنا ✏️',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                  ),
                  onSubmitted: (_) => _checkAnswer(),
                ),
              ),
              const SizedBox(height: 16),

              // رسالة النتيجة
              if (_isCorrect != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isCorrect!
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.alarmColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      AnimatedEmoji(
                        emoji: _isCorrect! ? '🎉' : '😅',
                        size: 56,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isCorrect!
                            ? _encourageMessage
                            : 'حاول مرة ثانية 💪',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _isCorrect!
                              ? AppTheme.successColor
                              : AppTheme.alarmColor,
                        ),
                      ),
                      if (!_isCorrect!)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'الكلمة الصحيحة: $_currentWord',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dictationColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // الأزرار
              if (_isCorrect == null)
                BounceButton(
                  onTap: _checkAnswer,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.dictationColor,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppTheme.dictationColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'تحقق ✓',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              else
                BounceButton(
                  onTap: _nextWord,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _currentWordIndex < widget.lesson.words.length - 1
                            ? 'الكلمة التالية ←'
                            : 'عرض النتيجة 🏆',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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

  Widget _buildResultScreen() {
    final total = widget.lesson.words.length;
    final percentage = (_correctCount / total * 100).round();
    final isGreat = percentage >= 80;

    // رسائل ممتعة حسب النتيجة
    final resultMessages = isGreat
        ? ['يا بطل! 🏆', 'شاطر! ⭐', 'ممتاز يا بطل! 🎉']
        : ['يلا نحاول مرة ثانية! 💪', 'ما تستسلم! 🌟'];
    final resultMessage =
        resultMessages[Random().nextInt(resultMessages.length)];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: AnimatedBubbleBackground(
        color: isGreat ? AppTheme.successColor : AppTheme.dictationColor,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة النتيجة
                  AnimatedEmoji(
                    emoji: isGreat ? '🏆' : '💪',
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  if (isGreat)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (i) => TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration:
                                    Duration(milliseconds: 500 + (i * 200)),
                                curve: Curves.elasticOut,
                                builder: (_, v, child) =>
                                    Transform.scale(scale: v, child: child),
                                child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Text('⭐',
                                        style: TextStyle(fontSize: 40))),
                              )),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    resultMessage,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_correctCount من $total كلمات صحيحة',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: isGreat
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // شريط التقدم في النتيجة
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedProgressBar(
                      progress: _correctCount / total,
                      color: isGreat
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                      height: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // أزرار
                  BounceButton(
                    onTap: _restart,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.dictationColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.dictationColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'إعادة المحاولة 🔄',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BounceButton(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppTheme.dictationColor,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'رجوع للدروس 📚',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.dictationColor,
                          ),
                        ),
                      ),
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
