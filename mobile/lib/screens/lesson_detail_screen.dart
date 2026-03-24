import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lessons_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/auth_provider.dart';
import '../models/lesson.dart';
import '../config/theme.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  DateTime? _startTime;
  Map<String, int> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  Future<void> _completeLesson() async {
    if (_startTime == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lessonsProvider = Provider.of<LessonsProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    final child = authProvider.currentChild;
    final lesson = lessonsProvider.selectedLesson;

    if (child == null || lesson == null) return;

    // حساب الوقت المستغرق
    final timeSpent = DateTime.now().difference(_startTime!).inSeconds;

    // حساب الدرجة (إذا كان هناك اختبار)
    int? score;
    if (lesson.questions != null && lesson.questions!.isNotEmpty) {
      int correctAnswers = 0;
      for (var question in lesson.questions!) {
        if (_selectedAnswers[question.id] == question.correctAnswer) {
          correctAnswers++;
        }
      }
      score = ((correctAnswers / lesson.questions!.length) * 100).round();
    }

    // عرض شاشة التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // تحديث التقدم
    final success = await progressProvider.updateLessonProgress(
      childId: child.id,
      lessonId: lesson.id,
      isCompleted: true,
      timeSpentSeconds: timeSpent,
      score: score,
    );

    if (!mounted) return;

    Navigator.pop(context); // إغلاق شاشة التحميل

    if (success) {
      // تحديث حالة الدرس محلياً
      lessonsProvider.markLessonComplete(lesson.id);

      // عرض رسالة النجاح
      _showCompletionDialog(score);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في حفظ التقدم'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCompletionDialog(int? score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.successColor,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'أحسنت!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              score != null ? 'حصلت على $score نقطة' : 'أكملت الدرس بنجاح',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الـ Dialog
                      Navigator.pop(context); // العودة لقائمة الدروس
                    },
                    child: const Text('قائمة الدروس'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الـ Dialog
                      _goToNextLesson();
                    },
                    child: const Text('الدرس التالي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _goToNextLesson() {
    final lessonsProvider = Provider.of<LessonsProvider>(context, listen: false);
    final currentLesson = lessonsProvider.selectedLesson;

    if (currentLesson == null) return;

    final nextLesson = lessonsProvider.getNextLesson(currentLesson.id);
    if (nextLesson != null) {
      lessonsProvider.selectLesson(nextLesson);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LessonDetailScreen()),
      );
    } else {
      // لا يوجد درس تالي - العودة للقائمة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonsProvider = Provider.of<LessonsProvider>(context);
    final lesson = lessonsProvider.selectedLesson;

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('الدرس')),
        body: const Center(child: Text('لم يتم اختيار درس')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: حفظ الدرس
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الدرس
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.schedule,
                        label: '${lesson.durationMinutes} دقيقة',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.category,
                        label: lesson.contentType,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // محتوى الدرس
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // محتوى نصي
                  if (lesson.contentType == 'text' || lesson.content.isNotEmpty)
                    _buildTextContent(lesson.content),
                  
                  // فيديو
                  if (lesson.contentType == 'video' && lesson.videoUrl != null)
                    _buildVideoPlayer(lesson.videoUrl!),
                  
                  // أسئلة
                  if (lesson.questions != null && lesson.questions!.isNotEmpty)
                    _buildQuestions(lesson.questions!),
                  
                  const SizedBox(height: 32),
                  // زر إكمال الدرس
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _completeLesson,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline),
                          SizedBox(width: 8),
                          Text(
                            'إكمال الدرس',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المحتوى',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الفيديو',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 8),
                Text('Video: $videoUrl'),
                // TODO: دمج مشغل فيديو (مثل video_player)
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuestions(List<Question> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأسئلة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return _buildQuestion(index + 1, question);
        }).toList(),
      ],
    );
  }

  Widget _buildQuestion(int number, Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السؤال $number: ${question.question}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswers[question.id] == optionIndex;

              return RadioListTile<int>(
                title: Text(option),
                value: optionIndex,
                groupValue: _selectedAnswers[question.id],
                onChanged: (value) {
                  setState(() {
                    _selectedAnswers[question.id] = value!;
                  });
                },
                activeColor: AppTheme.primaryColor,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
