import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/dictation_data.dart';
import '../../services/tts_service.dart';

class DictationScreen extends StatelessWidget {
  const DictationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = DictationData.lessons;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الإملاء'),
        backgroundColor: AppTheme.dictationColor,
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
              color: AppTheme.dictationColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.edit_note_rounded, size: 56, color: Colors.white),
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
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.dictationColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          lesson.letter.length <= 2 ? lesson.letter : '${index + 1}',
                          style: TextStyle(
                            fontSize: lesson.letter.length <= 2 ? 22 : 18,
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
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      '${lesson.words.length} كلمات',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.dictationColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.dictationColor,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DictationPracticeScreen(lesson: lesson),
                        ),
                      );
                    },
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

// ============================================
// شاشة تمرين الإملاء التفاعلي
// ============================================
class DictationPracticeScreen extends StatefulWidget {
  final DictationLesson lesson;

  const DictationPracticeScreen({super.key, required this.lesson});

  @override
  State<DictationPracticeScreen> createState() => _DictationPracticeScreenState();
}

class _DictationPracticeScreenState extends State<DictationPracticeScreen> {
  int _currentWordIndex = 0;
  final TextEditingController _controller = TextEditingController();
  bool? _isCorrect;
  int _correctCount = 0;
  bool _showWord = false;
  bool _isFinished = false;
  final TtsService _tts = TtsService();

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
      if (_isCorrect!) _correctCount++;
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
      body: SingleChildScrollView(
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
                        'الكلمة ${_currentWordIndex + 1} من ${widget.lesson.words.length}',
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
                      value: (_currentWordIndex + 1) / widget.lesson.words.length,
                      backgroundColor: AppTheme.dictationColor.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.dictationColor),
                      minHeight: 8,
                    ),
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
                borderRadius: BorderRadius.circular(24),
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
                        const Icon(
                          Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 56,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'اضغط لسماع الكلمة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
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
                      _ActionButton(
                        icon: Icons.volume_up_rounded,
                        label: 'اسمع',
                        onTap: () => _tts.speak(_currentWord),
                      ),
                      _ActionButton(
                        icon: Icons.visibility_rounded,
                        label: 'أظهر',
                        onTap: _showCurrentWord,
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
                borderRadius: BorderRadius.circular(20),
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
                  hintText: 'اكتب الكلمة هنا',
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect!
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : AppTheme.alarmColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      _isCorrect!
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: _isCorrect!
                          ? AppTheme.successColor
                          : AppTheme.alarmColor,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isCorrect! ? 'أحسنت! 🎉' : 'حاول مرة ثانية',
                      style: TextStyle(
                        fontSize: 20,
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.dictationColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'تحقق ✓',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentWordIndex < widget.lesson.words.length - 1
                        ? 'الكلمة التالية ←'
                        : 'عرض النتيجة',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final total = widget.lesson.words.length;
    final percentage = (_correctCount / total * 100).round();
    final isGreat = percentage >= 80;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة النتيجة
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isGreat
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.warningColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isGreat
                        ? Icons.emoji_events_rounded
                        : Icons.refresh_rounded,
                    size: 64,
                    color: isGreat
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isGreat ? 'ممتاز! 🎉' : 'حاول مرة ثانية',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
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
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: isGreat
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                  ),
                ),
                const SizedBox(height: 40),
                // أزرار
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _restart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dictationColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'إعادة المحاولة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      side: const BorderSide(color: AppTheme.dictationColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'رجوع للدروس',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.dictationColor,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
