import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../config/theme.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool showLock;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.showLock = true,
  });

  IconData _getContentIcon() {
    switch (lesson.contentType) {
      case 'video':
        return Icons.play_circle_outline;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'activity':
        return Icons.extension_outlined;
      default:
        return Icons.menu_book_outlined;
    }
  }

  String _getContentTypeText() {
    switch (lesson.contentType) {
      case 'video':
        return 'فيديو';
      case 'quiz':
        return 'اختبار';
      case 'activity':
        return 'نشاط';
      default:
        return 'نص';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = showLock && lesson.isLocked;

    return Card(
      elevation: isLocked ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // رقم الدرس أو أيقونة القفل
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey[300]
                        : lesson.isCompleted
                            ? AppTheme.successColor.withOpacity(0.2)
                            : AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isLocked
                        ? const Icon(Icons.lock, color: Colors.grey)
                        : lesson.isCompleted
                            ? const Icon(Icons.check_circle,
                                color: AppTheme.successColor, size: 28)
                            : Text(
                                '${lesson.order}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: 16),
                // محتوى الدرس
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // الوصف
                      Text(
                        lesson.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: isLocked ? Colors.grey : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // نوع المحتوى والمدة
                      Row(
                        children: [
                          Icon(
                            _getContentIcon(),
                            size: 16,
                            color: isLocked
                                ? Colors.grey
                                : AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getContentTypeText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked
                                  ? Colors.grey
                                  : AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: isLocked ? Colors.grey : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.durationMinutes} دقيقة',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocked ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // سهم التوجيه
                if (!isLocked)
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
